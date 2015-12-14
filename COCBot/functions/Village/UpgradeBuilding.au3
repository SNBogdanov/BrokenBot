
Func UpgradeBuilding()

	Local $i = 0
	Local $Upgraded = False
	Local $SomethingUpgraded = False
	Local $GoldRequired
	Local $ElixirRequired
	$iinpUPMinimumGold=GUICtrlRead($inpUPMinimumGold)
	$iinpUPMinimumElixir=GUICtrlRead($inpUPMinimumElixir)

	SetLog("Checking Upgrade Buildings...")
	For $Building In $UpgradeQueue

	        StatusCheck()
		$Upgraded = False

		$GoldCount = Number(ReadText(666, 25, 138, $textMainScreen, 0))
		$ElixirCount = Number(ReadText(666, 76, 138, $textMainScreen, 0))
		$FreeBuilder = ReadText(320, 23, 41, $textMainScreen)
		Setlog("Num. of Free Builders: " & $FreeBuilder, $COLOR_GREEN)
;		GUICtrlSetData($lblfreebuilder, $FreeBuilder)
		If $FreeBuilder =0  Then
			SetLog(GetLangText("msgNoBuilders"), $COLOR_RED)
			ExitLoop
		EndIf

		If $Building[5] <> "Wall" Then
			If $FreeBuilder < $itxtKeepFreeBuilder+1 Then
				SetLog(GetLangText("msgFreeBuilder"), $COLOR_RED)
				If IsChecked($chkUPHalt) Then 
					SetLog("Upgrade Halted.", $COLOR_PURPLE)
					ExitLoop
				Else
					$i += 1
					ContinueLoop
				EndIf
;				ClickP($TopLeftClient) ; Click Away
;				Return
			EndIf
		EndIf


		If $Building[0] = True Then ; if upgrade enabled

			If $Building[1] <> "" And $Building[2] <> "" Then ; if located
				If $Building[3] = 0 Then
					$GoldRequired=Number($Building[4])+$iinpUPMinimumGold
					If $GoldRequired > $MaxGold And $MaxGold > 0 Then $GoldRequired=$MaxGold

					If $GoldCount >= $GoldRequired Then
						If UpgradeMyBuilding($Building[1], $Building[2], $Building[3], $Building[5]) = True Then $Upgraded = True
					Else
						SetLog("Not enough Gold", $COLOR_RED)
					EndIf
				Else

					$ElixirRequired=Number($Building[4])+$iinpUPMinimumElixir
					If $ElixirRequired > $MaxElixir And $MaxElixir > 0 Then $ElixirRequired=$MaxElixir
					If $ElixirCount >= $ElixirRequired Then
						If UpgradeMyBuilding($Building[1], $Building[2], $Building[3], $Building[5]) = True Then $Upgraded = True
					Else
						SetLog("Not enough Elixir", $COLOR_RED)
					EndIf
				EndIf
			Else
				SetLog($Building[5] & " is not located", $COLOR_RED)
			EndIf

		Else

			If IsChecked($chkUPHalt) Then 
				SetLog("Upgrade Halted.", $COLOR_PURPLE)
				ExitLoop
			Else
				SetLog($Building[5] & " is not enabled, skipping", $COLOR_RED)
				$i += 1
				ContinueLoop
			EndIf
		EndIf


		If $Upgraded = True Then
			If $Building[5] = "Wall" Then
				GUICtrlSetData($lblwallupgradecount, GUICtrlRead($lblwallupgradecount) + 1)
			EndIf
			UPremove($i) ;cleaning from ini
			$SomethingUpgraded=True
			;SetLog("Removing " & $i)
			$i -= 1
		ElseIf IsChecked($chkUPHalt) Then
			SetLog("Upgrade Halted.", $COLOR_PURPLE)
			ExitLoop
		EndIf

		$i += 1
	Next

	If $SomethingUpgraded=True Then
		$UPCurSel = -1 ; dont save in current
		$UPprevSel = -1
		btnUPreload()
		btnUPSave()


	EndIf
	_GUICtrlListBox_SetCurSel($lstUPlist, 0)
	UpdateQueueDesign()
