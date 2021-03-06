; Script generated by the HM NIS Edit Script Wizard.

; HM NIS Edit Wizard helper defines
!define PRODUCT_NAME "Electrontubes"
!define PRODUCT_VERSION "0.4.1"
!define PRODUCT_PUBLISHER "Pozsar Zsolt"
!define PRODUCT_WEB_SITE "http:\\www.pozsarzs.hu"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\electrontubes.exe"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

; MUI 1.67 compatible ------
!include "MUI.nsh"

; MUI Settings
!define MUI_ABORTWARNING
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\modern-install.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"

; Language Selection Dialog Settings
!define MUI_LANGDLL_REGISTRY_ROOT "${PRODUCT_UNINST_ROOT_KEY}"
!define MUI_LANGDLL_REGISTRY_KEY "${PRODUCT_UNINST_KEY}"
!define MUI_LANGDLL_REGISTRY_VALUENAME "NSIS:Language"

; Uninstaller pages
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "$(MUILicense)" 
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!define MUI_FINISHPAGE_RUN "$INSTDIR\electrontubes.exe"
!define MUI_FINISHPAGE_SHOWREADME "$INSTDIR\documents\readme.txt"
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

; Language files
!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_LANGUAGE "Hungarian"

; License Language
LicenseLangString MUILicense ${LANG_ENGLISH} "electrontubes\documents\copying.txt"
LicenseLangString MUILicense ${LANG_HUNGARIAN} "electrontubes\documents\copying.txt"

; MUI end ------

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "electrontubes-0.4.1-win32.exe"
InstallDir "$PROGRAMFILES\Electrontubes"
InstallDirRegKey HKLM "${PRODUCT_DIR_REGKEY}" ""
ShowInstDetails show
ShowUnInstDetails show

Function .onInit
  !insertmacro MUI_LANGDLL_DISPLAY
FunctionEnd

Section "Main files" SEC01
  SetOutPath "$INSTDIR\documents"
  SetOverwrite try
  File "electrontubes\documents\authors.txt"
  File "electrontubes\documents\changelog.txt"
  File "electrontubes\documents\copying.txt"
  File "electrontubes\documents\install.txt"
  File "electrontubes\documents\readme.txt"
  File "electrontubes\documents\version.txt"
  SetOutPath "$INSTDIR\documents\hu"
  File "electrontubes\documents\hu\copying.txt"
  File "electrontubes\documents\hu\install.txt"
  File "electrontubes\documents\hu\readme.txt"
  SetOutPath "$INSTDIR\figures"
  File "electrontubes\figures\module_01.png"
  File "electrontubes\figures\module_02.png"
  File "electrontubes\figures\module_03.png"
  File "electrontubes\figures\module_04.png"
  File "electrontubes\figures\module_05.png"
  File "electrontubes\figures\module_06.png"
  File "electrontubes\figures\module_07.png"
  File "electrontubes\figures\module_08.png"
  File "electrontubes\figures\module_09.png"
  File "electrontubes\figures\module_10.png"
  File "electrontubes\figures\module_14.png"
  File "electrontubes\figures\module_15.png"
  SetOutPath "$INSTDIR\help"
  File "electrontubes\help\styles.css"
  File "electrontubes\help\en.html"
  File "electrontubes\help\en_cmdparams.html"
  File "electrontubes\help\en_hotkeys.html"
  File "electrontubes\help\en_intro.html"
  File "electrontubes\help\hu.html"
  File "electrontubes\help\hu_cmdparams.html"
  File "electrontubes\help\hu_hotkeys.html"
  File "electrontubes\help\hu_intro.html"
  SetOutPath "$INSTDIR\help\module_03"
  File "electrontubes\help\module_03\en_help.xml"
  File "electrontubes\help\module_03\hu_help.xml"
  File "electrontubes\help\module_03\page_01.png"
  File "electrontubes\help\module_03\page_02.png"
  File "electrontubes\help\module_03\page_03.png"
  File "electrontubes\help\module_03\page_04.png"
  SetOutPath "$INSTDIR\help\module_04"
  File "electrontubes\help\module_04\en_help.xml"
  File "electrontubes\help\module_04\hu_help.xml"
  File "electrontubes\help\module_04\page_01.png"
  File "electrontubes\help\module_04\page_02.png"
  File "electrontubes\help\module_04\page_03.png"
  File "electrontubes\help\module_04\page_04.png"
  SetOutPath "$INSTDIR\help\module_05"
  File "electrontubes\help\module_05\en_help.xml"
  File "electrontubes\help\module_05\hu_help.xml"
  File "electrontubes\help\module_05\page_01.png"
  File "electrontubes\help\module_05\page_02.png"
  File "electrontubes\help\module_05\page_03.png"
  SetOutPath "$INSTDIR\help\module_06"
  File "electrontubes\help\module_06\en_help.xml"
  File "electrontubes\help\module_06\hu_help.xml"
  File "electrontubes\help\module_06\page_01.png"
  File "electrontubes\help\module_06\page_02.png"
  File "electrontubes\help\module_06\page_03.png"
  SetOutPath "$INSTDIR\help\module_07"
  File "electrontubes\help\module_07\en_help.xml"
  File "electrontubes\help\module_07\hu_help.xml"
  File "electrontubes\help\module_07\page_01.png"
  File "electrontubes\help\module_07\page_02.png"
  File "electrontubes\help\module_07\page_03.png"
  SetOutPath "$INSTDIR\help\module_09"
  File "electrontubes\help\module_09\en_help.xml"
  File "electrontubes\help\module_09\hu_help.xml"
  File "electrontubes\help\module_09\page_01.png"
  File "electrontubes\help\module_09\page_02.png"
  File "electrontubes\help\module_09\page_03.png"
  File "electrontubes\help\module_09\page_04.png"
  SetOutPath "$INSTDIR\help\module_10"
  File "electrontubes\help\module_10\en_help.xml"
  File "electrontubes\help\module_10\hu_help.xml"
  File "electrontubes\help\module_10\page_01.png"
  File "electrontubes\help\module_10\page_02.png"
  File "electrontubes\help\module_10\page_03.png"
  SetOutPath "$INSTDIR\help\module_14"
  File "electrontubes\help\module_14\en_help.xml"
  File "electrontubes\help\module_14\hu_help.xml"
  File "electrontubes\help\module_14\page_01.png"
  File "electrontubes\help\module_14\page_02.png"
  File "electrontubes\help\module_14\page_03.png"
  SetOutPath "$INSTDIR\help\module_15"
  File "electrontubes\help\module_15\en_help.xml"
  File "electrontubes\help\module_15\hu_help.xml"
  File "electrontubes\help\module_15\page_01.png"
  File "electrontubes\help\module_15\page_02.png"
  File "electrontubes\help\module_15\page_03.png"
  SetOutPath "$INSTDIR"
  File "electrontubes\electrontubes.exe"
  File "electrontubes\readme.txt"
  CreateShortCut "$DESKTOP\Electrontubes.lnk" "$INSTDIR\electrontubes.exe"
  CreateDirectory "$SMPROGRAMS\Electrontubes"
  CreateShortCut "$SMPROGRAMS\Electrontubes\Electrontubes.lnk" "$INSTDIR\electrontubes.exe"
