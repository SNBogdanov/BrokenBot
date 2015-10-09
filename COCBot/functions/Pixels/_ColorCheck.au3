;==============================================================================================================
;==============================================================================================================
;===Color Variation============================================================================================
;--------------------------------------------------------------------------------------------------------------
;Checks if the color components exceed $sVari and returns true if they are below $sVari.
;--------------------------------------------------------------------------------------------------------------

;Func _ColorCheck($nColor1, $nColor2, $sVari = 5)
Func _ColorCheck($nColor1, $nColor2, $sVari = 5,$debug=0)
	Local $Red1, $Red2, $Blue1, $Blue2, $Green1, $Green2

	If $debug = 1 Then SetLog($nColor1)
	If $debug = 1 Then SetLog($nColor2)
	$Red1 = Dec(StringMid(String($nColor1), 1, 2))
	$Blue1 = Dec(StringMid(String($nColor1), 3, 2))
	$Green1 = Dec(StringMid(String($nColor1), 5, 2))

	$Red2 = Dec(StringMid(String($nColor2), 1, 2))
	$Blue2 = Dec(StringMid(String($nColor2), 3, 2))
	$Green2 = Dec(StringMid(String($nColor2), 5, 2))

	If $debug = 1 Then SetLog($Blue1&" - "&$Blue2, $COLOR_RED)
	If Abs($Blue1 - $Blue2) > $sVari Then Return False
	If $debug = 1 Then SetLog($Green1&" - "&$Green2, $COLOR_RED)
	If Abs($Green1 - $Green2) > $sVari Then Return False
	If $debug = 1 Then SetLog($Red1&" - "&$Red2, $COLOR_RED)
	If Abs($Red1 - $Red2) > $sVari Then Return False
	Return True
EndFunc   ;==>_ColorCheck

; CheckPixel : takes an array[4] as a parameter, [x, y, color, tolerance]
Func CheckPixel($tab)
	If _ColorCheck(_GetPixelColor($tab[0], $tab[1]), Hex($tab[2], 6), $tab[3]) Then
		Return True
	Else
		If $DebugMode = 1 Then
			SetLog(GetLangText("msgLocationX") & $tab[0] & " Y:" & $tab[1], $COLOR_RED)
			SetLog(GetLangText("msgGot") & _GetPixelColor($tab[0], $tab[1]), $COLOR_RED)
			SetLog(GetLangText("msgWanted") & Hex($tab[2], 6), $COLOR_RED)
			SetLog(GetLangText("msgVariance") & $tab[3], $COLOR_RED)
			_GDIPlus_ImageSaveToFile($hBitmap, $dirDebug & "Missedcolor-" & $tab[0] & "-" & $tab[1] & "-" & Hex($tab[2], 6) & "-" & _GetPixelColor($tab[0], $tab[1]) & ".png")
		EndIf
		
		Return False
	EndIf
EndFunc   ;==>CheckPixel
