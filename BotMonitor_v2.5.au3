#include <Date.au3>
#include <File.au3>
#include <FileConstants.au3>
#include <GUIConstantsEx.au3>
#include <Misc.au3>
#include <MsgBoxConstants.au3>
#include <WindowsConstants.au3>

;global variables
Global $BotMonitorTitle = "BotMonitor_v2.5"
Global $strLogFilename = @YEAR & "-" & @MON & "-" & @MDAY & "_" & @HOUR & "-" & @MIN & "-" & @SEC & ".log"
Global $strConf = @ScriptDir & "\bm_config\BotMonitor.ini"
Global $Bot
Global $BS
Global $BotTitle
Global $BSTitle = "BlueStacks App Player"
Global $strBSErrors
Global $strMessage
Global $strMsg
Global $OS
Global $exceptionFile = @ScriptDir & "\BrokenBotException1.log"

;check monitoring instance
If _Singleton($BotMonitorTitle, 1) = 0 Then
   MsgBox($MB_ICONWARNING, $BotMonitorTitle, "Monitoring script is already running.")
   Exit
EndIf

;get os architechture (for config file)
$OS = @OSArch

;check directories
CheckDIR()

SetLogs($strLogFilename, "Monitoring Script Started")
Space()
SetLogs($strLogFilename, "Checking if config file exists . . .")
CheckConfigFile()

SetLogs($strLogFilename, "Checking BlueStacks launcher . . .")
CheckBSLauncher()

SetLogs($strLogFilename, "Checking bot launcher . . .")
CheckBotLauncher()

;monitoring process
While 1
   ;check if bot and bs is not running
   SetLogs($strLogFilename, "Checking bot and bluestacks instances . . .")
   If Not(WinExists($BotTitle)) Then
	  SetLogs($strLogFilename, "Bot is not running, starting bot . . .")
	  RunBot()
   ElseIf Not(WinExists($BSTitle)) Then
	  SetLogs($strLogFilename, "BlueStacks is not running, checking for errors . . .")
	  CheckBSErrors()
	  Sleep(5000)
;	  CheckStatusText()
	  SetLogs($strLogFilename, "No errors/error window closed, stop-start bot . . .")
;	  RunBot()
	  StopStart()
   ElseIf FileExists($exceptionFile) Then
	  SetLogs($strLogFilename, "Exception file found . . .")
	  FileDelete($exceptionFile)
	  SetLogs($strLogFilename, "Closing bot instance")
	  WinClose($BotTitle)
	  Sleep(5000)
	  RunBot()
   Else
	  SetLogs($strLogFilename, "Bot and bluestacks is running, getting bot status messages . . .")
	  GetStatusText()
	  SetLogs($strLogFilename, "Checking bot status messages . . .")
	  CheckStatusText()
	  SetLogs($strLogFilename, "Checking for bluestacks errors . . .")
	  CheckBSErrors()
   EndIf

   Space()
   Sleep(60000)			;one minute interval
WEnd

SetLogs($strLogFilename, "Monitoring Script Ended")
Exit


;functions starts here
;create directory
Func CheckDIR()
   If(DirGetSize(@ScriptDir & "\bm_config") < 0) Then
	  DirCreate(@ScriptDir & "\bm_config")
   EndIf

   If(DirGetSize(@ScriptDir & "\bm_logs") < 0) Then
	  DirCreate(@ScriptDir & "\bm_logs")
   EndIf
EndFunc

;create log file
Func SetLogs($LogFile, $strMsg)
   Local $strFile = @ScriptDir & "\bm_logs\" & $LogFile
   If Not FileExists($strFile) Then
	  _FileCreate($strFile)
   EndIf
   _FileWriteLog($strFile, $strMsg)
   FileClose($strFile)
EndFunc

;check config file
Func CheckConfigFile()
   If Not FileExists($strConf) Then
      SetLogs($strLogFilename, "Config file does not exists, creating config file with initial values")
	  _FileCreate($strConf)
	  ConfigInitVal()
   EndIf
   SetLogs($strLogFilename, "Config file exists, reading values . . .")
   GetConfigVal()
EndFunc

