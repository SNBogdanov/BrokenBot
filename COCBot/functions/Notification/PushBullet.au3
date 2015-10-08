#include <Array.au3>
#include <String.au3>

Func _RemoteControl()
	$oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
	$access_token = $PushBullettoken
	$oHTTP.Open("Get", "https://api.pushbullet.com/v2/pushes?active=true&limit=3", False)
	$oHTTP.SetCredentials($access_token, "", 0)
	$oHTTP.SetRequestHeader("Content-Type", "application/json")
	$oHTTP.SetTimeouts(5000,5000,5000,5000)
	$oHTTP.Send()
	If @error Then Return
	$Result = $oHTTP.ResponseText

	If StringInStr(StringLower($Result), '"body":"bot') Then
		Local $title = _StringBetween($Result, '"body":"', '"', "", False)
		Local $iden = _StringBetween($Result, '"iden":"', '"', "", False)
		For $x = 0 To UBound($title) - 1
			If $title <> "" Or $iden <> "" Then
				$title[$x] = StringUpper(StringStripWS($title[$x], $STR_STRIPLEADING + $STR_STRIPTRAILING + $STR_STRIPSPACES))
				$iden[$x] = StringStripWS($iden[$x], $STR_STRIPLEADING + $STR_STRIPTRAILING + $STR_STRIPSPACES)
				If StringLeft($title[$x], 8) = "BOT HELP" Then
					SetLog(GetLangText("msgPBHelpSent"))
					_Push(GetLangText("pushHRa"), GetLangText("pushHRb") & _
																			  "\n\n----Additional Commands----\n\n" & _
																  "Warning: BrokenBot will follow these commands without considering what it is currently doing, even if it is in the middle of an ongoing attack\n\n" & _
															"[o] Stop - Stop BrokenBot, close BlueStacks and leave BrokenBot open\n" & _
															"[o] Start - Start BrokenBot. Bot must be left open to start it with this command.\n" & _
															"[o] Reset - Reset statistics" & _
															"[o] RestartBS - Restart BlueStacks\n" & _
															"[o] RestartBot - Restart BrokenBot\n" & _
															"[o] Restart - Restart BlueStacks and BrokenBot\n" & _
															"[o] ManualRestart - Use this in case your logs show that a manual restart is required. This will fully close BrokenBot and BlueStacks and then start BrokenBot again. Be warned: bot will start with the first available strategy in alphabetical order.\n" & _
															"[Note] The command ManualRestart will work with BrokenBot.au3 without any extra effort, but to use it with BrokenBot.exe, you need to compile the file RestartBrokenBot.au3 into RestartBrokenBot.exe"
																			  "\n\n----Danger Zone----\n\n" & _
																  "The following commands will make BrokenBot inaccessible\n\n" & _
															"[o] Quit - Close BlueStacks and BrokenBot\n" & _
															"[o] Sleep - Put your computer into sleep/suspend mode\n" & _
															"[o] Shutdown - Shut down your computer" & _)
					_DeleteMessage($iden[$x])
				ElseIf StringLeft($title[$x], 9) = "BOT PAUSE" And StringStripWS(StringRight($title[$x], StringLen($title[$x]) - 9), 3) = StringUpper(StringStripWS(GUICtrlRead($inppushuser), 3)) Then
					If $PauseBot = False Then
						SetLog(GetLangText("msgPBBotPauseFuture"))
						_Push(GetLangText("pushPRa"), GetLangText("pushPRb"))
						$PauseBot = True
					Else
						SetLog(GetLangText("msgPBNoAction"))
						_Push(GetLangText("pushPRa"), GetLangText("pushPRc"))
					EndIf
					_DeleteMessage($iden[$x])
				ElseIf StringLeft($title[$x], 10) = "BOT RESUME" And StringStripWS(StringRight($title[$x], StringLen($title[$x]) - 10), 3) = StringUpper(StringStripWS(GUICtrlRead($inppushuser), 3)) Then
					If $PauseBot = True Then
						SetLog(GetLangText("msgPBResumed"))
						_Push(GetLangText("pushRRa"), GetLangText("pushRRb"))
						$PauseBot = False
						If GUICtrlRead($btnPause) = "Resume" Then btnPause()
					Else
						SetLog(GetLangText("msgPBRunning"))
						_Push(GetLangText("pushRRa"), GetLangText("pushRRc"))
					EndIf
					_DeleteMessage($iden[$x])
				ElseIf StringLeft($title[$x], 9) = "BOT STATS" And StringStripWS(StringRight($title[$x], StringLen($title[$x]) - 9), 3) = StringUpper(StringStripWS(GUICtrlRead($inppushuser), 3)) Then
					SetLog(GetLangText("msgPBStats"))
					_Push(GetLangText("pushStatRa"), _PushStatisticsString())
					_DeleteMessage($iden[$x])
				ElseIf StringLeft($title[$x], 9) = "BOT RESET" And StringStripWS(StringRight($title[$x], StringLen($title[$x]) - 9), 3) = StringUpper(StringStripWS(GUICtrlRead($inppushuser), 3)) Then
        				StatusCheck()
					SetLog("Your request has been received. Resetting statistics.")
					_Push("Request to Reset Statistics", "Report of status before resetting statistics:\n\n" & _PushStatisticsString())
					$GoldStart=0
					$GoldUpgraded=0
					$ElixirStart=0
					$ElixirUpgraded=0
					$DarkStart=0
					$DarkUpgraded=0
					$TropyStart=0
				        $GoldCount = Number(ReadText(666, 25, 138, $textMainScreen, 0))
					$ElixirCount = Number(ReadText(666, 76, 138, $textMainScreen, 0))
				        If _ColorCheck(_GetPixelColor(718, 131), Hex(0xF8FCFF, 6), 40) Then
				        ; No DE
						$GemCount = Number(ReadText(736, 124, 68, $textMainScreen, 0))
        				Else
            					$DarkCount = Number(ReadText(711, 125, 93, $textMainScreen, 0))
            					$GemCount = Number(ReadText(736, 173, 68, $textMainScreen, 0))
        				EndIf
        				$TrophyCount = Number(ReadText(59, 75, 60, $textMainScreen))

					GUICtrlSetData($lblwallupgradecount, 0)
					GUICtrlSetData($lblresultsearchcost, 0)
					GUICtrlSetData($lblresultvillagesskipped,0)
					GUICtrlSetData($lblresultvillagesattacked,0)
					GUICtrlSetData($lblresultsearchdisconnected,0)
					UpdateStat($GoldCount,$ElixirCount,$DarkCount,$TrophyCount)
					$PushBulletvillagereportTimer = TimerInit()
					_DeleteMessage($iden[$x])
					If IsChecked($lblpushbulletenabled) And IsChecked($lblpushbulletdelete) Then
						_DeletePush()
					EndIf
				ElseIf StringLeft($title[$x], 8) = "BOT LOGS" And StringStripWS(StringRight($title[$x], StringLen($title[$x]) - 8), 3) = StringUpper(StringStripWS(GUICtrlRead($inppushuser), 3)) Then
					SetLog(GetLangText("msgPBLog"))
					_PushFile($sLogFileName, "logs", "text/plain; charset=utf-8", "Current Logs", $sLogFileName)
					_DeleteMessage($iden[$x])
			    ElseIf StringLeft($title[$x], 13) = "BOT RESTARTBS" And StringStripWS(StringRight($title[$x], StringLen($title[$x]) - 13), 3) = StringUpper(StringStripWS(GUICtrlRead($inppushuser), 3)) Then
					SetLog("Your request has been received. Restarting BlueStacks now.")
					_DeleteMessage($iden[$x])
					restartBlueStack()
				ElseIf StringLeft($title[$x], 14) = "BOT RESTARTBOT" And StringStripWS(StringRight($title[$x], StringLen($title[$x]) - 14), 3) = StringUpper(StringStripWS(GUICtrlRead($inppushuser), 3)) Then
					SetLog("Your request has been received. Restarting BrokenBot now.")
					_Push("Request to Restart", "Restarting BrokenBot")
					_DeleteMessage($iden[$x])
					btnStop()
					btnStart()
				 ElseIf StringLeft($title[$x], 11) = "BOT RESTART" And StringStripWS(StringRight($title[$x], StringLen($title[$x]) - 11), 3) = StringUpper(StringStripWS(GUICtrlRead($inppushuser), 3)) Then
					SetLog("Your request has been received. Restarting BlueStacks and BrokenBot now.")
					_Push("Request to Restart", "Restarting BlueStack and BrokenBot")
					_DeleteMessage($iden[$x])
					restartBlueStack()
					btnStop()
					btnStart()
				 ElseIf StringLeft($title[$x], 9) = "BOT SLEEP" And StringStripWS(StringRight($title[$x], StringLen($title[$x]) - 9), 3) = StringUpper(StringStripWS(GUICtrlRead($inppushuser), 3)) Then
					SetLog("Your request has been received. Putting your PC to Sleep.")
					_Push("Request to Sleep", "Putting your computer to Sleep. No command can be accepted after this.")
					_DeleteMessage($iden[$x])
					Shutdown(32)
					btnStop()
				 ElseIf StringLeft($title[$x], 12) = "BOT SHUTDOWN" And StringStripWS(StringRight($title[$x], StringLen($title[$x]) - 12), 3) = StringUpper(StringStripWS(GUICtrlRead($inppushuser), 3)) Then
					SetLog("Your request has been received. Your computer will be switched off.")
					_Push("Request to Shut down", "Switching off your computer. No command can be accepted after this.")
					_DeleteMessage($iden[$x])
					Shutdown(5)
					btnStop()
				 ElseIf StringLeft($title[$x], 8) = "BOT QUIT" And StringStripWS(StringRight($title[$x], StringLen($title[$x]) - 8), 3) = StringUpper(StringStripWS(GUICtrlRead($inppushuser), 3)) Then
					SetLog("Your request has been received. BrokenBot will close BlueStacks and quit.")
					_Push("Request to Quit", "Closing BlueStacks and BrokenBot. No command can be accepted after this.")
					_DeleteMessage($iden[$x])
					ProcessClose("HD-Frontend.exe")
					SetLog(GetLangText("msgExit"), $COLOR_ORANGE)
					DllClose($KernelDLL)
					_GDIPlus_Shutdown()
					_Crypt_Shutdown()
					btnUPsave()
					ModSave()
					Exit
				 ElseIf StringLeft($title[$x], 17) = "BOT MANUALRESTART" And StringStripWS(StringRight($title[$x], StringLen($title[$x]) - 17), 3) = StringUpper(StringStripWS(GUICtrlRead($inppushuser), 3)) Then
					SetLog("Your request has been received. Attempting to close and start BrokenBot afresh.", $COLOR_ORANGE)
					_DeleteMessage($iden[$x])
					$restartBrokenBot = "not_set"
					If (@Compiled) Then
					   If FileExists(@ScriptDir & "\COCBot\functions\Notification\RestartBrokenBot.exe") Then
						  $restartBrokenBot = '"' & @ScriptDir & "\COCBot\functions\Notification\RestartBrokenBot.exe" & '"' & " " & '"' & $sBotTitle & '"' & " " & '"' & @ScriptFullPath & '"' & " " & " 1"
					   Else
						  SetLog("BrokenBot could not perform the requested action. Please compile the file " & @ScriptDir & "\COCBot\functions\Notification\RestartBrokenBot.au3 if you want to use this command with the compiled version of BrokenBot.", $COLOR_ORANGE)
