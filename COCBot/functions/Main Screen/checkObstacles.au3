;Checks whether something is blocking the pixel for mainscreen and tries to unblock
;Returns True when there is something blocking

Func checkObstacles($Reset= true) ;Checks if something is in the way for mainscreen
	Local $x, $y
	_CaptureRegion()
;SetLog("checkObstacles")
	If _ImageSearchArea($device, 0, 237, 30+321, 293, 30+346, $x, $y, 80) Then
		SetLog(GetLangText("msgAnotherDev") & $itxtReconnect & GetLangText("msgAnotherDevMinutes"), $COLOR_RED)
		If _Sleep($itxtReconnect * 60000) Then Return
		$iTimeTroops = 0
		Click(429, 433);Check for "Another device" message
		If _Sleep(6000) Then Return
		$Checkrearm = True
		ZoomOut()
		Return True
	EndIf

	If _ImageSearch($break, 0, $x, $y, 80) Then
		SetLog(GetLangText("msgTakeBreak"), $COLOR_RED)
		If _Sleep(120000) Then Return ; 2 Minutes
		Click(429, 433);Check for "Take a break" message
		$Checkrearm = True
		Return True
	EndIf
	If _ImageSearch($Inactivity, 0, $x, $y, 80) Then
		SetLog(GetLangText("msgInactivity"), $COLOR_RED)
		If _Sleep(200) Then Return ;
		Click(429, 433);Check for "Take a break" message
		$Checkrearm = True
		Return True
	EndIf
	If _ImageSearch($PersonalBreak, 0, $x, $y, 80) Then
		SetLog(GetLangText("msgPersonalBreak"), $COLOR_RED)
		If _Sleep(3000) Then Return ;
		Click(429, 433);Check for "Take a break" message
		$Checkrearm = True
		Return True
	EndIf

	If _ImageSearch($connectionlost, 0, $x, $y, 80) Then

        	SetLog(GetLangText("msgConnectionLost"), $COLOR_RED)
	        If _Sleep(1000) Then Return ; 1 second
	        Click(429, 433);Check for "Connection Lost" message
	        $Checkrearm = True
	        Return True
	    EndIf
	If _ImageSearch($maintenance, 0, $x, $y, 80) Then

		SetLog(GetLangText("msgMaintenance"), $COLOR_RED)
		If _Sleep(60000) Then Return ; 1 Minutes
		Click(429, 433);Check for "Maintenance break" message
		$Checkrearm = True
		Return True
	EndIf
	
	If _ImageSearch($breakextended, 0, $x, $y, 80) Then

		SetLog(GetLangText("msgBreakextended"), $COLOR_RED)
		If _Sleep(60000) Then Return ; 1 Minutes
		Click(429, 433);Check for "Maintenance break" message
		$Checkrearm = True
		Return True
	EndIf
	
	If _ImageSearch($breakending, 0, $x, $y, 80) Then

		SetLog(GetLangText("msgBreakending"), $COLOR_RED)
		If _Sleep(60000) Then Return ; 1 Minutes
		Click(429, 433);Check for "Maintenance break" message
		$Checkrearm = True
		Return True
	EndIf
	
	$Message = _PixelSearch(457, 300, 458, 330, Hex(0x33B5E5, 6), 10)
	If IsArray($Message) Then
		Click(429, 433);Check for out of sync or inactivity
		If _Sleep(6000) Then Return
		ZoomOut()
		Return True
	EndIf

	_CaptureRegion()
	If _ColorCheck(_GetPixelColor(20+235, 39+209), Hex(0x9E4430, 6), 20) Then
		SetLog("After attack")
		Click(20+429, 30+493);See if village was attacked, clicks Okay
		$Checkrearm = True
		Return True
	EndIf

	If $Reset Then
	Local $RedCrossButton = _WaitForPixel(690, 95, 751, 135, Hex(0xD80407, 6), 5, 0.1) ;Finds Red Cross button in new Overview popup window with 0.2 delay

	If IsArray($RedCrossButton) Then
		SetLog("Army overview is opened")
		ClickP($TopLeftClient) ;Click Away
		Return True
	EndIf
	If  _WaitForColor(698, 160+24, Hex(0xD80408, 6), 16, 0.1) Then
		SetLog("1")
;		ClickP($TopLeftClient, 2, 250)
		Click(698,184) ;Click away If things are open
;		ClickP($TopLeftClient, 2, 250)
		Return True
	EndIf

;for $i =0 to 60
;SetLog($i&":"&_GetPixelColor(20+284, $i+28))
;Next
	If _ColorCheck(_GetPixelColor(20+284, 30+28), Hex(0x215B69, 6), 20) Then
		SetLog("Click away If things are open")
		Click(1, 1) ;Click away If things are open
		Return True
	EndIf
	If _ColorCheck(_GetPixelColor(819, 30+55), Hex(0x682764, 6), 20) Then
		SetLog("Close dialog")
		Click(819, 30+55) ;Clicks X
		Return True
	EndIf
	If _ColorCheck(_GetPixelColor(818, 34), Hex(0xF06468, 6), 20) Then
		SetLog(GetLangText("msgNoNextButton"), $COLOR_RED)
		Click(804, 32) ;Clicks X
		Return True
	EndIf

	If _ColorCheck(_GetPixelColor(822, 30+48), Hex(0xD80408, 6), 20) Or _ColorCheck(_GetPixelColor(830, 30+59), Hex(0xD80408, 6), 20) Then
		SetLog("Close dialog")
		Click(822, 30+48) ;Clicks X
		Return True
	EndIf
	EndIf

	If _ColorCheck(_GetPixelColor(331, 30+330), Hex(0xF0A03B, 6), 20) Then
		SetLog("Close Chat")
		Click(331, 30+330) ;Clicks chat thing
		If _Sleep(1000) Then Return
		Return True
	EndIf

	If _ColorCheck(_GetPixelColor(20+429, 30+519), Hex(0xB8E35F, 6), 20) Then
		SetLog("Defeat or Victory")
		Click(20+429, 30+519) ;If in that victory or defeat scene
		Return True
	EndIf
	If _ColorCheck(_GetPixelColor(801, 392), Hex(0x882B18, 6), 20) Then
		SetLog("During Attack")
		If _Sleep(30000) Then Return ; 1 Minutes
		ClickP($TopLeftClient) ;Click Away
		Return True
	EndIf

	If _ColorCheck(_GetPixelColor(71, 60+530), Hex(0xC00000, 6), 20) Then
		SetLog("End of battle")
		ReturnHome(False, False) ;If End battle is available
		Return True
	EndIf

	If _ColorCheck(_GetPixelColor(36, 60+523), Hex(0xEE5056, 6), 50)  Then
		SetLog("End of battle")
		ReturnHome(False, False) ;If End battle is available ?????
		Return True
	EndIf
	If _ColorCheck(_GetPixelColor(49, 645), Hex(0x7E2B16, 6), 50)  Then
		SetLog("Return Home button")
		Click(67, 60+602);Check if Return Home button available
		Return True
	EndIf
;	$Message = _PixelSearch(19, 60+565, 104, 60+580, Hex(0xD9DDCF, 6), 10)
;	If IsArray($Message) Then
;		SetLog("9")
;		Click(67, 60+602);Check if Return Home button available
;		If _Sleep(2000) Then Return
;		Return True
;	EndIf

	Return False
EndFunc   ;==>checkObstacles
