*
*   auxiliar.prg -- Main menu screen
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
#include "mybox.ch"
#include "rversion.ch"

PROC Auxiliar
  local ecra_principal, AX, getlist := {}
  CLEAR
  IF CONFIG->BELL <> 0
    SET BELL ON
  ELSE
    SET BELL OFF
  ENDIF
  
  SET WRAP ON
  SET DATE BRITISH
  SET SOFTSEEK ON
  SET CENTURY ON
  SET EPOCH TO (CONFIG->EPOCH)

  desenha_tela()
  DO WHILE .T.
    @ 22, 60 SAY "registos existentes."
    @ 22, 49 SAY LASTREC()
    AX = 0
    SET MESSAGE TO 24 CENTER
    @ 13,27 PROMPT " 1 - ADICIONAR REGISTOS " MESSAGE "Permite acrescentar registos ao ficheiro de dados actual"
    @ 14,27 PROMPT " 2 -  EDITAR REGISTOS   " MESSAGE "Permite alterar registos no ficheiro de dados actual"
    @ 15,27 PROMPT " 3 - IMPRIMIR REGISTOS  " MESSAGE "Faz a listagem dos registos existentes"
    @ 16,27 PROMPT " 4 - REINDEXAR REGISTOS " MESSAGE "Reordena os registo no ficheiro"
    @ 17,27 PROMPT " 5 -     CONFIGURAR     " MESSAGE "Configura a aplica‡„o"
    @ 19,27 PROMPT " 6 -   SAIR PARA DOS    " MESSAGE "Termina o programa e sai para o DOS"
    MENU TO AX
    SAVE SCREEN TO ecra_principal
    DO CASE
      CASE AX == 0 .OR. AX == 6
        CLEAR
        QUIT
      CASE AX == 1
        ADICIONA()
      CASE AX == 2
        EDITA()
      CASE AX == 3
*        IMPRIME()
      CASE AX == 4
        REINDEX
      CASE AX == 5
        CONFIGURAR()
    ENDCASE     
    RESTORE SCREEN FROM ecra_principal
  ENDDO    
RETURN

PROC desenha_tela
CLEAR SCREEN
@  3,17 SAY R_NAME_VERSION
@  6, 5 SAY CONTRIB->NOME+"     NIF: "+CONTRIB->NIF
@  7, 5 SAY CONTRIB->MORADA+"     R.F.(COD) "+CONTRIB->COD_RF
@  8, 5 SAY CONTRIB->DSC_ACT+"     C¢digo:  "+CONTRIB->COD_ACT
@ 11,23 SAY "Seleccione uma op‡„o:"

** desenhar as caixas...
@ 1, 2,21,76 BOX B_SLICK
@ 2,12 TO  4,67 DOUBLE
@ 5, 4 TO  9,74 DOUBLE

RETURN

PROC CONFIGURAR()
CLEAR SCREEN
@ 10, 10 SAY "BELL (0/1) " GET CONFIG->BELL PICTURE "9"
@ 11, 10 SAY "EPOCH " GET CONFIG->EPOCH PICTURE "9999"
READ

IF CONFIG->BELL <> 0
  SET BELL ON
ELSE
  SET BELL OFF
ENDIF
SET EPOCH TO (CONFIG->EPOCH)

RETURN

