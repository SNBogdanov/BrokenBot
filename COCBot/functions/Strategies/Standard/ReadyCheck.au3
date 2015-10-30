;ReadyCheck is in charge of build full army and spell.
;When Army is full, ReadyCheck will Return True
;Hero status check will be done later in the loop, right before start search
Local $MinElixir=150000
Func Standard_ReadyCheck($TimeSinceNewTroop)
	If $TimeSinceNewTroop > Standard_GetTrainTime() + 60 Then
		If $stuckCount < 3 Then
			$FirstStart = True
			SetLog(GetLangText("msgAppearsStuck"))
			$stuckCount += 1
		ElseIf $stuckCount >= 3 Then
			SetLog(GetLangText("msgSevereStuck"))
			$stuckCount += 1
		EndIf
	EndIf
	$ElixirCountOld=$ElixirCount
	$res= Number(ReadText(666, 76, 138, $textMainScreen, 0))
	If $res>1 Then $ElixirCount = $res
	UpdateStat(0,$ElixirCount,0,0)
	If Not _ColorCheck(_GetPixelColor(718, 131), Hex(0xF8FCFF, 6), 40) Then
		$DarkCountOld=$DarkCount
		$DarkCount = Number(ReadText(711, 125, 93, $textMainScreen, 0))
		UpdateStat(0,0,$DarkCount,0)
	EndIf


	$fullarmy = Standard_CheckArmyCamp()
	If StatusCheck(False) Then Return False ; Do not wait for main screen we need ArmyOverview open

	If $barracksCampFull And Not $fullarmy Then
		If $stuckCount < 3 Then
			$FirstStart = True
			SetLog(GetLangText("msgAppearsStuck"))
			$stuckCount += 1
			$fullarmy = Standard_CheckArmyCamp()
			If StatusCheck(false) Then Return False
		ElseIf $stuckCount >= 3 Then
			SetLog(GetLangText("msgSevereStuck"))
			$stuckCount += 1
		EndIf
	EndIf

	If StatusCheck(False) Then Return False ; Do not wait for main screen we need ArmyOverview open


	If $ElixirCount <$MinElixir Then
		If Not $fullarmy  Then
			SetLog("Elixir level "&$ElixirCount&" is less then minimum "&$MinElixir&", skip training", $COLOR_RED)
			Click(1, 1, 2, 250) ;Click Away with 205ms delay
			Return False
		EndIf
		Return True
	EndIf

	If IsChecked($chkMakeSpells) Then
		Local $mySpellFactoryNA = CheckFullSpellFactory()

		If Number($mySpellFactoryNA) = -1 Then ;if spellfactory not available
			$NeedsToBrew = False
		Else
			$NeedsToBrew = Not $mySpellFactoryNA
			If $FirstStart Then
				$NeedsToBrew = True
			EndIf
		EndIf


	EndIf

	$barracksCampFull = False
	If Not $fullarmy And $stuckCount < 3 Then Standard_Train()

	If StatusCheck(False) Then Return False ; Do not wait for main screen we need ArmyOverview open

	If $stuckCount >= 3 And (IsChecked($chkDeadActivate) Or IsChecked($chkAnyActivate)) Then
		$fullarmy = True
	EndIf

	If $fullarmy And (IsChecked($chkDeadActivate) Or IsChecked($chkAnyActivate)) Then
		Return True
	EndIf

	If IsChecked($chkMakeSpells) Then
		If $fullSpellFactory And IsChecked($chkNukeOnly) And Not IsChecked($chkNukeOnlyWithFullArmy) Then
			Return True
		EndIf
	EndIf

	Return False
EndFunc   ;==>Standard_ReadyCheck

;Quick check before start searching
;Check Hero status
;If last search failed, also check spell status and army status
;If army is not full for some reason, return false, else return true
Func Standard_miniReadyCheck()
	; Verify hero availability ~ minicheck only called by MainLoop in line 93, this verification moved to Standart_Train function since ArmyOverview queue demand. when Standart_Train called with reset = True, which is done by Standart__PrepNextBattle function in MainLoop.au3 line 88.
	If $SearchFailed Then ;Last search failed, do additional checks
		$fullarmy = Standard_CheckArmyCamp()
		If Not $fullarmy And $stuckCount < 3 Then
			Return False ;Troop missing in not stuck situation, exit loop and restart training
		Else
			$fullarmy = True ;Set the flag again, search condition can be properly populated
		EndIf
		If StatusCheck(False) Then Return False

		ChkHeroesAvailability()
		If StatusCheck(False) Then Return False

		If IsChecked($chkMakeSpells) Then
			$fullSpellFactory = CheckFullSpellFactory()
			If StatusCheck(False) Then Return False
		EndIf
;	Else ;SearchFailed=False
		;reset SearchCount only when last search wasn't failed
;		$SearchCount = 0
	EndIf

	If Not AdjustSearchCond() Then
		;No search condition is valid
		SetLog(GetLangText("msgHeroNotReady"), $COLOR_PURPLE)
		_Sleep(20000)
		Return False
	EndIf
;~ 	ClickP($TopLeftClient); click away

	Return True
EndFunc   ;==>Standard_miniReadyCheck


Func Standard_GetTrainTime()
	$MaxTrainTime = 0
	Switch _GUICtrlComboBox_GetCurSel($cmbTroopComp)
		Case 0
			$MaxTrainTime = 25
		Case 1
			$MaxTrainTime = 20
		Case 2
			$MaxTrainTime = 30
		Case 3
			$MaxTrainTime = 25
		Case 4
			$MaxTrainTime = 120
		Case 5
			$MaxTrainTime = 120
		Case 6
			$MaxTrainTime = 30
		Case 7
			$MaxTrainTime = 120
		Case 8
			Switch _GUICtrlComboBox_GetCurSel($cmbBarrack1)
				Case 0
					$MaxTrainTime = 20
				Case 1
					$MaxTrainTime = 25
				Case 2
					$MaxTrainTime = 120
				Case 3
					$MaxTrainTime = 30
				Case 4
					$MaxTrainTime = 120
				Case 5
					$MaxTrainTime = 240
				Case 6
					$MaxTrainTime = 480
				Case 7
					$MaxTrainTime = 900
				Case 8
					$MaxTrainTime = 1800
				Case 9
					$MaxTrainTime = 2700
				Case 10
					$MaxTrainTime = 0
			EndSwitch
			Switch _GUICtrlComboBox_GetCurSel($cmbBarrack2)
				Case 0
					If $MaxTrainTime < 20 Then $MaxTrainTime = 20
				Case 1
					If $MaxTrainTime < 25 Then $MaxTrainTime = 25
				Case 2
					If $MaxTrainTime < 120 Then $MaxTrainTime = 120
				Case 3
					If $MaxTrainTime < 30 Then $MaxTrainTime = 30
				Case 4
					If $MaxTrainTime < 120 Then $MaxTrainTime = 120
				Case 5
					If $MaxTrainTime < 240 Then $MaxTrainTime = 240
				Case 6
					If $MaxTrainTime < 480 Then $MaxTrainTime = 480
				Case 7
					If $MaxTrainTime < 900 Then $MaxTrainTime = 900
				Case 8
					If $MaxTrainTime < 1800 Then $MaxTrainTime = 1800
				Case 9
					If $MaxTrainTime < 2700 Then $MaxTrainTime = 2700
				Case 10
					; Nothing
			EndSwitch
			Switch _GUICtrlComboBox_GetCurSel($cmbBarrack3)
				Case 0
					If $MaxTrainTime < 20 Then $MaxTrainTime = 20
				Case 1
					If $MaxTrainTime < 25 Then $MaxTrainTime = 25
				Case 2
					If $MaxTrainTime < 120 Then $MaxTrainTime = 120
				Case 3
					If $MaxTrainTime < 30 Then $MaxTrainTime = 30
				Case 4
					If $MaxTrainTime < 120 Then $MaxTrainTime = 120
				Case 5
					If $MaxTrainTime < 240 Then $MaxTrainTime = 240
				Case 6
					If $MaxTrainTime < 480 Then $MaxTrainTime = 480
				Case 7
					If $MaxTrainTime < 900 Then $MaxTrainTime = 900
				Case 8
					If $MaxTrainTime < 1800 Then $MaxTrainTime = 1800
				Case 9
					If $MaxTrainTime < 2700 Then $MaxTrainTime = 2700
				Case 10
					; Nothing
			EndSwitch
			Switch _GUICtrlComboBox_GetCurSel($cmbBarrack4)
				Case 0
					If $MaxTrainTime < 20 Then $MaxTrainTime = 20
				Case 1
					If $MaxTrainTime < 25 Then $MaxTrainTime = 25
				Case 2
					If $MaxTrainTime < 120 Then $MaxTrainTime = 120
				Case 3
					If $MaxTrainTime < 30 Then $MaxTrainTime = 30
				Case 4
					If $MaxTrainTime < 120 Then $MaxTrainTime = 120
				Case 5
					If $MaxTrainTime < 240 Then $MaxTrainTime = 240
				Case 6
					If $MaxTrainTime < 480 Then $MaxTrainTime = 480
				Case 7
					If $MaxTrainTime < 900 Then $MaxTrainTime = 900
				Case 8
					If $MaxTrainTime < 1800 Then $MaxTrainTime = 1800
				Case 9
					If $MaxTrainTime < 2700 Then $MaxTrainTime = 2700
				Case 10
					; Nothing
			EndSwitch
		Case 9
			If GUICtrlRead($txtBarbarians) > 0 And $MaxTrainTime < 20 Then $MaxTrainTime = 20
			If GUICtrlRead($txtArchers) > 0 And $MaxTrainTime < 25 Then $MaxTrainTime = 25
			If GUICtrlRead($txtGoblins) > 0 And $MaxTrainTime < 30 Then $MaxTrainTime = 30
			If (GUICtrlRead($txtNumGiants) > 0 Or GUICtrlRead($txtNumWallbreakers) > 0) And $MaxTrainTime < 120 Then $MaxTrainTime = 120

	EndSwitch

	;check if training de troops and take them into account
	Standard_GetDETroopTotals()
	If $totalMinions > 0 And $MaxTrainTime < 45 Then $MaxTrainTime = 45
	If $totalHogs > 0 And $MaxTrainTime < 120 Then $MaxTrainTime = 120
	If $totalValkyries > 0 And $MaxTrainTime < 480 Then $MaxTrainTime = 480

	Return $MaxTrainTime
EndFunc   ;==>Standard_GetTrainTime