;~ 						  _Push("BrokenBot could not perform the requested action.", "Please compile the file " & @ScriptDir & "\COCBot\functions\Notification\RestartBrokenBot.au3 if you want to use this command with the compiled version of BrokenBot.")
					   EndIf
					Else
						$restartBrokenBot = '"' & @AutoItExe & '"' & " " & '"' & @ScriptDir & "\COCBot\functions\Notification\RestartBrokenBot.au3" & '"' & " " & '"' & $sBotTitle & '"' & " " & '"' & @ScriptFullPath & '"' & " " & " 0"
					EndIf
					If (Not ($restartBrokenBot = "not_set")) Then
					   SetLog("Running command: " & $restartBrokenBot)
					   _Push("Attempting to Restart", "The message 'Bot Start' will be automatically deleted if the Bot restarts successfully.")
					   _PushStartMessage()
					   Run($restartBrokenBot)
					Else
					   _Push("Request to Restart failed", "Please compile the file RestartBrokenBot.au3 if you want to use this command with the compiled version of BrokenBot.")
					EndIf
				 ElseIf StringLeft($title[$x], 8) = "BOT STOP" And StringStripWS(StringRight($title[$x], StringLen($title[$x]) - 8), 3) = StringUpper(StringStripWS(GUICtrlRead($inppushuser), 3)) Then
					SetLog("Your request has been received. BrokenBot will be stopped.")
					_Push("Request to Stop", "Stopping BrokenBot, closing BlueStacks and leaving BrokenBot open.")
					_DeleteMessage($iden[$x])
					ProcessClose("HD-Frontend.exe")
					btnStop()
				 ElseIf StringLeft($title[$x], 9) = "BOT START" And StringStripWS(StringRight($title[$x], StringLen($title[$x]) - 9), 3) = StringUpper(StringStripWS(GUICtrlRead($inppushuser), 3)) Then
					SetLog("Your request has been received. BrokenBot will be started.")
					_Push("Request to Start", "Starting BrokenBot")
					_DeleteMessage($iden[$x])
					btnStart()
				 EndIf
				$title[$x] = ""
				$iden[$x] = ""
			EndIf
		Next
	EndIf
