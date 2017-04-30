;Reads config file and sets variables

Func readConfig() ;Reads config and sets it to the variables
	;---------------------------------------------------------------------------------------
	; Main settings ------------------------------------------------------------------------
	;---------------------------------------------------------------------------------------
	$MinElixirToTrain = IniRead($config, "general", "MinElixirToTrain", "150000")
	$itxtMinTrophy = IniRead($config, "general", "MinTrophy", "0")
	$itxtMaxTrophy = IniRead($config, "general", "MaxTrophy", "3000")
	GUICtrlSetData($txtSnipeBelow, IniRead($config, "general", "MinSnipe", "0"))
	$ichkBotStop = IniRead($config, "general", "BotStop", "0")
	$icmbBotCommand = IniRead($config, "general", "Command", "0")
	$icmbBotCond = IniRead($config, "general", "Cond", "0")
	$ichkNoAttack = IniRead($config, "general", "NoAttack", "0")
	$ichkDonateOnly = IniRead($config, "general", "DonateOnly", "0")
	If IniRead($config, "general", "MixedExpMode", "0") = 1 Then
		GUICtrlSetState($mixmodenormexp, $GUI_CHECKED)
	Else
		GUICtrlSetState($mixmodenormexp, $GUI_UNCHECKED)
	EndIf
	;---------------------------------------------------------------------------------------
	; Attack settings ----------------------------------------------------------------------
	;---------------------------------------------------------------------------------------
	_GUICtrlComboBox_SetCurSel($cmbUnitDelay, IniRead($config, "attack", "UnitD", "0"))
	_GUICtrlComboBox_SetCurSel($cmbWaveDelay, IniRead($config, "attack", "WaveD", "0"))

	;---------------------------------------------------------------------------------------
	; Donate settings ----------------------------------------------------------------------
	;---------------------------------------------------------------------------------------
	$ichkRequest = IniRead($config, "donate", "chkRequest", "0")
	$itxtRequest = IniRead($config, "donate", "txtRequest", "")
	$ichkDonateBarbarians = IniRead($config, "donate", "chkDonateBarbarians", "0")
	$ichkDonateAllBarbarians = IniRead($config, "donate", "chkDonateAllBarbarians", "0")
	$itxtDonateBarbarians = StringReplace(IniRead($config, "donate", "txtDonateBarbarians", "barbarians|barb|any"), "|", @CRLF)
	$ichkDonateArchers = IniRead($config, "donate", "chkDonateArchers", "0")
	$ichkDonateAllArchers = IniRead($config, "donate", "chkDonateAllArchers", "0")
	$itxtDonateArchers = StringReplace(IniRead($config, "donate", "txtDonateArchers", "archers|arch|any"), "|", @CRLF)
	$ichkDonateGiants = IniRead($config, "donate", "chkDonateGiants", "0")
	$ichkDonateAllGiants = IniRead($config, "donate", "chkDonateAllGiants", "0")
	$itxtDonateGiants = StringReplace(IniRead($config, "donate", "txtDonateGiants", "giants|giant|any"), "|", @CRLF)
	If IniRead($config, "donate", "chkBlacklist", "0") = 1 Then
		GUICtrlSetState($chkBlacklist, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkBlacklist, $GUI_UNCHECKED)
	EndIf
	GUICtrlSetData($txtBlacklist, StringReplace(IniRead($config, "donate", "txtBlacklist", ""), "|", @CRLF))

	;---------------------------------------------------------------------------------------
	; Upgrade settings ---------------------------------------------------------------------
	;---------------------------------------------------------------------------------------
	$ichkWalls = IniRead($config, "upgrade", "auto-wall", "0")
	$icmbWalls = IniRead($config, "upgrade", "walllvlG", "0")
	$icmbWallsE = IniRead($config, "upgrade", "walllvlE", "0")
	$iWallUseGold = IniRead($config,"upgrade","wallusegold","0")
	$iWallUseElixer = IniRead($config,"upgrade","walluseelix","0")
	$itxtWallMinGold = IniRead($config, "upgrade", "minwallgold", "0")
	$itxtWallMinElixir = IniRead($config, "upgrade", "minwallelixir", "0")
	$icmbTolerance = IniRead($config, "upgrade", "walltolerance", "0")

	;UpgradeHeroes
	$ichkUpgradeKing = IniRead($config, "Upgrade", "UpKing", "0")	;==>upgradeking
	$ichkUpgradeQueen = IniRead($config, "Upgrade", "UpQueen", "0")	;==>upgradequeen
	$itxtKeepFreeBuilder = IniRead($config, "Upgrade", "KeepFreeBuilder", "1") ;==>FreeBuilderBox

	$iinpUPMinimumGold= IniRead($config, "Upgrade", "UpgradeMinimumGold", "0")
	$iinpUPMinimumElixir= IniRead($config, "Upgrade", "UpgradeMinimumElixir", "0")

	;Laboratory
	$ichkLab = IniRead($config, "upgrade", "auto-uptroops", "0")
	$icmbLaboratory = IniRead($config, "upgrade", "troops-name", "0")


