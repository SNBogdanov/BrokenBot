; Outputs stats of battles to log file
Func WriteStats($Skips, $EarnedGold, $EarnedElixir, $EarnedDark,$RaidGold,$RaidElixir,$RaidDark)
	$sStatPath = $dirStat & "Loot Results.csv"
	If Not FileExists($sStatPath) Then
		$hStatFileHandle = FileOpen($sStatPath, $FO_APPEND)
		FileWriteLine($hStatFileHandle, "Time;Skips;EarnedGold;EarnedElixir;EarnedDark;RaidGold;RaidElixir;RaidDark;GoldCount;ElixirCount;DarkCount;GoldGained;ElixirGained;DarkGained")
	Else
		$hStatFileHandle = FileOpen($sStatPath, $FO_APPEND)
	EndIf
	FileWriteLine($hStatFileHandle, _Now() & ";" & $Skips & ";" & $EarnedGold & ";" & $EarnedElixir & ";" & $EarnedDark & ";" & $RaidGold & ";" & $RaidElixir & ";" & $RaidDark & ";" & $GoldCount & ";" & $ElixirCount & ";" & $DarkCount & ";" & $GoldGained & ";" & $ElixirGained & ";" & $DarkGained)
	FileClose($hStatFileHandle)
EndFunc   ;==>WriteStats