Func Standard_GetDETroopTotals()
	; calculates the total of each DE troop to be trained
	Global $totalMinions = 0
	Global $totalHogs = 0
	Global $totalValkyries = 0

	$DarkBarrackTroop[0] = _GUICtrlComboBox_GetCurSel($cmbDarkBarrack1)
	$DarkBarrackTroop[1] = _GUICtrlComboBox_GetCurSel($cmbDarkBarrack2)

	$DarkBarrackTroopNext[0] = _GUICtrlComboBox_GetCurSel($cmbDarkBarrack1Next)
	$DarkBarrackTroopNext[1] = _GUICtrlComboBox_GetCurSel($cmbDarkBarrack2Next)

	If $DarkBarrackTroop[0] = 0 Then $totalMinions += GUICtrlRead($txtDarkBarrack1)
	If $DarkBarrackTroopNext[0] = 0 Then $totalMinions += GUICtrlRead($txtDarkBarrack1Next)
	If $DarkBarrackTroop[1] = 0 Then $totalMinions += GUICtrlRead($txtDarkBarrack2)
	If $DarkBarrackTroopNext[1] = 0 Then $totalMinions += GUICtrlRead($txtDarkBarrack2Next)

	If $DarkBarrackTroop[0] = 1 Then $totalHogs += GUICtrlRead($txtDarkBarrack1)
	If $DarkBarrackTroopNext[0] = 1 Then $totalHogs += GUICtrlRead($txtDarkBarrack1Next)
	If $DarkBarrackTroop[1] = 1 Then $totalHogs += GUICtrlRead($txtDarkBarrack2)
	If $DarkBarrackTroopNext[1] = 1 Then $totalHogs += GUICtrlRead($txtDarkBarrack2Next)

	If $DarkBarrackTroop[0] = 2 Then $totalValkyries += GUICtrlRead($txtDarkBarrack1)
	If $DarkBarrackTroopNext[0] = 2 Then $totalValkyries += GUICtrlRead($txtDarkBarrack1Next)
	If $DarkBarrackTroop[1] = 2 Then $totalValkyries += GUICtrlRead($txtDarkBarrack2)
	If $DarkBarrackTroopNext[1] = 2 Then $totalValkyries += GUICtrlRead($txtDarkBarrack2Next)

EndFunc   ;==>Standard_GetDETroopTotals

Func Standard_CheckArmyCamp($inCamp = False)
	SetLog(GetLangText("msgCheckingCamp"), $COLOR_BLUE)
	$fullarmy = False
	if StatusCheck() then return false

	If _Sleep(100) Then Return false

	If Not TryToOpenArmyOverview() Then Return false


	If _Sleep($TrainingDelay) Then Return false
	Click(150, 550, 2, 100) ; Try To return main page if its on other


	Local $previouscampcap = Number($itxtcampCap)
	For $readattempts = 1 To 5

		$CurCamp = GetTroopCapacity(211, 144, 290, 157)
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
			Local $TroopKind = _GetPixelColor(177 + 62 * $i, 195)
			Local $TroopKind2 = _GetPixelColor(187 + 62 * $i, 200)
			Local $TroopName = ""
			Local $TroopQ = StringStripWS(GetTroopCount(160 + (62 * $i), 170, 200 + (62 * $i), 181), 3)
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

	$FirstCampView = True

	Return $fullarmy
EndFunc   ;==>Standard_CheckArmyCamp

;Uses the location of manually set Barracks to train specified troops

; Train the troops (Fill the barracks)

Func Standard_GetTrainPos($TroopKind)
	Switch $TroopKind
		Case $eBarbarian ; 261, 366: 0x39D8E0
			Return $TrainBarbarian
		Case $eArcher ; 369, 366: 0x39D8E0
			Return $TrainArcher
		Case $eGiant ; 475, 366: 0x3DD8E0
			Return $TrainGiant
		Case $eGoblin ; 581, 366: 0x39D8E0
			Return $TrainGoblin
		Case $eWallbreaker ; 635, 335, 0x3AD8E0
			Return $TrainWallbreaker
		Case $eMinion
			Return $TrainMinion
		Case $eHog
			Return $TrainHog
		Case $eValkyrie
			Return $TrainValkyrie
		Case Else
			SetLog(GetLangText("msgDontKnow") & $TroopKind & GetLangText("msgYet"))
			Return 0
	EndSwitch
EndFunc   ;==>Standard_GetTrainPos

Func Standard_TrainIt($TroopKind, $howMuch = 1, $iSleep = 100)
	$anythingadded = True
	_CaptureRegion()
	Local $pos = Standard_GetTrainPos($TroopKind)
	If IsArray($pos) Then
		If CheckPixel($pos) Then
			ClickP($pos, $howMuch, 20)
			If _Sleep($iSleep) Then Return False
			Return True
		EndIf
	EndIf
EndFunc   ;==>Standard_TrainIt

Func Standard_GetTrainPosDll()
	$res = CallHelper("170 290 700 500 BrokenBotMatchObject 200 6 0")

	If $res <> $DLLFailed And $res <> $DLLTimeout Then
		If $res = $DLLLicense Then
			SetLog(GetLangText("msgLicense"), $COLOR_RED)
		ElseIf $res = $DLLNegative Or $res = $DLLError Then
			; failed to find training buttons
			SetLog(GetLangText("Failed finding troop training..."), $COLOR_RED)
			Return False
		Else
			$expRet = StringSplit($res, "|", 2)
			$numTroops = $expRet[0]
			$foundMinion = False
			$foundHog = False
			$foundValkyrie = False
			For $j = 1 To UBound($expRet) - 1 Step 6
				$ResX = $expRet[$j] + 170
				$ResY = $expRet[$j + 1] + 290
				$ResID = $expRet[$j + 4]
				If $ResX = 0 And $ResY = 0 Then ExitLoop

				;Only deal with minions, hogs, valks for now
				If $ResID = 11 Then ;minions
					$foundMinion = True
					$TrainMinionDll[0] = $ResX
					$TrainMinionDll[1] = $ResY
				ElseIf $ResID = 12 Then ;hogs
					$foundHog = True
					$TrainHogDll[0] = $ResX
					$TrainHogDll[1] = $ResY
				ElseIf $ResID = 13 Then ;valks
					$foundValkyrie = True
					$TrainValkyrieDll[0] = $ResX
					$TrainValkyrieDll[1] = $ResY
				EndIf
			Next

			If Not $foundMinion Then
				$TrainMinionDll[0] = -1
				$TrainMinionDll[1] = -1
			EndIf

			If Not $foundHog Then
				$TrainHogDll[0] = -1
				$TrainHogDll[1] = -1
			EndIf

			If Not $foundValkyrie Then
				$TrainValkyrieDll[0] = -1
				$TrainValkyrieDll[1] = -1
			EndIf

			If $DebugMode = 2 Then
				SetLog("Minions: X:" & $TrainMinionDll[0] & " Y:" & $TrainMinionDll[1])
				SetLog("Hogs: X:" & $TrainHogDll[0] & " Y:" & $TrainHogDll[1])
				SetLog("Valkyries: X:" & $TrainValkyrieDll[0] & " Y:" & $TrainValkyrieDll[1])
			EndIf

			Return True
		EndIf
	Else
		SetLog(GetLangText("msgDLLError"), $COLOR_RED)
		$ResX = 0
		$ResY = 0
		Return False ; return 0
	EndIf
EndFunc   ;==>Standard_GetTrainPosDll

Func Standard_TrainItDll($TroopKind, $howMuch = 1, $iSleep = 100)
	$anythingdarkadded = True
	Switch $TroopKind
		Case $eMinion
			$pos = $TrainMinionDll
		Case $eHog
			$pos = $TrainHogDll
		Case $eValkyrie
			$pos = $TrainValkyrieDll
		Case Else
			SetLog(GetLangText("msgDontKnow") & $TroopKind & GetLangText("msgYet"))
			Return
	EndSwitch
	If $pos[0] <> -1 Then
		ClickP($pos, $howMuch, 20)
		If _Sleep($iSleep) Then Return False
		Return True
	EndIf

EndFunc   ;==>Standard_TrainItDll

Func Standard_Train($reset = False)
	resetBarracksError()
	$ichkDarkTroop = False
	If _Sleep(200) Then Return
	If $reset Then ; reset all for cook again on startup
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

	If (($ArmyComp = 0) And (_GUICtrlComboBox_GetCurSel($cmbTroopComp) <> 8)) Or $FixTrain Then
		If $FixTrain Or $FirstStart And Not $reset Then $ArmyComp = $CurCamp
		$FixTrain = False
		Standard_GetDETroopTotals()
		$CurGiant += GUICtrlRead($txtNumGiants)
		$CurWB += GUICtrlRead($txtNumWallbreakers)
		$CurMinion += $totalMinions
		$CurHog += $totalHogs
		$CurValkyrie += $totalValkyries
		$CurArch += Floor((($itxtcampCap * GUICtrlRead($cmbRaidcap) / 100) - (GUICtrlRead($txtNumGiants) * 5) - (GUICtrlRead($txtNumWallbreakers)) * 2 - ($totalMinions * 2) - ($totalHogs * 5) - ($totalValkyries * 8)) * (GUICtrlRead($txtArchers) / 100))
		$CurBarb += Floor((($itxtcampCap * GUICtrlRead($cmbRaidcap) / 100) - (GUICtrlRead($txtNumGiants) * 5) - (GUICtrlRead($txtNumWallbreakers)) * 2 - ($totalMinions * 2) - ($totalHogs * 5) - ($totalValkyries * 8)) * (GUICtrlRead($txtBarbarians) / 100))
		$CurGoblin += Floor((($itxtcampCap * GUICtrlRead($cmbRaidcap) / 100) - (GUICtrlRead($txtNumGiants) * 5) - (GUICtrlRead($txtNumWallbreakers)) * 2 - ($totalMinions * 2) - ($totalHogs * 5) - ($totalValkyries * 8)) * (GUICtrlRead($txtGoblins) / 100))
