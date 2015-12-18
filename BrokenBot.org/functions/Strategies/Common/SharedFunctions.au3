; This code was created for public use by BrokenBot.org and falls under the GPLv3 license.
; This code can be incorporated into open source/non-profit projects free of charge and without consent.
; **NOT FOR COMMERCIAL USE** by any project which includes any part of the code in this sub-directory without express written consent of BrokenBot.org
; You **MAY NOT SOLICIT DONATIONS** from any project which includes any part of the code in this sub-directory without express written consent of BrokenBot.org
;
;Function needed by all strategies


;Check Out of Sync or Disconnection, if detected, bump speedBump by 0.5 seconds
Func ChkDisconnection($disconnected = False)
	_CaptureRegion()
	Local $x, $y
	Local $dummyX = 0
	Local $dummyY = 0
	If _ImageSearch(@ScriptDir & "\images\Client.bmp", 1, $dummyX, $dummyY, 50) = 1 Then
		If $dummyX > 290 And $dummyX < 310 And $dummyY > 325 And $dummyY < 340 Then
			$disconnected = True
			$speedBump += 500
			If $speedBump > 5000 Then
				$speedBump = 5000
				SetLog("Out of sync! Already searching slowly, not changing anything.", $COLOR_RED)
			Else
				SetLog("Out of sync! Slowing search speed by 0.5 secs.", $COLOR_RED)
			EndIf
		EndIf
	EndIf
	If _ImageSearch(@ScriptDir & "\images\Lost.bmp", 1, $dummyX, $dummyY, 50) = 1 And Not $disconnected Then
		If $dummyX > 320 And $dummyX < 350 And $dummyY > 330 And $dummyY < 350 Then
			$disconnected = True
			;Looks like lost connection is not related to search speed, test run without bump
;			SetLog("Lost Connection!", $COLOR_RED)
;~ 			$speedBump += 500
;~ 			If $speedBump > 5000 Then
;~ 				$speedBump=5000
;~ 				SetLog("Lost Connection! Already searching slowly, not changing anything.", $COLOR_RED)
;~ 			Else
;~ 				SetLog("Lost Connection! Slowing search speed by 0.5 secs.", $COLOR_RED)
;~ 			EndIf
		EndIf
	EndIf
	_CaptureRegion()
	If _ImageSearchArea($device, 0, 237, 321, 293, 346, $x, $y, 80) And Not $disconnected Then
;		SetLog(GetLangText("msgAnotherDev") & $itxtReconnect & GetLangText("msgAnotherDevMinutes"), $COLOR_RED)
		$disconnected = True
	EndIf

	If _ImageSearch($break, 0, $x, $y, 80) And Not $disconnected Then
;		SetLog(GetLangText("msgTakeBreak"), $COLOR_RED)
		$disconnected = True
	EndIf

	If _ImageSearch($connectionlost, 0, $x, $y, 80) And Not $disconnected Then

;        	SetLog(GetLangText("msgConnectionLost"), $COLOR_RED)
		$disconnected = True
	    EndIf
	If _ImageSearch($maintenance, 0, $x, $y, 80) And Not $disconnected Then

;		SetLog(GetLangText("msgMaintenance"), $COLOR_RED)
		$disconnected = True
	EndIf
	If _ImageSearch($breakextended, 0, $x, $y, 80) And Not $disconnected Then

;		SetLog(GetLangText("msgMaintenance"), $COLOR_RED)
		$disconnected = True
	EndIf
	If _ImageSearch($breakending, 0, $x, $y, 80) And Not $disconnected Then

;		SetLog(GetLangText("msgMaintenance"), $COLOR_RED)
		$disconnected = True
	EndIf
	
	
	$Message = _PixelSearch(457, 300, 458, 330, Hex(0x33B5E5, 6), 10)
	If IsArray($Message) And Not $disconnected  And Not $disconnected Then
		$disconnected = True
	EndIf

	If _ColorCheck(_GetPixelColor(71, 530), Hex(0xC00000, 6), 20)  And Not $disconnected Then
		$disconnected = True
	EndIf

	If _ColorCheck(_GetPixelColor(36, 523), Hex(0xEE5056, 6), 50)   And Not $disconnected Then
		$disconnected = True
	EndIf

	If $disconnected = True Then
		;increase disconnect counts
		GUICtrlSetData($lblresultsearchdisconnected, GUICtrlRead($lblresultsearchdisconnected) + 1)
		If $DebugMode = 1 Then _GDIPlus_ImageSaveToFile($hBitmap, $dirDebug & "DisConnt-" & @HOUR & @MIN & @SEC & ".png")

		If $PushBulletEnabled = 1 And IsChecked($lbldisconnect) Then
			Local $iCount = _FileCountLines($sLogPath)
			Local $myLines = ""
			Local $i
			For $i = 1 To 5
				$myLines = $myLines & FileReadLine($sLogPath, ($iCount - 5 + $i)) & "\n"
			Next
			_Push("Disconnected", "Your bot got disconnected while searching for enemy, total disconnections:" & GUICtrlRead($lblresultsearchdisconnected) & "\n" & _
					GetLangText("pushLast5Lines") & $myLines)
		EndIf
	EndIf
	Return $disconnected
EndFunc   ;==>ChkDisconnection



Func ChkHeroesAvailability()
	Local $result[3]=[False,False,False]
	Local $Tab[4]=[149-20, 148+30, 0xA1CC41, 8]

	$KingAvailable = False ; 470, 455 0xEBCB5F
	$QueenAvailable = False; 529, 455 1. 0x402458 2. 0x7A41D4
	If Not TryToOpenArmyOverview() Then Return $result
;	TryToOpenArmyOverview() 
	If _Sleep(150) Then Return $result
	Click(150, 550, 2, 100) ; Try To return main page if its on other

	_CaptureRegion()
	Local $Hero1 = _GetPixelColor(470-20, 30+455)
	Local $Hero2 = _GetPixelColor(529-20, 30+455)


;SetLog($Hero1)
;SetLog($Hero2)
;	If _ColorCheck($Hero1, Hex(0xEBCB5F, 6), 8) Then ; king
	If _ColorCheck($Hero1, Hex(0xFBC2B8, 6), 8) Then ; king

		$KingAvailable = True
		If _ColorCheck($Hero2, Hex(0xBC7174, 6), 8) Then $QueenAvailable = True


	Else
		$KingUG = True
		If _ColorCheck($Hero1, Hex(0x8440A0, 6), 8) Then $QueenAvailable = True;queen


	EndIf



	Setlog(GetLangText("msgKingAvail") & $KingAvailable)
	Setlog(GetLangText("msgQueenAvail") & $QueenAvailable)
	$result[0] = $KingAvailable
	$result[1] = $QueenAvailable
	$result[2] = CheckPixel($Tab)
	If $result[2] Then 
		Setlog("Army Camp is full")
	EndIf
	Return $result
EndFunc   ;==>ChkHerosAvailability
