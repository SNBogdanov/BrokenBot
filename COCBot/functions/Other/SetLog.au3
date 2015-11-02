Func SetLog($String, $Color = 0x000000,$Var1="",$Var2="",$Var3="",$Var4="",$Var5="",$Var6="",$Var7="",$Var8="",$Var9="",$Var10="",$Var11="",$Var12="",$Var13="",$Var14="",$Var15="",$Var16="",$Var17="",$Var18="",$Var19="",$Var20="",$Var21="",$Var22="",$Var23="",$Var24="",$Var25="",$Var26="",$Var27="",$Var28="",$Var29="",$Var30="",$Var31="",$Var32="") ;Sets the text for the log
	Local $Str
	$Str=GetLangText($String)
	If $Str <> "" Then $String = $Str
	$String=StringFormat($String,$Var1,$Var2,$Var3,$Var4,$Var5,$Var6,$Var7,$Var8,$Var9,$Var10,$Var11,$Var12,$Var13,$Var14,$Var15,$Var16,$Var17,$Var18,$Var19,$Var20,$Var21,$Var22,$Var23,$Var24,$Var25,$Var26,$Var27,$Var28,$Var29,$Var30,$Var31,$Var32)
	_GUICtrlRichEdit_AppendTextColor($txtLog, Time(), 0x000000)
	_GUICtrlRichEdit_AppendTextColor($txtLog, $String & @CRLF, _ColorConvert($Color))

	_GUICtrlStatusBar_SetText($statLog, "Status : " & $String)
	_FileWriteLog($hLogFileHandle, $String)
EndFunc   ;==>SetLog

Func _GUICtrlRichEdit_AppendTextColor($hWnd, $sText, $iColor)
	Local $iLength = _GUICtrlRichEdit_GetTextLength($hWnd, True, True)
	Local $iCp = _GUICtrlRichEdit_GetCharPosOfNextWord($hWnd, $iLength)
	_GUICtrlRichEdit_SetFont($hWnd, GUICtrlRead($lblFontSize),GUICtrlRead($lblFontName))
	_GUICtrlRichEdit_AppendText($hWnd, $sText)
	_GUICtrlRichEdit_SetFont($hWnd, GUICtrlRead($lblFontSize),GUICtrlRead($lblFontName))
	_GUICtrlRichEdit_SetSel($hWnd, $iCp - 1, $iLength + StringLen($sText))
	_GUICtrlRichEdit_SetCharColor($hWnd, $iColor)
	_GUICtrlRichEdit_Deselect($hWnd)
EndFunc   ;==>_GUICtrlRichEdit_AppendTextColor

Func _ColorConvert($nColor);RGB to BGR or BGR to RGB
	Return _
			BitOR(BitShift(BitAND($nColor, 0x000000FF), -16), _
			BitAND($nColor, 0x0000FF00), _
			BitShift(BitAND($nColor, 0x00FF0000), 16))
EndFunc   ;==>_ColorConvert