;~ 		SetLog("CurArch" & $CurArch & "one: " & $itxtcampCap & ":" & GUICtrlRead($cmbRaidcap) & "two :" & (GUICtrlRead($txtNumGiants) * 5) & "three:" & (GUICtrlRead($txtNumWallbreakers) * 2) & "four:" & (GUICtrlRead($txtArchers) / 100))
;~ 		SetLog("CurBarb" & $CurBarb)
;~ 		SetLog("CurGoblin" & $CurGoblin)
		If $CurArch < 0 Then $CurArch = 0
		If $CurBarb < 0 Then $CurBarb = 0
		If $CurGoblin < 0 Then $CurGoblin = 0
		If $CurWB < 0 Then $CurWB = 0
		If $CurGiant < 0 Then $CurGiant = 0
		If $CurMinion < 0 Then $CurMinion = 0
		If $CurHog < 0 Then $CurHog = 0
		If $CurValkyrie < 0 Then $CurValkyrie = 0

		If ($CurArch + $CurBarb + $CurGoblin + (5 * $CurGiant) + (2 * $CurWB) + (2 * $CurMinion) + (5 * $CurHog) + (8 * $CurValkyrie)) < $itxtcampCap Then
			If $CurArch > 0 Then
				$CurArch += 1
			EndIf
			If ($CurArch + $CurBarb + $CurGoblin + (5 * $CurGiant) + (2 * $CurWB) + (2 * $CurMinion) + (5 * $CurHog) + (8 * $CurValkyrie)) < $itxtcampCap Then
				If $CurBarb > 0 Then
					$CurBarb += 1
				EndIf
				If ($CurArch + $CurBarb + $CurGoblin + (5 * $CurGiant) + (2 * $CurWB) + (2 * $CurMinion) + (5 * $CurHog) + (8 * $CurValkyrie)) < $itxtcampCap Then
					If $CurGoblin > 0 Then
						$CurGoblin += 1
					EndIf
				EndIf
			EndIf
		EndIf

		If $stuckCount > 0 Then
			$safety = 0
			While (($CurArch + $CurBarb + $CurGoblin + (5 * $CurGiant) + (2 * $CurWB) + (2 * $CurMinion) + (5 * $CurHog) + (8 * $CurValkyrie)) < $itxtcampCap) And $safety < 20
				$safety += 1
				If $CurArch > 0 Or (GUICtrlRead($txtArchers) > 0) Then
					$CurArch += 1
				EndIf

				If ($CurArch + $CurBarb + $CurGoblin + (5 * $CurGiant) + (2 * $CurWB) + (2 * $CurMinion) + (5 * $CurHog) + (8 * $CurValkyrie)) >= $itxtcampCap Then ExitLoop

				If $CurBarb > 0 Or (GUICtrlRead($txtBarbarians) > 0) Then
					$CurBarb += 1
				EndIf

				If ($CurArch + $CurBarb + $CurGoblin + (5 * $CurGiant) + (2 * $CurWB) + (2 * $CurMinion) + (5 * $CurHog) + (8 * $CurValkyrie)) >= $itxtcampCap Then ExitLoop

				If $CurGoblin > 0 Or (GUICtrlRead($txtGoblins) > 0) Then
					$CurGoblin += 1
				EndIf
			WEnd
		EndIf

		SetLog(GetLangText("msgForcesNeededB") & $CurBarb & GetLangText("msgForcesNeededA") & $CurArch & GetLangText("msgForcesNeededGo") & $CurGoblin & GetLangText("msgForcesNeededGi") & $CurGiant & GetLangText("msgForcesNeededWB") & $CurWB, $COLOR_GREEN)

	ElseIf (($ArmyComp = 0) And (_GUICtrlComboBox_GetCurSel($cmbTroopComp) = 8)) Or $FixTrain Then
		Standard_GetDETroopTotals()
		$CurMinion += $totalMinions
		$CurHog += $totalHogs
		$CurValkyrie += $totalValkyries
		If $CurMinion < 0 Then $CurMinion = 0
		If $CurHog < 0 Then $CurHog = 0
		If $CurValkyrie < 0 Then $CurValkyrie = 0
	EndIf

	Local $GiantEBarrack, $WallEBarrack, $ArchEBarrack, $BarbEBarrack, $GoblinEBarrack
	$GiantEBarrack = Floor($CurGiant / 4)
	$WallEBarrack = Floor($CurWB / 4)
	$ArchEBarrack = Floor($CurArch / 4)
	$BarbEBarrack = Floor($CurBarb / 4)
	$GoblinEBarrack = Floor($CurGoblin / 4)

	Local $troopFirstGiant, $troopSecondGiant, $troopFirstWall, $troopSecondWall, $troopFirstGoblin, $troopSecondGoblin, $troopFirstBarba, $troopSecondBarba, $troopFirstArch, $troopSecondArch
	$troopFirstGiant = 0
	$troopSecondGiant = 0
	$troopFirstWall = 0
	$troopSecondWall = 0
	$troopFirstGoblin = 0
	$troopSecondGoblin = 0
	$troopFirstBarba = 0
	$troopSecondBarba = 0
	$troopFirstArch = 0
	$troopSecondArch = 0

	Local $BarrackControl
	Local $expUIRet[2]
	$stuckcheckneeded = True

	$ichkDarkTroop = Not (($DarkBarrackTroop[0] = 3 And $DarkBarrackTroop[1] = 3 And $DarkBarrackTroopNext[0] = 3 And $DarkBarrackTroopNext[0] = 3) Or (GUICtrlRead($txtDarkBarrack1) + GUICtrlRead($txtDarkBarrack2) + GUICtrlRead($txtDarkBarrack1Next) + GUICtrlRead($txtDarkBarrack2Next) = 0))

	RequestCC()
	If StatusCheck(False) Then Return



	If $reset Then ChkHeroesAvailability()

	If $anythingadded Or $FirstStart Or $reset Then
		SetLog(GetLangText("msgTrainingTroops"), $COLOR_BLUE)

;		$anythingadded = False






		For $i = 0 To 3

			If Not TryToOpenArmyOverview() Then ExitLoop
			If _Sleep($TrainingDelay) Then ExitLoop

