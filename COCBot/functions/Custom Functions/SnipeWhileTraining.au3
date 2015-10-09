;Global $SnipeTraining = True
Global $CurWBinCamp = 0
Global $CurGiantinCamp = 0
Global $CurArchinCamp = 0
Global $CurBarbinCamp = 0
Global $CurGoblininCamp = 0
Global $CurMinioninCamp = 0
Global $CurValkyrieinCamp = 0
Global $CurHoginCamp=0
;Local $SSearchCount=0




Func SnipeWhileTraining()

	Local $AttackType ;snipe method
	Local $SSReady = Prepare_SnipeSearch()
;	$SSearchCount=0

	If $SSReady = True Then
		$ssTrainingTime = GetRemainingTrainTime()
SetLog("Approximate time to full army: " & Floor(Floor($ssTrainingTime / 60) / 60) & GetLangText("msgTimeIdleHours") & Floor(Mod(Floor($ssTrainingTime / 60), 60)) & GetLangText("msgTimeIdleMin") & Floor(Mod($ssTrainingTime, 60)) & GetLangText("msgTimeIdleSec"), $COLOR_ORANGE)

		If $ssTrainingTime < 1.5 * 60 Then
			SetLog("Army is about to be full.", $COLOR_RED)
			Return  False
		EndIf


		SetLog(" Going to snipe ", $COLOR_GREEN)

		If PrepareSearch() = False Then Return False
		If $GoldBeforeSearch=0 Then $GoldBeforeSearch=$GoldCount

		$AttackType = Snipe_Search($ssTrainingTime)
		If $AttackType = 3 Then
			Standard_PrepareAttack(False, $AttackType)
			If BotStopped(False) Then Return False

			SetLog(GetLangText("msgBeginAttack"))
			Standard_Attack($AttackType)
			If BotStopped(False) Then Return  False

			ReturnHome($TakeLootSnapShot)
			If StatusCheck(False) Then Return True
			Return True
		EndIf
	EndIf
EndFunc   ;==>SnipeWhileTraining



Func Prepare_SnipeSearch()
	SetLog("Preparing Snipe search while training", $COLOR_BLUE)
	$CurWBinCamp = 0
	$CurGiantinCamp = 0
	$CurArchinCamp = 0
	$CurBarbinCamp = 0
	$CurMinioninCamp = 0
	$CurValkyrieinCamp = 0
	Standard_CheckArmyCamp(True)

	If $fullarmy Then 
		Click($TopLeftClient[0], $TopLeftClient[1], 2, 250); Click away twice with 250ms delay
		Return False
	EndIf
	If ChkDisconnection() Then Return False
	If ($CurArchinCamp + $CurBarbinCamp + $CurMinioninCamp + $CurValkyrieinCamp) < 10 Then
		SetLog("Aborted... Need at least 10 non-targeting troop", $COLOR_RED)
		Click($TopLeftClient[0], $TopLeftClient[1], 2, 250); Click away twice with 250ms delay
		Return False
	EndIf

	Return True
EndFunc   ;==>Prepare_SnipeSearch