SectionEnd

Section "Translate HU" SEC02
  SetOutPath "$INSTDIR\languages\hu"
  File "electrontubes\languages\hu\electrontubes.mo"
  File "electrontubes\languages\hu\electrontubes.po"
  SetOutPath "$INSTDIR\languages"
  File "electrontubes\languages\electrontubes.pot"
SectionEnd

Section -AdditionalIcons
  SetOutPath $INSTDIR
  CreateDirectory "$SMPROGRAMS\Electrontubes"
  CreateShortCut "$SMPROGRAMS\Electrontubes\Uninstall.lnk" "$INSTDIR\uninst.exe"
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\electrontubes.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\electrontubes.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd

; Section descriptions
  LangString DESC_Section1 ${LANG_ENGLISH} "Required files"
  LangString DESC_Section2 ${LANG_ENGLISH} "Hungarian translate"
  LangString DESC_Section1 ${LANG_HUNGARIAN} "Kötelező állományok"
  LangString DESC_Section2 ${LANG_HUNGARIAN} "Magyar fordítás"
  !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC01} $(DESC_Section1)
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC02} $(DESC_Section2)
  !insertmacro MUI_FUNCTION_DESCRIPTION_END

; Section uninstall
  Function un.onInit
  !insertmacro MUI_UNGETLANGUAGE
  FunctionEnd

