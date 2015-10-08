;Checks if your Elixir Storages are maxed out

Func isElixirFull()

	If $MaxElixir >0 Then
		If $ElixirCount = $MaxElixir Then
			SetLog(GetLangText("msgElixirFull"), $COLOR_GREEN)
			Return True
		Else
			Return False
		EndIf
	EndIf
	_CaptureRegion()
	;-----------------------------------------------------------------------------
	If _ColorCheck(_GetPixelColor(658, 84), Hex(0x000000, 6), 6) Then ;Hex is black
		If _ColorCheck(_GetPixelColor(660, 84), Hex(0xAE1AB3, 6), 6) Then ;Hex if color of elixir (purple)
			SetLog(GetLangText("msgElixirFull"), $COLOR_GREEN)
			Return True
		EndIf
	EndIf

	Return False
EndFunc   ;==>isElixirFull
