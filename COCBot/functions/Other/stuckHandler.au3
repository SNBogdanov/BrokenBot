#include <Constants.au3>

Func restartBlueStack()	;Kill and Restart bluestack
	If $restartBSAttemptedCount < 3 Then
		$restartBSAttemptedCount += 1
		If $PushBulletEnabled = 1 Then
			Local $iCount = _FileCountLines($sLogPath)
			Local $myLines = ""
			Local $i
			For $i = 1 to 5
				$myLines = $myLines &  FileReadLine($sLogPath, ($iCount - 5 + $i)) & "\n"
			Next
			_Push(GetLangText("pushRestartBlueStack"), GetLangText("pushRestartBlueStackMSG") & _
			GetLangText("pushLast5Lines") & $myLines)
		EndIf
		SetLog(GetLangText("pushRestartBlueStack"), $COLOR_RED)
		Local $BSFront = _WinAPI_GetProcessFileName(WinGetProcess($Title))		
		If @error Then 
			Open(False)
			$BSFront = _WinAPI_GetProcessFileName(WinGetProcess($Title))
		Else
			Local $QuitApp = StringReplace($BSFront, "Frontend", "Quit")
			Run($QuitApp)
		EndIf
		
		Sleep(5000)
		Local $RunApp = StringReplace($BSFront, "Frontend", "RunApp")
		Run($RunApp & " -p com.supercell.clashofclans -a com.supercell.clashofclans.GameApp")
		If _Sleep(10000) Then Return False
		Local $protection = 0
		Do
			If _Sleep(5000) Then Return False
			$protection += 1
		Until (ControlGetHandle($Title, "", "BlueStacksApp1") <> 0) Or $protection >= 60
		If $protection >= 60 Then
			If $DebugMode = 1 Then
				SetLog("Listing all windows:")
				Local $aList = WinList()
				For $i = 1 To $aList[0][0]
					SetLog("Title: " & $aList[$i][0] & " Handle: " & $aList[$i][1])
				Next
				SetLog("Exists: " & WinExists($Title, ""))
				SetLog("Handle of control: " & ControlGetHandle($Title, "", "BlueStacksApp1") <> 0)
			EndIf
			restartBlueStack()
		Else
			$restartBSAttemptedCount = 0
			waitMainScreen()
  		If $Hide = True Then
		  	$Hide = False
			  btnHide()
		  EndIf
		EndIf
		
	Else
		SetLog(GetLangText("msgBSRestartFail"), $COLOR_RED)
		btnStop()
		$restartBSAttemptedCount = 0
		Return False
	EndIf
	Return True
EndFunc	;==>restartBlueStack

Func handleBarracksError($i) ;Sets the text for the log
	If $i = 0 Then $brerror[0] = True
	If $i = 1 Then $brerror[1] = True
	If $i = 2 Then $brerror[2] = True
	If $i = 3 Then $brerror[3] = True
	If checkObstacles() Then 
		resetBarracksError()
		Return 
	EndIf

	If $brerror[0] = True And $brerror[1] = True And $brerror[2] = True And $brerror[3] = True Then
		SetLog(GetLangText("msgRestartBarracks"), $COLOR_RED)
		waitMainScreen()
;		If Not restartBlueStack() Then Return
	EndIf
EndFunc   ;==>handleBarracksError

Func resetBarracksError()
	$brerror[0] = False
	$brerror[1] = False
	$brerror[2] = False
	$brerror[3] = False
EndFunc   ;==>resetBarracksError