;			If Not _ColorCheck(_GetPixelColor(250+60*$i, 553), Hex(0x798799, 6), 30) Then
;				ContinueLoop
;			EndIf

			Click($myBarrackPos[$i][0], $myBarrackPos[$i][1]) ;Click Barrack
			If _Sleep($TrainingDelay) Then ExitLoop
			_CaptureRegion()
			If Not _ColorCheck(_GetPixelColor(235 + $i * 60 , 530), Hex(0xE8E8E0, 6), 20) Then
				SetLog(GetLangText("msgBarrack") & $i + 1 & GetLangText("msgNotAvailable"), $COLOR_RED)
				handleBarracksError($i)
				If _Sleep(100) Then ExitLoop
				ContinueLoop
			EndIf


			If _GUICtrlComboBox_GetCurSel($cmbTroopComp) = 8 Then
				Switch $i
					Case 0
						$BarrackControl = $cmbBarrack1
					Case 1
						$BarrackControl = $cmbBarrack2
					Case 2
						$BarrackControl = $cmbBarrack3
					Case 3
						$BarrackControl = $cmbBarrack4
				EndSwitch
				_CaptureRegion()
				Local $safeguarding = 0
				Switch _GUICtrlComboBox_GetCurSel($BarrackControl)
					Case 0
						While _ColorCheck(_GetPixelColor(216, 325), Hex(0xF09D1C, 6), 30) And ($safeguarding < 200)
							$safeguarding += 1
							$anythingadded = True
							Click(216, 325, 75) ;Barbarian
							If _Sleep(150) Then ExitLoop
							_CaptureRegion()
						WEnd
					Case 1
						While _ColorCheck(_GetPixelColor(330, 323), Hex(0xE84070, 6), 30) And ($safeguarding < 200)
							$safeguarding += 1
							$anythingadded = True
							Click(325, 320, 75) ;Archer
							If _Sleep(150) Then ExitLoop
							_CaptureRegion()
						WEnd
					Case 2
						While _ColorCheck(_GetPixelColor(419, 319), Hex(0xF88409, 6), 30) And ($safeguarding < 200)
							$safeguarding += 1
							$anythingadded = True
							Click(419, 319, 20) ;Giant
							If _Sleep(150) Then ExitLoop
							_CaptureRegion()
						WEnd
					Case 3
						While _ColorCheck(_GetPixelColor(549, 328), Hex(0xFB4C24, 6), 30) And ($safeguarding < 200)
							$safeguarding += 1
							$anythingadded = True
							Click(535, 320, 75) ;Goblin
							If _Sleep(150) Then ExitLoop
							_CaptureRegion()
						WEnd
					Case 4
						While _ColorCheck(_GetPixelColor(685, 327), Hex(0x9E4716, 6), 30) And ($safeguarding < 200)
							$safeguarding += 1
							$anythingadded = True
							Click(641, 341, 20) ;Wall Breaker
							If _Sleep(150) Then ExitLoop
							_CaptureRegion()
						WEnd
					Case 5
						While _ColorCheck(_GetPixelColor(213, 418), Hex(0x861F15, 6), 30) And ($safeguarding < 200)
							$safeguarding += 1
							$anythingadded = True
							Click(213, 418, 20) ;Balloon
							If _Sleep(150) Then ExitLoop
							_CaptureRegion()
						WEnd
					Case 6
						While _ColorCheck(_GetPixelColor(340, 449), Hex(0xF09C85, 6), 30) And ($safeguarding < 200)
							$safeguarding += 1
							$anythingadded = True
							Click(325, 425, 20) ;Wizard
							If _Sleep(150) Then ExitLoop
							_CaptureRegion()
						WEnd
					Case 7
						While _ColorCheck(_GetPixelColor(440, 445), Hex(0xFDD8C0, 6), 30) And ($safeguarding < 200)
							$safeguarding += 1
							$anythingadded = True
							Click(440, 445, 10) ;Healer
							If _Sleep(150) Then ExitLoop
							_CaptureRegion()
						WEnd
					Case 8
						While _ColorCheck(_GetPixelColor(539, 444), Hex(0x302848, 6), 30) And ($safeguarding < 200)
							$safeguarding += 1
							$anythingadded = True
							Click(539, 444, 10) ;Dragon
							If _Sleep(150) Then ExitLoop
							_CaptureRegion()
						WEnd
					Case 9
						While _ColorCheck(_GetPixelColor(647, 440), Hex(0x456180, 6), 30) And ($safeguarding < 200)
							$safeguarding += 1
							$anythingadded = True
							Click(647, 440, 10) ;PEKKA
							If _Sleep(150) Then ExitLoop
							_CaptureRegion()
						WEnd
					Case Else
						If _Sleep(50) Then ExitLoop
						_CaptureRegion()
				EndSwitch
			Else
				SetLog("====== " & GetLangText("msgBarrack") & $i + 1 & " : ======", $COLOR_BLUE)
				_CaptureRegion()
				;while _ColorCheck(_GetPixelColor(496, 200), Hex(0x880000, 6), 20) Then
				If $reset Or $FirstStart Then
					$anythingadded = True
					Click(503, 180, 80, 5)
				EndIf
				;wend


				;Check to see if we are stuck or done with training by trying to locate the "[!] All Camps Full!"
				$checkFull = _PixelSearch(374, 146, 423, 163, Hex(0xE84D50, 6), 5)
				If IsArray($checkFull) Then
					$barracksCampFull = True
					$FirstStart = False
					If _Sleep(100) Then ExitLoop
					Click($TopLeftClient[0], $TopLeftClient[1], 2, 250); Click away twice with 250ms delay
					Return
				EndIf

				If _Sleep(200) Then ExitLoop
				_CaptureRegion()
				If GUICtrlRead($txtNumGiants) <> "0" Then
					$troopFirstGiant = StringStripWS(ReadText(181 + (2 * 107), 298, 35, $textWindows), 3)
					If StringRight($troopFirstGiant, 1) = "x" Then $troopFirstGiant = StringLeft($troopFirstGiant, StringLen($troopFirstGiant) - 1)
				EndIf

				If GUICtrlRead($txtNumWallbreakers) <> "0" Then
					$troopFirstWall = StringStripWS(ReadText(181 + (4 * 107), 298, 35, $textWindows), 3)
					If StringRight($troopFirstWall, 1) = "x" Then $troopFirstWall = StringLeft($troopFirstWall, StringLen($troopFirstWall) - 1)
				EndIf

				If GUICtrlRead($txtGoblins) <> "0" Then
					$troopFirstGoblin = StringStripWS(ReadText(181 + (3 * 107), 298, 35, $textWindows), 3)
					If StringRight($troopFirstGoblin, 1) = "x" Then $troopFirstGoblin = StringLeft($troopFirstGoblin, StringLen($troopFirstGoblin) - 1)
				EndIf

				If GUICtrlRead($txtBarbarians) <> "0" Then
					$troopFirstBarba = StringStripWS(ReadText(181, 298, 35, $textWindows), 3)
					If StringRight($troopFirstBarba, 1) = "x" Then $troopFirstBarba = StringLeft($troopFirstBarba, StringLen($troopFirstBarba) - 1)
				EndIf

				If GUICtrlRead($txtArchers) <> "0" Then
					$troopFirstArch = StringStripWS(ReadText(181 + 107, 298, 35, $textWindows), 3)
					If StringRight($troopFirstArch, 1) = "x" Then $troopFirstArch = StringLeft($troopFirstArch, StringLen($troopFirstArch) - 1)
				EndIf

				If GUICtrlRead($txtArchers) <> "0" And $CurArch > 0 Then
					;If _ColorCheck(_GetPixelColor(261, 366), Hex(0x39D8E0, 6), 20) And $CurArch > 0 Then
					If $CurArch > 0 Then
						If $ArchEBarrack = 0 Then
							Standard_TrainIt($eArcher, 1)
						ElseIf $ArchEBarrack >= $CurArch Then
							Standard_TrainIt($eArcher, $CurArch)
						Else
							Standard_TrainIt($eArcher, $ArchEBarrack)
						EndIf
					EndIf
				EndIf

				If GUICtrlRead($txtNumGiants) <> "0" And $CurGiant > 0 Then
					;If _ColorCheck(_GetPixelColor(475, 366), Hex(0x3DD8E0, 6), 20) And $CurGiant > 0 Then
					If $CurGiant > 0 Then
						If $GiantEBarrack = 0 Then
							Standard_TrainIt($eGiant, 1)
						ElseIf $GiantEBarrack >= $CurGiant Or $GiantEBarrack = 0 Then
							Standard_TrainIt($eGiant, $CurGiant)
						Else
							Standard_TrainIt($eGiant, $GiantEBarrack)
						EndIf
					EndIf
				EndIf

				If GUICtrlRead($txtNumWallbreakers) <> "0" And $CurWB > 0 Then
					;If _ColorCheck(_GetPixelColor(688, 366), Hex(0x3AD8E0, 6), 20) And $CurWB > 0  Then
					If $CurWB > 0 Then
						If $WallEBarrack = 0 Then
							Standard_TrainIt($eWallbreaker, 1)
						ElseIf $WallEBarrack >= $CurWB Or $WallEBarrack = 0 Then
							Standard_TrainIt($eWallbreaker, $CurWB)
						Else
							Standard_TrainIt($eWallbreaker, $WallEBarrack)
						EndIf
					EndIf
				EndIf

				If GUICtrlRead($txtGoblins) <> "0" And $CurGoblin > 0 Then
					;If _ColorCheck(_GetPixelColor(261, 366), Hex(0x39D8E0, 6), 20) And $CurGoblin > 0 Then
					If $CurGoblin > 0 Then
						If $GoblinEBarrack = 0 Then
							Standard_TrainIt($eGoblin, 1)
						ElseIf $GoblinEBarrack >= $CurGoblin Or $GoblinEBarrack = 0 Then
							Standard_TrainIt($eGoblin, $CurGoblin)
						Else
							Standard_TrainIt($eGoblin, $GoblinEBarrack)
						EndIf
					EndIf
				EndIf

				If GUICtrlRead($txtBarbarians) <> "0" And $CurBarb > 0 Then
					;If _ColorCheck(_GetPixelColor(369, 366), Hex(0x39D8E0, 6), 20) And $CurBarb > 0 Then
					If $CurBarb > 0 Then
						If $BarbEBarrack = 0 Then
							Standard_TrainIt($eBarbarian, 1)
						ElseIf $BarbEBarrack >= $CurBarb Or $BarbEBarrack = 0 Then
							Standard_TrainIt($eBarbarian, $CurBarb)
						Else
							Standard_TrainIt($eBarbarian, $BarbEBarrack)
						EndIf
					EndIf
				EndIf

				If GUICtrlRead($txtArchers) <> "0" Then
					$troopSecondArch = StringStripWS(ReadText(181 + 107, 298, 35, $textWindows), 3)
					If StringRight($troopSecondArch, 1) = "x" Then
						$troopSecondArch = StringLeft($troopSecondArch, StringLen($troopSecondArch) - 1)
					Else
						$troopSecondArch = 0
					EndIf
				EndIf

				If GUICtrlRead($txtNumGiants) <> "0" Then
					$troopSecondGiant = StringStripWS(ReadText(181 + (2 * 107), 298, 35, $textWindows), 3)
					If StringRight($troopSecondGiant, 1) = "x" Then
						$troopSecondGiant = StringLeft($troopSecondGiant, StringLen($troopSecondGiant) - 1)
					Else
						$troopSecondGiant = 0
					EndIf
				EndIf

				If GUICtrlRead($txtNumWallbreakers) <> "0" Then
					$troopSecondWall = StringStripWS(ReadText(181 + (4 * 107), 298, 35, $textWindows), 3)
					If StringRight($troopSecondWall, 1) = "x" Then
						$troopSecondWall = StringLeft($troopSecondWall, StringLen($troopSecondWall) - 1)
					Else
						$troopSecondWall = 0
					EndIf
				EndIf

				If GUICtrlRead($txtGoblins) <> "0" Then
					$troopSecondGoblin = StringStripWS(ReadText(181 + (3 * 107), 298, 35, $textWindows), 3)
					If StringRight($troopSecondGoblin, 1) = "x" Then
						$troopSecondGoblin = StringLeft($troopSecondGoblin, StringLen($troopSecondGoblin) - 1)
					Else
						$troopSecondGoblin = 0
					EndIf
				EndIf

				If GUICtrlRead($txtBarbarians) <> "0" Then
					$troopSecondBarba = StringStripWS(ReadText(181, 298, 35, $textWindows), 3)
					If StringRight($troopSecondBarba, 1) = "x" Then
						$troopSecondBarba = StringLeft($troopSecondBarba, StringLen($troopSecondBarba) - 1)
					Else
						$troopSecondBarba = 0
					EndIf
				EndIf

				If GUICtrlRead($txtArchers) <> "0" Then
					$troopSecondArch = StringStripWS(ReadText(181 + 107, 298, 35, $textWindows), 3)
					If StringRight($troopSecondArch, 1) = "x" Then
						$troopSecondArch = StringLeft($troopSecondArch, StringLen($troopSecondArch) - 1)
					Else
						$troopSecondArch = 0
					EndIf
				EndIf

				If $troopSecondGiant > $troopFirstGiant And GUICtrlRead($txtNumGiants) <> "0" Then
					$ArmyComp += ($troopSecondGiant - $troopFirstGiant) * 5
					$CurGiant -= ($troopSecondGiant - $troopFirstGiant)
					SetLog(GetLangText("msgBarrack") & ($i + 1) & GetLangText("msgTraining") & GetLangText("troopNameGiant") & " : " & ($troopSecondGiant - $troopFirstGiant), $COLOR_GREEN)
					SetLog("Giant Remaining : " & $CurGiant, $COLOR_BLUE)
				EndIf


				If $troopSecondWall > $troopFirstWall And GUICtrlRead($txtNumWallbreakers) <> "0" Then
					$ArmyComp += ($troopSecondWall - $troopFirstWall) * 2
					$CurWB -= ($troopSecondWall - $troopFirstWall)
					SetLog(GetLangText("msgBarrack") & ($i + 1) & GetLangText("msgTraining") & GetLangText("troopNameWallBreaker") & " : " & ($troopSecondWall - $troopFirstWall), $COLOR_GREEN)
					SetLog("WallBreaker Remaining : " & $CurWB, $COLOR_BLUE)
				EndIf

				If $troopSecondGoblin > $troopFirstGoblin And GUICtrlRead($txtGoblins) <> "0" Then
					$ArmyComp += ($troopSecondGoblin - $troopFirstGoblin)
					$CurGoblin -= ($troopSecondGoblin - $troopFirstGoblin)
					SetLog(GetLangText("msgBarrack") & ($i + 1) & GetLangText("msgTraining") & GetLangText("troopNameGoblin") & " : " & ($troopSecondGoblin - $troopFirstGoblin), $COLOR_GREEN)
					SetLog("Goblin Remaining : " & $CurGoblin, $COLOR_BLUE)
				EndIf

				If $troopSecondBarba > $troopFirstBarba And GUICtrlRead($txtBarbarians) <> "0" Then
					$ArmyComp += ($troopSecondBarba - $troopFirstBarba)
					$CurBarb -= ($troopSecondBarba - $troopFirstBarba)
					SetLog(GetLangText("msgBarrack") & ($i + 1) & GetLangText("msgTraining") & GetLangText("troopNameBarbarian") & " : " & ($troopSecondBarba - $troopFirstBarba), $COLOR_GREEN)
					SetLog("Barbarian Remaining : " & $CurBarb, $COLOR_BLUE)
				EndIf

				If $troopSecondArch > $troopFirstArch And GUICtrlRead($txtArchers) <> "0" Then
					$ArmyComp += ($troopSecondArch - $troopFirstArch)
					$CurArch -= ($troopSecondArch - $troopFirstArch)
					SetLog(GetLangText("msgBarrack") & ($i + 1) & GetLangText("msgTraining") & GetLangText("troopNameArcher") & " : " & ($troopSecondArch - $troopFirstArch), $COLOR_GREEN)
					SetLog("Archer Remaining : " & $CurArch, $COLOR_BLUE)
				EndIf
				SetLog(GetLangText("msgTotalBuilding") & $ArmyComp, $COLOR_RED)
			EndIf

			If _Sleep(100) Then ExitLoop

		Next

		$ichkDarkTroop = False ; in case
		$ichkDarkTroop = Not (($DarkBarrackTroop[0] = 3 And $DarkBarrackTroop[1] = 3 And $DarkBarrackTroopNext[0] = 3 And $DarkBarrackTroopNext[1] = 3) Or (GUICtrlRead($txtDarkBarrack1) + GUICtrlRead($txtDarkBarrack2) + GUICtrlRead($txtDarkBarrack1Next) + GUICtrlRead($txtDarkBarrack2Next) = 0))

		If $ichkDarkTroop = False Then

			If $NeedsToBrew Then Standard_MakeSpells()
			If Not $reset Then Click($TopLeftClient[0], $TopLeftClient[1], 2, 250); Click away twice with 250ms delay
			$ArmyOverviewIsOpen = False
		EndIf
		; ^^^^^^^ if dark troops are not selected to be trained then we close the window else we go ahead to train dark troops( line 1050 )



		If $brerror[0] = True And $brerror[1] = True And $brerror[2] = True And $brerror[3] = True Then
			resetBarracksError()
			$needzoomout = True
			SetLog(GetLangText("msgRestartComplete"), $COLOR_RED)
		Else
			SetLog(GetLangText("msgTrainingComp"), $COLOR_BLUE)
		EndIf
	Else

		If $DebugMode = 1 Then SetLog(GetLangText("msgStuckCheck"))


		$stuckcheckneeded = True
		; Find a barracks you can open to check if we are stuck
		For $i = 3 To 0 Step -1
			If Not TryToOpenArmyOverview() Then ExitLoop
			If _Sleep($TrainingDelay) Then ExitLoop
			Click($myBarrackPos[$i][0], $myBarrackPos[$i][1]) ;Click Barrack
			If _Sleep($TrainingDelay) Then ExitLoop
			$expUIRet[0] = -1
			$resUI = CallHelper("0 0 860 720 BrokenBotMatchButton 108 1 3")
			If $resUI <> $DLLFailed And $resUI <> $DLLTimeout Then
				If $resUI = $DLLNegative Or $resUI = $DLLError Then
					; Didn't find button
				ElseIf $resUI = $DLLLicense Then
					SetLog(GetLangText("msgLicense"), $COLOR_RED)
				Else
					$expUIRet = StringSplit($resUI, "|", 2)
				EndIf
			Else
				SetLog(GetLangText("msgDLLError"), $COLOR_RED)
			EndIf
			If $expUIRet[0] = -1 Or UBound($expUIRet) < 3 Then
				SetLog(GetLangText("msgBarrack") & $i + 1 & GetLangText("msgNotAvailable"), $COLOR_RED)
				handleBarracksError($i)
				If _Sleep(200) Then ExitLoop
			Else
				Click($expUIRet[1], $expUIRet[2]) ;Click Train Troops button
				_WaitForPixel(720, 150, 740, 170, Hex(0xD80404, 6), 5, 1) ;Finds Red Cross button in new Training popup window
				If _Sleep(500) Then ExitLoop

				_CaptureRegion()
				If _ColorCheck(_GetPixelColor(504, 175), Hex(0xF18082, 6), 20) Then
					$stuckcheckneeded = False
					;Check to see if we are stuck or done with training by trying to locate the "[!] All Camps Full!"
					$checkFull = _PixelSearch(374, 146, 423, 163, Hex(0xE84D50, 6), 5)
					If IsArray($checkFull) Then
						$barracksCampFull = True
						$FirstStart = False
						If _Sleep(100) Then ExitLoop
						Click($TopLeftClient[0], $TopLeftClient[1], 2, 250); Click away twice with 250ms delay
						Return
					EndIf
					ExitLoop
				EndIf
			EndIf
		Next
		If $brerror[0] = True And $brerror[1] = True And $brerror[2] = True And $brerror[3] = True Then
			resetBarracksError()
			$needzoomout = True
			SetLog(GetLangText("msgRestartComplete"), $COLOR_RED)
		Else
			SetLog(GetLangText("msgTrainingComp"), $COLOR_BLUE)
		EndIf
		$ichkDarkTroop = Not (($DarkBarrackTroop[0] = 3 And $DarkBarrackTroop[1] = 3 And $DarkBarrackTroopNext[0] = 3 And $DarkBarrackTroopNext[0] = 3) Or (GUICtrlRead($txtDarkBarrack1) + GUICtrlRead($txtDarkBarrack2) + GUICtrlRead($txtDarkBarrack1Next) + GUICtrlRead($txtDarkBarrack2Next) = 0))

		If $ichkDarkTroop = False then
			If $NeedsToBrew Then Standard_MakeSpells()
			Click($TopLeftClient[0], $TopLeftClient[1], 2, 250); Click away twice with 250ms delay
			$ArmyOverviewIsOpen = False
			Return
		EndIf
	EndIf

