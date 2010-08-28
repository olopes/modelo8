*
*   pdfapi.prg -- Simple api wrapper for Haru PDF
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

#include "harupdf.ch"

STATIC hdPdf := NIL
STATIC hpPage := NIL

* wrappers para contornar a api de PDF
function PdfNew()
   if hdPdf == NIL

     hdPdf := HPDF_New()
     if hdPdf == NIL
       alert( " Pdf could not been created!" )
       return (nil)
     endif
  
     * do extra config

   endif
return (nil)

function PdfStartPage( aLines , bNew )
   LOCAL def_font
   if hdPdf == NIL
      return (nil)
   endif
   if bNew == NIL; bNew:=.T.; endif

   hpPage := HPDF_AddPage(hdPdf)
   HPDF_Page_SetSize(hpPage, HPDF_PAGE_SIZE_A4, HPDF_PAGE_PORTRAIT)
   def_font := HPDF_GetFont(hdPdf, "Courier", "CP1252" )
   HPDF_Page_SetFontAndSize(hpPage, def_font, 10)
   * HPDF_Page_SetTextLeading(hpPage,20)
   height = HPDF_Page_GetHeight (hpPage)

   HPDF_Page_BeginText(hpPage)
   HPDF_Page_MoveTextPos( hpPage, 50, height - 50 )
   if aLines <> NIL
     PdfDrawPage( aLines, bNew)
   endif

return (nil)

function PdfDrawPage( aLines , bNew )
   Local i
   if hdPdf == NIL
      return (nil)
   endif

   for i := 1 to len(aLines)
      HPDF_Page_ShowText(hpPage, aLines[i])
      HPDF_Page_MoveTextPos(hpPage, 0, -12)
   next
   
return (nil)

function PdfEndPage( )
   if hpPage == nil
     return nil
   endif
   HPDF_Page_EndText( hpPage )
   hpPage := nil
return (nil)

function PdfEnd( fName )
   if hdPdf == NIL
      return (nil)
   endif
   HPDF_SaveToFile(hdPdf, fName)
   HPDF_Free(hdPdf)
return (nil)
