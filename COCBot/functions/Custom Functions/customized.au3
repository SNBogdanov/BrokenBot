Global $myBarrackPos[4][2] = [[250, 30+550], [310, 30+550], [370, 30+550], [430, 30+550]]
Global $myDarkBarrackPos[2][2] = [[520, 30+550], [580, 30+550]]
Global $mySpellFactoryPos[2][2] = [[660, 30+550], [720, 30+550]]
Global $OverviewButton[2] = [38, 587]
;Global $OverviewButton[2] = [38, 638]

Global $NeedsToBrew = False

Global $curSpells = 0
Global $SpellsChanged = False

Global $reducesize = "118x23"

Global $TrainingDelay=250 ;read from ini file used in readycheck (default value 250)


Func TryToOpenArmyOverview()
	Local $RedCrossButton = _WaitForPixel(690, 95, 751, 135, Hex(0xD80407, 6), 5, 0.25) ;Finds Red Cross button in new Overview popup window with 0.2 delay

	If Not IsArray($RedCrossButton) Then

		If ChkDisconnection() Then Return False
		If $DebugMode = 1 Then SetLog("Opening ArmyOverview")
		ClickP($TopLeftClient) ;Click Away
		If _Sleep(250) Then Return False
		ClickP($OverviewButton)
		$RedCrossButton = _WaitForPixel(690, 95, 751, 135, Hex(0xD80407, 6), 5, 1)

		If Not IsArray($RedCrossButton) Then 
			If ($ichkForceBS) = 1 And Not WinActive("[CLASS:BlueStacksApp; INSTANCE:1]") And $Hide = False Then WinActivate("[CLASS:BlueStacksApp; INSTANCE:1]");If something blocked BS
			If checkObstacles(False) Then Return False
			If $DebugMode = 1 Then SetLog("Opening ArmyOverview")
			ClickP($TopLeftClient) ;Click Away
			If _Sleep(250) Then Return False
			ClickP($OverviewButton)
			$RedCrossButton = _WaitForPixel(690, 95, 751, 135, Hex(0xD80407, 6), 5, 1)
			If Not IsArray($RedCrossButton) Then 
				SetLog("Can not open Army Overview",$COLOR_RED)
				Return False
			EndIf
		EndIf
	Else
		If $DebugMode = 1 Then SetLog("Army overview is already opened")

	EndIf
	If _Sleep(150) Then Return False
	Return True
EndFunc   ;==>TryToOpenArmyOverview


Func GetTroopCapacity($x1,$y1,$x2,$y2)
	return _TesseractReadText($x1, $y1, $x2, $y2, "-threshold 55% ", "BrokenBot")
EndFunc
Func GetTroopCount($x1,$y1,$x2,$y2)
	return ReadText($x1, $y1, 37, $textWindows)
;	return _TesseractReadText($x1, $y1, $x2, $y2, "-negate -fuzz 37% -fill white +opaque black  -background white -gravity south -extent 118x23 -extent 118x42 -threshold 99%", "BrokenBot1")
EndFunc