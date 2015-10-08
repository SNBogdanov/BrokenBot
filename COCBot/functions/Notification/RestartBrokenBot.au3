#cs ----------------------------------------------------------------------------
 AutoIt Version: 3.3.14.2
 Author:         lockintosh
#ce ----------------------------------------------------------------------------

#RequireAdmin

$botTitle = $CmdLine[1]		;$sBotTitle
$botFile = $CmdLine[2]		;@ScriptFullPath
$botCompiled = $CmdLine[3]	;@Compiled

Do
   WinClose(WinGetHandle($botTitle))
   Sleep(500)
Until Not (WinExists($botTitle))

Sleep(500)

ProcessClose("HD-Frontend.exe")						;Close BlueStacks

If ($botCompiled = 1) Then
   Run('"' & $botFile & '"')							;Open BrokenBot
Else
   Run('"' & @AutoItExe & '"' & " " & '"' & $botFile & '"')
EndIf