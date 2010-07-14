*
*   adiciona.prg -- Input form to "Modelo 6" receipts 
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

proc adiciona()
  local ra, rb, rc, rd, getlist := {}
  FIELD RECIBO, DATAREC, VALOR, RETENC IN RECIBOS
  GOTO BOTTOM
  RA = inc_rec(RECIBO)
  RB = DATAREC
  RC = VALOR
  RD = RETENC
  SET COLOR TO "W+/N"
  CLEAR SCREEN
  @ 5,30 SAY "Acrescentar recibos"
  SET COLOR TO

  DO WHILE .T.
    @ 21, 60 SAY "registos existentes"
    @ 21, 49 SAY lastrec()
    @ 9,9 to 20,79 doub
    @ 11,12 SAY "Importƒncia bruta:" GET RC PICTURE [999 999.99]
    @ 11,50 SAY "IRS retido:" GET RD PICTURE [99 999.99]
    @ 18,12 SAY "Data do recibo:" GET RB PICTURE [99/99/9999]
    @ 18,50 SAY "N£mero do recibo:" GET RA PICTURE [@!]
    READ
    IF LASTKEY() <> K_ESC
      APPEND BLANK
      REPLACE RECIBO WITH RA
      REPLACE DATAREC WITH RB
      REPLACE VALOR WITH RC
      REPLACE RETENC WITH RD
  IF CONFIG->BELL <> 0
      TONE(1450,5)
      TONE(1450,5)
  ENDIF
    ELSE
      EXIT
    ENDIF
    RA = inc_rec(RECIBO)
  ENDDO
  CLEAR SCREEN
RETURN

FUNCTION inc_rec(cRecibo)
LOCAL tmpa, tmpb, tmpc, tmpd, retval
tmpa = substr(cRecibo,4,len(cRecibo)-3)
tmpb = val(tmpa)
tmpb++
tmpc = alltrim(str(tmpb,7))
IF len(tmpc) <> len(tmpa)
  tmpd = len(tmpa) - len(tmpc)
  retval = substr(cRecibo,1,3) + replicate("0", tmpd) + tmpc
ELSE
  retval = substr(cRecibo,1,3) + tmpc
ENDIF
RETURN retval
