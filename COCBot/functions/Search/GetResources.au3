;Uses the getGold,getElixir... functions and uses CompareResources until it meets conditions.
;Will wait ten seconds until getGold returns a value other than "", if longer than 10 seconds - calls checkNextButton
;-clicks next if checkNextButton returns true, otherwise will restart the bot.


Func GetResources($MidAttack = 0) ;Reads resources
	Local $RetVal[7]
	Local $i = 0
	Local $x = 0
	Local $txtDead = "Live"

	If $MidAttack = 0 And ChkDisconnection() Then
		SetLog(GetLangText("msgNoNextButton"), $COLOR_RED)
		Return False
	EndIf

	If IsChecked($chkFastSearchEnable) And _
			$MidAttack = 0 And _
			Not IsChecked($chkSnipe) And _
			Not IsChecked($chkDeadSnipe) And _
			Not (Number(GUICtrlRead($lblresulttrophynow)) < Number(GUICtrlRead($txtSnipeBelow))) Then ; if one of simple requirements are not meeted Skips searching deeper and we win a lot of time

		_CaptureRegion()

		$RetVal[0] = "-"
		$RetVal[1] = "-"
		$RetVal[2] = ReadText(50, 70, 150, $textVillageSearch) ;gold
		$RetVal[3] = ReadText(50, 99, 150, $textVillageSearch) ;elixir
		If _ColorCheck(_GetPixelColor(38, 136), Hex(0xD3CADA, 6), 40) Then
			$RetVal[4] = ReadText(50, 128, 80, $textVillageSearch); DE
			$RetVal[5] = ReadText(50, 170, 67, $textVillageSearch); Trophy
		Else
			$RetVal[4] = 0 ;DE
			$RetVal[5] = ReadText(50, 140, 67, $textVillageSearch) ;Trophy
		EndIf

		$RetVal[6] = False ; skipping base option


		If Not (DeadMinConditions($RetVal) Or AnyMinConditions($RetVal)) Then
			$SearchCount += 1
			SetLog(StringFormat("(%3d) [%s]:%7d [%s]:%7d [%s]: %4d",$SearchCount,GetLangText("msgGoldinitial"),$RetVal[2],GetLangText("msgElixirinitial"),$RetVal[3],GetLangText("msgDarkElixinitial"),$RetVal[4]), $COLOR_BLUE)
;			SetLog("Skipping Base...", $COLOR_BLUE)
			$RetVal[6] = True
;			Return $RetVal
		EndIf
		Return $RetVal
	EndIf

	If $MidAttack > 0 Then
		$RetVal[0] = ""
		$RetVal[1] = ""
	Else
		$fdiffReadGold = TimerDiff($hTimerClickNext)
		$RetVal[0] = checkDeadBase()
		If $RetVal[0] Then $txtDead = GetLangText("msgDeadInitial")

		$RetVal[1] = checkTownhall()
		If $RetVal[1] = "-" Then
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
				If CloseToEdge($Thx, $Thy, 80) Then
					$THLoc = "Out"
				Else
					$THLoc = "In"
				EndIf
			EndIf
		EndIf
	EndIf

	$RetVal[2] = ReadText(50, 70, 150, $textVillageSearch)
	$RetVal[3] = ReadText(50, 99, 150, $textVillageSearch)
	If _ColorCheck(_GetPixelColor(38, 136), Hex(0xD3CADA, 6), 40) Then
		$RetVal[4] = ReadText(50, 128, 80, $textVillageSearch)
		$RetVal[5] = ReadText(50, 170, 67, $textVillageSearch)
	Else
		$RetVal[4] = 0
		$RetVal[5] = ReadText(50, 140, 67, $textVillageSearch)
	EndIf


	If $MidAttack = 1 Then
		SetLog(StringFormat("%s [%s]:%7d [%s]:%7d [%s]: %4d [%s]: %2d [%s]: %2d,%3s,%4s",GetLangText("msgMidAttack"),GetLangText("msgGoldinitial"),$RetVal[2],GetLangText("msgElixirinitial"),$RetVal[3],GetLangText("msgDarkElixinitial"),$RetVal[4],GetLangText("msgTrophyInitial"),$RetVal[5],GetLangText("msgTHInitial"),$RetVal[1],$THLoc,$txtDead), $COLOR_BLUE)
	ElseIf $MidAttack = 0 Then
		$SearchCount += 1 ; Counter for number of searches
		SetLog(StringFormat("(%3d) [%s]:%7d [%s]:%7d [%s]: %4d [%s]: %2d [%s]: %2d,%3s,%4s",$SearchCount,GetLangText("msgGoldinitial"),$RetVal[2],GetLangText("msgElixirinitial"),$RetVal[3],GetLangText("msgDarkElixinitial"),$RetVal[4],GetLangText("msgTrophyInitial"),$RetVal[5],GetLangText("msgTHInitial"),$RetVal[1],$THLoc,$txtDead), $COLOR_BLUE)
	EndIf
	Return $RetVal