Func GetRemainingTrainTime()

	Local $MaxTrainTime = 0
	Local $WorkingBarracks = 4

	$SSGiant = GUICtrlRead($txtNumGiants) - $CurGiantinCamp
	$SSWBreaker = GUICtrlRead($txtNumWallbreakers) - $CurWBinCamp
	$SSArch = Floor((($itxtcampCap * GUICtrlRead($cmbRaidcap) / 100 - $CurCamp) - ($SSGiant * 5) - ($SSWBreaker) * 2) * (GUICtrlRead($txtArchers) / 100))
	$SSBarb = Floor((($itxtcampCap * GUICtrlRead($cmbRaidcap) / 100 - $CurCamp) - ($SSGiant * 5) - ($SSWBreaker) * 2) * (GUICtrlRead($txtBarbarians) / 100))
	$SSGoblin = Floor((($itxtcampCap * GUICtrlRead($cmbRaidcap) / 100 - $CurCamp) - ($SSGiant * 5) - ($SSWBreaker) * 2) * (GUICtrlRead($txtGoblins) / 100))
	;SetLog($SSArch & ' ' & $SSBarb & ' ' & $SSGoblin)


	Switch _GUICtrlComboBox_GetCurSel($cmbTroopComp)
		Case 0
			$MaxTrainTime = $SSArch * 25
		Case 1
			$MaxTrainTime = $SSBarb * 20
		Case 2
			$MaxTrainTime = $SSGoblin * 30
		Case 3
			$MaxTrainTime = $SSArch * 25 + $SSBarb * 20
		Case 4
			$MaxTrainTime = $SSArch * 25 + $SSBarb * 20 + $SSGoblin * 30 + $SSGiant * 120
		Case 5
			$MaxTrainTime = $SSArch * 25 + $SSBarb * 20 + $SSGiant * 120
		Case 6
			$MaxTrainTime = $SSArch * 25 + $SSBarb * 20 + $SSGoblin * 30
		Case 7
			$MaxTrainTime = $SSArch * 25 + $SSBarb * 20 + $SSGoblin * 30 + $SSGiant * 120 + $SSWBreaker * 120
		Case 9
			$MaxTrainTime = $SSArch * 25 + $SSBarb * 20 + $SSGiant * 120 + $SSWBreaker * 120
		Case 8

			$SSTroopKind1 = _GUICtrlComboBox_GetCurSel($cmbBarrack1)
			$SSTroopKind2 = _GUICtrlComboBox_GetCurSel($cmbBarrack2)
			$SSTroopKind3 = _GUICtrlComboBox_GetCurSel($cmbBarrack3)
			$SSTroopKind4 = _GUICtrlComboBox_GetCurSel($cmbBarrack4)

			$SSBarrackTime1 = SSGetTrainTime($SSTroopKind1)
			$SSBarrackTime2 = SSGetTrainTime($SSTroopKind2)
			$SSBarrackTime3 = SSGetTrainTime($SSTroopKind3)
			$SSBarrackTime4 = SSGetTrainTime($SSTroopKind4)

			$SSBarrackSize1 = SSGetTroopSize($SSTroopKind1)
			$SSBarrackSize2 = SSGetTroopSize($SSTroopKind2)
			$SSBarrackSize3 = SSGetTroopSize($SSTroopKind3)
			$SSBarrackSize4 = SSGetTroopSize($SSTroopKind4)



			$MaxTrainTime = ($itxtcampCap * GUICtrlRead($cmbRaidcap) / 100 - $CurCamp) / ($SSBarrackSize1 / $SSBarrackTime1 + $SSBarrackSize2 / $SSBarrackTime2 + $SSBarrackSize3 / $SSBarrackTime3 + $SSBarrackSize4 / $SSBarrackTime4)
			$WorkingBarracks = 1
	EndSwitch


	$MaxTrainTime /= $WorkingBarracks

	;check if training de troops and take them into account
;~ 	Standard_GetDETroopTotals()

;~ 	$CurMinion += $totalMinions
;~ 	$CurHog += $totalHogs
;~ 	$CurValkyrie += $totalValkyries

;~ 	$TotalMinionsTrainTime = (($totalMinions - $CurMinion) * 45) / 4
;~ 	$TotalHogsTrainTime = (($totalHogs - $CurHog) * 120) / 10
;~ 	$TotalValkyriesTrainTime = (($totalValkyries - $CurValkyrie) * 480) / 16

;~ 	If $TotalMinionsTrainTime > $MaxTrainTime Then $MaxTrainTime = $TotalMinionsTrainTime
;~ 	If $TotalHogsTrainTime > $MaxTrainTime Then $MaxTrainTime = $TotalHogsTrainTime
;~ 	If $TotalValkyriesTrainTime > $MaxTrainTime Then $MaxTrainTime = $TotalValkyriesTrainTime


	Return $MaxTrainTime
EndFunc   ;==>GetRemainingTrainTime


