Global $wallbuild
Global $walllowlevel

Func UpgradeWall()
	SetLog(GetLangText("msgCheckWalls"))
	If Not IsChecked($chkWalls) Then Return

        $FreeBuilder = ReadText(320, 23, 41, $textMainScreen)
	If $FreeBuilder = 0 Then
		SetLog(GetLangText("msgNoBuilders"), $COLOR_RED)
		Click(1, 1) ; Click Away
		Return
	EndIf

;	VillageReport()
	$GoldCount = Number(ReadText(666, 25, 138, $textMainScreen, 0))
	$res = Number(ReadText(666, 76, 138, $textMainScreen, 0))
	If $res>1 Then $ElixirCount = $res
	$itxtWallMinGold = GUICtrlRead($txtWallMinGold)
	$itxtWallMinElixir = GUICtrlRead($txtWallMinElixir)




	$GoldRequired=$UPWall[$icmbWalls+4]+$itxtWallMinGold
	If $GoldRequired > $MaxGold And $MaxGold > 0 Then $GoldRequired=$MaxGold

	$ElixirRequired=$UPWall[$icmbWallsE+8]+$itxtWallMinElixir
	If $ElixirRequired > $MaxElixir And $MaxElixir > 0 Then $ElixirRequired=$MaxElixir

	Local $MinWallGold = Number($GoldCount) > $GoldRequired
	Local $MinWallElixir = Number($ElixirCount) > $ElixirRequired

	If IsChecked($UseGold) Or isGoldFull() Then
		If $MinWallGold  Or isGoldFull() Then
			SetLog(GetLangText("msgWallUpGold"), $COLOR_BLUE)
			UpgradeWallGold()			
		Else
			SetLog(GetLangText("msgGoldBelowMin"), $COLOR_RED)
		EndIf
	EndIf
	If IsChecked($UseElixir) Or isElixirFull() Then
		If $MinWallElixir Or isElixirFull() Then
			Setlog(GetLangText("msgWallUpElix"), $COLOR_BLUE)
			UpgradeWallelix()			
		Else
			Setlog(GetLangText("msgElixBelowMin"), $COLOR_BLUE)
		EndIf
	EndIf

EndFunc   ;==>UpgradeWall


Func UpgradeWallelix()

	checkWallE()
	If $checkwalllogic Then
		Click(1, 1) ; Click Away
		_Sleep(600)
		Click($WallX, $WallY)
		_Sleep(600)
		_CaptureRegion()
		If _ColorCheck(_GetPixelColor(595, 568), Hex(0xFFFFFF, 6), 20) = False Then
			SetLog(GetLangText("msgWallElixorLvl"), $COLOR_ORANGE)
			Click(1, 1) ; Click away
			_Sleep(1000)
		Else
			Click(560, 599) ; Click Upgrade
			_Sleep(2000)
			Click(472, 482) ; Click Okay
			SetLog(GetLangText("msgWallUpDone"), $COLOR_BLUE) ; Done upgrade
			GUICtrlSetData($lblwallupgradecount, GUICtrlRead($lblwallupgradecount) + 1)
			Click(1, 1) ; Click away
			_Sleep(1000)
		EndIf
	EndIf
	Click(1, 1) ; Click Away
EndFunc   ;==>UpgradeWallelix


Func UpgradeWallGold()

	checkWall()
	If $checkwalllogic Then
		Click(1, 1) ; Click Away
		_Sleep(600)
		Click($WallX, $WallY)
		_Sleep(600)
		_CaptureRegion()
		If _ColorCheck(_GetPixelColor(523, 641), Hex(0x000000, 6), 20) = False Then ; checking wall level high than level 8
			$walllowlevel = 0
			If Not _ColorCheck(_GetPixelColor(500, 570), Hex(0xFEFEFE, 6), 20) Then
				SetLog(GetLangText("msgWallNotEnoughGold"), $COLOR_ORANGE)
				Click(1, 1) ; Click Away
				$wallbuild = 0
			Else
				Click(505, 596) ; Click Upgrade
				_Sleep(2000)
				Click(472, 482) ; Click Okay
				SetLog(GetLangText("msgWallUpDone"), $COLOR_BLUE) ; Done upgrade
				GUICtrlSetData($lblwallupgradecount, GUICtrlRead($lblwallupgradecount) + 1)
				_Sleep(1000)
				Click(1, 1) ; Click Away
			EndIf
		Else ; check wall level lower than 8
			$walllowlevel = 1
			If Not _ColorCheck(_GetPixelColor(547, 570), Hex(0xFFFFFF, 6), 20) Then
				SetLog(GetLangText("msgWallNotEnoughGold"), $COLOR_ORANGE)
				Click(1, 1) ; Click Away
				$wallbuild = 0
			Else
				Click(505, 596) ; Click Upgrade
				_Sleep(2000)
				Click(472, 482) ; Click Okay
				SetLog(GetLangText("msgWallUpDone"), $COLOR_BLUE) ; Done upgrade
				GUICtrlSetData($lblwallupgradecount, GUICtrlRead($lblwallupgradecount) + 1)
				_Sleep(1000)
				Click(1, 1) ; Click Away
			EndIf
		EndIf
	EndIf
	Click(1, 1) ; Click Away
EndFunc   ;==>UpgradeWallGold
