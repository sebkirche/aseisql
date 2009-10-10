// Scintilla source code edit control
/** @file LexSQL.cxx
 ** Lexer for SQL.
 **/
// Copyright 1998-2002 by Neil Hodgson <neilh@scintilla.org>
// The License.txt file describes the conditions under which this software may be distributed.
#include <windows.h>
#include <RICHEDIT.H>


#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdio.h>
#include <stdarg.h>

#include "Platform.h"

#include "PropSet.h"
#include "Accessor.h"
#include "KeyWords.h"
#include "Scintilla.h"
#include "SciLexer.h"

//DMLU: copy as RTF. Code from SciTe
//---------- Save to RTF ----------

#define RTF_HEADEROPEN "{\\rtf1\\ansi\\deff0\\deftab720"
#define RTF_FONTDEFOPEN "{\\fonttbl"
#define RTF_FONTDEF "{\\f%d\\fnil\\fcharset%u %s;}"
#define RTF_FONTDEFCLOSE "}"
#define RTF_COLORDEFOPEN "{\\colortbl"
#define RTF_COLORDEF "\\red%d\\green%d\\blue%d;"
#define RTF_COLORDEFCLOSE "}"
#define RTF_HEADERCLOSE "\n"
#define RTF_BODYOPEN ""
#define RTF_BODYCLOSE "}"

#define RTF_SETFONTFACE "\\f"
#define RTF_SETFONTSIZE "\\fs"
#define RTF_SETCOLOR "\\cf"
#define RTF_SETBACKGROUND "\\highlight"
#define RTF_BOLD_ON "\\b"
#define RTF_BOLD_OFF "\\b0"
#define RTF_ITALIC_ON "\\i"
#define RTF_ITALIC_OFF "\\i0"
#define RTF_UNDERLINE_ON "\\ul"
#define RTF_UNDERLINE_OFF "\\ulnone"
#define RTF_STRIKE_ON "\\i"
#define RTF_STRIKE_OFF "\\strike0"

#define RTF_EOLN "\\par\n"
#define RTF_TAB "\\tab "

#define SCE_SQL_DEFAULT     0
#define SCE_SQL_COMMENT     1
#define SCE_SQL_COMMENTLINE 2
#define SCE_SQL_NUMBER      3
#define SCE_SQL_WORD        4
#define SCE_SQL_STRING      5
#define SCE_SQL_CHARACTER   6
#define SCE_SQL_OPERATOR    7
#define SCE_SQL_IDENTIFIER  8




//style : low three bytes defines color hi byte : bit[0]=bold; bit[1]=italic
bool SaveAsRTF(HWND SciWnd,int start,int end,int*styledef,int stylecount,FILE*fp){
	if (end < 0)end=SendMessage(SciWnd,SCI_GETTEXTLENGTH,0,0);
	SendMessage(SciWnd,SCI_COLOURISE, 0, -1);

	int tabs = 1;//props.GetInt("export.rtf.tabs", 0);
	int tabSize = 4;
	char* fontFace = "Courier New";
	int fontSize = 9<<1;//??? props.GetInt("export.rtf.font.size", 0);
	unsigned int characterset = SC_CHARSET_DEFAULT;
	int styleCurrent = -1;
	int i;
	//fefine font table (only one font face)
	fputs(RTF_HEADEROPEN RTF_FONTDEFOPEN, fp);
	fprintf(fp, RTF_FONTDEF, 0, characterset, fontFace);
	fputs(RTF_FONTDEFCLOSE, fp);
	//define color table
	fputs(RTF_COLORDEFOPEN, fp);
	for(i=0;i<stylecount;i++){
		int color=styledef[i]&0xFFFFFF;
		fprintf(fp, RTF_COLORDEF, GetRValue(color), GetGValue(color), GetBValue(color));
	}
	fputs(RTF_COLORDEFCLOSE, fp);
	fprintf(fp, RTF_HEADERCLOSE RTF_BODYOPEN RTF_SETFONTFACE "0" RTF_SETFONTSIZE "%d",fontSize );
	for (i = start; i < end; i++) {
		char ch = SendMessage(SciWnd,SCI_GETCHARAT,i,0);
		int style = SendMessage(SciWnd,SCI_GETSTYLEAT,i,0);
		if (style > stylecount)	style = 0;
		if (styleCurrent<0 || (styleCurrent>=0 && styledef[style] != styledef[styleCurrent] ) ) {
			if(styleCurrent>=0){
				if(styledef[styleCurrent]&0x01000000)fputs(RTF_BOLD_OFF, fp);
				if(styledef[styleCurrent]&0x02000000)fputs(RTF_ITALIC_OFF, fp);
			}
			//open new style
			fprintf(fp,RTF_SETCOLOR "%i",style);
			if(styledef[style]&0x01000000)fputs(RTF_BOLD_ON, fp);
			if(styledef[style]&0x02000000)fputs(RTF_ITALIC_ON, fp);
			fputc(' ', fp);//put space after style definition
			styleCurrent = style;
		}
		//put char
		switch(ch){
			case '{' :
			case '}' :
			case '\\':
				fprintf(fp,"\\%c",ch);
				break;
			case '\n':
				fputs(RTF_EOLN, fp);
				break;
			case '\t':
				fputs(RTF_TAB, fp);
				break;
			case '\r':
				break;
			default:
				fputc(ch, fp);
				break;
		}
	}
	fputs(RTF_BODYCLOSE, fp);
	return true;
}


