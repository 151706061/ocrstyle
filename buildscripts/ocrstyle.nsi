; ��װ�����ʼ���峣��
!define OCRSTYLE_NAME "ocrstyle.exe"
!define PRODUCT_NAME "OCR Style"
!define PRODUCT_VERSION "1.0"
!define PRODUCT_PUBLISHER "������"
!define PRODUCT_WEB_SITE "http://www.ocrstyle.com/"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\${OCRSTYLE_NAME}"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

SetCompressor lzma

; ------ MUI �ִ����涨�� (1.67 �汾���ϼ���) ------
!include "MUI.nsh"

; MUI Ԥ���峣��
!define MUI_ABORTWARNING
!define MUI_ICON "ocrstyle\ocrstyle.ico"
!define MUI_UNICON "ocrstyle\uninstall.ico"
!define MUI_WELCOMEFINISHPAGE_BITMAP "ocrstyle\welcome.bmp"
!define MUI_CUSTOMFUNCTION_GUIINIT MyGUIInit

; ��ӭҳ��
!insertmacro MUI_PAGE_WELCOME
; ���Э��ҳ��
!insertmacro MUI_PAGE_LICENSE "ocrstyle\licence.txt"
; ��װĿ¼ѡ��ҳ��
!insertmacro MUI_PAGE_DIRECTORY
; ��װ����ҳ��
!insertmacro MUI_PAGE_INSTFILES
; ��װ���ҳ��
!define MUI_FINISHPAGE_RUN "$INSTDIR\${OCRSTYLE_NAME}"
!insertmacro MUI_PAGE_FINISH

; ��װж�ع���ҳ��
!insertmacro MUI_UNPAGE_INSTFILES

; ��װ�����������������
!insertmacro MUI_LANGUAGE "SimpChinese"

; ��װԤ�ͷ��ļ�
!insertmacro MUI_RESERVEFILE_INSTALLOPTIONS
; ------ MUI �ִ����涨����� ------

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "${OCRSTYLE_NAME}"
InstallDir "$PROGRAMFILES\OCR Style"
InstallDirRegKey HKLM "${PRODUCT_UNINST_KEY}" "UninstallString"
ShowInstDetails show
ShowUnInstDetails show
BrandingText "OCR Style www.ocrstyle.com"

;BGGradient 000000 800000 FFFFFF
;InstallColors FF8080 000030
; ���� WindowsXP ���Ӿ���ʽ
XPstyle on

Section "MainSection" SEC01
	;�ж��ļ��Ƿ��Ѿ���װ
	IfFileExists "$INSTDIR\uninst.exe" +1 BEGIN_INSTALL
	  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "����ϵͳ�Ѿ���װ�������ȷ��Ҫ���ǣ�" IDYES INSTALL_BEFORE_CHECK IDNO END_INSTALL

	;�ж��ļ��Ƿ�������
	INSTALL_BEFORE_CHECK:
  FindProcDLL::FindProc "${OCRSTYLE_NAME}"
    IntCmp $R0 1 TIP_CHECKED BEGIN_INSTALL
  TIP_CHECKED:
     MessageBox MB_ICONINFORMATION|MB_ABORTRETRYIGNORE "��⵽ OCR Style �������У�$\r$\n��ֹ���˳���װ����$\r$\n���ԣ�ǿ�ƽ������̲�������װ��" /SD IDABORT IDRETRY INSTALL_BEFORE_CHECK IDIGNORE IGNORE_RUN
     Quit
  IGNORE_RUN:
	  FindProcDLL::FindProc "${OCRSTYLE_NAME}"
	    IntCmp $R0 1 +1 BEGIN_INSTALL
  		KillProcDLL::KillProc "${OCRSTYLE_NAME}"

	BEGIN_INSTALL:
  SetOutPath "$INSTDIR"
  SetOverwrite ifnewer
  CreateDirectory "$SMPROGRAMS\OCR Style"
  CreateShortCut "$SMPROGRAMS\OCR Style\OCR Style.lnk" "$INSTDIR\${OCRSTYLE_NAME}"
  CreateShortCut "$DESKTOP\OCR Style.lnk" "$INSTDIR\${OCRSTYLE_NAME}"
  File "ocrstyle\licence.txt"
  File "..\bin\${OCRSTYLE_NAME}"
  File "..\bin\ocrengine.dll"
  File "..\bin\imageprocess.dll"
  File "..\bin\zlibwapi.dll"
  SetOutPath "$INSTDIR\tessdata"
  File /r /x ".svn" "..\bin\tessdata\*.*"
  SetOutPath "$INSTDIR\picture"
  File /r /x ".svn" "..\bin\picture\*.*"
  SetOutPath "$INSTDIR"

	END_INSTALL:
SectionEnd

Section -AdditionalIcons
  CreateShortCut "$SMPROGRAMS\OCR Style\Uninstall.lnk" "$INSTDIR\uninst.exe"
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\${OCRSTYLE_NAME}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\${OCRSTYLE_NAME}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd

#-- ���� NSIS �ű��༭�������� Function ���α�������� Section ����֮���д���Ա��ⰲװ�������δ��Ԥ֪�����⡣--#

Function .onInit
FunctionEnd

Function MyGUIInit
  #InitPluginsDir
	#File /oname=$PLUGINSDIR\splash.bmp "ocrstyle\splash.bmp"
	#BgImage::SetBg /FILLSCREEN $PLUGINSDIR\splash.bmp
	#CreateFont $R0 "Arial" 44 700 /ITALIC
	#BgImage::AddText "${PRODUCT_NAME} ${PRODUCT_VERSION}" $R0 255 255 255 40 48 1000 200
	#BgImage::Redraw
FunctionEnd

Function .onGUIEnd
	#BgImage::Destroy
FunctionEnd

/******************************
 *  �����ǰ�װ�����ж�ز���  *
 ******************************/

Section Uninstall
	;�ж��ļ��Ƿ�������
  FindProcDLL::FindProc "${OCRSTYLE_NAME}"
    IntCmp $R0 1 TIP_QUIT BEGIN_UNINSTALL

  TIP_QUIT:
    MessageBox MB_ICONSTOP " OCR Style �������У����ȹرճ����ٽ���ж�أ�"
    Quit
  
  BEGIN_UNINSTALL:
	; ж�����
  Delete "$INSTDIR\uninst.exe"
  Delete "$INSTDIR\${OCRSTYLE_NAME}"
  Delete "$INSTDIR\ocrengine.dll"
  Delete "$INSTDIR\imageprocess.dll"
  Delete "$INSTDIR\zlibwapi.dll"
  Delete "$INSTDIR\licence.txt"
  RMDir /r "$INSTDIR\tessdata"
  RMDir /r "$INSTDIR\picture"

  Delete "$SMPROGRAMS\OCR Style\Uninstall.lnk"
  Delete "$DESKTOP\OCR Style.lnk"
  Delete "$SMPROGRAMS\OCR Style\OCR Style.lnk"

  RMDir "$SMPROGRAMS\OCR Style"

  RMDir "$INSTDIR"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  SetAutoClose true
SectionEnd

#-- ���� NSIS �ű��༭�������� Function ���α�������� Section ����֮���д���Ա��ⰲװ�������δ��Ԥ֪�����⡣--#

Function un.onInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "��ȷʵҪ��ȫ�Ƴ� $(^Name) ���������е������" IDYES +2
  Abort
FunctionEnd

Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) �ѳɹ��ش����ļ�����Ƴ���"
FunctionEnd
