*
*   imprime.prg -- Print configuration screen 
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

static getlist := {}

proc imprime()
  local meses := { "Janeiro", "Fevereiro", "Mar‡o", "Abril", "Maio",;
                   "Junho", "Julho", "Agosto", "Setembro", "Outubro",;
                   "Novembro", "Dezembro" /*, "Resumo Mensal"*/}
  local ok := .F., perg, IouE, p, linhaB, Acumulado, lanc, pag, imposto

  clear screen
  SET COLOR TO "W+/N"
  @ 5,30 SAY "Listar recibos"
  SET COLOR TO
  @ 24, 60 SAY "Recibos no ficheiro"
  @ 24, 49 SAY lastrec()

  @ 10,5 SAY "Selecione o mˆs a listar: (ESC=SAIR)"
  DO WHILE !ok
    @ 4,49 CLEAR TO 17,60
    @ 4,49  TO 17,60
    perg = achoice(5, 50, 16, 59, meses,, "ameses")
    IF perg == 0
      CLEAR SCREEN
      return
    ELSE
      ok = .T.
    ENDIF
  ENDDO
  
  @ 4,49 CLEAR TO 17,60
  IouE = SPACE(1)
  @10,5 say "Listar para a [i]mpressora, [E]cr„? ou [P]DF (ESC=SAIR)" GET IouE PICTURE [@!] VALID IouE $ [IEP]
  READ
  IF IouE == "P"
    sendToPdf(perg, meses[perg])
  ELSEIF IouE == "I"
    printWindows(perg, meses[perg])
  ELSEIF IouE == "E"
    listScr(perg, meses[perg])
  ENDIF

  
  @ 24,5 SAY  "Terminado. Pressione uma tecla para continuar..."
  INKEY(0)
  CLEAR SCREEN
RETURN

function ameses(modo, elemento, posicao)
  local retorno := AC_CONT, tecla
  if modo = AC_EXCEPT
    tecla = lastkey()
    if tecla = K_ENTER
        retorno = AC_SELECT
    elseif tecla = K_ESC
        retorno = AC_ABORT
    endif
  endif
return retorno