EndFunc   ;==>UpgradeBuilding



Func UpgradeMyBuilding($UPx, $UPy, $UPgoldORElixir, $UPname)


	SetLog("Attempting to upgrade " & $UPname, $COLOR_GREEN)

	If _Sleep(500) Then Return False
	Click($UPx, $UPy) ; Click building
	If _Sleep(500) Then Return False

	If $UPgoldORElixir = 1 Then ; elixir
		Local $ElixirUpgrade = _PixelSearch(300, 60+560, 629, 60+583, Hex(0xF759E8, 6), 10) ;Finds Elixir Upgrade Button

		If IsArray($ElixirUpgrade) Then
			Click($ElixirUpgrade[0], $ElixirUpgrade[1]) ;Click Upgrade Button
			If _Sleep(1000) Then Return False
			Local $UpgradeCheck = _PixelSearch(300, 30+463, 67330+, 522, Hex(0xB9E051, 6), 10) ;Confirm Upgrade
			If IsArray($UpgradeCheck) Then
				Click($UpgradeCheck[0], $UpgradeCheck[1]) ;Click Upgrade Button
				If _Sleep(1000) Then Return False
				_CaptureRegion()
				If Not _ColorCheck(_GetPixelColor(571, 30+263), Hex(0xD90404, 6), 20) Then
					SetLog($UPname & " " & GetLangText("msgUpgradeSuccess"), $COLOR_GREEN)
					If _Sleep(1000) Then Return True ; because already upgraded
					ClickP($TopLeftClient, 2)
					Return True
				Else
					SetLog("Failed to Upgrade " & $UPname, $COLOR_RED)
					ClickP($TopLeftClient, 2)
					Return False
				EndIf
			Else
				SetLog("Couldnt find Confirm button", $COLOR_RED)
				ClickP($TopLeftClient, 2)
				Return False
			EndIf
		Else
			SetLog("Couldnt find upgrade button", $COLOR_RED)
			ClickP($TopLeftClient, 2)
			Return False
		EndIf
	Else

		Local $GoldUpgrade = _PixelSearch(300, 60+560, 629, 60+583, Hex(0xF4EE54, 6), 10) ;Finds Gold Upgrade Button


		If IsArray($GoldUpgrade) Then

			Click($GoldUpgrade[0], $GoldUpgrade[1]) ;Click Upgrade Button
			If _Sleep(1000) Then Return False
			Local $UpgradeCheck = _PixelSearch(300, 60+463, 673, 60+522, Hex(0xB9E051, 6), 10) ;Confirm Upgrade
			If IsArray($UpgradeCheck) Then
				Click($UpgradeCheck[0], $UpgradeCheck[1]) ;Click Upgrade Button
				If _Sleep(1000) Then Return False
				_CaptureRegion()
				If Not _ColorCheck(_GetPixelColor(571, 30+263), Hex(0xD90404, 6), 20) Then
					SetLog($UPname & " " & GetLangText("msgUpgradeSuccess"), $COLOR_GREEN)
					If _Sleep(1000) Then Return True
					ClickP($TopLeftClient, 2)
					Return True
				Else
					SetLog("Failed to Upgrade " & $UPname, $COLOR_RED)
					ClickP($TopLeftClient, 2)
					Return False
				EndIf
			Else
				SetLog("Couldnt find Confirm button", $COLOR_RED)
				ClickP($TopLeftClient, 2)
				Return False
			EndIf
		Else
			SetLog("Couldnt find upgrade button", $COLOR_RED)
			ClickP($TopLeftClient, 2)
			Return False
		EndIf
	EndIf

	ClickP($TopLeftClient, 2)
	Return False
EndFunc   ;==>UpgradeMyBuilding

