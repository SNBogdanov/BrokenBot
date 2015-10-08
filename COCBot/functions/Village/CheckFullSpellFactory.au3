Func CheckFullSpellFactory()

	Local $previousSpells = $curSpells

	SetLog(GetLangText("msgCheckingSF"), $COLOR_BLUE)
	$fullSpellFactory = False
	$SpellsChanged = True

	If _Sleep(100) Then Return

	If Not TryToOpenArmyOverview() Then Return




	If _Sleep(100) Then Return

	For $readattempts = 1 To 5
		$curSpells = GetTroopCapacity(204, 389, 242, 404)
;		$curSpells = _TesseractReadText(204, 389, 242, 404, "-threshold 55% ")
		$curSpells = StringStripWS($curSpells, 8)

		$itxtFactoryCap = StringMid($curSpells, StringInStr($curSpells, "/") + 1)
		If Number($itxtFactoryCap) > 0 And Number($itxtFactoryCap) < 12 And StringIsDigit($itxtFactoryCap) Then
			$curSpells = StringLeft($curSpells, StringInStr($curSpells, "/") - 1)
			If Number($curSpells) >= 0 And Number($curSpells) <= $itxtFactoryCap And StringIsDigit($curSpells) Then
				SetLog("Spells: " & $curSpells & "/" & $itxtFactoryCap, $COLOR_GREEN)
				ExitLoop
			EndIf
		EndIf

		If _Sleep(500) Then Return
		If $readattempts = 5 Then
			SetLog("Spells: " & GetLangText("lblUnknownCap"), $COLOR_GREEN)
			$curSpells = -1
			ExitLoop
		EndIf
	Next

;	If  ($curSpells - $previousSpells) <> 0 Then $SpellsChanged = True

	If $curSpells = -1 Then
		SetLog(GetLangText("msgSFUnavailable"), $COLOR_RED)
		Return -1
	EndIf

	If $curSpells + 1 >= $itxtFactoryCap Then
		SetLog(GetLangText("msgSpellFull"), $COLOR_RED)
		$fullSpellFactory = True
	EndIf


	If $DebugMode = 1 Then SetLog("Spell Factory Full: " & $fullSpellFactory)


	Return False
;	Return $fullSpellFactory
EndFunc   ;==>CheckFullSpellFactory


