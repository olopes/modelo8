*
*   cupsprint.prg -- Print to cups printer
*   Copyright (C) 2010 Oscar Lopes <psicover.dev@gmail.com>
*
*   This file is part of Modelo8.
*
*   Modelo8 is free software: you can redistribute it and/or modify
*   it under the terms of the GNU General Public License as published by
*   the Free Software Foundation, either version 3 of the License, or
*   (at your option) any later version.
*
*   Modelo8 is distributed in the hope that it will be useful,
*   but WITHOUT ANY WARRANTY; without even the implied warranty of
*   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*   GNU General Public License for more details.
*
*   You should have received a copy of the GNU General Public License
*   along with Modelo8.  If not, see <http://www.gnu.org/licenses/>.
*

#include "inkey.ch"
#include "achoice.ch"
* #include "Box.ch"

#define FORM_A4 9
#define PS_SOLID 0


* TODO 
* Escolher impressora

function printPrinter(perg,mes860)
  LOCAL fname
  LOCAL defPrinter
  LOCAL aPrn
  LOCAL nPrn 
  LOCAL jobId

  aPrn := CUPS_GET_DESTS()
  nPrn := 1

  @ 11,1 CLEAR TO 23,61
  @ 11,1 TO 23,61
  * @ 11,1,23,61 BOX B_SINGLE
  nPrn := ACHOICE(12,2,22,60,aPrn,.T.,,nPrn)
  IF EMPTY(nPrn) 
        return (nil)
  ENDIF
  
  oPrinter := aPrn[nPrn]

  * Criar temp file
  fname := "/"+CURDIR()+"/print.pdf"

  sendToPdf(perg,mes860,fname)
  jobId := cups_print_file(oPrinter,fname)
  ferase(fname)

  @ 11,1 CLEAR TO 23,61
  IF jobId = 0
    @ 12,3 SAY "Erro no envio do pedido de impressao."
    @ 13,3 SAY "Erro: " + ALLTRIM(STR(CUPS_LAST_ERROR())) + "; " + CUPS_LAST_ERROR_STRING()
  ELSE
    @ 12,3 SAY "Impressao em curso com o ID: " + ALLTRIM(STR(jobId))
  ENDIF
  ? ""
RETURN(NIL)



#pragma BEGINDUMP
#include <cups/cups.h>
#include <hbapi.h>
#include <hbapiitm.h>
#include <stdio.h>

HB_FUNC (CUPS_LAST_ERROR) {
  hb_retnl( (LONG) cupsLastError() );
  return;
}

HB_FUNC (CUPS_LAST_ERROR_STRING) {
  /*hb_retc( cupsLastErrorString() ); */
  hb_retc( ippErrorString ( cupsLastError() ) );
  return;
}

HB_FUNC( CUPS_PRINT_FILE ) {
  char * sPrinter;
  char * sFile;
  int num_dests;
  cups_dest_t *dest, *dests;
  int i, jobId = 0;
  int num_options = 0;
  cups_option_t *options = NULL;

  sPrinter = (char*)hb_parc( 1 );
  sFile = (char*)hb_parc( 2 );

  num_dests = cupsGetDests(&dests);
  dest = cupsGetDest(sPrinter, NULL, num_dests, dests);
  for (i = 0; i < dest->num_options; i ++)
    num_options = cupsAddOption(dest->options[i].name, dest->options[i].value,
                                num_options, &options);

  printf("Def printer: %s %p\n", dest->name, dest->name);
  printf("File: '%s'\n", sFile);

  jobId = cupsPrintFile(dest->name, sFile, "Modelo 8", num_options, options);

  printf("Print job num: %d\n", jobId);

  cupsFreeOptions(num_options, options);
  cupsFreeDests(num_dests, dests);

  hb_retnl( jobId );
  return;
}

HB_FUNC( CUPS_GET_DESTS ) {
  cups_dest_t *dest = NULL;
  cups_dest_t *dests = NULL;
  int num_dests = 0, i;
  PHB_ITEM pDir, pElem;

  pDir = hb_itemArrayNew( 0 );
  num_dests = cupsGetDests(&dests);

  if (num_dests > 0) {
    pElem = hb_itemNew( NULL ); 
    for(i=0, dest=dests; i < num_dests; i++,dest++) {
      hb_itemPutC   ( pElem, dest->name );
      hb_arrayAddForward( pDir, pElem );
    }

    hb_itemRelease( pElem );
  }
  cupsFreeDests(num_dests, dests);
  hb_itemReturnRelease( pDir );

}
#pragma ENDDUMP