;	$ichkUpgrade1 = IniRead($config, "upgrade", "auto-upgrade1", "0")
;	$ichkUpgrade2 = IniRead($config, "upgrade", "auto-upgrade2", "0")
;	$ichkUpgrade3 = IniRead($config, "upgrade", "auto-upgrade3", "0")
;
;	$itxtUpgradeX1 = IniRead($config, "upgrade", "PosX1", "")
;	$itxtUpgradeY1 = IniRead($config, "upgrade", "PosY1", "")
;	if $ichkUpgrade1=0 Or $itxtUpgradeX1 = "" Or $itxtUpgradeY1 ="" Then
;		$ichkUpgrade1=0
;		$itxtUpgradeX1 = ""
;		$itxtUpgradeY1 =""
;	EndIf
;	$itxtUpgradeX2 = IniRead($config, "upgrade", "PosX2", "")
;	$itxtUpgradeY2 = IniRead($config, "upgrade", "PosY2", "")
;	if $ichkUpgrade2=0 Or $itxtUpgradeX2 = "" Or $itxtUpgradeY2 ="" Then
;		$ichkUpgrade2=0
;		$itxtUpgradeX2 = ""
;		$itxtUpgradeY2 =""
;	EndIf
;	$itxtUpgradeX3 = IniRead($config, "upgrade", "PosX3", "")
;	$itxtUpgradeY3 = IniRead($config, "upgrade", "PosY3", "")
;	if $ichkUpgrade3=0 Or $itxtUpgradeX3 = "" Or $itxtUpgradeY3 ="" Then
;		$ichkUpgrade3=0
;		$itxtUpgradeX3 = ""
;		$itxtUpgradeY3 =""
;	EndIf
;	If $ichkUpgrade1 = 1 Then
;       	GUICtrlSetState($chkUpgrade1, $GUI_CHECKED)
;		GUICtrlSetState($btnLocateUp1, $GUI_ENABLE)
;	Else
;	        GUICtrlSetState($chkUpgrade1, $GUI_UNCHECKED)
;		GUICtrlSetState($btnLocateUp1, $GUI_DISABLE)
;	EndIf
;	GUICtrlSetData($txtUpgradeX1, $itxtUpgradeX1)
;	GUICtrlSetData($txtUpgradeY1, $itxtUpgradeY1)
;
;	If $ichkUpgrade2 = 1 Then
;	        GUICtrlSetState($chkUpgrade2, $GUI_CHECKED)
;		GUICtrlSetState($btnLocateUp2, $GUI_ENABLE)
;	Else
;	        GUICtrlSetState($chkUpgrade2, $GUI_UNCHECKED)
;		GUICtrlSetState($btnLocateUp2, $GUI_DISABLE)
;	EndIf
;	GUICtrlSetData($txtUpgradeX2, $itxtUpgradeX2)
;	GUICtrlSetData($txtUpgradeY2, $itxtUpgradeY2)
;
;	If $ichkUpgrade3 = 1 Then
;	        GUICtrlSetState($chkUpgrade3, $GUI_CHECKED)
;		GUICtrlSetState($btnLocateUp3, $GUI_ENABLE)
;	Else
;	        GUICtrlSetState($chkUpgrade3, $GUI_UNCHECKED)
;		GUICtrlSetState($btnLocateUp3, $GUI_DISABLE)
;	EndIf
;	GUICtrlSetData($txtUpgradeX3, $itxtUpgradeX3)
;	GUICtrlSetData($txtUpgradeY3, $itxtUpgradeY3)
;
	;---------------------------------------------------------------------------------------
	; Notification settings ----------------------------------------------------------------
	;---------------------------------------------------------------------------------------
	$PushBulletEnabled = IniRead($config, "notification", "pushbullet", "0")
	$PushBullettoken = IniRead($config, "notification", "accounttoken", "")
	$PushBullettype = IniRead($config, "notification", "lastraidtype", "0")
	$PushBulletattacktype = IniRead($config, "notification", "attackimage", "0")
	$PushBulletvillagereport = IniRead($config, "notification", "villagereport", "0")
	$PushBulletchatlog = IniRead($config, "notification", "chatlog", "0")
	$PushBulletmatchfound = IniRead($config, "notification", "matchfound", "0")
	$PushBulletlastraid = IniRead($config, "notification", "lastraid", "0")
	$PushBulletdebug = IniRead($config, "notification", "debug", "0")
	$PushBulletremote = IniRead($config, "notification", "remote", "0")
	$PushBulletdelete = IniRead($config, "notification", "delete", "0")
	$PushBulletfreebuilder = IniRead($config, "notification", "freebuilder", "0")
	$PushBulletdisconnection = IniRead($config, "notification", "disconnection", "0")
	GUICtrlSetData($inppushuser, IniRead($config, "notification", "user@"&@ComputerName, ""))