EndFunc   ;==>_RemoteControl

Func _PushBullet($pTitle = "", $pMessage = "")
	$oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
	$access_token = $PushBullettoken
	$oHTTP.Open("Get", "https://api.pushbullet.com/v2/devices", False)
	$oHTTP.SetCredentials($access_token, "", 0)
	$oHTTP.Send()
	$Result = $oHTTP.ResponseText
	Local $device_iden = _StringBetween($Result, 'iden":"', '"')
	Local $device_name = _StringBetween($Result, 'nickname":"', '"')
EndFunc   ;==>_PushBullet

Func _Push($pTitle, $pMessage)
	Local $Date = _NowDate()
	Local $Time = _NowTime()
	If StringStripWS(GUICtrlRead($inppushuser), 3) <> "" Then $pTitle = "[" & StringStripWS(GUICtrlRead($inppushuser), 3) & "] " & $pTitle
	$oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
	$access_token = $PushBullettoken
	$oHTTP.Open("Post", "https://api.pushbullet.com/v2/pushes", False)
	$oHTTP.SetCredentials($access_token, "", 0)
	$oHTTP.SetRequestHeader("Content-Type", "application/json")
	$pMessage = $Date & " at " & $Time & "\n" & $pMessage
	Local $pPush = '{"type": "note", "title": "' & $pTitle & '", "body": "' & $pMessage & '","dismissable": true}'
	$oHTTP.Send($pPush)
