*
*   lstscr.prg -- Print to screen
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


function listscr(perg,mes)
  local ok := .F., p, linhaB, Acumulado, lanc, pag, imposto
  FIELD RECIBO, DATAREC, VALOR, RETENC IN RECIBOS

  clear screen

  ? "                  AUXILIAR AO LIVRO DE REGISTO MODELO 8"
  ? 
  ? "               Rela‡„o dos recibos MODELO 6 do mˆs de", mes
  ?
  ?    CONTRIB->NOME                                 +"    NIF "+CONTRIB->NIF
  ?    CONTRIB->MORADA                               +"   R.F.(COD) "+CONTRIB->COD_RF
  ?    CONTRIB->DSC_ACT                              +"     CODIGO "+CONTRIB->COD_ACT
  ?
  ? "       LANC.            RECIBO                   VALOR        RETENCAO"
  ? "        N§.      N§.            DATA             BRUTO           IRS"

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
      ? lanc, "   ", RECIBO, "   ", DATAREC, "   ", VALOR, "   ", RETENC
      Acumulado += VALOR
      imposto += RETENC
    ENDIF
    SKIP
  ENDDO

  ?
  ? "Soma TOTAL do mˆs:                           " , Acumulado, "  ", imposto
  ?
RETURN