EndFunc   ;==>GetResources


Func DeadMinConditions(Const $RetVal)

	If IsChecked($chkDeadActivate) Then
		If IsChecked($chkDeadGE) Then ; if dead, minimum gold and elixir selected

			$myDeadAndOr = _GUICtrlComboBox_GetCurSel($cmbDead) ; and or +

			If $myDeadAndOr = 0 Then ; if and condition. One should meet demand
				If (Number($RetVal[2]) < Number($MinDeadGold)) Or _
						(Number($RetVal[3]) < Number($MinDeadElixir)) Then


;					SetLog(StringFormat("(%3d) [%s]:%7d [%s]:%7d [%s]: %4d",$SearchCount+1,GetLangText("msgGoldinitial"),$RetVal[2],GetLangText("msgElixirinitial"),$RetVal[3],GetLangText("msgDarkElixinitial"),$RetVal[4]), $COLOR_BLUE)
					If $DebugMode = 1 Then SetLog("Dead Min And, Demands [G]: " & $MinDeadGold & " [E]:" & $MinDeadElixir & "   Found [G]: " & $RetVal[2] & " [E]:" & $RetVal[3])

					Return False ;if min gold or elixir does not meet search condition then do not do adnotional checks just skip
				EndIf
			ElseIf $myDeadAndOr = 1 Then ; if Or condition. Both Should meet demands
				If (Number($RetVal[2]) < Number($MinDeadGold)) And _
						(Number($RetVal[3]) < Number($MinDeadElixir)) Then
;					SetLog(StringFormat("(%3d) [%s]:%7d [%s]:%7d [%s]: %4d",$SearchCount+1,GetLangText("msgGoldinitial"),$RetVal[2],GetLangText("msgElixirinitial"),$RetVal[3],GetLangText("msgDarkElixinitial"),$RetVal[4]), $COLOR_BLUE)
					If $DebugMode = 1 Then SetLog("Dead Min OR, Demand [G]: " & $MinDeadGold & " [E]:" & $MinDeadElixir & "   Found [G]: " & $RetVal[2] & " [E]:" & $RetVal[3])
					Return False ;if min gold AND elixir does not meet search condition then do not do adnotional checks just skip
				EndIf
			ElseIf $myDeadAndOr = 2 Then ; if "+" condition. Both Should meet demands
				If Number(Number($RetVal[2]) + Number($RetVal[3])) < _
						Number(Number($MinDeadGold) + Number($MinDeadElixir)) Then
;					SetLog(StringFormat("(%3d) [%s]:%7d [%s]:%7d [%s]: %4d",$SearchCount+1,GetLangText("msgGoldinitial"),$RetVal[2],GetLangText("msgElixirinitial"),$RetVal[3],GetLangText("msgDarkElixinitial"),$RetVal[4]), $COLOR_BLUE)
					If $DebugMode = 1 Then SetLog('Dead Min "+", Demand [G]: ' & $MinDeadGold & " [E]:" & $MinDeadElixir & "   Found [G]: " & $RetVal[2] & " [E]:" & $RetVal[3])
					Return False ;if min gold + elixir does not meet search condition then do not do adnotional checks just skip
				EndIf

			EndIf
		EndIf


		If IsChecked($chkDeadMeetDE) Then

			If (Number($RetVal[4]) < Number($MinDeadDark)) Then


;				SetLog(StringFormat("(%3d) [%s]:%7d [%s]:%7d [%s]: %4d",$SearchCount+1,GetLangText("msgGoldinitial"),$RetVal[2],GetLangText("msgElixirinitial"),$RetVal[3],GetLangText("msgDarkElixinitial"),$RetVal[4]), $COLOR_BLUE)
				If $DebugMode = 1 Then SetLog("Dead Min DE, Demands [DE]: " & $MinDeadDark & "   Found [DE]: " & $RetVal[4])

				Return False ;if DE does not meet search condition then do not do adnotional checks just skip
			EndIf

		EndIf


		If IsChecked($chkDeadMeetTrophy) Then

			If (Number($RetVal[5]) < Number($MinDeadTrophy)) Then


;				SetLog(StringFormat("(%3d) [%s]:%7d [%s]:%7d [%s]: %4d",$SearchCount+1,GetLangText("msgGoldinitial"),$RetVal[2],GetLangText("msgElixirinitial"),$RetVal[3],GetLangText("msgDarkElixinitial"),$RetVal[4]), $COLOR_BLUE)
				If $DebugMode = 1 Then SetLog("Dead Min T, Demands [T]: " & $MinDeadTrophy & "   Found [T]: " & $RetVal[5])

				Return False ;if trophy count does not meet search condition then do not do adnotional checks just skip
			EndIf

		EndIf

	Else
		Return False
	EndIf

	Return True
