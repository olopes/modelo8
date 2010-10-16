*
*   pdf.prg -- Print to PDF
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

* #include "hbvpdf.ch"

function sendToPdf(perg,mes860,cFile3)

  local meses := { "Janeiro", "Fevereiro", "Março", "Abril", "Maio",;
                   "Junho", "Julho", "Agosto", "Setembro", "Outubro",;
                   "Novembro", "Dezembro"}
  local meses_abr := { "jan", "fev", "mar", "abr", "maio",;
                   "jun", "jul", "ago", "set", "out",;
                   "nov", "dez"}
  local mes := meses[perg]

local lines := { ;
  "           AUXILIAR AO LIVRO DE REGISTO MODELO 8", ;
  "", ;
  "                  Relação dos recibos MODELO 6 do mês de " + mes, ;
  "", ;
  CONTRIB->NOME                                 +"    NIF "+CONTRIB->NIF, ;
  CONTRIB->MORADA                               +"   R.F.(COD) "+CONTRIB->COD_RF, ;
  CONTRIB->DSC_ACT                              +"     CODIGO "+CONTRIB->COD_ACT, ;
  "", ;
  "       LANC.            RECIBO                   VALOR        RETENCAO", ;
  "        Nº.      Nº.            DATA             BRUTO           IRS" ;
}
  local bShowFile := .F.

if cFile3 == NIL
   cFile3 := "rpt_"+meses_abr[perg]+".pdf"
#ifdef _MK_DARWIN_
   cFile3:="/"+CURDIR()+"/"+cFile3
#endif
   bShowFile := .T.
endif

PdfNew()
PdfStartPage( lines , .T. )

lines:={}

  lanc := 0
  pag := 1
  Acumulado := 0
  imposto := 0

  GO TOP
  DO WHILE !EOF()
    IF month(DATAREC) == perg
      lanc++
      Acumulado += VALOR
      imposto += RETENC

      aadd(lines, str(lanc) +"   "+RECIBO+"      "+DTOC(DATAREC)+"   "+;
	str(VALOR)+"     "+str(RETENC) + "  ")
      
    ENDIF
    SKIP
  ENDDO

  aadd(lines, "")
  aadd(lines, "Soma TOTAL do mes:                           " + ;
	str(Acumulado) + " EUR  " + str(imposto) + " EUR")
  aadd(lines, "")
  PdfDrawPage( lines )
  PdfEndPage()
  PdfEnd(cFile3)
  
  IF bShowFile = .T.
    OpenFile(cFile3)
  ENDIF
return NIL



********************************************************************************
***************INICIO DA FUNCAO DE ABRIR ARQUIVOS*******************************
********************************************************************************
// Open help file with associated viewer application
FUNCTION OpenFile( cHelpFile )
   LOCAL nRet, cPath, cFileName, cFileExt
   HB_FNameSplit( cHelpFile, @cPath, @cFileName, @cFileExt )
   nRet := _OpenHelpFile( cPath, cHelpFile )
RETURN nRet

#pragma BEGINDUMP

#include <hbapi.h>
#include <stdio.h>
#include <stdlib.h>

#if defined( _MK_WIN_ )
   /* (sharpsign) pragma comment( lib, "shell32.lib" ) */
   #include <windows.h>

   HB_FUNC( _OPENHELPFILE )
   {
     HINSTANCE hInst;
     LPCTSTR lpPath = (LPTSTR) hb_parc( 1 );
     LPCTSTR lpHelpFile = (LPTSTR) hb_parc( 2 );
     hInst = ShellExecute( 0, "open", lpHelpFile, 0, lpPath, SW_SHOW );
     hb_retnl( (LONG) hInst );
     return;
   }

#elif defined( _MK_DARWIN_ )
#include <ApplicationServices/ApplicationServices.h>

   HB_FUNC( _OPENHELPFILE )
   {
    FSRef inRef;
    OSStatus status;
    UInt8 *path, *parent;
    
    parent = (UInt8*) hb_parc( 1 );
    path = (UInt8*) hb_parc( 2 );
    /* printf("File is: '%s'\n", path); */
    status = FSPathMakeRef(path,&inRef,NULL);
    /* printf("Status: %d\n", (int)status); */
    status = LSOpenFSRef(&inRef,NULL);
    /* printf("Status: %d\n", (int)status); */

     hb_retnl( (LONG) status );
     return;
   }

#else
#include <unistd.h>
   HB_FUNC( _OPENHELPFILE )
   {
     int pid;
     char *sFile, sCmd;

     sFile = hb_parc(2);

     sCmd = (char*) malloc(20+strlen(sFile));
     sprintnf(sCmd, "xdg-open \"%s\"", sFile);
     printf("executing: %s\n", sCmd);
     pid = system(sCmd);
     
/* Atempt to use the Unix way */
/*
     pid= fork();
     if(pid == 0) {
       pid = execlp("xdg-open",file, NULL);
       exit(0);
     }
*/

     hb_retnl( (LONG) pid );
     return;
   }

#endif
#pragma ENDDUMP
********************************************************************************
***************FIM DA FUNCAO DE ABRIR ARQUIVOS**********************************
********************************************************************************