;~ 	BEGIN DARK TROOPS

	If $ichkDarkTroop = False Then
		$FirstStart = False
		Click($TopLeftClient[0], $TopLeftClient[1], 2, 250); Click away twice with 250ms delay
		Return
	EndIf
	$DarkBarrackTroop[0] = _GUICtrlComboBox_GetCurSel($cmbDarkBarrack1)
	$DarkBarrackTroop[1] = _GUICtrlComboBox_GetCurSel($cmbDarkBarrack2)

	$DarkBarrackTroopNext[0] = _GUICtrlComboBox_GetCurSel($cmbDarkBarrack1Next)
	$DarkBarrackTroopNext[1] = _GUICtrlComboBox_GetCurSel($cmbDarkBarrack2Next)



	Local $TrainPos[2]

	Global $LeftRax1, $LeftRax2, $TrainDrax1, $TrainDrax2, $ClickRax1, $ClickRax2
	Global $LeftRax1Next, $LeftRax2Next, $TrainDrax1Next, $TrainDrax2Next, $ClickRax1Next, $ClickRax2Next
	Global $FirstDarkTrain, $FirstDarkTrain2, $FirstDarkTrainNext, $FirstDarkTrain2Next

	If $fullarmy Or $FirstStart Then
		$TrainDrax1 = True
		$TrainDrax2 = True
		$TrainDrax1Next = True
		$TrainDrax2Next = True
		$FirstDarkTrain = True
		$FirstDarkTrain2 = True
		$FirstDarkTrainNext = True
		$FirstDarkTrain2Next = True
	EndIf

	If $TrainDrax1 = False And $TrainDrax2 = False And $TrainDrax1Next = False And $TrainDrax2Next = False Then Return

	If $anythingdarkadded Or $FirstStart Or $reset Then
		SetLog(GetLangText("msgTrainingDark"), $COLOR_BLUE)

		If $fullarmy Or $FirstStart Then
			SetLog("Forces Needed: Minions-" & $CurMinion & ", Hogs-" & $CurHog & ", Valks-" & $CurValkyrie, $COLOR_GREEN)
		EndIf
;		$anythingdarkadded = False




		For $i = 0 To 1

			If Not TryToOpenArmyOverview() Then ExitLoop
			If _Sleep($TrainingDelay) Then ExitLoop

			Click($myDarkBarrackPos[$i][0], $myDarkBarrackPos[$i][1]) ;Click Dark Barrack
			If _Sleep($TrainingDelay) Then ExitLoop


			If ($fullArmy Or $FirstStart) And _GUICtrlComboBox_GetCurSel($cmbTroopComp) <> 8 Then ;Reset troops on first loop, or if army is full to start cooking for next attack
				_CaptureRegion()
;				If Not _ColorCheck(_GetPixelColor(502, 179), Hex(0xFFFFFF, 6), 20) Then
				If Not _ColorCheck(_GetPixelColor(502, 179), Hex(0xD1D0C2, 6), 20) Then
					Click(502, 179, 80, 2)
				EndIf
			EndIf

			;Check to see if we are stuck or done with training by trying to locate the "[!] All Camps Full!"
