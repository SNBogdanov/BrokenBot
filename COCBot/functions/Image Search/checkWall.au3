; check Wall function | safar46
Global $checkwalllogic

Global $WallX = 0, $WallY = 0, $WallLoc = 0
Global $Tolerance2


Global $Wall[7][3]
$Wall[0][0] = @ScriptDir & "\images\Walls\4_1.bmp"
$Wall[0][1] = @ScriptDir & "\images\Walls\4_2.bmp"
$Wall[0][2] = @ScriptDir & "\images\Walls\4.png"

$Wall[1][0] = @ScriptDir & "\images\Walls\5_1.bmp"
$Wall[1][1] = @ScriptDir & "\images\Walls\5_2.bmp"
$Wall[1][2] = @ScriptDir & "\images\Walls\5.png"

$Wall[2][0] = @ScriptDir & "\images\Walls\6_1.bmp"
$Wall[2][1] = @ScriptDir & "\images\Walls\6_2.bmp"
$Wall[2][2] = @ScriptDir & "\images\Walls\6.png"

$Wall[3][0] = @ScriptDir & "\images\Walls\7_1.bmp"
$Wall[3][1] = @ScriptDir & "\images\Walls\7_2.bmp"
$Wall[3][2] = @ScriptDir & "\images\Walls\7.png"

$Wall[4][0] = @ScriptDir & "\images\Walls\8_1.bmp"
$Wall[4][1] = @ScriptDir & "\images\Walls\8_2.bmp"
$Wall[4][2] = @ScriptDir & "\images\Walls\8.png"

$Wall[5][0] = @ScriptDir & "\images\Walls\9_1.bmp"
$Wall[5][1] = @ScriptDir & "\images\Walls\9_2.bmp"
$Wall[5][2] = @ScriptDir & "\images\Walls\9.png"

$Wall[6][0] = @ScriptDir & "\images\Walls\10_1.bmp"
$Wall[6][1] = @ScriptDir & "\images\Walls\10_2.bmp"
$Wall[6][2] = @ScriptDir & "\images\Walls\10.png"

Local $WallPos
Local $Walltollerance

Func checkWall()
	_CaptureRegion()
	Local $listArrayPoint = ""
	$ToleranceHere = 20
	$icmbWalls=_GUICtrlComboBox_GetCurSel($cmbWalls)
	Switch _GUICtrlComboBox_GetCurSel($cmbTolerance)
		Case 0
			$Walltollerance = 71
		Case 1
			$Walltollerance = 51
		Case 2
			$Walltollerance = 91
	EndSwitch
	While $ToleranceHere < $Walltollerance
		$ToleranceHere = $ToleranceHere + 10
			For $ImageIndex = 0 To 2
				$WallPos = _ImageSearch($Wall[$icmbWalls][$ImageIndex], 1, $WallX, $WallY, $ToleranceHere) ; Getting Wall Location
				If $WallPos = 1 Then
				$checkwalllogic = True
				SetLog(GetLangText("msgWallFound") & $icmbWalls + 4 & " " & GetLangText("msgWallAt") & " PosX: " & $WallX & ", PosY: " & $WallY & "...", $COLOR_GREEN)
				Return True
				EndIf
			Next
	WEnd
	$checkwalllogic = False
	SetLog(GetLangText("msgWallNotFound") & $icmbWalls + 4 & GetLangText("msgWallSkipUpgrade"), $COLOR_RED)
	If $PushBulletEnabled = 1 Then
		_Push(GetLangText("msgWallNotFound"),GetLangText("msgWallNotFound") & $icmbWalls + 4 & GetLangText("msgWallSkipUpgrade"))
	EndIf
	Return False

EndFunc   ;==>checkWall