Func SSGetTrainTime($TroopKind)

	Switch $TroopKind
		Case 0
			Return 20
		Case 1
			Return 25
		Case 2
			Return 120
		Case 3
			Return 30
		Case 4
			Return 120
		Case 5
			Return 240
		Case 6
			Return 480
		Case 7
			Return 900
		Case 8
			Return 1800
		Case 9
			Return 2700
		Case 10
			; Nothing
	EndSwitch
	Return 1
EndFunc   ;==>SSGetTrainTime


Func SSGetTroopSize($TroopKind)

	Switch $TroopKind
		Case 0
			Return 1
		Case 1
			Return 1
		Case 2
			Return 5
		Case 3
			Return 1
		Case 4
			Return 2
		Case 5
			Return 5
		Case 6
			Return 4
		Case 7
			Return 14
		Case 8
			Return 20
		Case 9
			Return 25
		Case 10
			; Nothing
	EndSwitch

	Return 0
EndFunc   ;==>SSGetTroopSize


Func GetSnipe()
	;just copied from GetResources.au3

	$fdiffReadGold = TimerDiff($hTimerClickNext) ; amount of time to locate TH


	If checkTownhall() = "-" Then
		$THLoc = "-"
		$THquadrant = "-"
		$THx = 0
		$THy = 0
	Else
		$THquadrant = 0
		If $WideEdge = 1 Then
			If ((((85 - 389) / (528 - 131)) * ($THx - 131)) + 389 > $THy) Then
				$THquadrant = 1
			ElseIf ((((237 - 538) / (723 - 337)) * ($THx - 337)) + 538 > $THy) Then
				$THquadrant = 4
			Else
				$THquadrant = 7
			EndIf
			If ((((388 - 85) / (725 - 330)) * ($THx - 330)) + 85 > $THy) Then
				$THquadrant = $THquadrant + 2
			ElseIf ((((537 - 238) / (535 - 129)) * ($THx - 129)) + 238 > $THy) Then
				$THquadrant = $THquadrant + 1
			EndIf
		Else
			If ((((70 - 374) / (508 - 110)) * ($THx - 110)) + 374 > $THy) Then
				$THquadrant = 1
			ElseIf ((((252 - 552) / (742 - 358)) * ($THx - 358)) + 552 > $THy) Then
				$THquadrant = 4
			Else
				$THquadrant = 7
			EndIf
			If ((((373 - 70) / (744 - 350)) * ($THx - 350)) + 70 > $THy) Then
				$THquadrant = $THquadrant + 2
			ElseIf ((((552 - 253) / (516 - 108)) * ($THx - 108)) + 253 > $THy) Then
				$THquadrant = $THquadrant + 1
			EndIf
		EndIf
		If GUICtrlRead($sldAcc) > -1 Then
			If $THquadrant >= 1 And $THquadrant <= 4 Then $THLoc = "Out"
			If $THquadrant = 5 Then $THLoc = "In"
			If $THquadrant >= 6 And $THquadrant <= 9 Then $THLoc = "Out"
		Else
			; Future implementation...better determination of outside TH
			SeekEdges()
			If CloseToEdge($THx, $THy, 80) Then
				$THLoc = "Out"
			Else
				$THLoc = "In"
			EndIf
		EndIf
	EndIf
	$SearchCount += 1 ; Counter for number of searches
	SetLog(StringFormat("(%3d) [%s]: %3s",$SearchCount,GetLangText("msgTHInitial"),$THLoc), $COLOR_BLUE)

	If $THLoc = "Out" Then Return True

	Return False
EndFunc   ;==>GetSnipe




