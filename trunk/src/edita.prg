*
*   edita.prg -- Basic editor for "Modelo 6" receipts 
*   Copyright (C) 2010 Oscar Lopes
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

* fazer isto com um tbrowse()
#include "inkey.ch"
#include "setcurs.ch"
#include "set.ch"
#define KEY_ELEM 1
#define BLK_ELEM 2
#define K_CTRL_DEL 403

STATIC getlist := {}

proc edita
  local ok := .F., metodo, oldcur
  local editor, coluna
  local ed_methods := {{K_DOWN,      {|b| b:down()}},;
                       {K_UP,        {|b| b:up()}},;
                       {K_PGDN,      {|b| b:pagedown()}},;
                       {K_PGUP,      {|b| b:pageup()}},;
                       {K_CTRL_PGDN, {|b| b:gotop()}},;
                       {K_CTRL_PGUP, {|b| b:gobottom()}},;
                       {K_LEFT,      {|b| b:left()}},;
                       {K_RIGHT,     {|b| b:right()}},;
                       {K_HOME,      {|b| b:home()}},;
                       {K_END,       {|b| b:end()}},;
                       {K_CTRL_LEFT, {|b| b:panleft()}},;
                       {K_CTRL_RIGHT,{|b| b:panright()}},;
                       {K_CTRL_HOME, {|b| b:panhome()}},;
                       {K_CTRL_END,  {|b| b:panend()}}}
  FIELD RECIBO, DATAREC, VALOR, RETENC IN RECIBOS
  PRIVATE tecla

  && cria um browser e uma coluna
  editor := TBrowseDB(5,14,17,64)
  coluna := TBColumnNew("  N§ Recibo  Data         Val Bruto  Reten‡„o",;
                        {|| iif(deleted(),"*"," ")+" "+;
                        RECIBO+" "+transform(DATAREC,"E99/99/9999")+" "+;
                        str(VALOR)+" "+str(RETENC)+"  "})
  editor:addcolumn(coluna)

  GO TOP

  clear screen
  SET COLOR TO W+/N
  @ 3,31 SAY "Modificar Registos"
  @ 22,9 SAY "ESC = SAIR    RETURN = Modificar registo   SETAS = Mover Cursor"
  @ 23,9 SAY "F10 = Procurar  DEL = Marcar Registo  CTRL+DEL = Apaga Registos"
  @ 4,13 TO 18,65 DOUBLE
  SET COLOR TO
  @ 19, 60 SAY "Registos no ficheiro"
  @ 19, 49 SAY LASTREC()

  oldcur := setcursor(SC_NONE)
  DO While !ok  // ciclo at‚ ser pedido para terminar

    // mostra as linhas do browse no ecr„
    DO While nextkey() = 0 .AND. !editor:stabilize()
    EndDo
    // espera por uma tecla
    tecla := inkey(0)

    // pesquisa o array de metodos … procura da tecla pressionada
    metodo := ascan(ed_methods, {|elem| tecla = elem[KEY_ELEM]})

    If metodo != 0 // encontrou
      eval(ed_methods[metodo, BLK_ELEM], editor)
    Else           // nao estava pre-definida....
      Do Case
      Case tecla = K_ESC
        ok := .T.
      Case tecla = K_F10
        editor:dehilite()
        procura()
        editor:refreshAll()
        editor:hilite()
      Case tecla = K_ENTER
        modifica()
        editor:refreshAll()
      Case tecla = K_CTRL_DEL
        editor:dehilite()
        expugna()
        editor:refreshAll()
        editor:hilite()
      Case tecla = K_DEL
        If deleted()
          RECALL
        Else
          DELETE
        ENDIF
        editor:refreshCurrent()
      EndCase
    EndIf
  EndDo
  setcursor(oldcur)
  clear screen
RETURN

PROC expugna
  Local recdel, exp_scr, cur
  cur := setcursor(SC_NORMAL) 
  SAVE SCREEN TO exp_scr
  recdel = SPACE(1)
  @ 4,13 TO 18,65
  SET COLOR TO W+/N
  @ 9,9 CLEAR TO 11,52
  @ 9,9 TO 11,52 DOUBLE
  @ 9,20 SAY "APAGAR"
  @ 10,10 SAY "APAGAR TODOS OS REGISTOS MARCADOS? (S/N)" GET recdel PICTURE [!] VALID recdel$ [SN] 
  READ
  SET COLOR TO
  IF RECDEL == "S"
    PACK
  ENDIF
  RESTORE SCREEN FROM exp_scr
  setcursor(cur)
  @ 19, 60 SAY "Registos no ficheiro"
  @ 19, 49 SAY LASTREC()
RETURN

PROC procura
  Local recdel, pro_scr, cur, conf, recib, curRec
  FIELD RECIBO

  curRec := recno()
  cur := setcursor(SC_NORMAL)
  SAVE SCREEN TO pro_scr
  GO TOP
  conf := set(_SET_CONFIRM, .T.)
  RECIB = SPACE(10)
  @ 4,13 TO 18,65
  SET COLOR TO W+/N
  @ 19,0 TO 21,23 DOUBLE
  @ 19,9 SAY "PROCURAR"
  SET COLOR TO
  @ 20,1 SAY "RECIBO N§:" 
  @ 20,12 GET RECIB PICTURE [@!]
  READ
  LOCATE FOR RECIB == RECIBO
  if !found()
    SET COLOR TO W+/N
    @ 19, 0 CLEAR TO 21,30
    @ 19, 0 TO 21,30 DOUBLE
    @ 19,9 SAY "PROCURAR"
    SET COLOR TO
    @ 20, 1 SAY RECIB + " n„o encontrado..."
    inkey(2)
    GOTO curRec
  endif
  RESTORE SCREEN FROM pro_scr
  set(_SET_CONFIRM, conf)
  setcursor(cur)
RETURN

PROC modifica
  local ra, rb, rc, rd, mod_scr, cur
  FIELD RECIBO, DATAREC, VALOR, RETENC
  SAVE SCREEN TO mod_scr
  cur := setcursor(SC_NORMAL)
  RA = RECIBO
  RB = DATAREC
  RC = VALOR
  RD = RETENC
  SET COLOR TO "W+/N"
  CLEAR SCREEN
  @ 5,30 SAY "Modificar recibo n§ "+ltrim(str(recno()))
  SET COLOR TO

  @ 21, 60 SAY "registos existentes"
  @ 21, 49 SAY lastrec()
  @ 9,9 to 20,79 doub
  @ 11,12 SAY "Importƒncia bruta:" GET RC PICTURE [999 999.99]
  @ 11,50 SAY "IRS retido:" GET RD PICTURE [99 999.99]
  @ 18,12 SAY "Data do recibo:" GET RB PICTURE [99/99/9999]
  @ 18,50 SAY "N£mero do recibo:" GET RA PICTURE [@!]
  READ
  IF LASTKEY() <> K_ESC
    REPLACE RECIBO WITH RA
    REPLACE DATAREC WITH RB
    REPLACE VALOR WITH RC
    REPLACE RETENC WITH RD
	IF CONFIG->BELL <> 0
      TONE(1450,5)
      TONE(1450,5)
	ENDIF
  ENDIF
  setcursor(cur)
  RESTORE SCREEN FROM mod_scr
RETURN

