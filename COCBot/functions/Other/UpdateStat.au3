Func UpdateStat($Gold,$Elixir,$Dark,$Trophy)
	Local $GoldNow
;	SetLog("UpdateStat:"&$Gold&"+"&$Elixir&"+"&$Dark&"+"&$Trophy)
	SetTime()
	$GoldNow = $Gold
	If $Gold < 0 Then
		$GoldNow=StringReplace(GUICtrlRead($lblresultgoldnow)," ","")+$Gold
	EndIf
	If $GoldNow > 0 Then
		If $GoldStart = 0 Then
			$sTimer = TimerInit()
			$SubmissionTimer = TimerInit()
            		GUICtrlSetData($lblresultgoldtstart, _NumberFormat(Round($GoldNow)))
			$GoldStart=$GoldNow
		EndIf
        	GUICtrlSetData($lblresultgoldnow, _NumberFormat(Round($GoldNow)))
	    	$GoldGained = $GoldNow - $GoldStart + $GoldUpgraded
	EndIf
	GUICtrlSetData($lblresultgoldgain, _NumberFormat(Round($GoldGained)))
       	GUICtrlSetData($lblresultavggoldgain, _NumberFormat(Round($GoldGained/(TimerDiff($sTimer)/(1000*3600)))))
	If $Elixir > 0 Then
		If $ElixirStart = 0 Then
            		GUICtrlSetData($lblresultelixirstart, _NumberFormat(Round($Elixir)))
			$ElixirStart=$Elixir
		EndIf
	        GUICtrlSetData($lblresultelixirnow, _NumberFormat(Round($Elixir)))
	    	$ElixirGained = $Elixir - $ElixirStart + $ElixirUpgraded
	EndIf
        GUICtrlSetData($lblresultelixirgain, _NumberFormat(Round($ElixirGained)))
	GUICtrlSetData($lblresultavgelixirgain, _NumberFormat(Round($ElixirGained/(TimerDiff($sTimer)/(1000*3600)))))
	If $Dark > 0 Then
		If $DarkStart = 0 Then
            		GUICtrlSetData($lblresultdestart, _NumberFormat(Round($Dark)))
			$DarkStart=$Dark
		EndIf
	        GUICtrlSetData($lblresultdenow, _NumberFormat(Round($Dark)))
	        $DarkGained = $Dark - $DarkStart+ $DarkUpgraded
	EndIf
	GUICtrlSetData($lblresultdegain, _NumberFormat(Round($DarkGained)))
	GUICtrlSetData($lblresultavgdegain, _NumberFormat(Round($DarkGained/(TimerDiff($sTimer)/(1000*3600)))))
	If $Trophy > 0 Then
		If $TropyStart = 0 Then
            		GUICtrlSetData($lblresulttrophystart, $Trophy)
			$TropyStart=$Trophy
		EndIf
        	GUICtrlSetData($lblresulttrophynow, $Trophy)
	        $TrophyGained = $Trophy - $TropyStart
	EndIf
	GUICtrlSetData($lblresulttrophygain, $TrophyGained)
;	SetLog("UpdateStat:"&$GoldGained&"+"&$ElixirGained&"+"&$DarkGained&"+"&$TrophyGained)
EndFunc   ;==>UpdateStat