extern "C" bool __stdcall CopyAsRTF(HWND SciWnd,int*styledef,int stylecount) {
	int StartPos=SendMessage(SciWnd,SCI_GETSELECTIONSTART,0,0);
	int EndPos  =SendMessage(SciWnd,SCI_GETSELECTIONEND,0,0);
	if(StartPos==EndPos)return true;
	
	FILE*fp=tmpfile();
	if (fp) {
		SaveAsRTF( SciWnd, StartPos, EndPos, styledef,stylecount,fp);
		fseek(fp, 0, SEEK_END);
		int len = ftell(fp);
		fseek(fp, 0, SEEK_SET);
		HGLOBAL hand = ::GlobalAlloc(GMEM_MOVEABLE | GMEM_ZEROINIT, len + 1);
		if (hand) {
			::OpenClipboard(SciWnd);
			::EmptyClipboard();
			char *ptr = static_cast<char *>(::GlobalLock(hand));
			fread(ptr, 1, len, fp);
			ptr[len] = '\0';
			::GlobalUnlock(hand);
			::SetClipboardData(::RegisterClipboardFormat(CF_RTF), hand);
			::CloseClipboard();
		}
		fclose(fp);
	}
	return true;
}




static void classifyWordSQL(unsigned int start, unsigned int end, WordList &keywords, Accessor &styler,int foldLevelOld,int &foldLevel,int &endFlag,int &beginFlag) {
	//int foldLevelOld     the original level of current line 
	//int &foldLevel       the current foldLevel (could be changed in this function)
	//int &endFlag         set if in current line was an END for the BEGIN from previous lines
	//int &beginFlag       set if we have BEGIN (waiting for TRAN or TRANSACTION)
	//                       if no TRAN[SACTION] then converted to foldLevel++
	char s[100];
	bool wordIsNumber = isdigit(styler[start]) || (styler[start] == '.');
	for (unsigned int i = 0; i < end - start + 1 && i < 30; i++) {
		s[i] = static_cast<char>(toupper(styler[start + i]));
		s[i + 1] = '\0';
	}
	char chAttr = SCE_SQL_DEFAULT;//SCE_SQL_IDENTIFIER;
	if (wordIsNumber)chAttr = SCE_SQL_NUMBER;
	else {
	
		if(beginFlag==1){
			if( !strcmp(s,"TRAN") || !strcmp(s,"TRANSACTION") )beginFlag=0;
			else {
				foldLevel++;
				beginFlag=0;
			}
		}
		if( !strcmp(s,"END") ){
			foldLevel--;
			if(foldLevel<foldLevelOld)endFlag=1;
		}else if( !strcmp(s,"BEGIN") ){
			beginFlag=1;
		}else if( !strcmp(s,"CASE") ){
			foldLevel++;
		}
		
		if (keywords.InList(s))	chAttr = SCE_SQL_WORD;
	}
	styler.ColourTo(end, chAttr);
}

static int GetFoldLevelOld(Accessor &styler,int line){
	char s[100];
	int level=SC_FOLDLEVELBASE;
	int i,startPos,endPos,style,stylePrev=SCE_SQL_DEFAULT;
	int beginFlag=0;
	if( line>0 ){
		//get level for the previous line
		line--;
		level=styler.LevelAt(line);
		if(level&SC_FOLDLEVELHEADERFLAG){
			level=level&SC_FOLDLEVELNUMBERMASK;
			startPos=styler.LineStart(line);
			endPos=styler.LineStart(line+1);
			for(i=startPos;i<endPos;i++){
				style=styler.StyleAt(i);
				if(style==SCE_SQL_WORD){
					if(stylePrev!=SCE_SQL_WORD)startPos=i;
					if(i-startPos>90)startPos=i;
					s[i-startPos]=static_cast<char>(toupper(styler[i]));
				}else if(stylePrev==SCE_SQL_WORD&&style!=SCE_SQL_WORD){
					s[i-startPos]=0;
					
					if(beginFlag==1){
						if( !strcmp(s,"TRAN") || !strcmp(s,"TRANSACTION") )beginFlag=0;
						else {
							level++;
							beginFlag=0;
						}
					}
					if( !strcmp(s,"END") ){
						level--;
					}else if( !strcmp(s,"BEGIN") ){
						beginFlag=1;
					}else if( !strcmp(s,"CASE") ){
						level++;
					}
				}
				stylePrev=style;
			}
			if(beginFlag)level++;
		}
	}
	return level;
}

