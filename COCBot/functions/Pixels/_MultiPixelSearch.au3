;Uses multiple pixels with coordinates of each color in a certain region, works for memory BMP

;$xSkip and $ySkip for numbers of pixels skip
;$offColor[2][COLOR/OFFSETX/OFFSETY] offset relative to firstColor coordination

Func _MultiPixelSearch($iLeft, $iTop, $iRight, $iBottom, $xSkip, $ySkip, $firstColor, $offColor, $iColorVariation)
	_CaptureRegion($iLeft, $iTop, $iRight, $iBottom)
	For $x = 0 To $iRight - $iLeft Step $xSkip
		For $y = 0 To $iBottom - $iTop Step $ySkip
;SetLog("_GetPixelColor("&$x&","&$y&")"&_GetPixelColor($x, $y))
			If _ColorCheck(_GetPixelColor($x, $y), $firstColor, $iColorVariation) Then
				Local $allchecked = True
;SetLog("Begin:("&$x+$iLeft&","&$y+$iTop&")")
;SetLog(_GetPixelColor($x + $offColor[0][1], $y + $offColor[0][2]))
;SetLog(_GetPixelColor($x + $offColor[1][1], $y + $offColor[1][2]))
;SetLog(_GetPixelColor($x + $offColor[2][1], $y + $offColor[2][2]))
				For $i = 0 To UBound($offColor) - 1
					If _ColorCheck(_GetPixelColor($x + $offColor[$i][1], $y + $offColor[$i][2]), Hex($offColor[$i][0], 6), $iColorVariation) = False Then
						$allchecked = False
						ExitLoop
					EndIf
				Next
				If $allchecked Then
					Local $Pos[2] = [$iLeft + $x, $iTop + $y]
					Return $Pos
				EndIf
			EndIf
		Next
	Next
	Return 0
EndFunc   ;==>_MultiPixelSearch