Section Uninstall
  Delete "$INSTDIR\uninst.exe"
  Delete "$INSTDIR\readme.txt"
  Delete "$INSTDIR\electrontubes.exe"
  Delete "$INSTDIR\help\styles.css"
  Delete "$INSTDIR\help\en.html"
  Delete "$INSTDIR\help\en_cmdparams.html"
  Delete "$INSTDIR\help\en_hotkeys.html"
  Delete "$INSTDIR\help\en_intro.html"
  Delete "$INSTDIR\help\hu.html"
  Delete "$INSTDIR\help\hu_cmdparams.html"
  Delete "$INSTDIR\help\hu_hotkeys.html"
  Delete "$INSTDIR\help\hu_intro.html"
  Delete "$INSTDIR\help\module_03\en_help.xml"
  Delete "$INSTDIR\help\module_03\hu_help.xml"
  Delete "$INSTDIR\help\module_03\page_01.png"
  Delete "$INSTDIR\help\module_03\page_02.png"
  Delete "$INSTDIR\help\module_03\page_03.png"
  Delete "$INSTDIR\help\module_03\page_04.png"
  Delete "$INSTDIR\help\module_04\en_help.xml"
  Delete "$INSTDIR\help\module_04\hu_help.xml"
  Delete "$INSTDIR\help\module_04\page_01.png"
  Delete "$INSTDIR\help\module_04\page_02.png"
  Delete "$INSTDIR\help\module_04\page_03.png"
  Delete "$INSTDIR\help\module_04\page_04.png"
  Delete "$INSTDIR\help\module_05\en_help.xml"
  Delete "$INSTDIR\help\module_05\hu_help.xml"
  Delete "$INSTDIR\help\module_05\page_01.png"
  Delete "$INSTDIR\help\module_05\page_02.png"
  Delete "$INSTDIR\help\module_05\page_03.png"
  Delete "$INSTDIR\help\module_06\en_help.xml"
  Delete "$INSTDIR\help\module_06\hu_help.xml"
  Delete "$INSTDIR\help\module_06\page_01.png"
  Delete "$INSTDIR\help\module_06\page_02.png"
  Delete "$INSTDIR\help\module_06\page_03.png"
  Delete "$INSTDIR\help\module_07\en_help.xml"
  Delete "$INSTDIR\help\module_07\hu_help.xml"
  Delete "$INSTDIR\help\module_07\page_01.png"
  Delete "$INSTDIR\help\module_07\page_02.png"
  Delete "$INSTDIR\help\module_07\page_03.png"
  Delete "$INSTDIR\help\module_09\en_help.xml"
  Delete "$INSTDIR\help\module_09\hu_help.xml"
  Delete "$INSTDIR\help\module_09\page_01.png"
  Delete "$INSTDIR\help\module_09\page_02.png"
  Delete "$INSTDIR\help\module_09\page_03.png"
  Delete "$INSTDIR\help\module_09\page_04.png"
  Delete "$INSTDIR\help\module_10\en_help.xml"
  Delete "$INSTDIR\help\module_10\hu_help.xml"
  Delete "$INSTDIR\help\module_10\page_01.png"
  Delete "$INSTDIR\help\module_10\page_02.png"
  Delete "$INSTDIR\help\module_10\page_03.png"
  Delete "$INSTDIR\help\module_14\en_help.xml"
  Delete "$INSTDIR\help\module_14\hu_help.xml"
  Delete "$INSTDIR\help\module_14\page_01.png"
  Delete "$INSTDIR\help\module_14\page_02.png"
  Delete "$INSTDIR\help\module_14\page_03.png"
  Delete "$INSTDIR\help\module_15\en_help.xml"
  Delete "$INSTDIR\help\module_15\hu_help.xml"
  Delete "$INSTDIR\help\module_15\page_01.png"
  Delete "$INSTDIR\help\module_15\page_02.png"
  Delete "$INSTDIR\help\module_15\page_03.png"
  Delete "$INSTDIR\figures\module_01.png"
  Delete "$INSTDIR\figures\module_02.png"
  Delete "$INSTDIR\figures\module_03.png"
  Delete "$INSTDIR\figures\module_04.png"
  Delete "$INSTDIR\figures\module_05.png"
  Delete "$INSTDIR\figures\module_06.png"
  Delete "$INSTDIR\figures\module_07.png"
  Delete "$INSTDIR\figures\module_08.png"
  Delete "$INSTDIR\figures\module_09.png"
  Delete "$INSTDIR\figures\module_10.png"
  Delete "$INSTDIR\figures\module_14.png"
  Delete "$INSTDIR\figures\module_15.png"
  Delete "$INSTDIR\languages\electrontubes.pot"
  Delete "$INSTDIR\languages\hu\electrontubes.po"
  Delete "$INSTDIR\languages\hu\electrontubes.mo"
  Delete "$INSTDIR\documents\authors.txt"
  Delete "$INSTDIR\documents\changelog.txt"
  Delete "$INSTDIR\documents\copying.txt"
  Delete "$INSTDIR\documents\install.txt"
  Delete "$INSTDIR\documents\readme.txt"
  Delete "$INSTDIR\documents\version.txt"
  Delete "$INSTDIR\documents\hu\install.txt"
  Delete "$INSTDIR\documents\hu\readme.txt"
  Delete "$INSTDIR\documents\hu\copying.txt"

  Delete "$SMPROGRAMS\Electrontubes\Uninstall.lnk"
  Delete "$DESKTOP\Electrontubes.lnk"
  Delete "$SMPROGRAMS\Electrontubes\Electrontubes.lnk"

  RMDir "$SMPROGRAMS\Electrontubes"
  RMDir "$INSTDIR\help\module_15"
  RMDir "$INSTDIR\help\module_14"
  RMDir "$INSTDIR\help\module_10"
  RMDir "$INSTDIR\help\module_09"
  RMDir "$INSTDIR\help\module_07"
  RMDir "$INSTDIR\help\module_06"
  RMDir "$INSTDIR\help\module_05"
  RMDir "$INSTDIR\help\module_04"
  RMDir "$INSTDIR\help\module_03"
  RMDir "$INSTDIR\help"
  RMDir "$INSTDIR\figures"
  RMDir "$INSTDIR\languages\hu"
  RMDir "$INSTDIR\languages"
  RMDir "$INSTDIR\documents\hu"
  RMDir "$INSTDIR\documents"
  RMDir "$INSTDIR"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  SetAutoClose true
SectionEnd
