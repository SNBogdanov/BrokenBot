Func runBot() ;Bot that runs everything in order
	Global $AttackType
	Global $AfterAttack=False
	Local $GoldCountLocal,$ElixirCountLocal,$GemCountLocal,$DarkCountLocal
	Local $GoldCountOldLocal,$ElixirCountOldLocal,$GemCountOldLocal,$DarkCountOldLocal
	Click(1, 1, 2, 250) ;Click Away with 205ms delay

	SaveConfig()
	readConfig()
	applyConfig()
	If StatusCheck(True, True, 3) Then Return
	If $MaxGold = 0 Then
		$Text=StringReplace(ReadText(690, 8, 140, 1, 1),"G","6")
		$Text=StringReplace($Text,"O","0")
		$MaxGold = Number(StringRegExpReplace($Text,"[^0-9]",""))
		$Text=StringReplace(ReadText(690, 57, 140, 1, 1),"G","6")
		$Text=StringReplace($Text,"O","0")
		$MaxElixir = Number(StringRegExpReplace($Text,"[^0-9]",""))
		If Not _ColorCheck(_GetPixelColor(718, 131), Hex(0xF8FCFF, 6), 40) Then
			$Text=StringReplace(ReadText(745, 106, 100, 1, 1),"G","6")
			$Text=StringReplace($Text,"O","0")
			$MaxDark = Number(StringRegExpReplace($Text,"[^0-9]",""))
		EndIf

		SetLog("Maximum gold in storage:"&_NumberFormat($MaxGold),$COLOR_GREEN)
		SetLog("Maximum elixir in storage:"&_NumberFormat($MaxElixir),$COLOR_GREEN)
		SetLog("Maximum dark elixir in storage:"&_NumberFormat($MaxDark),$COLOR_GREEN)
		If $MaxGold = 0 Then
			$res=MsgBox($MB_YESNOCANCEL,"Warning","Please check BS configuration, can not continue"&@CR&"If you want to continue for your own risk press Yes, Or press No to stop")
			If $res=$IDCANCEL Or $res=$IDNO Then
				btnStop()
				Return
			EndIf
		EndIf
	EndIf
	If Not _TesseractCheck() Then
		btnStop()
		Return
	EndIf
	If $SearchCost = 0 Then
		CheckCostPerSearch()
		If StatusCheck() Then Return
		If $SearchCost = 0 Then
			btnStop()
			Return
		EndIf
	EndIf
	While 1
		If TimerDiff($hUpdateTimer) > (1000 * 60 * 60 * 12) Then
			checkupdate()
		EndIf

		_ReduceMemory() ;=> added to reduce memory use

		; Configuration and cleanup
		$Restart = False
		LootLogCleanup(100)
		$strPlugInInUse = IniRead($dirStrat & GUICtrlRead($lstStrategies) & ".ini", "plugin", "name", "")

		;Check attack mode
		chkNoAttack()
		If StatusCheck(True, True, 3) Then Return

		If $FirstStart And IsChecked($chkHelper) Then
			$ret = CallHelper("0 0 860 720 BrokenBotRedLineCheck 1 1 0 0 0", 10)
			If $ret = $DLLFailed Or $ret = $DLLTimeout Then
				MsgBox($MB_ICONWARNING + $MB_OK, GetLangText("msgMissing"), GetLangText("msgMissingDLL1") & @CRLF & @CRLF & GetLangText("msgMissingDLL2") & @CRLF & @CRLF & GetLangText("msgMissingDLL3"))
				GUICtrlSetState($chkHelper, $GUI_UNCHECKED)
			ElseIf $ret = $DLLLicense Then
				MsgBox(48, "BrokenBot.org", GetLangText("msgLicense") & @CRLF & @CRLF & "Please visit BrokenBot.org")
			EndIf
		EndIf

		; Collect stats

		$FreeBuilder = ReadText(320, 23, 41, $textMainScreen)

		VillageReport()
		If StatusCheck() Then Return

		$GoldCountOldLocal = Number(ReadText(666, 25, 138, $textMainScreen, 0))
		$ElixirCountOldLocal = Number(ReadText(666, 76, 138, $textMainScreen, 0))
		If _ColorCheck(_GetPixelColor(718, 131), Hex(0xF8FCFF, 6), 40) Then
			; No DE
			$GemCountOldLocal = Number(ReadText(736, 124, 68, $textMainScreen, 0))
		Else
			$DarkCountOldLocal = Number(ReadText(711, 125, 93, $textMainScreen, 0))
			$GemCountOldLocal = Number(ReadText(736, 173, 68, $textMainScreen, 0))
		EndIf
		UpdateStat($GoldCountOldLocal,$ElixirCountOldLocal,$DarkCountOldLocal,0)

		clearField()
		If StatusCheck() Then Return

		$GoldCountOldLocal = Number(ReadText(666, 25, 138, $textMainScreen, 0))
		$ElixirCountOldLocal = Number(ReadText(666, 76, 138, $textMainScreen, 0))
		UpdateStat($GoldCountOldLocal,$ElixirCountOldLocal,0,0)

		If $Checkrearm Then
			ReArm()
			$Checkrearm = False
		EndIf
		If StatusCheck() Then Return

		$GoldCountOldLocal = Number(ReadText(666, 25, 138, $textMainScreen, 0))
		$ElixirCountOldLocal = Number(ReadText(666, 76, 138, $textMainScreen, 0))
		If _ColorCheck(_GetPixelColor(718, 131), Hex(0xF8FCFF, 6), 40) Then
			; No DE
			UpdateStat($GoldCountOldLocal,$ElixirCountOldLocal,0,0)
		Else
			$DarkCountOldLocal = Number(ReadText(711, 125, 93, $textMainScreen, 0))
			UpdateStat($GoldCountOldLocal,$ElixirCountOldLocal,$DarkCountOldLocal,0)
		EndIf

		DonateCC()
		If StatusCheck() Then Return