static void ColouriseSQLDoc(unsigned int startPos, int length,
                            int initStyle, WordList *keywordlists[], Accessor &styler) {
	int comm_nest=0;
	int beginFlag=0;
	int endFlag=0;
	int prevState=SCE_SQL_DEFAULT;
	int foldLevelOld=SC_FOLDLEVELBASE;  //the original fold level for current line
	int foldLevel=SC_FOLDLEVELBASE;     //the current fold level (changed during line analyse) 
	
	if(initStyle==SCE_SQL_COMMENT && startPos>0){
		//find start of comment and change startPos
		while( styler.StyleAt(startPos-1)==initStyle ){
			startPos--;
			length++;
			if(startPos==0)break;
		}
		initStyle = SCE_SQL_DEFAULT;
	}
	prevState=initStyle;
	
/*
FILE *log=fopen("sci.log","at");
fprintf(log,"Start\n");
fprintf(log,"sizeof(SCNotification)=%i\n",sizeof(SCNotification));
fflush(log);
fclose(log);
*/
	
	WordList &keywords = *keywordlists[0];
	styler.StartAt(startPos);
	//fold init
	int lineCurrent = styler.GetLine(startPos);
	
	foldLevel=GetFoldLevelOld(styler,lineCurrent);
	foldLevelOld=foldLevel;
	//--------------
	int spaceFlags = 0;

	int state = initStyle;
	char chPrev = ' ';
	char chNext = styler[startPos];
	styler.StartSegment(startPos);
	unsigned int lengthDoc = startPos + length;
	for (unsigned int i = startPos; i <= lengthDoc; i++) {
		char ch = chNext;
		chNext = styler.SafeGetCharAt(i + 1);
		if ((ch == '\r' && chNext != '\n') || (ch == '\n')) {
			//fprintf(log," line=%8i foldLevel=%8X foldLevelOld=%8X\n",lineCurrent,foldLevel,foldLevelOld);
			int foldLevelNew=0;   //new fold level to set for current line
			
			if( beginFlag==1 )foldLevel++;
			
			
			foldLevelNew=foldLevel&SC_FOLDLEVELNUMBERMASK;
			if( foldLevel> (foldLevelOld&SC_FOLDLEVELNUMBERMASK))
				foldLevelNew=foldLevelOld|SC_FOLDLEVELHEADERFLAG;
			//case if END BEGIN are in the same line
			if( foldLevel==(foldLevelOld&SC_FOLDLEVELNUMBERMASK) && endFlag==1)
				foldLevelNew=(foldLevel-1)|SC_FOLDLEVELHEADERFLAG;
			
			styler.SetLevel(lineCurrent, foldLevelNew);
			
			//end found at the next line after begin.
			//so remove foldheader from previous line.
/*			if(lineCurrent>0){
				foldLevelOld=styler.LevelAt(lineCurrent-1);
				if((foldLevelOld&SC_FOLDLEVELHEADERFLAG) && (foldLevelNew==(foldLevelOld&SC_FOLDLEVELNUMBERMASK))){
					styler.SetLevel(lineCurrent-1, foldLevelNew);
				}
			}
*/
			foldLevelOld=foldLevel;
			beginFlag=0;
			endFlag=0;
			lineCurrent++;
		}

		if (styler.IsLeadByte(ch)) {
			chNext = styler.SafeGetCharAt(i + 2);
			chPrev = ' ';
			i += 1;
			continue;
		}

		if (state == SCE_SQL_DEFAULT) {
			if (iswordstart(ch)) {
				styler.ColourTo(i - 1, state);
				state = SCE_SQL_WORD;
			} else if (ch == '/' && chNext == '*') {
				styler.ColourTo(i - 1, state);
				ch=' ';
				chNext=' ';
				state = SCE_SQL_COMMENT;
			} else if (ch == '-' && chNext == '-') {
				styler.ColourTo(i - 1, state);
				state = SCE_SQL_COMMENTLINE;
			} else if (ch == '\'') {
				styler.ColourTo(i - 1, state);
				state = SCE_SQL_CHARACTER;
			} else if (ch == '"') {
				styler.ColourTo(i - 1, state);
				state = SCE_SQL_STRING;
			} else if (ch == '@') {
				styler.ColourTo(i - 1, state);
				state = SCE_SQL_IDENTIFIER;
			} else if (isoperator(ch)) {
				styler.ColourTo(i - 1, state);
				styler.ColourTo(i, SCE_SQL_OPERATOR);
			}
		} else if (state == SCE_SQL_WORD) {
			if (!iswordchar(ch)) {
				classifyWordSQL(styler.GetStartSegment(), i - 1, keywords, styler, foldLevelOld,foldLevel,endFlag,beginFlag);
				state = SCE_SQL_DEFAULT;
				if (ch == '/' && chNext == '*') {
					state = SCE_SQL_COMMENT;
					ch=' ';
					chNext=' ';
				} else if (ch == '-' && chNext == '-') {
					state = SCE_SQL_COMMENTLINE;
				} else if (ch == '\'') {
					state = SCE_SQL_CHARACTER;
				} else if (ch == '"') {
					state = SCE_SQL_STRING;
				} else if (isoperator(ch)) {
					styler.ColourTo(i, SCE_SQL_OPERATOR);
				}
			}
		} else {
			if (state==SCE_SQL_COMMENT) {
				if (ch=='/'){
					if(chPrev=='*'){
						if (((i > (styler.GetStartSegment() + 2)) || ((initStyle==SCE_SQL_COMMENT) &&
							(styler.GetStartSegment() == startPos)))) {
							if(comm_nest){
								comm_nest--;
							}else{
								styler.ColourTo(i, state);
								state = SCE_SQL_DEFAULT;
							}
							ch=' ';
						}
					}else if(chNext=='*'){
						comm_nest++;
						ch=' ';
						chNext=' ';
					}
				}
			} else if (state == SCE_SQL_COMMENTLINE) {
				if (ch == '\r' || ch == '\n') {
					styler.ColourTo(i - 1, state);
					state = SCE_SQL_DEFAULT;
				}
			} else if (state == SCE_SQL_CHARACTER) {
				if (ch == '\'') {
					if ( chNext == '\'' ) {
						i++;
					} else {
						styler.ColourTo(i, state);
						state = SCE_SQL_DEFAULT;
						i++;
					}
					ch = chNext;
					chNext = styler.SafeGetCharAt(i + 1);
				}
			} else if (state == SCE_SQL_STRING) {
				if (ch == '"') {
					if ( chNext == '"' ) {
						i++;
					} else {
						styler.ColourTo(i, state);
						state = SCE_SQL_DEFAULT;
						i++;
					}
					ch = chNext;
					chNext = styler.SafeGetCharAt(i + 1);
				}
			} else if (state == SCE_SQL_IDENTIFIER) {
				if ( !iswordstart(ch) ) {
					styler.ColourTo(i - 1, state);
					state = SCE_SQL_DEFAULT;
				}
			}
			if (state == SCE_SQL_DEFAULT) {    // One of the above succeeded
				if (ch == '/' && chNext == '*') {
					state = SCE_SQL_COMMENT;
					ch=' ';
					chNext=' ';
				} else if (ch == '-' && chNext == '-') {
					state = SCE_SQL_COMMENTLINE;
				} else if (ch == '\'') {
					state = SCE_SQL_CHARACTER;
				} else if (ch == '"') {
					state = SCE_SQL_STRING;
				} else if (ch == '@') {
					state = SCE_SQL_IDENTIFIER;
				} else if (iswordstart(ch)) {
					state = SCE_SQL_WORD;
				} else if (isoperator(ch)) {
					styler.ColourTo(i, SCE_SQL_OPERATOR);
				}
			}
		}
		//process for the comment folding
		if(state==SCE_SQL_COMMENT && prevState!=SCE_SQL_COMMENT){
			beginFlag=1;
		}else if(state!=SCE_SQL_COMMENT && prevState==SCE_SQL_COMMENT){
			endFlag=1;
			foldLevel--;
		}
		
		prevState=state;
		chPrev = ch;
	}
	styler.ColourTo(lengthDoc - 1, state);
//	fprintf(log,"end\n");
//	fflush(log);
//	fclose(log);
}

LexerModule lmSQL(SCLEX_SQL, ColouriseSQLDoc, "sql");