Func FindWall()
	_CaptureRegion()
	Local $listArrayPoint = ""
	$ToleranceHere = 20
	$icmbWalls=_GUICtrlComboBox_GetCurSel($cmbWalls)
	If ($ichkForceBS) = 1 And Not WinActive("[CLASS:BlueStacksApp; INSTANCE:1]") And $Hide = False Then WinActivate("[CLASS:BlueStacksApp; INSTANCE:1]");If something blocked BS
	Switch _GUICtrlComboBox_GetCurSel($cmbTolerance)
		Case 0
			$Walltollerance = 71
		Case 1
			$Walltollerance = 51
		Case 2
			$Walltollerance = 91
	EndSwitch
	While $ToleranceHere < $Walltollerance
		$ToleranceHere = $ToleranceHere + 10
			For $ImageIndex = 0 To 2
				$WallPos = _ImageSearch($Wall[$icmbWalls][$ImageIndex], 1, $WallX, $WallY, $ToleranceHere) ; Getting Wall Location
				If $WallPos = 1 Then
				Click($WallX, $WallY)
				SetLog(GetLangText("msgWallFound") & $icmbWalls + 4 & " " & GetLangText("msgWallAt") & " PosX: " & $WallX & ", PosY: " & $WallY & "...", $COLOR_GREEN)
				Return True
				EndIf
			Next
	WEnd
	SetLog(GetLangText("msgWallNotFound") & $icmbWalls + 4 & GetLangText("msgWallAdjustTol"), $COLOR_RED)
	Return False
EndFunc   ;==>FindWall

Func checkWallE()
	_CaptureRegion()
	Local $listArrayPoint = ""
	$icmbWallsE=_GUICtrlComboBox_GetCurSel($cmbWallsE)
	$ToleranceHere = 20
	Switch _GUICtrlComboBox_GetCurSel($cmbTolerance)
		Case 0
			$Walltollerance = 71
		Case 1
			$Walltollerance = 51
		Case 2
			$Walltollerance = 91
	EndSwitch
	While $ToleranceHere < $Walltollerance
		$ToleranceHere = $ToleranceHere + 10
			For $ImageIndex = 0 To 2
				$WallPos = _ImageSearch($Wall[$icmbWallsE+4][$ImageIndex], 1, $WallX, $WallY, $ToleranceHere) ; Getting Wall Location
				If $WallPos = 1 Then
					$checkwalllogic = True
					SetLog(GetLangText("msgWallFound") & $icmbWallsE + 8 & " " & GetLangText("msgWallAt") & " PosX: " & $WallX & ", PosY: " & $WallY & "...", $COLOR_GREEN)
					Return True
				EndIf
			Next
	WEnd
	$checkwalllogic = False
	SetLog(GetLangText("msgWallNotFound") & $icmbWallsE + 8 & GetLangText("msgWallSkipUpgrade"), $COLOR_RED)
	If $PushBulletEnabled = 1 Then
		_Push(GetLangText("msgWallNotFound"),GetLangText("msgWallNotFound") & $icmbWallsE + 8 & GetLangText("msgWallSkipUpgrade"))
	EndIf
	Return False
EndFunc   ;==>checkWall

Func FindWallE()
	_CaptureRegion()
	Local $listArrayPoint = ""
	$ToleranceHere = 20
	$icmbWallsE=_GUICtrlComboBox_GetCurSel($cmbWallsE)
	If ($ichkForceBS) = 1 And Not WinActive("[CLASS:BlueStacksApp; INSTANCE:1]") And $Hide = False Then WinActivate("[CLASS:BlueStacksApp; INSTANCE:1]");If something blocked BS
	Switch _GUICtrlComboBox_GetCurSel($cmbTolerance)
		Case 0
			$Walltollerance = 71
		Case 1
			$Walltollerance = 51
		Case 2
			$Walltollerance = 91
	EndSwitch
	While $ToleranceHere < $Walltollerance
		$ToleranceHere = $ToleranceHere + 10
			For $ImageIndex = 0 To 2
				$WallPos = _ImageSearch($Wall[$icmbWallsE+4][$ImageIndex], 1, $WallX, $WallY, $ToleranceHere) ; Getting Wall Location
				If $WallPos = 1 Then
				Click($WallX, $WallY)
				SetLog(GetLangText("msgWallFound") & $icmbWallsE + 8 & " " & GetLangText("msgWallAt") & " PosX: " & $WallX & ", PosY: " & $WallY & "...", $COLOR_GREEN)
				Return True
				EndIf
			Next
	WEnd
	SetLog(GetLangText("msgWallNotFound") & $icmbWallsE + 8 & GetLangText("msgWallAdjustTol"), $COLOR_RED)
	Return False
EndFunc   ;==>FindWall 

