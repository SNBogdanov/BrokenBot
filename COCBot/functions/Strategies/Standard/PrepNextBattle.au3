Func Standard_PrepNextBattle()
	;Resetting this flag only after search successful
	;As this flag will be used in miniReady_Check as well
	;$stuckCount = 0
	$AttackNow = False
	If $ElixirCount <$MinElixirToTrain Then
		If Not $fullarmy  Then
			SetLog("Elixir level "&$ElixirCount&" is less then minimum "&$MinElixirToTrain&", skip training", $COLOR_RED)
			$stuckCount=0
			Click(1, 1, 2, 250) ;Click Away with 205ms delay
			Return False
		EndIf
		Return True
	EndIf

	Standard_Train(True)
EndFunc   ;==>Standard_PrepNextBattle