;		RequestCC()
;		If StatusCheck() Then Return

		BoostAllBuilding()
		If StatusCheck() Then Return

		collectResources()
		If StatusCheck() Then Return
		If _Sleep(1000) Then Return

		$GoldCountOldLocal = Number(ReadText(666, 25, 138, $textMainScreen, 0))
		$ElixirCountOldLocal = Number(ReadText(666, 76, 138, $textMainScreen, 0))
		If _ColorCheck(_GetPixelColor(718, 131), Hex(0xF8FCFF, 6), 40) Then
			; No DE
			$GemCountOldLocal = Number(ReadText(736, 124, 68, $textMainScreen, 0))
		Else
			$DarkCountOldLocal = Number(ReadText(711, 125, 93, $textMainScreen, 0))
			$GemCountOldLocal = Number(ReadText(736, 173, 68, $textMainScreen, 0))
		EndIf
		UpdateStat($GoldCountOldLocal,$ElixirCountOldLocal,$DarkCountOldLocal,0)

		Laboratory()
		If StatusCheck() Then Return

		$ElixirCountLocal = Number(ReadText(666, 76, 138, $textMainScreen, 0))
		If _ColorCheck(_GetPixelColor(718, 131), Hex(0xF8FCFF, 6), 40) Then
			$DarkCountLocal=$DarkCount
		Else
			$DarkCountLocal = Number(ReadText(711, 125, 93, $textMainScreen, 0))
		EndIf

		If $ElixirCountOldLocal > $ElixirCountLocal Or $DarkCountOldLocal > $DarkCountLocal Then
			If $ElixirCountLocal > 0 Then $ElixirUpgraded = $ElixirUpgraded + $ElixirCountOldLocal - $ElixirCountLocal
			If $DarkCountLocal > 0 Then $DarkUpgraded = $DarkUpgraded + $DarkCountOldLocal - $DarkCountLocal
			UpdateStat(0,$ElixirCountLocal,$DarkCountLocal,0)
			$ElixirCountOldLocal = $ElixirCountLocal
			$DarkCountOldLocal = $DarkCountLocal
		EndIf

		UpgradeHeroes()	;==> upgradeheroes
		If StatusCheck() Then Return

		If _ColorCheck(_GetPixelColor(718, 131), Hex(0xF8FCFF, 6), 40) Then
			$DarkCountLocal=$DarkCount
		Else
			$DarkCountLocal = Number(ReadText(711, 125, 93, $textMainScreen, 0))
		EndIf

		If  $DarkCountOldLocal > $DarkCountLocal Then
			If $DarkCountLocal > 0 Then $DarkUpgraded = $DarkUpgraded + $DarkCountOldLocal - $DarkCountLocal
			UpdateStat(0,0,$DarkCountLocal,0)
			$DarkCountOldLocal = $DarkCountLocal
		EndIf

		UpgradeBuilding()
		If StatusCheck() Then Return

		$GoldCountLocal = Number(ReadText(666, 25, 138, $textMainScreen, 0))
		$ElixirCountLocal = Number(ReadText(666, 76, 138, $textMainScreen, 0))

		If $GoldCountOldLocal > $GoldCountLocal Or $ElixirCountOldLocal > $ElixirCountLocal  Then
			If $GoldCountLocal > 0 Then $GoldUpgraded = $GoldUpgraded + $GoldCountOldLocal - $GoldCountLocal
			If $ElixirCountLocal > 0 Then $ElixirUpgraded = $ElixirUpgraded + $ElixirCountOldLocal - $ElixirCountLocal
			UpdateStat($GoldCountLocal,$ElixirCountLocal,0,0)
			$GoldCountOldLocal = $GoldCountLocal
			$ElixirCountOldLocal = $ElixirCountLocal
		EndIf

		UpgradeWall()
		If StatusCheck() Then Return

		$GoldCountLocal = Number(ReadText(666, 25, 138, $textMainScreen, 0))
		$ElixirCountLocal = Number(ReadText(666, 76, 138, $textMainScreen, 0))

		If $GoldCountOldLocal > $GoldCountLocal Or $ElixirCountOldLocal > $ElixirCountLocal  Then
			If $GoldCountLocal > 0 Then $GoldUpgraded = $GoldUpgraded + $GoldCountOldLocal - $GoldCountLocal
			If $ElixirCountLocal > 0 Then $ElixirUpgraded = $ElixirUpgraded + $ElixirCountOldLocal - $ElixirCountLocal
			UpdateStat($GoldCountLocal,$ElixirCountLocal,0,0)
			$GoldCountOldLocal = $GoldCountLocal
			$ElixirCountOldLocal = $ElixirCountLocal
		EndIf

		$GoldCount = $GoldCountLocal
		$ElixirCount = $ElixirCountLocal
		$DarkCount = $DarkCountLocal
		$GemCount  = $GemCountLocal
		UpdateStat($GoldCount,$ElixirCount,$DarkCount,0)

		If $PushBulletEnabled = 1 And $PushBulletchatlog = 1 Then
			ReadChatLog(Not $ChatInitialized)
		EndIf
		If StatusCheck() Then Return
		$TrophyCount = Number(ReadText(59, 75, 60, $textMainScreen))

		Switch $CurrentMode
			Case $modeNormal
				If DropTrophy() Then ContinueLoop
				If StatusCheck(False) Then Return False

				If Idle($strPlugInInUse) Then ContinueLoop
				If StatusCheck(False) Then Return

				If Not $SearchFailed Then Call($strPlugInInUse & "_PrepNextBattle")
