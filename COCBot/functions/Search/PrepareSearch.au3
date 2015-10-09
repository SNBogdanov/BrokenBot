;Goes into a match, breaks shield if it has to
; Returns True if successful, otherwise False after 10 failed attempts
Func PrepareSearch() ;Click attack button and find match button, will break shield
	Click(1, 1, 2, 250) ;Click Away with 205ms delay

	Click(60, 614);Click Attack Button
	SetLog(GetLangText("msgSearchingMatch"))
	If _WaitForColorArea(287, 494, 5, 5, Hex(0xEEAC28, 6), 50) Then
		Click(217, 510);Click Find a Match Button
		; Is shield active?
	        If _Sleep(1000) Then Return  ;<--give BS a second to load
;		If _WaitForColorArea(513, 416, 5, 5, Hex(0x5DAC10, 6), 50, 1) Then
		If _WaitForColorArea(300, 420, 2, 2, Hex(0xC83C10, 6), 5, 1) Then
			SetLog("Shield is active", $COLOR_RED)
			Click(513, 416)
		EndIf
		If _WaitForColorArea(23, 523, 25, 10, Hex(0xEE5056, 6), 50, 5) Then Return True
	Else
		SetLog(GetLangText("msgSearchingMatch")&" failed")
		;Something is wrong here, restart bluestack
		If checkObstacles() Then Return False
;		restartBlueStack()
	EndIf
	Return False
EndFunc   ;==>PrepareSearch
