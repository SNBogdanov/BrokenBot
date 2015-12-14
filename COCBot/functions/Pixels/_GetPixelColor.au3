;Returns color of pixel in the coordinations

Func _GetPixelColor($iX, $iY)
	Local $aPixelColor = _GDIPlus_BitmapGetPixel($hBitmap, $iX, $iY)
;SetLog("_GetPixelColor("&$iX&","&$iY&")="&$aPixelColor)
	Return Hex($aPixelColor, 6)
EndFunc   ;==>_GetPixelColor
