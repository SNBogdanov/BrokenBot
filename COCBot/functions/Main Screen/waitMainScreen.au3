;Waits 5 minutes for the pixel of mainscreen to be located, checks for obstacles every 2 seconds.
;After five minutes, will try to restart bluestacks.

Func waitMainScreen() ;Waits for main screen to popup
	SetLog(GetLangText("msgWaitMS"), $COLOR_ORANGE)
	For $i = 0 To 150 ;150*2000 = 5 Minutes
		_CaptureRegion()
		If Not _ColorCheck(_GetPixelColor(284, 28), Hex(0x41B1CD, 6), 20) Then ;Checks for Main Screen
			If _Sleep(2000) Then Return
			If ($ichkForceBS) = 1 And Not WinActive("[CLASS:BlueStacksApp; INSTANCE:1]") And $Hide = False Then WinActivate("[CLASS:BlueStacksApp; INSTANCE:1]");If something blocked BS
			checkObstacles()	;in case of bluestack freeze, this may become dead loop. Just stick to 5 minutes waiting
		Else
			Return
		EndIf
	Next

	SetLog(GetLangText("msgUnableLoad"), $COLOR_RED)
	If Not restartBlueStack() Then Return
EndFunc   ;==>waitMainScreen
