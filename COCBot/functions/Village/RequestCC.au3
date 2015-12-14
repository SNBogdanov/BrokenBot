Func RequestCC()

	If IsChecked($chkRequest)  Then

		SetLog(GetLangText("msgRequesting"), $COLOR_BLUE)

		If Not TryToOpenArmyOverview() Then Return
		_CaptureRegion()
		If _ColorCheck(_GetPixelColor(650, 30+300), Hex(0xD5D5D5, 6), 3) Then
			SetLog(GetLangText("msgCCFull"), $COLOR_RED)
			Click(150, 550) ;Click away
			Return
		EndIf
		If _ColorCheck(_GetPixelColor(691, 30+356), Hex(0xFFFFFF, 6), 3) Then
			SetLog(GetLangText("msgRequestAlready"), $COLOR_RED)
			Click(150, 550) ;Click away
			Return
		EndIf

		If _Sleep(500) Then Return
		Click(670, 30+325) ;Click request button
		If _Sleep(1000) Then Return
		_CaptureRegion()
		If _ColorCheck(_GetPixelColor(340, 245), Hex(0xCC4010, 6), 20) Then
			If GUICtrlRead($txtRequest) <> "" Then
			Click(430, 140) ;Select text for request
			If _Sleep(1000) Then Return
				$TextRequest = GUICtrlRead($txtRequest)
				ControlSend($Title, "", "", $TextRequest, 0)
			EndIf
			If _Sleep(1000) Then Return
			Click(524, 228); Click Send button
		EndIf
	EndIf
EndFunc   ;==>RequestCC
