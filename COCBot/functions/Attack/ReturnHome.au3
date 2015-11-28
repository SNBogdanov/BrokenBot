;Returns home when in battle, will take screenshot and check for gold/elixir change unless specified not to.
;Added AbortSearch flag to avoid deadloop while try to recover from search error
Func ReturnHome($TakeSS = 1, $GoldChangeCheck = True, $AbortSearch = False) ;Return main screen

	If $GoldChangeCheck = True Then
		GoldElixirChange() ; Waits for gold and elixir to stop changing
		If _Sleep(100) Then Return
	EndIf

	If $OverlayVisible Then DeleteOverlay()
	$AttackNow = False
	$checkKPower = False
	$checkQPower = False
	SetLog(GetLangText("msgReturnHome"), $COLOR_BLUE)
	GUICtrlSetState($btnAtkNow, $GUI_DISABLE)
	If $Running = False Then Return
	If _GUICtrlComboBox_GetCurSel($cmbTroopComp) <> 8 And $AttackType = 3 Then $FirstStart = True
	If _Sleep(1500) Then Return	;wait until number stop changing.
;	_CaptureRegion()
	If _WaitForColorArea(19, 519, 100, 30, Hex(0xEE5056, 6), 50, 2) Then
		SetLog("Click End Battle/Surrender")
		Click(77, 529) ;Click Surrender
		If _Sleep(500) Then Return
;		_CaptureRegion()
;		If _WaitForColorArea(280, 372, 130, 50, Hex(0xCF4010, 6), 30, 2) Then
		If _WaitForColorArea(298, 413, 2, 2, Hex(0xCE4412, 6), 20, 2) Then
;		If _ColorCheck(_GetPixelColor(298, 413), Hex(0xCE4412, 6), 20) Then ; Check for confirm button
			Click(522, 384) ; Click confirm
			If _Sleep(500) Then Return
;			_CaptureRegion()
;			If _ColorCheck(_GetPixelColor(425, 531), Hex(0xCDE870, 6), 20) Then ; Check for Return Home button
			If _WaitForColorArea(425, 531, Hex(0xCDE870, 6), 20,2) Then ; Check for Return Home button
				Click(428, 544) ;Click Return Home Button
			EndIf


		EndIf
	EndIf
	$Raid = 0
	If (_WaitForColor(304, 569, Hex(0x020202, 6), 30, 5) And $AbortSearch = False) Then
		_CaptureRegion()
		$Raid = 1
		;Get Last Raid Resources
		$LastRaidGold = ReadText(300, 291, 140, $textReturnHome, 0)
		$LastRaidElixir = ReadText(300, 329, 140, $textReturnHome, 0)
		_CaptureRegion()
		If _ColorCheck(_GetPixelColor(462, 372), Hex(0xF2D668, 6), 40) Then
			; No DE
			$LastRaidDarkElixir = 0
			$LastRaidTrophy = ReadText(380, 367, 60, $textReturnHome, 0)
		Else
			$LastRaidDarkElixir = ReadText(300, 367, 140, $textReturnHome, 0)
			$LastRaidTrophy = ReadText(380, 403, 60, $textReturnHome, 0)
		EndIf

		If $LastRaidTrophy >= 0 Then
			If _ColorCheck(_GetPixelColor(678, 418), Hex(0x030000, 6), 30) Then
;				If _Sleep(250) Then Return
;SetLog(Number(StringReplace(ReadText(587, 340, 95, 3, 0), "+", "")))
;SetLog(Number(StringReplace(ReadText(588, 340, 95, 3, 0), "+", "")))
;SetLog(Number(StringReplace(ReadText(589, 340, 95, 3, 0), "+", "")))
;SetLog(Number(StringReplace(ReadText(591, 340, 95, 3, 0), "+", "")))
;SetLog(Number(StringReplace(ReadText(592, 340, 95, 3, 0), "+", "")))
;SetLog(Number(StringReplace(ReadText(593, 340, 95, 3, 0), "+", "")))

				$BonusLeagueG=Number(StringReplace(ReadText(590, 340, 93, 3, 0), "+", ""))
				If $BonusLeagueG > 1000000 Then $BonusLeagueG -= 1000000