;				Click($TopLeftClient[0], $TopLeftClient[1], 2, 250); Click away twice with 250ms delay

				$GoldCount = Number(ReadText(666, 25, 138, $textMainScreen, 0))
				$res = Number(ReadText(666, 76, 138, $textMainScreen, 0))
				If $res>1 Then $ElixirCount = $res
				If _ColorCheck(_GetPixelColor(718, 131), Hex(0xF8FCFF, 6), 40) Then
					; No DE
					UpdateStat($GoldCount,$ElixirCount,0,0)
				Else
					$DarkCount = Number(ReadText(711, 125, 93, $textMainScreen, 0))
					UpdateStat($GoldCount,$ElixirCount,$DarkCount,0)
				EndIf

				While True
					If StatusCheck(False) Then Return

					If Not Call($strPlugInInUse & "_miniReadyCheck") Then ExitLoop

					Click(1, 1, 2, 250) ;Click Away with 205ms delay
					$TrophyCount = Number(ReadText(59, 75, 60, $textMainScreen))
					UpdateStat(0,0,0,$TrophyCount)
					If PrepareSearch() Then
						If $GoldBeforeSearch=0 Then $GoldBeforeSearch=$GoldCount
						$AttackType = Call($strPlugInInUse & "_Search")
						If $AttackType = -1 Then
							$SearchFailed = True
							ContinueLoop
						EndIf

						If $AttackType = -2 Then
							$SearchFailed = True
							ExitLoop
						EndIf
						If BotStopped(False) Then Return

						Call($strPlugInInUse & "_PrepareAttack", False, $AttackType)
						If BotStopped(False) Then Return

						SetLog(GetLangText("msgBeginAttack"))
						Call($strPlugInInUse & "_Attack", $AttackType)
						If BotStopped(False) Then Return

						ReturnHome($TakeLootSnapShot)
						If StatusCheck() Then Return
						If _GUICtrlComboBox_GetCurSel($cmbTroopComp) = 8 And $AttackType <> 3 Then $AfterAttack=True
					Else
						If _ColorCheck(_GetPixelColor(820, 15), Hex(0xF88288, 6), 20) Then Click(820, 15) ;Click Red X
						If ChkDisconnection() Then
							$SearchFailed = True
							ExitLoop
						EndIf
						If StatusCheck() Then Return
						ContinueLoop
					EndIf
					ExitLoop
				WEnd
			Case $modeDonateTrain
				$fullarmy = Donate_CheckArmyCamp()
				If StatusCheck() Then Return False

				If Not $fullarmy Then Donate_Train()
				If StatusCheck() Then Return False

				If _Sleep(5000) Then Return
			Case $modeDonate
				If _Sleep(5000) Then Return
				; Why is this even a mode?
			Case $modeExperience
				Experience()
		EndSwitch

		_BumpMouse()
	WEnd
EndFunc   ;==>runBot

