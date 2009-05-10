#include <stdio.h>

#include <windows.h>

#include "Platform.h"
#include "Scintilla.h"


/**
 * Display the Print dialog (if @a showDialog asks it),
 * allowing it to choose what to print on which printer.
 * If OK, print the user choice, with optionally defined header and footer.
 */

HANDLE hDevMode=NULL;
HANDLE hDevNames=NULL;


int CALLBACK EnumFontFamExProc(ENUMLOGFONTEX *lpelf,NEWTEXTMETRICEX *lpntme,int FontType,LPARAM lParam){
	
	if( (long)SendMessage((HWND)lParam,CB_FINDSTRINGEXACT,-1,(long)lpelf->elfLogFont.lfFaceName)==CB_ERR)
		SendMessage((HWND)lParam,CB_ADDSTRING,0,(long)lpelf->elfLogFont.lfFaceName);
	return 1; //continue
}



extern "C" BOOL _stdcall EnumerateFonts(HWND w){
	HDC hdc = GetDC(NULL);

	LOGFONT lf;
	memset(&lf,0,sizeof(lf));
	lf.lfCharSet=DEFAULT_CHARSET;
	EnumFontFamiliesEx(hdc,&lf,(FONTENUMPROC)&EnumFontFamExProc,(LPARAM)w,0);
	
	
	ReleaseDC(NULL, hdc);
	return true;
	
}


