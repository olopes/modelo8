*
*   main.prg -- Main procedure and database creation
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
#include "box.ch"
#include "rversion.ch"

FUNC MAIN
PrintDisclaimer()
OpenDB()
AUXILIAR()
RETURN (NIL)


PROC OpenDB()
  LOCAL estrutura := {}
  LOCAL RNOME, RNIF, RMORA, RRF, RCAE, RDAE
  LOCAL dbname
  
  DIRMAKE("db")
  
  * cria os ficheiros na pasta DB
  SET DEFAULT TO "db"
  SET PATH TO "db"

  IF !file("config.dbf")  && se estes ficheiros nao existem, cria novos
    ? "Aguarde enquanto eu crio uma nova configuracao... "
    estrutura := {}
    AADD(estrutura, {"BELL",  "N", 1, 0})
    AADD(estrutura, {"EPOCH", "N", 4, 0})

    dbcreate("config.dbf", estrutura)
    ?? "Ok."
    DBUSEAREA(.T., "DBFNTX", "config.dbf", "CONFIG")
    * USE CONFIG NEW
    APPEND BLANK
    REPLACE BELL WITH 0
    REPLACE EPOCH WITH 1990
    CLOSE CONFIG
  END
  IF !file("contrib.dbf")  && se estes ficheiros nao existem, cria novos
    RNOME=PADR("",50," ")
    RNIF=PADR("",9," ")
    RMORA=PADR("",50," ")
    RRF=PADR("",4," ")
    RDAE=PADR("",50," ")
    RCAE=PADR("",5," ")

    @  5,10 SAY "Informa‡„o do contribuinte"
    @  9, 1 SAY "Nome:      " GET RNOME
    @  9,65 SAY "NIF:" GET RNIF PICTURE [999999999]
    @ 10, 1 SAY "Morada:    " GET RMORA
    @ 10,65 SAY "COD RF:" GET RRF PICTURE [9999]
    @ 11, 1 SAY "Actividade:" GET RDAE
    @ 11,65 SAY "CAE:" GET RCAE PICTURE [99999]
    @ 15,10 SAY "ESC p/ cancelar e sair."
    READ
    
    IF LASTKEY() <> K_ESC
      ? "Aguarde enquanto eu crio uma nova bd de contribuintes... "
      estrutura := {}
      AADD(estrutura, {"NOME",    "C", 50, 0})
      AADD(estrutura, {"NIF",     "C",  9, 0})
      AADD(estrutura, {"MORADA",  "C", 50, 0})
      AADD(estrutura, {"COD_RF",  "C",  4, 0})
      AADD(estrutura, {"COD_ACT", "C",  5, 0})
      AADD(estrutura, {"DSC_ACT", "C", 50, 0})

      dbcreate("contrib.dbf", estrutura)
    
      DBUSEAREA(.T., "DBFNTX", "contrib.dbf", "CONTRIB")
      *USE CONTRIB NEW
      APPEND BLANK
      REPLACE NOME    WITH RNOME
      REPLACE NIF     WITH RNIF
      REPLACE MORADA  WITH RMORA
      REPLACE COD_RF  WITH RRF
      REPLACE COD_ACT WITH RCAE
      REPLACE DSC_ACT WITH RDAE
      CLOSE CONTRIB
      ?? "Ok."
    ELSE
      CLEAR
      QUIT
    ENDIF
  END
  DBUSEAREA(.T., "DBFNTX", "config.dbf", "CONFIG")
  *USE CONFIG NEW
  GOTO 1
  DBUSEAREA(.T., "DBFNTX", "contrib.dbf", "CONTRIB")
  *USE CONTRIB NEW
  GOTO 1
  dbname=ALLTRIM(LEFT(CONTRIB->NIF,8))
  IF !FILE(dbname+".dbf")  && criar a BD de recibos
    estrutura := {}
    ? "Aguarde enquanto eu crio uma nova base de dados..."
  
    * aadd(estrutura, {"NIF", "C", 9, 0})
    aadd(estrutura, {"RECIBO", "C", 10, 0})
    aadd(estrutura, {"DATAREC", "D", 8, 0})
    aadd(estrutura, {"VALOR", "N", 11, 2})
    aadd(estrutura, {"RETENC", "N", 9, 2})

    dbcreate(dbname+".dbf", estrutura)
    ?? "Ok."
  ENDIF

  IF !FILE(dbname+".ntx")
    DBUSEAREA(.T., "DBFNTX", dbname,"RECIBOS")
    DBCREATEINDEX(dbname,"DTOS(RECIBOS->DATAREC)", {||DTOS(RECIBOS->DATAREC)})
    * USE RECIBOS NEW
    * INDEX ON RECIBOS->NIF+DTOS(RECIBOS->DATAREC) TO RECIBOS
    CLOSE RECIBOS
  ENDIF
  
  DBUSEAREA(.T., "DBFNTX", dbname,"RECIBOS")
  * USE RECIBOS INDEX RECIBOS NEW
  DBSETINDEX(dbname)
  GOTO 1
  SELECT RECIBOS
RETURN

#pragma BEGINDUMP
#include <stdio.h>

HB_FUNC(PRINTDISCLAIMER) {
  printf("Modelo 8\n"); 
  printf("Copyright (C) 2010  Oscar Lopes <psicover.dev@gmail.com>\n");
  printf("This software comes with ABSOLUTELY NO WARRANTY.\n");
}

#pragma ENDDUMP