;~ 	If IniRead($config, "brokenbot.org", "senddata", "0") = 1 Then
;~ 		GUICtrlSetState($chkBBSendData, $GUI_CHECKED)
;~ 	Else
;~ 		GUICtrlSetState($chkBBSendData, $GUI_UNCHECKED)
;~ 	EndIf
	;---------------------------------------------------------------------------------------
	; Misc settings ------------------------------------------------------------------------
	;---------------------------------------------------------------------------------------
	$AlertBaseFound = IniRead($config, "misc", "AlertBaseFound", "0")
	$TakeAttackSnapShot = IniRead($config, "misc", "TakeAttackSnapShot", "0")
	$TakeLootSnapShot = IniRead($config, "misc", "TakeLootSnapShot", "0")
	$TakeAllTownSnapShot = IniRead($config, "misc", "TakeAllTownSnapShot", "0")
	$DebugMode = IniRead($config, "misc", "Debug", "0")
	$ichkCollect = IniRead($config, "misc", "Collect", "1")
	$itxtReconnect = IniRead($config, "misc", "reconnectdelay", "0")
	$itxtReturnh = IniRead($config, "misc", "returnhomedelay", "0")
	$icmbSearchsp = IniRead($config, "misc", "searchspd", "0")
	$ichkTrap = IniRead($config, "misc", "chkTrap", "0")
	$WideEdge = IniRead($config, "misc", "WideEdge", "0")
	$iClearField = IniRead($config, "misc", "ClearField", "0")
	$ichkAvoidEdge = IniRead($config, "misc", "AvoidEdge", "0")
	$itxtspellCap = IniRead($config, "misc", "spellcap", "3")
	; Import old setting to new method
	If $ichkAvoidEdge = "0" Then
		GUICtrlSetData($sldAcc, 100)
		IniWrite($config, "misc", "AvoidEdge", "-1")
	ElseIf $ichkAvoidEdge = "1" Then
		GUICtrlSetData($sldAcc, 10)
		IniWrite($config, "misc", "AvoidEdge", "-1")
	Else
		GUICtrlSetData($sldAcc, IniRead($config, "misc", "RedLineAcc", "10"))
	EndIf

	;---------------------------------------------------------------------------------------
	; Config settings ----------------------------------------------------------------------
	;---------------------------------------------------------------------------------------
	If IniRead($config, "config", "Background@"&@ComputerName, "0") = 1 Then
		GUICtrlSetState($chkBackground, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkBackground, $GUI_UNCHECKED)
	EndIf
	$ichkForceBS=IniRead($config, "config", "ForceBS@"&@ComputerName, "0")
	If IniRead($config, "config", "chkUpdate@"&@ComputerName, "0") = 1 Then
		GUICtrlSetState($chkUpdate, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkUpdate, $GUI_UNCHECKED)
	EndIf
	If IniRead($config, "config", "stayalive@"&@ComputerName, "0") = 1 Then
		GUICtrlSetState($chkStayAlive, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkStayAlive, $GUI_UNCHECKED)
	EndIf
	If IniRead($config, "config", "MinimizeTray@"&@ComputerName, "0") = 1 Then
		GUICtrlSetState($chkMinimizeTray, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkMinimizeTray, $GUI_UNCHECKED)
	EndIf
	If IniRead($config, "config", "speedboost@"&@ComputerName, "0") = 1 Then
		GUICtrlSetState($chkSpeedBoost, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkSpeedBoost, $GUI_UNCHECKED)
	EndIf
	If IniRead($config, "config", "usehelper@"&@ComputerName, "1") = 1 Then
		GUICtrlSetState($chkHelper, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkHelper, $GUI_UNCHECKED)
	EndIf
	$ilblFontName=IniRead($config, "config", "LogFontName", "Lucida Console")
	$ilblFontSize=IniRead($config, "config", "LogFontSize", "7.5")
	$ClearAllPushes=IniRead($config, "config", "ClearAllPushes", "0")

	;---------------------------------------------------------------------------------------
	; Base location settings ---------------------------------------------------------------
	;---------------------------------------------------------------------------------------
	$CCPos[0] = IniRead($config, "position", "xCCPos", "")
	$CCPos[1] = IniRead($config, "position", "yCCPos", "")
	$frmBotPosX = IniRead($config, "position", "frmBotPosX@"&@ComputerName, "920")
	$frmBotPosY = IniRead($config, "position", "frmBotPosY@"&@ComputerName, "8")
	$TownHallPos[0] = IniRead($config, "position", "xTownHall", "")
	$TownHallPos[1] = IniRead($config, "position", "yTownHall", "")
	$ArmyPos[0] = IniRead($config, "position", "xArmy", "")
	$ArmyPos[1] = IniRead($config, "position", "yArmy", "")
	$SpellPos[0] = IniRead($config, "position", "xSpell", "")
	$SpellPos[1] = IniRead($config, "position", "ySpell", "")
	$KingPos[0] = IniRead($config, "position", "xKing", "")
	$KingPos[1] = IniRead($config, "position", "yKing", "")
	$QueenPos[0] = IniRead($config, "position", "xQueen", "")
	$QueenPos[1] = IniRead($config, "position", "yQueen", "")
