Global $myBarrackPos[4][2] = [[250, 550], [310, 550], [370, 550], [430, 550]]
Global $myDarkBarrackPos[2][2] = [[520, 550], [580, 550]]
Global $mySpellFactoryPos[2][2] = [[660, 550], [720, 550]]
Global $OverviewButton[2] = [38, 587]



Global $NeedsToBrew = False





Func TryToOpenArmyOverview()
	Local $RedCrossButton = _WaitForPixel(690, 95, 751, 135, Hex(0xD80407, 6), 5, 0.2) ;Finds Red Cross button in new Training popup window with 0.2 delay

	If Not IsArray($RedCrossButton) Then
		If $DebugMode = 1 Then SetLog("Opening Army overview")
		ClickP($TopLeftClient) ;Click Away
		ClickP($OverviewButton)
	Else
		If $DebugMode = 1 Then SetLog("Army overview is aleready opened")

	EndIf
	If _Sleep(150) Then Return
EndFunc   ;==>TryToOpenArmyOverview
