;Checks if your Gold Storages are maxed out

Func isGoldFull()
	If $MaxGold >0 Then
		If $GoldCount = $MaxGold Then
			SetLog(GetLangText("msgGoldFull"), $COLOR_GREEN)
			Return True
		Else
			Return False
		EndIf
	EndIf
	_CaptureRegion()
	;-----------------------------------------------------------------------------
	If _ColorCheck(_GetPixelColor(658, 33), Hex(0x000000, 6), 6) Then ;Hex is black
		If _ColorCheck(_GetPixelColor(660, 33), Hex(0xD4B100, 6), 6) Then ;Hex if color of gold (orange)
			SetLog(GetLangText("msgGoldFull"), $COLOR_GREEN)
			Return True
		EndIf
	EndIf

	Return False
EndFunc   ;==>isGoldFull
