Global $GoldBeforeSearch=0
Func VillageReport()
        Local $TrophyCountOld,$GoldCountOld,$ElixirCountOld,$DarkCountOld
        StatusCheck()
        SetLog(GetLangText("msgVillageRep"), $COLOR_GREEN)
        $FreeBuilder = ReadText(320, 23, 41, $textMainScreen)
        Setlog(GetLangText("msgNumFreeBuild") & $FreeBuilder, $COLOR_GREEN)
        $FreeBuilder = Number(StringLeft($FreeBuilder, 1))
        If $PushBulletEnabled = 1 And $PushBulletfreebuilder = 1 And $FreeBuilder > 0 And Not ($buildernotified) Then
            _Push(GetLangText("pushFB"), GetLangText("pushFBb") & ($FreeBuilder = 1) ? (GetLangText("pushFBc") : $FreeBuilder) & GetLangText("pushFBd") & ($FreeBuilder = 1) ? ("" : GetLangText("pushFBe")) & GetLangText("pushFBf"))
            $buildernotified = True
            SetLog(GetLangText("msgPushFreeBuild"), $COLOR_GREEN)
        Else
            $buildernotified = False
        EndIf
        $TrophyCountOld = $TrophyCount
        $GoldCountOld = $GoldCount
        $ElixirCountOld = $ElixirCount
        $DarkCountOld = $DarkCount
	If _Sleep(1000) Then Return
        $GoldCount = Number(ReadText(666, 25, 138, $textMainScreen, 0))
	$res = Number(ReadText(666, 76, 138, $textMainScreen, 0))
	If $res>1 Then $ElixirCount = $res
        If _ColorCheck(_GetPixelColor(718, 131), Hex(0xF8FCFF, 6), 40) Then
        ; No DE
            $GemCount = Number(ReadText(736, 124, 68, $textMainScreen, 0))
        Else
            $DarkCount = Number(ReadText(711, 125, 93, $textMainScreen, 0))
            $GemCount = Number(ReadText(736, 173, 68, $textMainScreen, 0))
        EndIf
        $TrophyCount = Number(ReadText(59, 75, 60, $textMainScreen))
	If $GoldCount <2 Then $GoldCount=$GoldCountOld
	If $ElixirCount <2 Then $ElixirCount=$ElixirCountOld
	If $DarkCount <2 Then $DarkCount=$DarkCountOld
	UpdateStat($GoldCount,$ElixirCount,$DarkCount,$TrophyCount)
        If Not $FirstAttack  Then
            If $PushBulletEnabled = 1 And $PushBulletvillagereport = 1 Then
                If TimerDiff($PushBulletvillagereportTimer) >= $PushBulletvillagereportInterval Then ;Report is due
		    _Push(GetLangText("pushVR"), _PushStatisticsString())

                    SetLog(GetLangText("msgPushVillageRep"), $COLOR_GREEN)
                    $PushBulletvillagereportTimer = TimerInit()
                EndIf
            EndIf
    		If Not $MidAttack And $Raid = 1 Then ;report when there is a Raid except when bot disconnected
    			$SubmissionAttacks += 1
    			$SubmissionGold += $LastRaidGold
    			$SubmissionElixir += $LastRaidElixir
    			$SubmissionDE += $LastRaidDarkElixir
    			WriteStats($SearchCount,$LastRaidGold-$SearchCount*$SearchCost,$LastRaidElixir-$ElixirTrainCost,$LastRaidDarkElixir-$DarkTrainCost,$LastRaidGold,$LastRaidElixir,$LastRaidDarkElixir)
    			SetLog(GetLangText("msgLastRaidGain") & " [" & GetLangText("msgGoldinitial") & "]: " & _NumberFormat($LastRaidGold-$SearchCount*$SearchCost) & " [" & GetLangText("msgElixirinitial") & "]: " & _NumberFormat($LastRaidElixir-$ElixirTrainCost) & _
    					" [" & GetLangText("msgDarkElixinitial") & "]: " & _NumberFormat($LastRaidDarkElixir-$DarkTrainCost) & " [" & GetLangText("msgTrophyInitial") & "]: " & ($TrophyCount - $TrophyCountOld))
    			SetLog(GetLangText("msgLastRaidLoot") & " [" & GetLangText("msgGoldinitial") & "]: " & _NumberFormat($LastRaidGold) & " [" & GetLangText("msgElixirinitial") & "]: " & _NumberFormat($LastRaidElixir) & _
    					" [" & GetLangText("msgDarkElixinitial") & "]: " & _NumberFormat($LastRaidDarkElixir) & " [" & GetLangText("msgTrophyInitial") & "]: " & $LastRaidTrophy)
    			If $PushBulletEnabled = 1 Then ;do pushbullet reports
    				Local $PushReportText = GetLangText("pushLRb") & GetLangText("msgGoldinitial") & "]: " & _NumberFormat($LastRaidGold-$SearchCount*$SearchCost) & " [" & GetLangText("msgElixirinitial") & "]: " & _NumberFormat($LastRaidElixir-$ElixirTrainCost) & _
    						" [" & GetLangText("msgDarkElixinitial") & "]: " & _NumberFormat($LastRaidDarkElixir-$DarkTrainCost) & " [" & GetLangText("msgTrophyInitial") & "]: " & ($TrophyCount - $TrophyCountOld) & _
    						"\nLoot+Bonus: \n[" & GetLangText("msgGoldinitial") & "]: " & _NumberFormat($LastRaidGold) & " [" & GetLangText("msgElixirinitial") & "]: " & _NumberFormat($LastRaidElixir) & _
    						" [" & GetLangText("msgDarkElixinitial") & "]: " & _NumberFormat($LastRaidDarkElixir) & " [" & GetLangText("msgTrophyInitial") & "]: " & $LastRaidTrophy & _
    						"\n" & GetLangText("pushLootA") & "\n" & $MatchFoundText & _
    						"\n" & GetLangText("pushBS") & $SearchCount & _
    						"; " & GetLangText("pushDS") & GUICtrlRead($lblresultsearchdisconnected) & _
    						"\n" & GetLangText("pushVR") & " \n[" & GetLangText("msgGoldinitial") & "]: " & _NumberFormat($GoldCount) & " [" & GetLangText("msgElixirinitial") & "]: " & _NumberFormat($ElixirCount) & _
    						" [" & GetLangText("msgDarkElixinitial") & "]: " & _NumberFormat($DarkCount) & " [" & GetLangText("msgTrophyInitial") & "]: " & $TrophyCount & " [" & GetLangText("msgGemInitial") & "]: " & $GemCount & _
    						"\n[Attack]: " & GUICtrlRead($lblresultvillagesattacked) & " [Skip]: " & GUICtrlRead($lblresultvillagesskipped) & _
    						" [Walls]: " & GUICtrlRead($lblwallupgradecount) & _
    						"\n" & GetLangText("pushG") & " \n[" & GetLangText("msgGoldinitial") & "]: " & _NumberFormat($GoldGained) & " [" & GetLangText("msgElixirinitial") & "]: " & _NumberFormat($ElixirGained) & _
    						" [" & GetLangText("msgDarkElixinitial") & "]: " & _NumberFormat($DarkGained)
    				If IsChecked($UseJPG) Then
    					If _Sleep(1000) Then Return
    					_PushFile($FileName, "loots", "image/jpeg", GetLangText("pushLR"), $PushReportText)
    					SetLog(GetLangText("msgPushLastRaid"), $COLOR_GREEN)
    				ElseIf IsChecked($lbllastraid) Then
    					_Push(GetLangText("pushLR"), $PushReportText)
    					SetLog(GetLangText("msgPushLastRaid"), $COLOR_GREEN)
    				EndIf
    			EndIf
    			StatSubmission(True)
			$GoldBeforeSearch=0
    			$Raid = 0
			$SearchCount = 0
    			$closetofull = False
    			$anythingadded = True
    			$anythingdarkadded = True
			$ElixirTrainCost=0
			$DarkTrainCost=0
    		EndIf
        EndIf
    	SetLog(GetLangText("msgResources"), $COLOR_GREEN)
    	SetLog(StringFormat(" [%s]: %7d [%s]: %7d",GetLangText("msgGoldinitial"),$GoldCount,GetLangText("msgGoldgained"),$GoldGained), $COLOR_GREEN)
    	SetLog(StringFormat(" [%s]: %7d [%s]: %7d",GetLangText("msgElixirinitial"),$ElixirCount,GetLangText("msgElixirgained"),$ElixirGained), $COLOR_GREEN)
    	SetLog(StringFormat(" [%s]: %7d [%s]: %7d",GetLangText("msgDarkElixinitial"),$DarkCount,GetLangText("msgDarkElixgained"),$DarkGained), $COLOR_GREEN)
    	SetLog(StringFormat(" [%s]: %7d [%s]: %7d",GetLangText("msgTrophyInitial"),$TrophyCount,GetLangText("msgTrophygained"),$TrophyGained), $COLOR_GREEN)
	SetLog(StringFormat(" [%s]: %5d",GetLangText("msgGemInitial"),$GemCount), $COLOR_GREEN)
        $FirstAttack = False
EndFunc   ;==>VillageReport