EndFunc   ;==>DeadMinConditions






Func AnyMinConditions(Const $RetVal)

	If IsChecked($chkAnyActivate) Then
		If IsChecked($chkMeetGE) Then ; if , minimum gold and elixir selected

			$myAndOr = _GUICtrlComboBox_GetCurSel($cmbAny) ; and or +

			If $myAndOr = 0 Then ; if and condition. One should meet demand
				If (Number($RetVal[2]) < Number($MinGold)) Or _
						(Number($RetVal[3]) < Number($MinElixir)) Then


;					SetLog(StringFormat("(%3d) [%s]:%7d [%s]:%7d [%s]: %4d",$SearchCount+1,GetLangText("msgGoldinitial"),$RetVal[2],GetLangText("msgElixirinitial"),$RetVal[3],GetLangText("msgDarkElixinitial"),$RetVal[4]), $COLOR_BLUE)
					If $DebugMode = 1 Then SetLog(" Any Min And, Demands [G]: " & $MinGold & " [E]:" & $MinElixir & "   Found [G]: " & $RetVal[2] & " [E]:" & $RetVal[3])

					Return False
				EndIf
			ElseIf $myAndOr = 1 Then ; if Or condition. Both Should meet demands
				If (Number($RetVal[2]) < Number($MinGold)) And _
						(Number($RetVal[3]) < Number($MinElixir)) Then
;					SetLog(StringFormat("(%3d) [%s]:%7d [%s]:%7d [%s]: %4d",$SearchCount+1,GetLangText("msgGoldinitial"),$RetVal[2],GetLangText("msgElixirinitial"),$RetVal[3],GetLangText("msgDarkElixinitial"),$RetVal[4]), $COLOR_BLUE)
					If $DebugMode = 1 Then SetLog(" Min OR, Demand [G]: " & $MinGold & " [E]:" & $MinElixir & "   Found [G]: " & $RetVal[2] & " [E]:" & $RetVal[3])
					Return False ;if min gold AND elixir does not meet search condition then do not do adnotional checks just skip
				EndIf
			ElseIf $myAndOr = 2 Then ; if "+" condition. Both Should meet demands
				If Number(Number($RetVal[2]) + Number($RetVal[3])) < _
						Number(Number($MinGold) + Number($MinElixir)) Then
;					SetLog(StringFormat("(%3d) [%s]:%7d [%s]:%7d [%s]: %4d",$SearchCount+1,GetLangText("msgGoldinitial"),$RetVal[2],GetLangText("msgElixirinitial"),$RetVal[3],GetLangText("msgDarkElixinitial"),$RetVal[4]), $COLOR_BLUE)
					If $DebugMode = 1 Then SetLog(' Min "+", Demand [G]: ' & $MinGold & " [E]:" & $MinElixir & "   Found [G]: " & $RetVal[2] & " [E]:" & $RetVal[3])
					Return False ;if min gold + elixir does not meet search condition then do not do adnotional checks just skip
				EndIf

			EndIf
		EndIf


		If IsChecked($chkMeetDE) Then

			If (Number($RetVal[4]) < Number($MinDark)) Then


;				SetLog(StringFormat("(%3d) [%s]:%7d [%s]:%7d [%s]: %4d",$SearchCount+1,GetLangText("msgGoldinitial"),$RetVal[2],GetLangText("msgElixirinitial"),$RetVal[3],GetLangText("msgDarkElixinitial"),$RetVal[4]), $COLOR_BLUE)
				If $DebugMode = 1 Then SetLog(" Min DE, Demands [DE]: " & $MinDark & "   Found [DE]: " & $RetVal[4])

				Return False ;if DE does not meet search condition then do not do adnotional checks just skip
			EndIf

		EndIf


		If IsChecked($chkMeetTrophy) Then

			If (Number($RetVal[5]) < Number($MinTrophy)) Then


;				SetLog(StringFormat("(%3d) [%s]:%7d [%s]:%7d [%s]: %4d",$SearchCount+1,GetLangText("msgGoldinitial"),$RetVal[2],GetLangText("msgElixirinitial"),$RetVal[3],GetLangText("msgDarkElixinitial"),$RetVal[4]), $COLOR_BLUE)
				If $DebugMode = 1 Then SetLog(" Min T, Demands [T]: " & $MinTrophy & "   Found [T]: " & $RetVal[5])

				Return False ;if trophy count does not meet search condition then do not do adnotional checks just skip
			EndIf

		EndIf
	Else
		Return False
	EndIf
	Return True
EndFunc   ;==>AnyMinConditions