Func Idle($Plugin) ;Sequence that runs until Full Army
	Local $TimeIdle = 0 ;In Seconds
	Local $hTimer = TimerInit()
	Local $prevCamp = 0
	Local $hTroopTimer = TimerInit()
	Local $TimeSinceTroop = 0
	While Not Call($Plugin & "_ReadyCheck", $TimeSinceTroop)
		If StatusCheck() Then Return False
		SetLog(GetLangText("msgWaitingFull"), $COLOR_PURPLE)
		DonateCC()
		If StatusCheck() Then Return False ; Do not wait for main screen we need ArmyOverview open

		_CaptureRegion()
		$ElixirCountOld=$ElixirCount
		$res= Number(ReadText(666, 76, 138, $textMainScreen, 0))
		If $res>1 Then $ElixirCount = $res
		If $ElixirCount >1 Then $ElixirTrainCost= $ElixirCountOld-$ElixirCount+$ElixirTrainCost
		UpdateStat(0,$ElixirCount,0,0)
		If Not _ColorCheck(_GetPixelColor(718, 131), Hex(0xF8FCFF, 6), 40) Then
			$DarkCountOld=$DarkCount
			$DarkCount = Number(ReadText(711, 125, 93, $textMainScreen, 0))
			If $DarkCount >1 Then $DarkTrainCost= $DarkCountOld-$DarkCount+$DarkTrainCost
			UpdateStat(0,0,$DarkCount,0)
		EndIf
		If $iCollectCounter > $COLLECTATCOUNT Then ; This is prevent from collecting all the time which isn't needed anyway
			collectResources()
			If StatusCheck() Then Return False
			If _Sleep(1000) Then Return False

			$GoldCountOldLocal = Number(ReadText(666, 25, 138, $textMainScreen, 0))
			$ElixirCountOldLocal = Number(ReadText(666, 76, 138, $textMainScreen, 0))
			If _ColorCheck(_GetPixelColor(718, 131), Hex(0xF8FCFF, 6), 40) Then
				; No DE
				UpdateStat($GoldCountOldLocal,$ElixirCountOldLocal,0,0)
			Else
				$DarkCountOldLocal = Number(ReadText(711, 125, 93, $textMainScreen, 0))
				UpdateStat($GoldCountOldLocal,$ElixirCountOldLocal,$DarkCountOldLocal,0)
			EndIf
			$iCollectCounter = 0
			$TrophyCount = Number(ReadText(59, 75, 60, $textMainScreen))

		EndIf
		$iCollectCounter += 1

		_BumpMouse()

		$TimeIdle = Round(TimerDiff($hTimer) / 1000, 2) ;In Seconds
		If $CurCamp <> $prevCamp Then
			$prevCamp = $CurCamp
			$hTroopTimer = TimerInit()
		EndIf
		If $CurCamp = 0 Or $CurCamp = "" Then
			$hTroopTimer = TimerInit() ; Not a good fix, but will stop errors for people whose troop size can't be read for now
		EndIf
		$TimeSinceTroop = TimerDiff($hTroopTimer) / 1000
		SetLog(GetLangText("msgTimeIdle") & Floor(Floor($TimeIdle / 60) / 60) & GetLangText("msgTimeIdleHours") & Floor(Mod(Floor($TimeIdle / 60), 60)) & GetLangText("msgTimeIdleMin") & Floor(Mod($TimeIdle, 60)) & GetLangText("msgTimeIdleSec"), $COLOR_ORANGE)
		$hIdle = TimerInit()
		If IsChecked($mixmodenormexp) And IsChecked($chkSnipeTrainingEnable) Then
			If Not $closetofull Then
				$AfterAttack=False;
				Click(125,695,3,250)
				SetLog("Unbreakable mode, wait 5 minute", $COLOR_PURPLE)
				If _Sleep(5*60000) Then Return
				If StatusCheck() Then Return False
			    $Checkrearm = True
			    Return True
;				ReArm()
			EndIf
		ElseIf IsChecked($chkSnipeTrainingEnable) Then
			If SnipeWhileTraining() Then Return True
		ElseIf IsChecked($mixmodenormexp) Then
			Experience()
		EndIf
		If $closetofull Then
			$loopdelay = 1000
		Else
			$loopdelay = 30000
		EndIf
		While TimerDiff($hIdle) < $loopdelay
			DonateCC(True)
			If _Sleep(1000) Then Return False
		WEnd
		If StatusCheck() Then Return False
	WEnd

EndFunc   ;==>Idle

Func _ReduceMemory()
   Local $ai_GetCurrentProcessId = DllCall('kernel32.dll', 'int', 'GetCurrentProcessId')
   Local $ai_Handle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $ai_GetCurrentProcessId[0])
   Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', $ai_Handle[0])
   DllCall('kernel32.dll', 'int', 'CloseHandle', 'int', $ai_Handle[0])
   Return $ai_Return[0]
EndFunc