extern "C" BOOL _stdcall SciPrint(HWND MainHWND,HWND SciHWND, bool showDialog) {
	BOOL ret=true;
	
	PRINTDLG pdlg = {
	                    sizeof(PRINTDLG), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	                };
	pdlg.hwndOwner = MainHWND;
	pdlg.hInstance = NULL;//hInstance;
	pdlg.Flags = PD_USEDEVMODECOPIES | PD_ALLPAGES | PD_RETURNDC;
	pdlg.nFromPage = 1;
	pdlg.nToPage = 1;
	pdlg.nMinPage = 1;
	pdlg.nMaxPage = 0xffffU; // We do not know how many pages in the
	// document until the printer is selected and the paper size is known.
	pdlg.nCopies = 1;
	pdlg.hDC = 0;
	pdlg.hDevMode = hDevMode;
	pdlg.hDevNames = hDevNames;

	// See if a range has been selected
	//CharacterRange crange = GetSelection();
	int startPos = 0;//crange.cpMin;
	int endPos = 0;//crange.cpMax;

	//if (startPos == endPos) {
		pdlg.Flags |= PD_NOSELECTION;
	//} else {
	//	pdlg.Flags |= PD_SELECTION;
	//}
	if (!showDialog) {
		// Don't display dialog box, just use the default printer and options
		pdlg.Flags |= PD_RETURNDEFAULT;
	}
	if (PrintDlg(&pdlg)) {

		hDevMode = pdlg.hDevMode;
		hDevNames = pdlg.hDevNames;

		HDC hdc = pdlg.hDC;

		RECT rectMargins, rectPhysMargins;
		POINT ptPage;
		POINT ptDpi;

		// Get printer resolution
		ptDpi.x = GetDeviceCaps(hdc, LOGPIXELSX);    // dpi in X direction
		ptDpi.y = GetDeviceCaps(hdc, LOGPIXELSY);    // dpi in Y direction

		// Start by getting the physical page size (in device units).
		ptPage.x = GetDeviceCaps(hdc, PHYSICALWIDTH);   // device units
		ptPage.y = GetDeviceCaps(hdc, PHYSICALHEIGHT);  // device units

		// Get the dimensions of the unprintable
		// part of the page (in device units).
		rectPhysMargins.left = GetDeviceCaps(hdc, PHYSICALOFFSETX);
		rectPhysMargins.top = GetDeviceCaps(hdc, PHYSICALOFFSETY);

		// To get the right and lower unprintable area,
		// we take the entire width and height of the paper and
		// subtract everything else.
		rectPhysMargins.right = ptPage.x						// total paper width
								- GetDeviceCaps(hdc, HORZRES) // printable width
								- rectPhysMargins.left;				// left unprintable margin

		rectPhysMargins.bottom = ptPage.y						// total paper height
								 - GetDeviceCaps(hdc, VERTRES)	// printable height
								 - rectPhysMargins.top;				// right unprintable margin

		rectMargins.left	= rectPhysMargins.left;
		rectMargins.top	= rectPhysMargins.top;
		rectMargins.right	= rectPhysMargins.right;
		rectMargins.bottom	= rectPhysMargins.bottom;

		// Convert device coordinates into logical coordinates
		DPtoLP(hdc, (LPPOINT) &rectMargins, 2);
		DPtoLP(hdc, (LPPOINT)&rectPhysMargins, 2);

		// Convert page size to logical units and we're done!
		DPtoLP(hdc, (LPPOINT) &ptPage, 1);

		DOCINFO di = {sizeof(DOCINFO), 0, 0, 0, 0};
		di.lpszDocName = "ASE Isql";
		di.lpszOutput = 0;
		di.lpszDatatype = 0;
		di.fwType = 0;
		if (StartDoc(hdc, &di) < 0) {
			MessageBox(MainHWND, "Can not start printer document.", 0, MB_OK);
			return FALSE;
		}

		LONG lengthDoc = SendMessage(SciHWND,SCI_GETLENGTH,0,0);
		LONG lengthDocMax = lengthDoc;
		LONG lengthPrinted = 0;

		// Requested to print selection
		if (pdlg.Flags & PD_SELECTION) {
			if (startPos > endPos) {
				lengthPrinted = endPos;
				lengthDoc = startPos;
			} else {
				lengthPrinted = startPos;
				lengthDoc = endPos;
			}

			if (lengthPrinted < 0)
				lengthPrinted = 0;
			if (lengthDoc > lengthDocMax)
				lengthDoc = lengthDocMax;
		}

		// We must substract the physical margins from the printable area
		RangeToFormat frPrint;
		frPrint.hdc = hdc;
		frPrint.hdcTarget = hdc;
		frPrint.rc.left = rectMargins.left - rectPhysMargins.left;
		frPrint.rc.top = rectMargins.top - rectPhysMargins.top;
		frPrint.rc.right = ptPage.x - rectMargins.right - rectPhysMargins.left;
		frPrint.rc.bottom = ptPage.y - rectMargins.bottom - rectPhysMargins.top;
		frPrint.rcPage.left = 0;
		frPrint.rcPage.top = 0;
		frPrint.rcPage.right = ptPage.x - rectPhysMargins.left - rectPhysMargins.right - 1;
		frPrint.rcPage.bottom = ptPage.y - rectPhysMargins.top - rectPhysMargins.bottom - 1;
		
		// Print each page
		int pageNum = 1;
		bool printPage;

		while (lengthPrinted < lengthDoc) {
			printPage = (!(pdlg.Flags & PD_PAGENUMS) ||
						 (pageNum >= pdlg.nFromPage) && (pageNum <= pdlg.nToPage));


			if (printPage) {
				::StartPage(hdc);
			}

			frPrint.chrg.cpMin = lengthPrinted;
			frPrint.chrg.cpMax = lengthDoc;

			lengthPrinted = SendMessage(SciHWND,SCI_FORMATRANGE,
									   printPage,
									   reinterpret_cast<LPARAM>(&frPrint));

			if (printPage) {
			fprintf(log,"end page %i\n",pageNum);
				::EndPage(hdc);
			}
			pageNum++;

			if ((pdlg.Flags & PD_PAGENUMS) && (pageNum > pdlg.nToPage))
				break;
		}

		SendMessage(SciHWND,SCI_FORMATRANGE, FALSE, 0);

		fprintf(log,"print end\n");
		::EndDoc(hdc);
		::DeleteDC(hdc);
	}else{
		fprintf(log,"error in PrintDlg : 0x%X\n",CommDlgExtendedError());
		ret=FALSE;
	}
	fprintf(log,"-----END-----\n");
	fflush(log);
	if( log != NULL ) fclose( log );
	return ret;
}