;			$checkFull = _PixelSearch(374, 146, 423, 163, Hex(0xE84D50, 6), 5)
;			If IsArray($checkFull) Then
;				$barracksCampFull = True
;				$FirstStart = False
;				If _Sleep(100) Then ExitLoop
;				Click($TopLeftClient[0], $TopLeftClient[1], 2, 250); Click away twice with 250ms delay
;
;				Return
;			EndIf

			Standard_GetTrainPosDll()

			;Dark Barrack 1
			If GUICtrlRead($txtDarkBarrack1) <> "0" And $i = 0 And $TrainDrax1 = True Then
				$itxtDarkBarrack1 = GUICtrlRead($txtDarkBarrack1)
				If $DarkBarrackTroop[$i] = 0 Then
					$itxtDarkBarrack1 = Floor(($itxtDarkBarrack1 / $totalMinions) * $CurMinion)

					Local $troopMinion = StringStripWS(ReadText(181, 298, 35, $textWindows), 3)
					If StringRight($troopMinion, 1) = "x" Then $troopMinion = StringLeft($troopMinion, StringLen($troopMinion) - 1)
					;SetLog($troopMinion & " Minions training already", $COLOR_BLUE)

					If $itxtDarkBarrack1 <= 20 And ($fullarmy Or $FirstDarkTrain) Then
						Standard_TrainItDll($eMinion, $itxtDarkBarrack1)
						$TrainDrax1 = False
						SetLog("Dark Barrack 1 Train Minion Completed...", $COLOR_BLUE)
						$FirstDarkTrain = False
					ElseIf $itxtDarkBarrack1 > 20 And ($fullarmy Or $FirstDarkTrain) Then
						Standard_TrainItDll($eMinion, 20)
						$LeftRax1 = ($itxtDarkBarrack1 - 20)
						$ClickRax1 = $LeftRax1
						SetLog("Dark Barrack 1 Minion Remaining : " & $LeftRax1, $COLOR_BLUE)
						$FirstDarkTrain = False
					ElseIf $LeftRax1 > 1 And ($troopMinion < 20) And $LeftRax1 > ($troopMinion < 20) Then
						Standard_TrainItDll($eMinion, (20 - $troopMinion))
						$LeftRax1 = ($ClickRax1 - (20 - $troopMinion))
						$ClickRax1 = $LeftRax1
						SetLog("Dark Barrack 1 Minion Remaining : " & $LeftRax1, $COLOR_BLUE)
						$FirstDarkTrain = False
					ElseIf $LeftRax1 > 1 And ($troopMinion < 20) And $LeftRax1 <= ($troopMinion < 20) Then
						Standard_TrainItDll($eMinion, $LeftRax1)
						$TrainDrax1 = False
						SetLog("Dark Barrack 1 Train Minion Completed...", $COLOR_BLUE)
						$FirstDarkTrain = False
					ElseIf $LeftRax1 <= 1 And ($troopMinion < 20) Then
						Standard_TrainItDll($eMinion, $LeftRax1)
						$TrainDrax1 = False
						SetLog("Dark Barrack 1 Train Minion Completed...", $COLOR_BLUE)
						$FirstDarkTrain = False
					Else
						SetLog("Dark Barrack 1 Training in progress, Minion Remaining : " & $LeftRax1, $COLOR_BLUE)
						$FirstDarkTrain = False
					EndIf
				EndIf

				If $DarkBarrackTroop[$i] = 1 Then
					$itxtDarkBarrack1 = Floor(($itxtDarkBarrack1 / $totalHogs) * $CurHog)

					Local $troopHog = StringStripWS(ReadText(181 + 107, 298, 35, $textWindows), 3)
					If StringRight($troopHog, 1) = "x" Then $troopHog = StringLeft($troopHog, StringLen($troopHog) - 1)
					;SetLog($troopHog & " Hogs training already", $COLOR_BLUE)

					If $itxtDarkBarrack1 <= 10 And ($fullarmy Or $FirstDarkTrain) Then
						Standard_TrainItDll($eHog, $itxtDarkBarrack1)
						$TrainDrax1 = False
						SetLog("Dark Barrack 1 Train Hog Completed...", $COLOR_BLUE)
						$FirstDarkTrain = False
					ElseIf $itxtDarkBarrack1 > 10 And ($fullarmy Or $FirstDarkTrain) Then
						Standard_TrainItDll($eHog, 10)
						$LeftRax1 = ($itxtDarkBarrack1 - 10)
						$ClickRax1 = $LeftRax1
						SetLog("Dark Barrack 1 Hog Remaining : " & $LeftRax1, $COLOR_BLUE)
						$FirstDarkTrain = False
					ElseIf $LeftRax1 > 1 And ($troopHog < 10) And $LeftRax1 > ($troopHog < 10) Then
						Standard_TrainItDll($eHog, (10 - $troopHog))
						$LeftRax1 = ($ClickRax1 - (10 - $troopHog))
						$ClickRax1 = $LeftRax1
						SetLog("Dark Barrack 1 Hog Remaining : " & $LeftRax1, $COLOR_BLUE)
						$FirstDarkTrain = False
					ElseIf $LeftRax1 > 1 And ($troopHog < 10) And $LeftRax1 <= ($troopHog < 10) Then
						Standard_TrainItDll($eHog, $LeftRax1)
						$TrainDrax1 = False
						SetLog("Dark Barrack 1 Train Hog Completed...", $COLOR_BLUE)
						$FirstDarkTrain = False
					ElseIf $LeftRax1 <= 1 And ($troopHog < 10) Then
						Standard_TrainItDll($eHog, $LeftRax1)
						$TrainDrax1 = False
						SetLog("Dark Barrack 1 Train Hog Completed...", $COLOR_BLUE)
						$FirstDarkTrain = False
					Else
						SetLog("Dark Barrack 1 Training in progress, Hog Remaining : " & $LeftRax1, $COLOR_BLUE)
						$FirstDarkTrain = False
					EndIf
				EndIf

				If $DarkBarrackTroop[$i] = 2 Then
					$itxtDarkBarrack1 = Floor(($itxtDarkBarrack1 / $totalValkyries) * $CurValkyrie)
					Local $troopValkyrie = StringStripWS(ReadText(181 + 107 * 2, 298, 35, $textWindows), 3)
					If StringRight($troopValkyrie, 1) = "x" Then $troopValkyrie = StringLeft($troopValkyrie, StringLen($troopValkyrie) - 1)
					;SetLog($troopValkyrie & " Valkyries training already", $COLOR_BLUE)

					If $itxtDarkBarrack1 <= 7 And ($fullarmy Or $FirstDarkTrain) Then
						Standard_TrainItDll($eValkyrie, $itxtDarkBarrack1)
						$TrainDrax1 = False
						SetLog("Dark Barrack 1 Train Valkyrie Completed...", $COLOR_BLUE)
						$FirstDarkTrain = False
					ElseIf $itxtDarkBarrack1 > 7 And ($fullarmy Or $FirstDarkTrain) Then
						Standard_TrainItDll($eValkyrie, 7)
						$LeftRax1 = ($itxtDarkBarrack1 - 7)
						$ClickRax1 = $LeftRax1
						SetLog("Dark Barrack 1 Valkyrie Remaining : " & $LeftRax1, $COLOR_BLUE)
						$FirstDarkTrain = False
					ElseIf $LeftRax1 > 1 And ($troopValkyrie < 7) And $LeftRax1 > ($troopValkyrie < 7) Then
						Standard_TrainItDll($eValkyrie, (7 - $troopValkyrie))
						$LeftRax1 = ($ClickRax1 - (7 - $troopValkyrie))
						$ClickRax1 = $LeftRax1
						SetLog("Dark Barrack 1 Valkyrie Remaining : " & $LeftRax1, $COLOR_BLUE)
						$FirstDarkTrain = False
					ElseIf $LeftRax1 > 1 And ($troopValkyrie < 7) And $LeftRax1 <= ($troopValkyrie < 7) Then
						Standard_TrainItDll($eValkyrie, $LeftRax1)
						$TrainDrax1 = False
						SetLog("Dark Barrack 1 Train Valkyrie Completed...", $COLOR_BLUE)
						$FirstDarkTrain = False
					ElseIf $LeftRax1 <= 1 And ($troopValkyrie < 7) Then
						Standard_TrainItDll($eValkyrie, $LeftRax1)
						$TrainDrax1 = False
						SetLog("Dark Barrack 1 Train Valkyrie Completed...", $COLOR_BLUE)
						$FirstDarkTrain = False
					Else
						SetLog("Dark Barrack 1 Training in progress, Valkyrie Remaining : " & $LeftRax1, $COLOR_BLUE)
						$FirstDarkTrain = False
					EndIf
				EndIf
			EndIf

			;Second Troop type
			If GUICtrlRead($txtDarkBarrack1Next) <> "0" And $i = 0 And $TrainDrax1Next = True Then
				$itxtDarkBarrack1Next = GUICtrlRead($txtDarkBarrack1Next)
				If $DarkBarrackTroopNext[$i] = 0 Then
					$itxtDarkBarrack1Next = Floor(($itxtDarkBarrack1Next / $totalMinions) * $CurMinion)
					Local $troopMinion = StringStripWS(ReadText(181, 298, 35, $textWindows), 3)
					If StringRight($troopMinion, 1) = "x" Then $troopMinion = StringLeft($troopMinion, StringLen($troopMinion) - 1)
					;SetLog($troopMinion & " Minions training already", $COLOR_BLUE)

					If $itxtDarkBarrack1Next <= 20 And ($fullarmy Or $FirstDarkTrainNext) Then
						Standard_TrainItDll($eMinion, $itxtDarkBarrack1Next)
						$TrainDrax1Next = False
						SetLog("Dark Barrack 1 Train Minion Completed...", $COLOR_BLUE)
						$FirstDarkTrainNext = False
					ElseIf $itxtDarkBarrack1Next > 20 And ($fullarmy Or $FirstDarkTrainNext) Then
						Standard_TrainItDll($eMinion, 20)
						$LeftRax1Next = ($itxtDarkBarrack1Next - 20)
						$ClickRax1Next = $LeftRax1Next
						SetLog("Dark Barrack 1 Minion Remaining : " & $LeftRax1Next, $COLOR_BLUE)
						$FirstDarkTrainNext = False
					ElseIf $LeftRax1Next > 1 And ($troopMinion < 20) And $LeftRax1Next > ($troopMinion < 20) Then
						Standard_TrainItDll($eMinion, (20 - $troopMinion))
						$LeftRax1Next = ($ClickRax1Next - (20 - $troopMinion))
						$ClickRax1Next = $LeftRax1Next
						SetLog("Dark Barrack 1 Minion Remaining : " & $LeftRax1Next, $COLOR_BLUE)
						$FirstDarkTrainNext = False
					ElseIf $LeftRax1Next > 1 And ($troopMinion < 20) And $LeftRax1Next <= ($troopMinion < 20) Then
						Standard_TrainItDll($eMinion, $LeftRax1Next)
						$TrainDrax1Next = False
						SetLog("Dark Barrack 1 Train Minion Completed...", $COLOR_BLUE)
						$FirstDarkTrainNext = False
					ElseIf $LeftRax1Next <= 1 And ($troopMinion < 20) Then
						Standard_TrainItDll($eMinion, $LeftRax1Next)
						$TrainDrax1Next = False
						SetLog("Dark Barrack 1 Train Minion Completed...", $COLOR_BLUE)
						$FirstDarkTrainNext = False
					Else
						SetLog("Dark Barrack 1 Training in progress, Minion Remaining : " & $LeftRax1Next, $COLOR_BLUE)
						$FirstDarkTrainNext = False
					EndIf
				EndIf

				If $DarkBarrackTroopNext[$i] = 1 Then
					$itxtDarkBarrack1Next = Floor(($itxtDarkBarrack1Next / $totalHogs) * $CurHog)
					Local $troopHog = StringStripWS(ReadText(181 + 107, 298, 35, $textWindows), 3)
					If StringRight($troopHog, 1) = "x" Then $troopHog = StringLeft($troopHog, StringLen($troopHog) - 1)
					;SetLog($troopHog & " Hogs training already", $COLOR_BLUE)

					If $itxtDarkBarrack1Next <= 10 And ($fullarmy Or $FirstDarkTrainNext) Then
						Standard_TrainItDll($eHog, $itxtDarkBarrack1Next)
						$TrainDrax1Next = False
						SetLog("Dark Barrack 1 Train Hog Completed...", $COLOR_BLUE)
						$FirstDarkTrainNext = False
					ElseIf $itxtDarkBarrack1Next > 10 And ($fullarmy Or $FirstDarkTrainNext) Then
						Standard_TrainItDll($eHog, 10)
						$LeftRax1Next = ($itxtDarkBarrack1Next - 10)
						$ClickRax1Next = $LeftRax1Next
						SetLog("Dark Barrack 1 Hog Remaining : " & $LeftRax1Next, $COLOR_BLUE)
						$FirstDarkTrainNext = False
					ElseIf $LeftRax1Next > 1 And ($troopHog < 10) And $LeftRax1Next > ($troopHog < 10) Then
						Standard_TrainItDll($eHog, (10 - $troopHog))
						$LeftRax1Next = ($ClickRax1Next - (10 - $troopHog))
						$ClickRax1Next = $LeftRax1Next
						SetLog("Dark Barrack 1 Hog Remaining : " & $LeftRax1Next, $COLOR_BLUE)
						$FirstDarkTrainNext = False
					ElseIf $LeftRax1Next > 1 And ($troopHog < 10) And $LeftRax1Next <= ($troopHog < 10) Then
						Standard_TrainItDll($eHog, $LeftRax1Next)
						$TrainDrax1Next = False
						SetLog("Dark Barrack 1 Train Hog Completed...", $COLOR_BLUE)
						$FirstDarkTrainNext = False
					ElseIf $LeftRax1Next <= 1 And ($troopHog < 10) Then
						Standard_TrainItDll($eHog, $LeftRax1Next)
						$TrainDrax1Next = False
						SetLog("Dark Barrack 1 Train Hog Completed...", $COLOR_BLUE)
						$FirstDarkTrainNext = False
					Else
						SetLog("Dark Barrack 1 Training in progress, Hog Remaining : " & $LeftRax1Next, $COLOR_BLUE)
						$FirstDarkTrainNext = False
					EndIf
				EndIf

				If $DarkBarrackTroopNext[$i] = 2 Then
					$itxtDarkBarrack1Next = Floor(($itxtDarkBarrack1Next / $totalValkyries) * $CurValkyrie)
					Local $troopValkyrie = StringStripWS(ReadText(181 + 107 * 2, 298, 35, $textWindows), 3)
					If StringRight($troopValkyrie, 1) = "x" Then $troopValkyrie = StringLeft($troopValkyrie, StringLen($troopValkyrie) - 1)
					;SetLog($troopValkyrie & " Valkyries training already", $COLOR_BLUE)

					If $itxtDarkBarrack1Next <= 7 And ($fullarmy Or $FirstDarkTrainNext) Then
						Standard_TrainItDll($eValkyrie, $itxtDarkBarrack1Next)
						$TrainDrax1Next = False
						SetLog("Dark Barrack 1 Train Valkyrie Completed...", $COLOR_BLUE)
						$FirstDarkTrainNext = False
					ElseIf $itxtDarkBarrack1Next > 7 And ($fullarmy Or $FirstDarkTrainNext) Then
						Standard_TrainItDll($eValkyrie, 7)
						$LeftRax1Next = ($itxtDarkBarrack1Next - 7)
						$ClickRax1Next = $LeftRax1Next
						SetLog("Dark Barrack 1 Valkyrie Remaining : " & $LeftRax1Next, $COLOR_BLUE)
						$FirstDarkTrainNext = False
					ElseIf $LeftRax1Next > 1 And ($troopValkyrie < 7) And $LeftRax1Next > ($troopValkyrie < 7) Then
						Standard_TrainItDll($eValkyrie, (7 - $troopValkyrie))
						$LeftRax1Next = ($ClickRax1Next - (7 - $troopValkyrie))
						$ClickRax1Next = $LeftRax1Next
						SetLog("Dark Barrack 1 Valkyrie Remaining : " & $LeftRax1Next, $COLOR_BLUE)
						$FirstDarkTrainNext = False
					ElseIf $LeftRax1Next > 1 And ($troopValkyrie < 7) And $LeftRax1Next <= ($troopValkyrie < 7) Then
						Standard_TrainItDll($eValkyrie, $LeftRax1Next)
						$TrainDrax1Next = False
						SetLog("Dark Barrack 1 Train Valkyrie Completed...", $COLOR_BLUE)
						$FirstDarkTrainNext = False
					ElseIf $LeftRax1Next <= 1 And ($troopValkyrie < 7) Then
						Standard_TrainItDll($eValkyrie, $LeftRax1Next)
						$TrainDrax1Next = False
						SetLog("Dark Barrack 1 Train Valkyrie Completed...", $COLOR_BLUE)
						$FirstDarkTrainNext = False
					Else
						SetLog("Dark Barrack 1 Training in progress, Valkyrie Remaining : " & $LeftRax1Next, $COLOR_BLUE)
						$FirstDarkTrainNext = False
					EndIf
				EndIf
			EndIf

			;Dark Barrack 2
			If GUICtrlRead($txtDarkBarrack2) <> "0" And $i = 1 And $TrainDrax2 = True Then
				$itxtDarkBarrack2 = GUICtrlRead($txtDarkBarrack2)
				If $DarkBarrackTroop[$i] = 0 Then
					$itxtDarkBarrack2 = Ceiling(($itxtDarkBarrack2 / $totalMinions) * $CurMinion)
					Local $troopMinion2 = StringStripWS(ReadText(181, 298, 35, $textWindows), 3)
					If StringRight($troopMinion2, 1) = "x" Then $troopMinion2 = StringLeft($troopMinion2, StringLen($troopMinion2) - 1)
					;SetLog($troopMinion2 & " Minions training already", $COLOR_BLUE)

					If $itxtDarkBarrack2 <= 20 And ($fullarmy Or $FirstDarkTrain2) Then
						Standard_TrainItDll($eMinion, $itxtDarkBarrack2)
						$TrainDrax2 = False
						SetLog("Dark Barrack 2 Train Minion Completed...", $COLOR_BLUE)
						$FirstDarkTrain2 = False
					ElseIf $itxtDarkBarrack2 > 20 And ($fullarmy Or $FirstDarkTrain2) Then
						Standard_TrainItDll($eMinion, 20)
						$LeftRax2 = ($itxtDarkBarrack2 - 20)
						$ClickRax2 = $LeftRax2
						SetLog("Dark Barrack 2 Minion Remaining : " & $LeftRax2, $COLOR_BLUE)
						$FirstDarkTrain2 = False
					ElseIf $LeftRax2 > 1 And ($troopMinion2 < 20) And $LeftRax2 > ($troopMinion2 < 20) Then
						Standard_TrainItDll($eMinion, (20 - $troopMinion2))
						$LeftRax2 = ($ClickRax2 - (20 - $troopMinion2))
						$ClickRax2 = $LeftRax2
						SetLog("Dark Barrack 2 Minion Remaining : " & $LeftRax2, $COLOR_BLUE)
						$FirstDarkTrain2 = False
					ElseIf $LeftRax2 > 1 And ($troopMinion2 < 20) And $LeftRax2 <= ($troopMinion2 < 20) Then
						Standard_TrainItDll($eMinion, $LeftRax2)
						$TrainDrax2 = False
						SetLog("Dark Barrack 2 Train Minion Completed...", $COLOR_BLUE)
						$FirstDarkTrain2 = False
					ElseIf $LeftRax2 <= 1 And ($troopMinion2 < 20) Then
						Standard_TrainItDll($eMinion, $LeftRax2)
						$TrainDrax2 = False
						SetLog("Dark Barrack 2 Train Minion Completed...", $COLOR_BLUE)
						$FirstDarkTrain2 = False
					Else
						SetLog("Dark Barrack 2 Training in progress, Minion Remaining : " & $LeftRax2, $COLOR_BLUE)
						$FirstDarkTrain2 = False
					EndIf
				EndIf

				If $DarkBarrackTroop[$i] = 1 Then
					$itxtDarkBarrack2 = Ceiling(($itxtDarkBarrack2 / $totalHogs) * $CurHog)
					Local $troopHog2 = StringStripWS(ReadText(181 + 107, 298, 35, $textWindows), 3)
					If StringRight($troopHog2, 1) = "x" Then $troopHog2 = StringLeft($troopHog2, StringLen($troopHog2) - 1)
					;SetLog($troopHog2 & " Hogs training already", $COLOR_BLUE)


					If $itxtDarkBarrack2 <= 10 And ($fullarmy Or $FirstDarkTrain2) Then
						Standard_TrainItDll($eHog, $itxtDarkBarrack2)
						$TrainDrax2 = False
						SetLog("Dark Barrack 2 Train Hog Completed...", $COLOR_BLUE)
						$FirstDarkTrain2 = False
					ElseIf $itxtDarkBarrack2 > 10 And ($fullarmy Or $FirstDarkTrain2) Then
						Standard_TrainItDll($eHog, 10)
						$LeftRax2 = ($itxtDarkBarrack2 - 10)
						$ClickRax2 = $LeftRax2
						SetLog("Dark Barrack 2 Hog Remaining : " & $LeftRax2, $COLOR_BLUE)
						$FirstDarkTrain2 = False
					ElseIf $LeftRax2 > 1 And ($troopHog2 < 10) And $LeftRax2 > ($troopHog2 < 10) Then
						Standard_TrainItDll($eHog, (10 - $troopHog2))
						$LeftRax2 = ($ClickRax2 - (10 - $troopHog2))
						$ClickRax2 = $LeftRax2
						SetLog("Dark Barrack 2 Hog Remaining : " & $LeftRax2, $COLOR_BLUE)
						$FirstDarkTrain2 = False
					ElseIf $LeftRax2 > 1 And ($troopHog2 < 10) And $LeftRax2 <= ($troopHog2 < 10) Then
						Standard_TrainItDll($eHog, $LeftRax2)
						$TrainDrax2 = False
						SetLog("Dark Barrack 2 Train Hog Completed...", $COLOR_BLUE)
						$FirstDarkTrain2 = False
					ElseIf $LeftRax2 <= 1 And ($troopHog2 < 10) Then
						Standard_TrainItDll($eHog, $LeftRax2)
						$TrainDrax2 = False
						SetLog("Dark Barrack 2 Train Hog Completed...", $COLOR_BLUE)
						$FirstDarkTrain2 = False
					Else
						SetLog("Dark Barrack 2 Training in progress, Hog Remaining : " & $LeftRax2, $COLOR_BLUE)
						$FirstDarkTrain2 = False
					EndIf
				EndIf

				If $DarkBarrackTroop[$i] = 2 Then
					$itxtDarkBarrack2 = Ceiling(($itxtDarkBarrack2 / $totalValkyries) * $CurValkyrie)
					Local $troopValkyrie2 = StringStripWS(ReadText(181 + 107 * 2, 298, 35, $textWindows), 3)
					If StringRight($troopValkyrie2, 1) = "x" Then $troopValkyrie2 = StringLeft($troopValkyrie2, StringLen($troopValkyrie2) - 1)
					;SetLog($troopValkyrie2 & " Valkyries training already", $COLOR_BLUE)

					If $itxtDarkBarrack2 <= 7 And ($fullarmy Or $FirstDarkTrain2) Then
						Standard_TrainItDll($eValkyrie, $itxtDarkBarrack2)
						$TrainDrax2 = False
						SetLog("Dark Barrack 2 Train Valkyrie Completed...", $COLOR_BLUE)
						$FirstDarkTrain2 = False
					ElseIf $itxtDarkBarrack2 > 7 And ($fullarmy Or $FirstDarkTrain2) Then
						Standard_TrainItDll($eValkyrie, 7)
						$LeftRax2 = ($itxtDarkBarrack2 - 7)
						$ClickRax2 = $LeftRax2
						SetLog("Dark Barrack 2 Valkyrie Remaining : " & $LeftRax2, $COLOR_BLUE)
						$FirstDarkTrain2 = False
					ElseIf $LeftRax2 > 1 And ($troopValkyrie2 < 7) And $LeftRax2 > ($troopValkyrie2 < 7) Then
						Standard_TrainItDll($eValkyrie, (7 - $troopValkyrie2))
						$LeftRax2 = ($ClickRax2 - (7 - $troopValkyrie2))
						$ClickRax2 = $LeftRax2
						SetLog("Dark Barrack 2 Valkyrie Remaining : " & $LeftRax2, $COLOR_BLUE)
						$FirstDarkTrain2 = False
					ElseIf $LeftRax2 > 1 And ($troopValkyrie2 < 7) And $LeftRax2 <= ($troopValkyrie2 < 7) Then
						Standard_TrainItDll($eValkyrie, $LeftRax2)
						$TrainDrax2 = False
						SetLog("Dark Barrack 2 Train Valkyrie Completed...", $COLOR_BLUE)
						$FirstDarkTrain2 = False
					ElseIf $LeftRax2 <= 1 And ($troopValkyrie2 < 7) Then
						Standard_TrainItDll($eValkyrie, $LeftRax2)
						$TrainDrax2 = False
						SetLog("Dark Barrack 2 Train Valkyrie Completed...", $COLOR_BLUE)
						$FirstDarkTrain2 = False
					Else
						SetLog("Dark Barrack 2 Training in progress, Valkyrie Remaining : " & $LeftRax2, $COLOR_BLUE)
						$FirstDarkTrain2 = False
					EndIf
				EndIf
			EndIf

			;Second Troop type
			If GUICtrlRead($txtDarkBarrack2Next) <> "0" And $i = 1 And $TrainDrax2Next = True Then
				$itxtDarkBarrack2Next = GUICtrlRead($txtDarkBarrack2Next)
				If $DarkBarrackTroopNext[$i] = 0 Then
					$itxtDarkBarrack2Next = Ceiling(($itxtDarkBarrack2Next / $totalMinions) * $CurMinion)
					Local $troopMinion2 = StringStripWS(ReadText(181, 298, 35, $textWindows), 3)
					If StringRight($troopMinion2, 1) = "x" Then $troopMinion2 = StringLeft($troopMinion2, StringLen($troopMinion2) - 1)
					;SetLog($troopMinion2 & " Minions training already", $COLOR_BLUE)

					If $itxtDarkBarrack2Next <= 20 And ($fullarmy Or $FirstDarkTrain2Next) Then
						Standard_TrainItDll($eMinion, $itxtDarkBarrack2Next)
						$TrainDrax2Next = False
						SetLog("Dark Barrack 2 Train Minion Completed...", $COLOR_BLUE)
						$FirstDarkTrain2Next = False
					ElseIf $itxtDarkBarrack2Next > 20 And ($fullarmy Or $FirstDarkTrain2Next) Then
						Standard_TrainItDll($eMinion, 20)
						$LeftRax2Next = ($itxtDarkBarrack2Next - 20)
						$ClickRax2Next = $LeftRax2Next
						SetLog("Dark Barrack 2 Minion Remaining : " & $LeftRax2Next, $COLOR_BLUE)
						$FirstDarkTrain2Next = False
					ElseIf $LeftRax2Next > 1 And ($troopMinion2 < 20) And $LeftRax2Next > ($troopMinion2 < 20) Then
						Standard_TrainItDll($eMinion, (20 - $troopMinion2))
						$LeftRax2Next = ($ClickRax2Next - (20 - $troopMinion2))
						$ClickRax2Next = $LeftRax2Next
						SetLog("Dark Barrack 2 Minion Remaining : " & $LeftRax2Next, $COLOR_BLUE)
						$FirstDarkTrain2Next = False
					ElseIf $LeftRax2Next > 1 And ($troopMinion2 < 20) And $LeftRax2Next <= ($troopMinion2 < 20) Then
						Standard_TrainItDll($eMinion, $LeftRax2Next)
						$TrainDrax2Next = False
						SetLog("Dark Barrack 2 Train Minion Completed...", $COLOR_BLUE)
						$FirstDarkTrain2Next = False
					ElseIf $LeftRax2Next <= 1 And ($troopMinion2 < 20) Then
						Standard_TrainItDll($eMinion, $LeftRax2Next)
						$TrainDrax2Next = False
						SetLog("Dark Barrack 2 Train Minion Completed...", $COLOR_BLUE)
						$FirstDarkTrain2Next = False
					Else
						SetLog("Dark Barrack 2 Training in progress, Minion Remaining : " & $LeftRax2Next, $COLOR_BLUE)
						$FirstDarkTrain2Next = False
					EndIf
				EndIf

				If $DarkBarrackTroopNext[$i] = 1 Then
					$itxtDarkBarrack2Next = Ceiling(($itxtDarkBarrack2Next / $totalHogs) * $CurHog)
					Local $troopHog2 = StringStripWS(ReadText(181 + 107, 298, 35, $textWindows), 3)
					If StringRight($troopHog2, 1) = "x" Then $troopHog2 = StringLeft($troopHog2, StringLen($troopHog2) - 1)
					;SetLog($troopHog2 & " Hogs training already", $COLOR_BLUE)

					If $itxtDarkBarrack2Next <= 10 And ($fullarmy Or $FirstDarkTrain2Next) Then
						Standard_TrainItDll($eHog, $itxtDarkBarrack2Next)
						$TrainDrax2Next = False
						SetLog("Dark Barrack 2 Train Hog Completed...", $COLOR_BLUE)
						$FirstDarkTrain2Next = False
					ElseIf $itxtDarkBarrack2Next > 10 And ($fullarmy Or $FirstDarkTrain2Next) Then
						Standard_TrainItDll($eHog, 10)
						$LeftRax2Next = ($itxtDarkBarrack2Next - 10)
						$ClickRax2Next = $LeftRax2Next
						SetLog("Dark Barrack 2 Hog Remaining : " & $LeftRax2Next, $COLOR_BLUE)
						$FirstDarkTrain2Next = False
					ElseIf $LeftRax2Next > 1 And ($troopHog2 < 10) And $LeftRax2Next > ($troopHog2 < 10) Then
						Standard_TrainItDll($eHog, (10 - $troopHog2))
						$LeftRax2Next = ($ClickRax2Next - (10 - $troopHog2))
						$ClickRax2Next = $LeftRax2Next
						SetLog("Dark Barrack 2 Hog Remaining : " & $LeftRax2Next, $COLOR_BLUE)
						$FirstDarkTrain2Next = False
					ElseIf $LeftRax2Next > 1 And ($troopHog2 < 10) And $LeftRax2Next <= ($troopHog2 < 10) Then
						Standard_TrainItDll($eHog, $LeftRax2Next)
						$TrainDrax2Next = False
						SetLog("Dark Barrack 2 Train Hog Completed...", $COLOR_BLUE)
						$FirstDarkTrain2Next = False
					ElseIf $LeftRax2Next <= 1 And ($troopHog2 < 10) Then
						Standard_TrainItDll($eHog, $LeftRax2Next)
						$TrainDrax2Next = False
						SetLog("Dark Barrack 2 Train Hog Completed...", $COLOR_BLUE)
						$FirstDarkTrain2Next = False
					Else
						SetLog("Dark Barrack 2 Training in progress, Hog Remaining : " & $LeftRax2Next, $COLOR_BLUE)
						$FirstDarkTrain2Next = False
					EndIf
				EndIf

				If $DarkBarrackTroopNext[$i] = 2 Then
					$itxtDarkBarrack2Next = Ceiling(($itxtDarkBarrack2Next / $totalValkyries) * $CurValkyrie)
					Local $troopValkyrie2 = StringStripWS(ReadText(181 + 107 * 2, 298, 35, $textWindows), 3)
					If StringRight($troopValkyrie2, 1) = "x" Then $troopValkyrie2 = StringLeft($troopValkyrie2, StringLen($troopValkyrie2) - 1)
					;SetLog($troopValkyrie2 & " Valkyries training already", $COLOR_BLUE)

					If $itxtDarkBarrack2Next <= 7 And ($fullarmy Or $FirstDarkTrain2Next) Then
						Standard_TrainItDll($eValkyrie, $itxtDarkBarrack2Next)
						$TrainDrax2Next = False
						SetLog("Dark Barrack 2 Train Valkyrie Completed...", $COLOR_BLUE)
						$FirstDarkTrain2Next = False
					ElseIf $itxtDarkBarrack2Next > 7 And ($fullarmy Or $FirstDarkTrain2Next) Then
						Standard_TrainItDll($eValkyrie, 7)
						$LeftRax2Next = ($itxtDarkBarrack2Next - 7)
						$ClickRax2Next = $LeftRax2Next
						SetLog("Dark Barrack 2 Valkyrie Remaining : " & $LeftRax2Next, $COLOR_BLUE)
						$FirstDarkTrain2Next = False
					ElseIf $LeftRax2Next > 1 And ($troopValkyrie2 < 7) And $LeftRax2Next > ($troopValkyrie2 < 7) Then
						Standard_TrainItDll($eValkyrie, (7 - $troopValkyrie2))
						$LeftRax2Next = ($ClickRax2Next - (7 - $troopValkyrie2))
						$ClickRax2Next = $LeftRax2Next
						SetLog("Dark Barrack 2 Valkyrie Remaining : " & $LeftRax2Next, $COLOR_BLUE)
						$FirstDarkTrain2Next = False
					ElseIf $LeftRax2Next > 1 And ($troopValkyrie2 < 7) And $LeftRax2Next <= ($troopValkyrie2 < 7) Then
						Standard_TrainItDll($eValkyrie, $LeftRax2Next)
						$TrainDrax2Next = False
						SetLog("Dark Barrack 2 Train Valkyrie Completed...", $COLOR_BLUE)
						$FirstDarkTrain2Next = False
					ElseIf $LeftRax2Next <= 1 And ($troopValkyrie2 < 7) Then
						Standard_TrainItDll($eValkyrie, $LeftRax2Next)
						$TrainDrax2Next = False
						SetLog("Dark Barrack 2 Train Valkyrie Completed...", $COLOR_BLUE)
						$FirstDarkTrain2Next = False
					Else
						SetLog("Dark Barrack 2 Training in progress, Valkyrie Remaining : " & $LeftRax2Next, $COLOR_BLUE)
						$FirstDarkTrain2Next = False
					EndIf
				EndIf
			EndIf

			If _Sleep(100) Then ExitLoop

		Next
		SetLog(GetLangText("msgDarkTroopComplete"), $COLOR_BLUE)

		If IsChecked($chkMakeSpells) = False Then
			Click($TopLeftClient[0], $TopLeftClient[1], 2, 250); Click away twice with 250ms delay
			If _Sleep(200) Then Return
			Return
		EndIf
	Else
		If $stuckcheckneeded Then
			; Find a barracks you can open to check if we are stuck
			For $i = 1 To 0 Step -1
				If Not TryToOpenArmyOverview() Then ExitLoop
				If _Sleep($TrainingDelay) Then ExitLoop
				Click($myDarkBarrackPos[$i][0], $myDarkBarrackPos[$i][1]) ;Click Dark Barrack
				If _Sleep($TrainingDelay) Then ExitLoop
				$expUIRet[0] = -1
				$resUI = CallHelper("0 0 860 720 BrokenBotMatchButton 108 1 3")
				If $resUI <> $DLLFailed And $resUI <> $DLLTimeout Then
					If $resUI = $DLLNegative Or $resUI = $DLLError Then
						; Didn't find button
					ElseIf $resUI = $DLLLicense Then
						SetLog(GetLangText("msgLicense"), $COLOR_RED)
					Else
						$expUIRet = StringSplit($resUI, "|", 2)
					EndIf
				Else
					SetLog(GetLangText("msgDLLError"), $COLOR_RED)
				EndIf
				If $expUIRet[0] = -1 Or UBound($expUIRet) < 3 Then
					SetLog(GetLangText("msgBarrack") & $i + 1 & GetLangText("msgNotAvailable"), $COLOR_RED)
					handleBarracksError($i)
					If _Sleep(500) Then ExitLoop
				Else
					Click($expUIRet[1], $expUIRet[2]) ;Click Train Troops button
					_WaitForPixel(720, 150, 740, 170, Hex(0xD80404, 6), 5, 1) ;Finds Red Cross button in new Training popup window
					If _Sleep(500) Then ExitLoop

					_CaptureRegion()
					If _ColorCheck(_GetPixelColor(504, 175), Hex(0xF18082, 6), 20) Then
						;Check to see if we are stuck or done with training by trying to locate the "[!] All Camps Full!"
						$checkFull = _PixelSearch(374, 146, 423, 163, Hex(0xE84D50, 6), 5)
						If IsArray($checkFull) Then
							$barracksCampFull = True
							$FirstStart = False
							If _Sleep(100) Then ExitLoop
							If $NeedsToBrew Then Standard_MakeSpells()
							Click($TopLeftClient[0], $TopLeftClient[1], 2, 250); Click away twice with 250ms delay

							Return
						EndIf

						ExitLoop
					EndIf

				EndIf
			Next
		EndIf
	EndIf
	$FirstDarkTrain = False
	$FirstDarkTrain2 = False
	$FirstDarkTrainNext = False
	$FirstDarkTrain2Next = False
	$FirstStart = False
