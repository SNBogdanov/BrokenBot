; Outputs stats of battles to log file
Func WriteStats($Skips, $EarnedGold, $EarnedElixir, $EarnedDark,$RaidGold,$RaidElixir,$RaidDark)
	$sStatPath = $dirStat & "Loot Results.csv"
	If Not FileExists($sStatPath) Then
		$hStatFileHandle = FileOpen($sStatPath, $FO_APPEND)
		FileWriteLine($hStatFileHandle, "Time"&$Delimiter&"Skips"&$Delimiter&"EarnedGold"&$Delimiter&"EarnedElixir"&$Delimiter&"EarnedDark"&$Delimiter&"RaidGold"&$Delimiter&"RaidElixir"&$Delimiter&"RaidDark"&$Delimiter&"GoldCount"&$Delimiter&"ElixirCount"&$Delimiter&"DarkCount"&$Delimiter&"GoldGained"&$Delimiter&"ElixirGained"&$Delimiter&"DarkGained")
	Else
		$hStatFileHandle = FileOpen($sStatPath, $FO_APPEND)
	EndIf
	FileWriteLine($hStatFileHandle, _Now() & $Delimiter & $Skips & $Delimiter & $EarnedGold & $Delimiter & $EarnedElixir & $Delimiter & $EarnedDark & $Delimiter & $RaidGold & $Delimiter & $RaidElixir & $Delimiter & $RaidDark & $Delimiter & $GoldCount & $Delimiter & $ElixirCount & $Delimiter & $DarkCount & $Delimiter & $GoldGained & $Delimiter & $ElixirGained & $Delimiter & $DarkGained)
	FileClose($hStatFileHandle)
EndFunc   ;==>WriteStats
