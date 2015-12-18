Func Donate_CheckArmyCamp($inCamp = False)
	SetLog(GetLangText("msgCheckingCamp"), $COLOR_BLUE)
	$fullarmy = False
	if StatusCheck(false) then return false

	If _Sleep(100) Then Return false

	If Not TryToOpenArmyOverview() Then Return false


	If _Sleep($TrainingDelay) Then Return false
	Click(150, 550, 2, 100) ; Try To return main page if its on other


	Local $previouscampcap = Number($itxtcampCap)
	For $readattempts = 1 To 5

		$CurCamp = GetTroopCapacity(211-20, 30+144, 290-20, 30+157)
;		$CurCamp = GetTroopCapacity(211, 144, 290, 157)
		$CurCamp = StringStripWS($CurCamp, 8)

		$itxtcampCap = StringMid($CurCamp, StringInStr($CurCamp, "/") + 1)
		If Number($itxtcampCap) > 0 And Number($itxtcampCap) < 300 And (Number($itxtcampCap) >= $previouscampcap Or $failedcampCap) And StringIsDigit($itxtcampCap) And Mod(Number($itxtcampCap), 5) = 0 Then
			$failedcampCap = False
			$CurCamp = StringLeft($CurCamp, StringInStr($CurCamp, "/") - 1)
			If Number($CurCamp) >= 0 And Number($CurCamp) <= $itxtcampCap And StringIsDigit($CurCamp) Then
				SetLog(GetLangText("msgTotalCampCap") & $CurCamp & "/" & $itxtcampCap, $COLOR_GREEN)
				ExitLoop
			EndIf
		EndIf
		If _Sleep(500) Then Return false
		If $readattempts = 5 Then
			SetLog(GetLangText("msgTotalCampCap") & GetLangText("lblUnknownCap"), $COLOR_GREEN)
			$CurCamp = 0
			If $itxtcampCap < $previouscampcap Then
				$itxtcampCap = $previouscampcap
			Else
				If $previouscampcap > 0 Then
					$itxtcampCap = $previouscampcap
				Else
					$itxtcampCap = 240
					$failedcampCap = True
				EndIf
			EndIf
		EndIf
	Next

	If (($CurCamp / $itxtcampCap) + .15) >= ((_GUICtrlComboBox_GetCurSel($cmbRaidcap) + 1) / 10) Then
		$closetofull = True
	Else
		$closetofull = False
	EndIf

	If ($CurCamp / $itxtcampCap) >= ((_GUICtrlComboBox_GetCurSel($cmbRaidcap) + 1) / 10) Then
		$fullarmy = True
	Else
		_CaptureRegion()
		If $FirstStart Then
			$ArmyComp = 0
			$CurGiant = 0
			$CurWB = 0
			$CurArch = 0
			$CurBarb = 0
			$CurGoblin = 0
			$CurMinion = 0
			$CurHog = 0
			$CurValkyrie = 0
		EndIf
		For $i = 0 To 9
			Local $TroopKind = _GetPixelColor(-20+177 + 62 * $i, 30+195)
			Local $TroopKind2 = _GetPixelColor(-20+187 + 62 * $i, 30+200)
			Local $TroopName = ""
			Local $TroopQ = StringStripWS(GetTroopCount(-20+160 + (62 * $i), 30+170, -20+200 + (62 * $i), 30+181), 3)
			_CaptureRegion() ; we need this to restore capture that  changed by _TesseractReadText

			If StringLeft($TroopQ, 1) = "x" Then $TroopQ = StringRight($TroopQ, StringLen($TroopQ) - 1)
			$TroopQ = Number($TroopQ)  ; start of known troops
			If _ColorCheck($TroopKind, Hex(0xEC4989, 6), 30) Then
				If $TroopQ = 0 Then $TroopQ = 1 ;if we found the image of a troop there has to be at least one
				If ($CurArch = 0 And $FirstStart) Then $CurArch -= $TroopQ
				If $inCamp = True Then $CurArchinCamp = $TroopQ
				$TroopName = "Archers"
			ElseIf _ColorCheck($TroopKind, Hex(0xFFC020, 6), 30) Then
				If $TroopQ = 0 Then $TroopQ = 1 ;if we found the image of a troop there has to be at least one
				If ($CurBarb = 0 And $FirstStart) Then $CurBarb -= $TroopQ
				If $inCamp = True Then $CurBarbinCamp = $TroopQ
				$TroopName = "Barbarians"
			ElseIf _ColorCheck($TroopKind, Hex(0xFFC17F, 6), 30) Then
				If $TroopQ = 0 Then $TroopQ = 1 ;if we found the image of a troop there has to be at least one
				If ($CurGiant = 0 And $FirstStart) Then $CurGiant -= $TroopQ
				If $inCamp = True Then $CurGiantinCamp = $TroopQ
				$TroopName = "Giants"
			ElseIf _ColorCheck($TroopKind, Hex(0x90E658, 6), 30) Then
				If $TroopQ = 0 Then $TroopQ = 1 ;if we found the image of a troop there has to be at least one
				If ($CurGoblin = 0 And $FirstStart) Then $CurGoblin -= $TroopQ
				If $inCamp = True Then $CurGoblininCamp = $TroopQ
				$TroopName = "Goblins"
			ElseIf _ColorCheck($TroopKind, Hex(0x151F37, 6), 20) Then
				If $TroopQ = 0 Then $TroopQ = 1 ;if we found the image of a troop there has to be at least one
				If ($CurMinion = 0 And $FirstStart) Then $CurMinion -= $TroopQ
				If $inCamp = True Then $CurMinioninCamp = $TroopQ
				$TroopName = "Minions"
			ElseIf _ColorCheck($TroopKind, Hex(0x2C1E19, 6), 20) Then
;			ElseIf _ColorCheck($TroopKind, Hex(0x4C2E26, 6), 30) Then
				If $TroopQ = 0 Then $TroopQ = 1 ;if we found the image of a troop there has to be at least one
				If ($CurHog = 0 And $FirstStart) Then $CurHog -= $TroopQ
				If $inCamp = True Then $CurHoginCamp = $TroopQ
				$TroopName = "Hogs"
			ElseIf _ColorCheck($TroopKind, Hex(0xA95E58, 6), 30) Then
				If $TroopQ = 0 Then $TroopQ = 1 ;if we found the image of a troop there has to be at least one
				If ($CurValkyrie = 0 And $FirstStart) Then $CurValkyrie -= $TroopQ
				If $inCamp = True Then $CurValkyrieinCamp = $TroopQ
				$TroopName = "Valkyries"
			ElseIf _ColorCheck($TroopKind2, Hex(0xD5753F, 6), 20) Then
				If $TroopQ = 0 Then $TroopQ = 1 ;if we found the image of a troop there has to be at least one
				If ($CurWB = 0 And $FirstStart) Then $CurWB -= $TroopQ
				If $inCamp = True Then $CurWBinCamp = $TroopQ
				$TroopName = "Wallbreakers"
			EndIf ; end of known troops
			If $TroopName = "" Then $TroopName = "Unknown"
			If $TroopQ <> 0 Then
				SetLog("- " & $TroopName & " " & $TroopQ, $COLOR_GREEN)
			Else
				ExitLoop ; if it is 0 why we need to continue up to 9 times??
			EndIf
		Next
	EndIf

;	ClickP($TopLeftClient) ;Click Away
	$FirstCampView = True

	Return $fullarmy
EndFunc   ;==>Donate_CheckArmyCamp