;				_CaptureRegion(590, 340, 92,16)
;			Local $Date =  @YEAR & "." & @MON & "." & @MDAY
;			Local $Time = @HOUR & "." & @MIN
;			$FileName = $Date & "_at_" & $Time & "_1.jpg"
;			_GDIPlus_ImageSaveToFile($hBitmap, $dirLoots & $FileName)
;				If _Sleep(250) Then Return
				$BonusLeagueE=Number(StringReplace(ReadText(589, 371, 93, 3, 0), "+", ""))
;				If $BonusLeagueE > 1000000 Then $BonusLeagueE -= 1000000
;				If _Sleep(250) Then Return
				$BonusLeagueD=Number(StringReplace(ReadText(624, 402, 92, 3, 0), "+", ""))
				SetLog("Bonus [G]: " & _NumberFormat($BonusLeagueG) & " [E]: " & _NumberFormat($BonusLeagueE) & " [DE]: " & _NumberFormat($BonusLeagueD), $COLOR_GREEN)
			Else
;				If _Sleep(250) Then Return
				$BonusLeagueG=Number(StringReplace(ReadText(590, 340, 92, 3, 0), "+", ""))
;				If _Sleep(250) Then Return
				$BonusLeagueE=Number(StringReplace(ReadText(590, 371, 92, 3, 0), "+", ""))
;				If _Sleep(250) Then Return
				$BonusLeagueD=0
				SetLog("Bonus [G]: " & _NumberFormat($BonusLeagueG) & " [E]: " & _NumberFormat($BonusLeagueE), $COLOR_GREEN)
			EndIf
		Else
			$BonusLeagueG = 0
			$BonusLeagueE = 0
			$BonusLeagueD = 0
		EndIf

		$LastRaidGold+=$BonusLeagueG
		$LastRaidElixir+=$BonusLeagueE
		$LastRaidDarkElixir+=$BonusLeagueD

		$GoldTotalLoot += $LastRaidGold
		$ElixirTotalLoot += $LastRaidElixir
		$DarkTotalLoot += $LastRaidDarkElixir
		$TrophyTotalLoot += $LastRaidTrophy
		If $TakeSS = 1 Or ( $PushBulletEnabled = 1 And IsChecked($UseJPG) ) Then
			SetLog(GetLangText("msgTakingLootSS"), $COLOR_ORANGE)
			Local $Date =  @YEAR & "." & @MON & "." & @MDAY
			Local $Time = @HOUR & "." & @MIN
			$FileName = $Date & "_at_" & $Time & ".jpg"
			If _Sleep(300) Then Return
			_CaptureRegion()
			_GDIPlus_ImageSaveToFile($hBitmap, $dirLoots & $FileName)
			If $LastRaidGold>500000 Or $LastRaidElixir>500000 Then
				_GDIPlus_ImageSaveToFile($hBitmap, $dirLoots &"Amazing\"& $FileName)
			EndIf
		EndIf
		If _Sleep(1000) Then Return
		Click(428, 544) ;Click Return Home Button
	Else
		checkMainScreen(True)
	EndIf

	If _GUICtrlEdit_GetLineCount($txtLog) > 5000 Then
		_GUICtrlEdit_SetText($txtLog, "")
	EndIf
	Local $counter = 0
	While 1
		If _Sleep(200) Then Return
		_CaptureRegion()
		If _ColorCheck(_GetPixelColor(284, 28), Hex(0x41B1CD, 6), 20) Then
			Return
		EndIf

		$counter += 1

		If $counter >= 50 Then
			SetLog(GetLangText("msgCannotReturn"), $COLOR_RED)
			checkMainScreen(True)
			Return
		EndIf
	WEnd
EndFunc   ;==>ReturnHome