Func Snipe_Search($ssMaxSearchingTime = 0)
	Local $AttackMethod
	Local $ssStartTime = TimerInit()

	_WinAPI_EmptyWorkingSet(WinGetProcess($Title)) ; Reduce BlueStacks Memory Usage

	$hTimerClickNext = TimerInit() ;Next button already pressed before call here


	_BlockInputEx(3, "", "", $HWnD)

	While 1
		; Make sure end battle button is visible
		If Not _WaitForColorArea(23, 523, 25, 10, Hex(0xEE5056, 6), 50, 10) Then
			If ChkDisconnection() Then Return -2
			Return -1
		EndIf

		; Make sure clouds have cleared
		If Not _WaitForColor(1, 670, Hex(0x02070D, 6), 50, 5) Then 
			If ChkDisconnection() Then Return -2
			Return -1
		EndIf
		GUICtrlSetData($lblresultsearchcost, _NumberFormat(Number(StringReplace(GUICtrlRead($lblresultsearchcost), " ", "")) + $SearchCost))
		UpdateStat(-$SearchCost, 0, 0, 0)

		If _Sleep($speedBump) Then Return -1



		If GetSnipe() = True Then
			SetLog(GetLangText("msgSnipeFound"), $COLOR_PURPLE)
			$AttackMethod = 3
			ExitLoop
		EndIf
		GUICtrlSetData($lblresultvillagesskipped, GUICtrlRead($lblresultvillagesskipped) + 1)
																						;30 seconds is removed just in case
		If $ssMaxSearchingTime > 0 And TimerDiff($ssStartTime)/1000 > $ssMaxSearchingTime - 30 Then
			SetLog("Troop may be ready. Returning home...", $COLOR_PURPLE)
			ReturnHome(False, False, True) ;Abort search
			Return -1
		EndIf

		If  TimerDiff($ssStartTime)/1000 > 60*2 Then
			SetLog("Returning home to check camp just in case...", $COLOR_PURPLE)
			ReturnHome(False, False, True) ;Abort search
			Return -1
		EndIf


		_CaptureRegion()
		If _ColorCheck(_GetPixelColor(726, 497), Hex(0xF0AE28, 6), 20) Then ; find next button

			Local $fDiffNow = TimerDiff($hTimerClickNext) - $fdiffReadGold ;How long in attack prep mode
			$RandomDelay = _Random_Gaussian($icmbSearchsp * 1500, ($icmbSearchsp * 1500) / 6)
			If $fDiffNow < $speedBump + $RandomDelay Then ; Wait accoridng to search speed + speedBump
				If _Sleep($speedBump + $RandomDelay - $fDiffNow) Then ExitLoop
			EndIf



			Click(750, 500) ;Click Next
			$hTimerClickNext = TimerInit()
			;Take time to do search

			If _Sleep(1000) Then Return -1
		ElseIf _ColorCheck(_GetPixelColor(23, 523), Hex(0xEE5056, 6), 20) Then ;If End battle is available
			GUICtrlSetState($btnAtkNow, $GUI_DISABLE)
			SetLog(GetLangText("msgNoNextReturn"), $COLOR_RED)
			ChkDisconnection(True)
			ReturnHome(False, False, True)
			Return -1
		Else
			GUICtrlSetState($btnAtkNow, $GUI_DISABLE)
			SetLog(GetLangText("msgNoNextRestart"), $COLOR_RED)
			ChkDisconnection()
			Return -1
		EndIf

	WEnd

	GUICtrlSetData($lblresultvillagesattacked, GUICtrlRead($lblresultvillagesattacked) + 1)

	If IsChecked($chkAlertSearch) Then
		TrayTip("Match Found!", "Snipe Base Found while training", 0)
		If FileExists(@WindowsDir & "\media\Windows Exclamation.wav") Then
			SoundPlay(@WindowsDir & "\media\Windows Exclamation.wav", 1)
		Else
			SoundPlay(@WindowsDir & "\media\Festival\Windows Exclamation.wav", 1)
		EndIf
	EndIf
	$MatchFoundText = "Snipe Base Found while training"
	If $PushBulletEnabled = 1 And $PushBulletmatchfound = 1 Then
		_Push(GetLangText("pushMatch"), $MatchFoundText)
		SetLog(GetLangText("msgPushMatch"), $COLOR_GREEN)
	EndIf
	SetLog(GetLangText("msgSearchComplete"), $COLOR_BLUE)

	_BlockInputEx(0, "", "", $HWnD)
	Return $AttackMethod
EndFunc   ;==>Snipe_Search