;	For $i = 0 To 3 ;Covers all 4 Barracks
;		$barrackPos[$i][0] = IniRead($config, "position", "xBarrack" & $i + 1, "")
;		$barrackPos[$i][1] = IniRead($config, "position", "yBarrack" & $i + 1, "")
;	Next
;	For $i = 0 To 1 ;Cover 2 Dark Barracks
;		$DarkBarrackPos[$i][0] = IniRead($config, "position", "xDarkBarrack" & $i + 1, "")
;		$DarkBarrackPos[$i][1] = IniRead($config, "position", "yDarkBarrack" & $i + 1, "")
;	Next
;	For $i = 0 To 16 ;Covers all Collectors
;		$collectorPos[$i][0] = IniRead($config, "position", "xCollector" & $i + 1, "")
;		$collectorPos[$i][1] = IniRead($config, "position", "yCollector" & $i + 1, "")
;	Next
	$LabPos[0] = IniRead($config, "position", "LabPosX", "")
	$LabPos[1] = IniRead($config, "position", "LabPosY", "")

	;---------------------------------------------------------------------------------------
	; Hidden settings ----------------------------------------------------------------------
	;---------------------------------------------------------------------------------------
	; These settings can be read in from config but aren't found in the GUI
GUICtrlSetState($expMode, $GUI_DISABLE)
GUICtrlSetState($expMode, $GUI_UNCHECKED)
GUICtrlSetState($txtSnipeBelow, $GUI_DISABLE)
GUICtrlSetData($txtSnipeBelow, 0)
$ichkDonateBarbarians = 0
$ichkDonateAllBarbarians = 0
$ichkDonateArchers = 0
$ichkDonateAllArchers = 0
$ichkDonateGiants = 0
$ichkDonateAllGiants = 0
GUICtrlSetState($chkDonateAllBarbarians, $GUI_DISABLE)
GUICtrlSetState($chkDonateBarbarians, $GUI_DISABLE)
GUICtrlSetState($chkDonateAllArchers, $GUI_DISABLE)
GUICtrlSetState($chkDonateArchers, $GUI_DISABLE)
GUICtrlSetState($chkDonateAllGiants, $GUI_DISABLE)
GUICtrlSetState($chkDonateGiants, $GUI_DISABLE)
GUICtrlSetState($chkWalls, $GUI_UNCHECKED)
GUICtrlSetState($chkWalls, $GUI_DISABLE)
GUICtrlSetState($UseGold, $GUI_UNCHECKED)
GUICtrlSetState($UseGold, $GUI_DISABLE)
GUICtrlSetState($UseElixir, $GUI_UNCHECKED)	
GUICtrlSetState($UseElixir, $GUI_DISABLE)	
	ModReload()
EndFunc   ;==>readConfig
