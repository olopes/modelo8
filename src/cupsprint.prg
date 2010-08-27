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

function printPrinter(perg,mes850)
? "CUPS printing not implemented"
/*
  local ok := .F., p, linhaB, Acumulado, lanc, pag, imposto
  local aPrn := GetPrinters()
  local nPrn := 1
  local oPrinter
  FIELD RECIBO, DATAREC, VALOR, RETENC IN RECIBOS

  local meses := { "Janeiro", "Fevereiro", "Março", "Abril", "Maio",;
                   "Junho", "Julho", "Agosto", "Setembro", "Outubro",;
                   "Novembro", "Dezembro"}
  local mes := meses[perg]

  /* Seleccao da impressoa * /
  @ 11,1 CLEAR TO 23,61
  @ 11,1 TO 23,61
  * @ 11,1,23,61 BOX B_SINGLE
  nPrn := ACHOICE(12,2,22,60,aPrn,.T.,,nPrn)
  IF EMPTY(nPrn) 
	return (nil)
  ENDIF
  
  oPrinter := Win32Prn():New(aPrn[nPrn])
  oPrinter:Landscape:= .F.
  oPrinter:FormType := FORM_A4
  oPrinter:Copies   := 1
  IF !oPrinter:Create()
    Alert("Cannot Create Printer")
  ELSE
    IF !oPrinter:startDoc("Recibos de "+mes)
      Alert("StartDoc() failed")
    ELSE

      oPrinter:SetPrc(4, 8 )
	  * 700 is bold
      oPrinter:SetFont("Courier New",12,{1,10}, 700, .F., .F., 0)
      pline(oPrinter,"                  AUXILIAR AO LIVRO DE REGISTO MODELO 8")
      oPrinter:SetFont("Courier New",10,{1,11}, 0, .F., .F., 0)
      oPrinter:NewLine()
      pline(oPrinter,"               Relação dos recibos MODELO 6 do mês de "+ mes)
      oPrinter:NewLine()
      pline(oPrinter,CONTRIB->NOME                                 +"    NIF "+CONTRIB->NIF)
      pline(oPrinter,CONTRIB->MORADA                               +"   R.F.(COD) "+CONTRIB->COD_RF)
      pline(oPrinter,CONTRIB->DSC_ACT                              +"     CODIGO "+CONTRIB->COD_ACT)
      oPrinter:NewLine()
      pline(oPrinter,"       LANC.            RECIBO                   VALOR        RETENCAO")
      pline(oPrinter,"        Nº.      Nº.            DATA             BRUTO           IRS")

      GO TOP
      linhaB := 10
      lanc := 0
      pag := 1
      Acumulado := 0
      imposto := 0
      DO WHILE !EOF()
        IF month(DATAREC) == perg
          linhaB++
          lanc++
          pline(oPrinter,str(lanc) +"   "+RECIBO+"      "+DTOC(DATAREC)+"     "+str(VALOR)+"     "+str(RETENC) + "  ")
          Acumulado += VALOR
          imposto += RETENC
          IF linhaB = 60
            oPrinter:NewLine()
            pline(oPrinter,"                                           Página: " + str(pag))
            pag++
            linhaB := 0
            oPrinter:NewPage()
            oPrinter:SetPrc(3, 8)
            pline(oPrinter,"       LANC.            RECIBO                   VALOR        RETENCAO")
            pline(oPrinter,"        Nº.      Nº.            DATA             BRUTO           IRS")
          ENDIF
        ENDIF 
        SKIP
      ENDDO

      oPrinter:NewLine()
      pline(oPrinter,"Soma TOTAL do mês:                        " +str(Acumulado)+ "  "+str(imposto))
      oPrinter:NewLine()
      oPrinter:EndDoc()
    ENDIF
    oPrinter:Destroy()
  ENDIF

RETURN(NIL)

function PLINE(oPrinter,msg)
  oPrinter:SetPrc(oPrinter:Prow()+01, 8 )
  oPrinter:TextOut(msg)
*/
return (NIL)