;~ 	END DARK TROOPS

	If $NeedsToBrew Then Standard_MakeSpells()
	If _Sleep(200) Then Return
	Click($TopLeftClient[0], $TopLeftClient[1], 2, 250); Click away twice with 250ms delay

EndFunc   ;==>Standard_Train

Func Standard_MakeSpells()

	If _Sleep(100) Then Return


	If $SpellsChanged Then ;if there is a change

		If Not TryToOpenArmyOverview() Then Return


		If _Sleep($TrainingDelay) Then Return

		Click($mySpellFactoryPos[0][0], $mySpellFactoryPos[0][1])

		If _Sleep($TrainingDelay) Then Return


		$SpellCount = (Number($itxtspellcap) * 2 - Number($CurSpells)) / 2
		$SpellCount = Number($itxtspellcap) ; this happens when bot run first time



		If $FirstStart Then
			$SpellCount = Number($itxtspellcap) ; this happens when bot run first time
		EndIf

		SetLog(GetLangText("msgMakingSpell") & GUICtrlRead($cmbSpellCreate) & " x " & $SpellCount, $COLOR_BLUE)

		Click(220 + _GUICtrlComboBox_GetCurSel($cmbSpellCreate) * 106, 320, $SpellCount)
		If _Sleep(500) Then Return
		$spellsstarted = True
		$NeedsToBrew = False
		$SpellsChanged = False

	Else
		If $DebugMode = 1 Then SetLog("SpellsChanged: " & $SpellsChanged)
		SetLog("No change detected. Skipping Spell making", $COLOR_RED)
	EndIf



;	Click($TopLeftClient[0], $TopLeftClient[1], 2, 250); Click away twice with 250ms delay
EndFunc   ;==>Standard_MakeSpells