EndFunc   ;==>_Push

Func _PushFile($File, $Folder, $FileType, $title, $body)
	If StringStripWS(GUICtrlRead($inppushuser), 3) <> "" Then $title = "[" & StringStripWS(GUICtrlRead($inppushuser), 3) & "] " & $title
	$oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
	$access_token = $PushBullettoken
	$oHTTP.Open("Post", "https://api.pushbullet.com/v2/upload-request", False)
	$oHTTP.SetCredentials($access_token, "", 0)
	$oHTTP.SetRequestHeader("Content-Type", "application/json")

	Local $pPush = '{"file_name": "' & $File & '", "file_type": "' & $FileType & '"}'
	$oHTTP.Send($pPush)
	$Result = $oHTTP.ResponseText
	$Result1 = $Result
	Local $upload_url = _StringBetween($Result, 'upload_url":"', '"')
	Local $awsaccesskeyid = _StringBetween($Result, 'awsaccesskeyid":"', '"')
	Local $acl = _StringBetween($Result, 'acl":"', '"')
	Local $key = _StringBetween($Result, 'key":"', '"')
	Local $signature = _StringBetween($Result, 'signature":"', '"')
	Local $policy = _StringBetween($Result, 'policy":"', '"')
	Local $file_url = _StringBetween($Result, 'file_url":"', '"')

	If IsArray($upload_url) And IsArray($awsaccesskeyid) And IsArray($acl) And IsArray($key) And IsArray($signature) And IsArray($policy) Then
		$Result = RunWait(@ScriptDir & "\curl\curl.exe -i -X POST " & $upload_url[0] & ' -F awsaccesskeyid="' & $awsaccesskeyid[0] & '" -F acl="' & $acl[0] & '" -F key="' & $key[0] & '" -F signature="' & $signature[0] & '" -F policy="' & $policy[0] & '" -F content-type="' & $FileType & '" -F file=@"' & @ScriptDir & '\' & $Folder & '\' & $File & '" -o "' & @ScriptDir & '\logs\curl.log"', "", @SW_HIDE)
		If Not FileExists($dirLogs & "curl.log") Then _FileCreate($dirLogs & "curl.log")
		If IsChecked($lblpushbulletdebug) Then
			SetLog('=========================================================================')
			SetLog($Result)
			SetLog($upload_url[0])
			SetLog($acl[0])
			SetLog($key[0])
			SetLog($signature[0])
			SetLog($policy[0])
			SetLog($awsaccesskeyid[0])
			SetLog($file_url[0])
			SetLog($Result1)
			SetLog(@ScriptDir & "\curl\curl.exe -i -X POST " & $upload_url[0] & ' -F awsaccesskeyid="' & $awsaccesskeyid[0] & '" -F acl="' & $acl[0] & '" -F key="' & $key[0] & '" -F signature="' & $signature[0] & '" -F policy="' & $policy[0] & '" -F content-type="' & $FileType & '" -F file=@"' & @ScriptDir & '\' & $Folder & '\' & $File & '" -o "' & @ScriptDir & '\logs\curl.log"')
		EndIf
		If Not FileExists($dirLogs & "curl.log") Then _FileCreate($dirLogs & "curl.log")
		If _FileCountLines(@ScriptDir & '\logs\curl.log') > 8 Then
            Local $hFileOpen = FileOpen(@ScriptDir & '\logs\curl.log')
            Local $sFileRead = FileReadLine($hFileOpen, 3)
            Local $sFileRead1 = StringSplit($sFileRead, " ")
            Local $sLink = $sFileRead1[2]
            Local $fLink = $file_url[0]
            Local $findstr1 = StringRegExp($sLink, '204')
            If $findstr1 = 1 Then
                $oHTTP.Open("Post", "https://api.pushbullet.com/v2/pushes", False)
                $oHTTP.SetCredentials($access_token, "", 0)
                $oHTTP.SetRequestHeader("Content-Type", "application/json")
                ;Local $pPush = '{"type": "file", "file_name": "' & $FileName & '", "file_type": "' & $FileType & '", "file_url": "' & $file_url[0] & '", "title": "' & $title & '", "body": "' & $body & '"}'
                Local $pPush = '{"type": "file", "file_name": "' & $File & '", "file_type": "' & $FileType & '", "file_url": "' & $fLink & '", "title": "' & $title & '", "body": "' & $body & '"}'
                $oHTTP.Send($pPush)
                $Result = $oHTTP.ResponseText
			Else
				If IsChecked($lblpushbulletdebug) Then
					SetLog($hFileOpen)
					SetLog(GetLangText("msgPBErrorUpload"))
				EndIf
			EndIf
		Else
			If IsChecked($lblpushbulletdebug) Then
				SetLog(GetLangText("msgPBErrorUploading"))
			EndIf
		EndIf
	Else
		If IsChecked($lblpushbulletdebug) Then
			SetLog('=========================================================================')
			SetLog('Malformed HTTP response:')
			SetLog($Result)
		EndIf
	EndIf
	If IsChecked($lblpushbulletdebug) Then
		SetLog($Result)
		SetLog(GetLangText("msgPBPasteForum"))
		SetLog('=========================================================================')
	EndIf
EndFunc   ;==>_PushFile

Func _DeletePush()
	$oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
	$access_token = $PushBullettoken
	$oHTTP.Open("Delete", "https://api.pushbullet.com/v2/pushes", False)
	$oHTTP.SetCredentials($access_token, "", 0)
	$oHTTP.SetRequestHeader("Content-Type", "application/json")
	$oHTTP.Send()
EndFunc   ;==>_DeletePush

Func _DeleteMessage($iden)
	$oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
	$access_token = $PushBullettoken
	$oHTTP.Open("Delete", "https://api.pushbullet.com/v2/pushes/" & $iden, False)
	$oHTTP.SetCredentials($access_token, "", 0)
	$oHTTP.SetRequestHeader("Content-Type", "application/json")
	$oHTTP.Send()
EndFunc   ;==>_DeleteMessage

Func _PushStartMessage()
    $pMessage = "Bot Start"
	If StringStripWS(GUICtrlRead($inppushuser), 3) <> "" Then $pMessage = $pMessage & " " & StringStripWS(GUICtrlRead($inppushuser), 3)
	$oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
	$access_token = $PushBullettoken
	$oHTTP.Open("Post", "https://api.pushbullet.com/v2/pushes", False)
	$oHTTP.SetCredentials($access_token, "", 0)
	$oHTTP.SetRequestHeader("Content-Type", "application/json")
	Local $pPush = '{"type": "note", "title": "' & "" & '", "body": "' & $pMessage & '","dismissable": true}'
	$oHTTP.Send($pPush)
EndFunc   ;==>_PushStartMessage

Func _PushStatisticsString()
   If (StringInStr($sBotVersion,"SNBogdanov")) Then
	  Return GetLangText("PushStatRb") & GUICtrlRead($lblresultgoldtstart)& _
			GetLangText("pushStatRc") & GUICtrlRead($lblresultelixirstart) & _
			GetLangText("pushStatRd") & GUICtrlRead($lblresultdestart) & _
			GetLangText("pushStatRe") & GUICtrlRead($lblresulttrophystart) & _
			GetLangText("pushStatRf") & GUICtrlRead($lblresultgoldnow) & _
			GetLangText("pushStatRg") & GUICtrlRead($lblresultelixirnow) & _
			GetLangText("pushStatRh") & GUICtrlRead($lblresultdenow) & _
			GetLangText("pushStatRi") & GUICtrlRead($lblresulttrophynow) & _
			GetLangText("pushStatRl") & GUICtrlRead($lblresultgoldgain) & _
			"\nGold/hr:  " & GUICtrlRead($lblresultavggoldgain) & _
			GetLangText("pushStatRm") & GUICtrlRead($lblresultelixirgain) & _
			"\nElixir/hr:  " & GUICtrlRead($lblresultavgelixirgain) & _
			GetLangText("pushStatRn") & GUICtrlRead($lblresultdegain) & _
			"\nDark Elixir/hr:  " & GUICtrlRead($lblresultavgdegain) & _
			GetLangText("pushStatRo") & GUICtrlRead($lblresulttrophygain) & _
			GetLangText("pushStatRp") & GUICtrlRead($lblresultvillagesattacked) & _
			GetLangText("pushStatRq") & GUICtrlRead($lblresultvillagesskipped) & _
			GetLangText("pushStatRq1") & GUICtrlRead($lblresultsearchdisconnected) & _
			GetLangText("pushStatRr") & GUICtrlRead($lblresultsearchcost) & _
			GetLangText("pushStatRk") & GUICtrlRead($lblwallupgradecount) & _
			GetLangText("pushStatRs") & StringFormat("%02i:%02i:%02i", $hour, $min, $sec)
   Else
	  Return GetLangText("PushStatRb") & GUICtrlRead($lblresultgoldtstart)& _
			GetLangText("pushStatRc") & GUICtrlRead($lblresultelixirstart) & _
			GetLangText("pushStatRd") & GUICtrlRead($lblresultdestart) & _
			GetLangText("pushStatRe") & GUICtrlRead($lblresulttrophystart) & _
			GetLangText("pushStatRf") & GUICtrlRead($lblresultgoldnow) & _
			GetLangText("pushStatRg") & GUICtrlRead($lblresultelixirnow) & _
			GetLangText("pushStatRh") & GUICtrlRead($lblresultdenow) & _
			GetLangText("pushStatRi") & GUICtrlRead($lblresulttrophynow) & _
			GetLangText("pushStatRl") & GUICtrlRead($lblresultgoldgain) & _
			GetLangText("pushStatRm") & GUICtrlRead($lblresultelixirgain) & _
			GetLangText("pushStatRn") & GUICtrlRead($lblresultdegain) & _
			GetLangText("pushStatRo") & GUICtrlRead($lblresulttrophygain) & _
			GetLangText("pushStatRp") & GUICtrlRead($lblresultvillagesattacked) & _
			GetLangText("pushStatRq") & GUICtrlRead($lblresultvillagesskipped) & _
			GetLangText("pushStatRq1") & GUICtrlRead($lblresultsearchdisconnected) & _
			GetLangText("pushStatRr") & GUICtrlRead($lblresultsearchcost) & _
			GetLangText("pushStatRk") & GUICtrlRead($lblwallupgradecount) & _
			GetLangText("pushStatRs") & StringFormat("%02i:%02i:%02i", $hour, $min, $sec)
   EndIf
EndFunc   ;==>_PushStatisticsString