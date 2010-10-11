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
* Gerar PDF
* Enviar para impressora

function printPrinter(perg,mes860)
  LOCAL fname
  LOCAL defPrinter

  * Criar temp file
  fname := "./print.pdf"
  sendToPdf(perg,mes860,fname)

  sendPdfToPrinter(fname);

RETURN(NIL)


FUNCTION sendPdfToPrinter( cFile )
   LOCAL cPath, cFileName, cFileExt
   HB_FNameSplit( cFile, @cPath, @cFileName, @cFileExt )
   _SendCups( cPath, cFile )
RETURN (NIL) 

#pragma BEGINDUMP
#include <cups/cups.h>
#include <hbapi.h>
#include <stdio.h>

HB_FUNC( _SENDCUPS ) {
  char * sPath;
  char * sFile;
  const char * sDefaultPrinter;

  sPath = (char*)hb_parc( 1 );
  sFile = (char*)hb_parc( 2 );

  /* sDefaultPrinter = cupsGetDefault(); */
  sDefaultPrinter = "FilePrinter";
  printf("Def printer: %s %p\n", sDefaultPrinter, sDefaultPrinter);
  printf("File: %s; Path: %s\n", sFile, sPath);

  cupsPrintFile(sDefaultPrinter, sFile, "Modelo 8", 0, NULL);
  hb_retnl( 0 );
  return;
}
#pragma ENDDUMP

