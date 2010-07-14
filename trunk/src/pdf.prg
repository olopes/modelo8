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

#include "pdf.ch"
#include "pdfhbdoc.ch"

function sendToPdf(perg,mes860)

  local meses := { "Janeiro", "Fevereiro", "Março", "Abril", "Maio",;
                   "Junho", "Julho", "Agosto", "Setembro", "Outubro",;
                   "Novembro", "Dezembro"}
  local meses_abr := { "jan", "fev", "mar", "abr", "maio",;
                   "jun", "jul", "ago", "set", "out",;
                   "nov", "dez"}
  local mes := meses[perg]

local lines := { ;
  "      AUXILIAR AO LIVRO DE REGISTO MODELO 8", ;
  "", ;
  "               Relação dos recibos MODELO 6 do mês de " + mes, ;
  "", ;
  CONTRIB->NOME                                 +"    NIF "+CONTRIB->NIF, ;
  CONTRIB->MORADA                               +"   R.F.(COD) "+CONTRIB->COD_RF, ;
  CONTRIB->DSC_ACT                              +"     CODIGO "+CONTRIB->COD_ACT, ;
  "", ;
  "       LANC.            RECIBO                   VALOR        RETENCAO", ;
  "        Nº.      Nº.            DATA             BRUTO           IRS" ;
}

cFile3 := "rpt_"+meses_abr[perg]+".pdf"
PdfNew(cFile3,10,a4_height,a4_width,80,40,,)
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
  PdfEnd()
  
  OpenFile(cFile3)

return NIL

***********************************************************************************
***************INICIO DA FUNCAO DE ABRIR ARQUIVOS**********************************
***********************************************************************************
// Open help file with associated viewer application
FUNCTION OpenFile( cHelpFile )
   LOCAL nRet, cPath, cFileName, cFileExt
   HB_FNameSplit( cHelpFile, @cPath, @cFileName, @cFileExt )
   nRet := _OpenHelpFile( cPath, cHelpFile )
RETURN nRet

#pragma BEGINDUMP
   #include <hbapi.h>
   #pragma comment( lib, "shell32.lib" )
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
#pragma ENDDUMP
********************************************************************************
***************FIM DA FUNCAO DE ABRIR ARQUIVOS**********************************
********************************************************************************
