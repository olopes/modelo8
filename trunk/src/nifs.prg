*
*   nifs.prg -- NIF (Tax id) validation
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

FUNCTION CHECK_NIF(NIF)
LOCAL N[9], checkDigit


IF LEN(NIF) != 9
  RETURN (.F.)
ENDIF

FOR  i := 1 TO 9
N[i]=VAL(NIF[i])
NEXT

** validar o primeiro algarismo
* Os algarismos validos sao: 125689
* logo nao pode ser nenhum destes: 0347
IF (N[1] = 0 .OR. N[1] = 3 .OR. N[1] = 4 .OR. N[1] = 7)
  RETURN (.F.)
ENDIF

checkDigit := 0
FOR i := 1 TO 8
  checkDigit := checkDigit + N[i]*(10-i)
NEXT
checkDigit := 11 - (checkDigit % 11)

checkDigit := IIF(checkDigit=10, 0, checkDigit)

RETURN (checkDigit=N[9])