;config file initial values
Func ConfigInitVal()
   IniWrite(@ScriptDir & "\bm_config\BotMonitor.ini", "Paths", "BotExe", "BrokenBot.exe")
   If($OS = "X64") Then
	  IniWrite(@ScriptDir & "\bm_config\BotMonitor.ini", "Paths", "BSPath", "C:\Program Files (x86)\BlueStacks\")
   Else
	  IniWrite(@ScriptDir & "\bm_config\BotMonitor.ini", "Paths", "BSPath", "C:\Program Files\BlueStacks\")
   EndIf
   IniWrite(@ScriptDir & "\bm_config\BotMonitor.ini", "Paths", "BSExe", "HD-StartLauncher.exe")

   IniWrite(@ScriptDir & "\bm_config\BotMonitor.ini", "Title", "BSTitle", "BrokenBot.org - Break FREE")

   IniWrite(@ScriptDir & "\bm_config\BotMonitor.ini", "ErrorWindow", "BSErrors", "Restarting BlueStacks|BlueStacks Restart Utility|BrokenBot.org - Clash of Clans Bot")

   SetLogs($strLogFilename, "Done creating config file")
EndFunc

;get config file values
Func GetConfigVal()
   $Bot = IniRead(@ScriptDir & "\bm_config\BotMonitor.ini", "Paths", "BotExe", "Error")
   $BS = IniRead(@ScriptDir & "\bm_config\BotMonitor.ini", "Paths", "BSPath", "Error") & IniRead(@ScriptDir & "\bm_config\BotMonitor.ini", "Paths", "BSExe", "Error")
   $BotTitle = '[REGEXPTITLE:(?i).*?' & IniRead(@ScriptDir & "\bm_config\BotMonitor.ini", "Title", "BSTitle", "Error") & '.*?]'
   $strBSErrors = IniRead(@ScriptDir & "\bm_config\BotMonitor.ini", "ErrorWindow", "BSErrors", "Error")
   If((StringInStr($Bot, "Error")) Or (StringInStr($BS, "Error")) Or (StringInStr($BotTitle, "Error"))) Then
	  SetLogs($strLogFilename, "Error reading config file values, re-creating config file")
	  FileDelete($strConf)
	  CheckConfigFile()

	  SetLogs($strLogFilename, "Reading config file values")
	  GetConfigVal()
   Else
	  SetLogs($strLogFilename, "Done reading config file values")
   EndIf
EndFunc

;check bluestacks launcher
Func CheckBSLauncher()

   If Not(FileExists($BS)) Then
	  SetLogs($strLogFilename, "BlueStacks launcher not found!")
	  MsgBox($MB_ICONERROR, $BotMonitorTitle & " - ERROR", "BlueStacks launcher not found." & @LF & "Please configure it on your .ini file.")
	  Exit
   EndIf
   SetLogs($strLogFilename, "BlueStacks launcher found.")
EndFunc

;check bot launcher
Func CheckBotLauncher()
   If Not(FileExists($Bot)) Then
	  SetLogs($strLogFilename, "Bot launcher not found!")
	  MsgBox($MB_ICONERROR, $BotMonitorTitle & " - ERROR", "Bot launcher not found." & @LF & "Please configure it on your .ini file.")
	  Exit
   EndIf
   SetLogs($strLogFilename, "Bot launcher found.")
EndFunc

;start bot
Func RunBot()
   Run($Bot)						;run bot
   Sleep(5000)						;wait 5 seconds
   If(WinExists($BotTitle)) Then	;check if bot successfully started
	  SetLogs($strLogFilename, "Bot launched successfuly, starting bot process")
	  ClickStart()					;yes - start bot
   Else
	  SetLogs($strLogFilename, "Bot failed to launched, attempting to re-launched bot")
	  RunBot()						;no - run again
   EndIf
EndFunc

;click start bot
Func ClickStart()
   WinActivate($BotTitle)			;set focus to bot
   Sleep(20000)						;wait 2 seconds and click start
   If(ControlCommand($BotTitle, "", "[CLASS:Button; TEXT:Start Bot]", "IsVisible", "")) Then
	  ControlClick($BotTitle, "", "[CLASS:Button; TEXT:Start Bot]", "left", "1")
   EndIf
   Local $intCount = 0
   While 1							;loop until bluestacks started
	  Sleep(10000)					;wait 10 seconds for bluestacks
	  SetLogs($strLogFilename, "Waiting for bluestacks window")
	  if(WinExists($BSTitle)) Then	;check if bot exists, then click hide bs
;		 If(ControlCommand($BotTitle, "", "[CLASS:Button; TEXT:Hide BS]", "IsVisible", "")) Then
;			SetLogs($strLogFilename, "BlueStacks window successfuly started, hiding bluestacks")
;			ControlClick($BotTitle, "", "[CLASS:Button; TEXT:Hide BS]", "left", "1")
;		 EndIf
		 ExitLoop
	  EndIf
	  $intCount = $intCount + 1
	  If($intCount = 60) Then		;if 10mins passed and bluestacks did not start
		 SetLogs($strLogFilename, "BlueStacks failed to start after 10 minutes, restarting bot")
		 CloseAll()					;close bot and bluestacks
		 ExitLoop
	  EndIf
   WEnd
EndFunc

;close bot and blustacks
Func CloseAll()
   While 1
	  SetLogs($strLogFilename, "Closing bot instance")
	  WinClose($BotTitle)
	  Sleep(5000)
	  SetLogs($strLogFilename, "Closing bluestacks instance")
	  WinClose($BSTitle)
	  Sleep(5000)
	  If Not((WinExists($BotTitle) And (WinExists($BSTitle)))) Then
		 SetLogs($strLogFilename, "Successfully closed bot and bluestacks instances")
		 ExitLoop
	  EndIf
	  SetLogs($strLogFilename, "Failed to close bot and bluestacks instances")
   WEnd
EndFunc

;check bluestacks error
Func CheckBSErrors()
   Local $arrBSErrors = StringSplit($strBSErrors,"|")
   For $i = 1 To $arrBSErrors[0]
	  If WinExists($arrBSErrors[$i]) Then
		 SetLogs($strLogFilename, "Error window found : " & $arrBSErrors[$i] & ", closing window")
		 WinActivate($arrBSErrors[$i])
		 WinClose($arrBSErrors[$i])
	  ElseIf($arrBSErrors[$i] = "BrokenBot.org - Clash of Clans Bot") Then
		 If(ControlCommand($arrBSErrors[$i], "", "[CLASS:DirectUIHWND; TEXT:Close program]", "IsVisible", "")) Then
			SetLogs($strLogFilename, "Stopping bot")
			ControlClick($arrBSErrors[$i], "", "[CLASS:DirectUIHWND; TEXT:Close program]", "left", "1")
			CloseAll()
		 Else
			SetLogs($strLogFilename, "No error/s found.")
		 EndIf
	  EndIf
   Next
EndFunc

;stop-start bot
Func StopStart()
   While 1
	  WinActivate($BotTitle)
	  Sleep(2000)
	  If(ControlCommand($BotTitle, "", "[CLASS:Button; TEXT:Stop Bot]", "IsVisible", "")) Then
		 SetLogs($strLogFilename, "Stopping bot")
		 ControlClick($BotTitle, "", "[CLASS:Button; TEXT:Stop Bot]", "left", "1")
	  EndIf

	  Sleep(2000)
	  If(ControlCommand($BotTitle, "", "[CLASS:Button; TEXT:Start Bot]", "IsVisible", "")) Then
		 SetLogs($strLogFilename, "Starting bot")
		 ControlClick($BotTitle, "", "[CLASS:Button; TEXT:Start Bot]", "left", "1")
		 ExitLoop
	  EndIf
	  SetLogs($strLogFilename, "Failed to stop bot normally, kill it")
          ShellExecuteWait ("pskill","brokenbot.exe")
	  ExitLoop
   WEnd
EndFunc

;get rich textbox contents on bot
Func GetStatusText()
   SetLogs($strLogFilename, "Getting bot rich textbox contents")
   Local $strTextValues = ControlGetText($BotTitle, "", "[CLASS:RICHEDIT50W]")	;get text box content of bot
   Local $arrTextValues = StringSplit($strTextValues, @LF)						;split to newline
   Local $intSize = UBound($arrTextValues)										;get array element count
   $strMsg = $arrTextValues[$intSize - 2]										;get 2nd to the last element
EndFunc

;validate rich textbox contents on bot
Func CheckStatusText()
   $strMessage = $strMsg
   Local $intLoopCount = 0
   While 1
	  SetLogs($strLogFilename, "Last message     : " & $strMessage & @CRLF)
	  SetLogs($strLogFilename, "New last message : " & $strMsg & @CRLF)
	  If($intLoopCount = 0) Then
		 Sleep(60000)	;wait 1 minute
	  ElseIf($intLoopCount = 1) Then
		 Sleep(180000)	;wait 3 minutes
	  ElseIf($intLoopCount = 2) Then
		 Sleep(600000)	;wait 10 minutes
	  ElseIf($intLoopCount = 3) Then
		 SetLogs($strLogFilename, "Bot has stucked, restarting bot . . .")
                 StopStart()
;		 CloseAll()
		 ExitLoop
	  EndIf

	  GetStatusText()
	  SetLogs($strLogFilename, "Last message     : " & $strMessage & @CRLF)
	  SetLogs($strLogFilename, "New last message : " & $strMsg & @CRLF)
	  If($strMessage <> $strMsg) Then
		 SetLogs($strLogFilename, "Bot is good, no issues found.")
		 ExitLoop
	  EndIf
	  If(ControlCommand($BotTitle, "", "[CLASS:Button; TEXT:Resume]", "IsVisible", "")) Then
		 SetLogs($strLogFilename, "Bot is paused, no issues found.")
		 ExitLoop
	  EndIf
	  $intLoopCount = $intLoopCount + 1
   WEnd
EndFunc

Func Space()
   SetLogs($strLogFilename, "")
   SetLogs($strLogFilename, "=================================================================================================")
   SetLogs($strLogFilename, "")
EndFunc
;functions ends here