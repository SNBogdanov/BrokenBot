Global 	$UPCannon[13] 	= [250	 ,1000	,4000	,16000	,50000	,100000	,200000	,400000	,800000	,1600000,3200000,6400000,7500000]
Global 	$UPArcherTower[13]= [1000	 ,2000	,5000	,20000	,80000	,180000	,360000	,720000	,1500000,2500000,4500000,6500000,7500000]
Global 	$UPMortar[8]	= [8000	 ,32000	,120000	,400000	,800000	,1600000,3200000,6400000]
Global 	$UPAirDefense[8]	= [22500 ,90000	,270000	,540000	,1080000,2160000,4320000,7560000]
Global	$UPWizardTower[8] = [180000,360000,720000	,1280000,1960000,2680000,5360000,6480000]
Global  $UPAirSweeper[6]	= [500000,750000,1250000,2400000,4800000,7200000]
Global  $UPHiddenTesla[8] =[1000000,1250000,1500000,2000000,2500000,3000000,3500000,5000000]
Global  $UPXBow[4]	=[3000000,5000000,7000000,8000000]
Global  $UPInfernoTower[3]=[5000000,6500000,8000000]
Global  $UPGoldMine[12]	= [150	 ,300	,700	,1400	,3500	,7000	,14000	,28000	,56000	,84000	,168000	,336000	]
Global  $UPElixirCollector[12]=[150 ,300	,700	,1400	,3500	,7000	,14000	,28000	,56000	,84000	,168000	,336000	]
Global  $UPDarkElixirDrill[6]= [1000000	,1500000,2000000,3000000,4000000,5000000]
Global  $UPGoldStorage[11] = [1500	 ,3000	,6000	,12000	,25000	,50000	,100000	,250000	,500000	,1000000,2000000]
Global  $UPElixirStorage[11]=[1500	 ,3000	,6000	,12000	,25000	,50000	,100000	,250000	,500000	,1000000,2000000]
Global  $UPDarkElixirStorage[6]=[600000,1200000,1800000,2400000,3000000,3600000]
Global  $UPArmyCamp[8]	= [250	 ,2500	,10000	,100000	,250000	,750000	,2250000,6750000]
Global  $UPBarracks[10]	= [200	 ,1000	,2500	,5000	,10000	,80000	,240000	,700000	,1500000,2000000]
Global  $UPDarkBarracks[6]= [750000,1250000,1750000,2250000,2750000,3500000]
Global  $UPLaboratory[8]	= [25000 ,50000	,90000	,270000	,500000	,1000000,2500000,4000000]
Global  $UPSpellFactory[5]= [200000,400000,800000	,1600000,3200000]
Global  $UPDarkSpellFactory[3]=[1500000,2500000,3500000]
Global  $UPTownHall[10]   = [0	 ,1000	,4000	,25000	,150000	,750000	,1200000,2000000,3000000,4000000]
Global  $UPClanCastle[6]	= [10000 ,100000,800000	,1800000,5000000,7000000]
Global  $UPWall[11]	= [50    ,1000	,5000	,10000	,30000	,75000	,200000	,500000	,1000000,3000000,4000000]
Global  $UPBomb[6]	= [400	 ,1000	,10000	,100000	,1000000,1500000]
Global  $UPGiantBomb[4]	= [12500 ,75000 ,750000 ,2500000]
Global  $UPAirBomb[4]	= [4000  ,20000 ,200000	,1500000]
Global  $UPSeekingAirMine[3]=[15000,2000000,4000000]
Global  $UPSkeletonTrap[3]= [6000  ,600000,1300000]

Func IdentifyBuilding(ByRef $Name,ByRef $UpgradeCost,ByRef $UpgradeResource)
	$Name=""
	$UpgradeCost=0
	$UpgradeResource=0
	$Location = _WaitForPixel(240, 581, 484, 583, Hex(0x4084B8, 6), 6, 2)

	If Not IsArray($Location) Then
		SetLog(GetLangText("msgFailedBuilding"), $COLOR_RED)
		Return False
	Else
		Click($Location[0], $Location[1])
		Sleep(500)
		If Not _WaitForColor(698, 160, Hex(0xD80408, 6), 16, 2) Then
			SetLog(GetLangText("msgFailedBuilding"), $COLOR_RED)
			ClickP($TopLeftClient, 2, 250)
			Return False
		Else
			$MenuBar = StringReplace(StringStripWS(ReadText(175, 138, 500, $textWindowTitles),3),"N","n")
			$Level = Number(StringRegExpReplace($MenuBar,"[^0-9]",""))
			$MenuBar = StringReplace(StringRegExpReplace($MenuBar,"[0-9]","")," (Level )","")
			$MenuBar = StringReplace($MenuBar,"La boratory","Laboratory")
			$MenuBar = StringReplace($MenuBar,"lnferno","Inferno")
		EndIf
	EndIf
	If $Level <1 Then
		SetLog(GetLangText("msgFailedBuilding"), $COLOR_RED)
		ClickP($TopLeftClient, 2, 250)
		Return False
	EndIf
	If $MenuBar =  "Cannon" Then
  		If $Level>= UBound($UPCannon) Then 
			SetLog(GetLangText("msgMaxedBuilding")&$Level, $COLOR_RED)
			ClickP($TopLeftClient, 2, 250)
			Return False
		EndIf
		$UpgradeCost=$UPCannon[$Level]
	ElseIf $MenuBar =  "Archer Tower" Then
		If $Level>= UBound($UPArcherTower) Then 
			SetLog(GetLangText("msgMaxedBuilding")&$Level, $COLOR_RED)
			ClickP($TopLeftClient, 2, 250)
			Return False
		EndIf
		$UpgradeCost=$UPArcherTower[$Level]
	ElseIf $MenuBar =  "Mortar" Then
		If $Level>= UBound($UPMortar) Then 
			SetLog(GetLangText("msgMaxedBuilding")&$Level, $COLOR_RED)
			ClickP($TopLeftClient, 2, 250)
			Return False
		EndIf
		$UpgradeCost=$UPMortar[$Level]
	ElseIf $MenuBar =  "Air Defense" Then
		If $Level >= UBound($UPAirDefense) Then 
			SetLog(GetLangText("msgMaxedBuilding")&$Level, $COLOR_RED)
			ClickP($TopLeftClient, 2, 250)
			Return False
		EndIf
		$UpgradeCost=$UPAirDefense[$Level]
	ElseIf $MenuBar =  "Wizard Tower" Then
		If $Level>= UBound($UPWizardTower) Then 
			SetLog(GetLangText("msgMaxedBuilding")&$Level, $COLOR_RED)
			ClickP($TopLeftClient, 2, 250)
			Return False
		EndIf
		$UpgradeCost=$UPWizardTower[$Level]
	ElseIf $MenuBar =  "Air Sweeper" Then
		If $Level>= UBound($UPAirSweeper) Then 
			SetLog(GetLangText("msgMaxedBuilding")&$Level, $COLOR_RED)
			ClickP($TopLeftClient, 2, 250)
			Return False
		EndIf
		$UpgradeCost=$UPAirSweeper[$Level]
	ElseIf $MenuBar =  "Hidden Tesla" Then
		If $Level>= UBound($UPHiddenTesla) Then 
			SetLog(GetLangText("msgMaxedBuilding")&$Level, $COLOR_RED)
			ClickP($TopLeftClient, 2, 250)
			Return False
		EndIf
		$UpgradeCost=$UPHiddenTesla[$Level]
	ElseIf $MenuBar =  "X-Bow" Then
		If $Level>= UBound($UPXBow) Then 
			SetLog(GetLangText("msgMaxedBuilding")&$Level, $COLOR_RED)
			ClickP($TopLeftClient, 2, 250)
			Return False
		EndIf
		$UpgradeCost=$UPXBow[$Level]
	ElseIf $MenuBar =  "Inferno Tower" Then
		If $Level>= UBound($UPInfernoTower) Then 
			SetLog(GetLangText("msgMaxedBuilding")&$Level, $COLOR_RED)
			ClickP($TopLeftClient, 2, 250)
			Return False
		EndIf
		$UpgradeCost=$UPInfernoTower[$Level]
	ElseIf $MenuBar =  "Gold Mine" Then
		If $Level>= UBound($UPGoldMine) Then 
			SetLog(GetLangText("msgMaxedBuilding")&$Level, $COLOR_RED)
			ClickP($TopLeftClient, 2, 250)
			Return False
		EndIf
		$UpgradeCost=$UPGoldMine[$Level]
		$UpgradeResource=1
	ElseIf $MenuBar =  "Elixir Collector" Then
		If $Level>= UBound($UPElixirCollector) Then 
			SetLog(GetLangText("msgMaxedBuilding")&$Level, $COLOR_RED)
			ClickP($TopLeftClient, 2, 250)
			Return False
		EndIf
		$UpgradeCost=$UPElixirCollector[$Level]
	ElseIf $MenuBar =  "Dark Elixir Drill" Then
		If $Level>= UBound($UPDarkElixirDrill) Then 
			SetLog(GetLangText("msgMaxedBuilding")&$Level, $COLOR_RED)
			ClickP($TopLeftClient, 2, 250)
			Return False
		EndIf
		$UpgradeCost=$UPDarkElixirDrill[$Level]
		$UpgradeResource=1
	ElseIf $MenuBar =  "Gold Storage" Then
		If $Level>= UBound($UPGoldStorage) Then 
			SetLog(GetLangText("msgMaxedBuilding")&$Level, $COLOR_RED)
			ClickP($TopLeftClient, 2, 250)
			Return False
		EndIf
		$UpgradeCost=$UPGoldStorage[$Level]
		$UpgradeResource=1
	ElseIf $MenuBar =  "Elixir Storage" Then
		If $Level>= UBound($UPElixirStorage) Then 
			SetLog(GetLangText("msgMaxedBuilding")&$Level, $COLOR_RED)
			ClickP($TopLeftClient, 2, 250)
			Return False
		EndIf
		$UpgradeCost=$UPElixirStorage[$Level]
	ElseIf $MenuBar =  "Dark Elixir Storage" Then
		If $Level>= UBound($UPDarkElixirStorage) Then 
			SetLog(GetLangText("msgMaxedBuilding")&$Level, $COLOR_RED)
			ClickP($TopLeftClient, 2, 250)
			Return False
		EndIf
		$UpgradeCost=$UPDarkElixirStorage[$Level]
		$UpgradeResource=1
	ElseIf $MenuBar =  "Army Camp" Then
		If $Level>= UBound($UPArmyCamp) Then 
			SetLog(GetLangText("msgMaxedBuilding")&$Level, $COLOR_RED)
			ClickP($TopLeftClient, 2, 250)
			Return False
		EndIf
		$UpgradeCost=$UPArmyCamp[$Level]
		$UpgradeResource=1
	ElseIf $MenuBar =  "Barracks" Then
		If $Level>= UBound($UPBarracks) Then 
			SetLog(GetLangText("msgMaxedBuilding")&$Level, $COLOR_RED)
			ClickP($TopLeftClient, 2, 250)
			Return False
		EndIf
		$UpgradeCost=$UPBarracks[$Level]
		$UpgradeResource=1
	ElseIf $MenuBar =  "Dark Barracks" Then
		If $Level>= UBound($UPDarkBarracks) Then 
			SetLog(GetLangText("msgMaxedBuilding")&$Level, $COLOR_RED)
			ClickP($TopLeftClient, 2, 250)
			Return False
		EndIf
		$UpgradeCost=$UPDarkBarracks[$Level]
		$UpgradeResource=1
	ElseIf $MenuBar =  "Laboratory" Then
		If $Level>= UBound($UPLaboratory) Then 
			SetLog(GetLangText("msgMaxedBuilding")&$Level, $COLOR_RED)
			ClickP($TopLeftClient, 2, 250)
			Return False
		EndIf
		$UpgradeCost=$UPLaboratory[$Level]
		$UpgradeResource=1
	ElseIf $MenuBar =  "Spell Factory" Then
		If $Level>= UBound($UPSpellFactory) Then 
			SetLog(GetLangText("msgMaxedBuilding")&$Level, $COLOR_RED)
			ClickP($TopLeftClient, 2, 250)
			Return False
		EndIf
		$UpgradeCost=$UPSpellFactory[$Level]
		$UpgradeResource=1
	ElseIf $MenuBar =  "Dark Spell Factory" Then
		If $Level>= UBound($UPDarkSpellFactory) Then 
			SetLog(GetLangText("msgMaxedBuilding")&$Level, $COLOR_RED)
			ClickP($TopLeftClient, 2, 250)
			Return False
		EndIf
		$UpgradeCost=$UPDarkSpellFactory[$Level]
		$UpgradeResource=1
	ElseIf $MenuBar =  "Town Hall" Then
		If $Level>= UBound($UPTownHall) Then 
			SetLog(GetLangText("msgMaxedBuilding")&$Level, $COLOR_RED)
			ClickP($TopLeftClient, 2, 250)
			Return False
		EndIf
		$UpgradeCost=$UPTownHall[$Level]
	ElseIf $MenuBar =  "Clan Castle" Then
		If $Level>= UBound($UPClanCastle) Then 
			SetLog(GetLangText("msgMaxedBuilding")&$Level, $COLOR_RED)
			ClickP($TopLeftClient, 2, 250)
			Return False
		EndIf
		$UpgradeCost=$UPClanCastle[$Level]
	ElseIf $MenuBar =  "Bomb" Then
		If $Level>= UBound($UPBomb) Then 
			SetLog(GetLangText("msgMaxedBuilding")&$Level, $COLOR_RED)
			ClickP($TopLeftClient, 2, 250)
			Return False
		EndIf
		$UpgradeCost=$UPBomb[$Level]
	ElseIf $MenuBar =  "Giant Bomb" Then
		If $Level>= UBound($UPGiantBomb) Then 
			SetLog(GetLangText("msgMaxedBuilding")&$Level, $COLOR_RED)
			ClickP($TopLeftClient, 2, 250)
			Return False
		EndIf
		$UpgradeCost=$UPGiantBomb[$Level]
	ElseIf $MenuBar =  "Air Bomb" Then
		If $Level>= UBound($UPAirBomb) Then 
			SetLog(GetLangText("msgMaxedBuilding")&$Level, $COLOR_RED)
			ClickP($TopLeftClient, 2, 250)
			Return False
		EndIf
		$UpgradeCost=$UPAirBomb[$Level]
	ElseIf $MenuBar =  "Seeking Air Mine" Then
		If $Level>= UBound($UPSeekingAirMine) Then 
			SetLog(GetLangText("msgMaxedBuilding")&$Level, $COLOR_RED)
			ClickP($TopLeftClient, 2, 250)
			Return False
		EndIf
		$UpgradeCost=$UPSeekingAirMine[$Level]
	ElseIf $MenuBar =  "Skeleton Trap" Then
		If $Level>= UBound($UPSkeletonTrap) Then 
			SetLog(GetLangText("msgMaxedBuilding")&$Level, $COLOR_RED)
			ClickP($TopLeftClient, 2, 250)
			Return False
		EndIf
		$UpgradeCost=$UPSkeletonTrap[$Level]
	ElseIf $MenuBar =  "Wall" Then
		If $Level>= UBound($UPWall) Then 
			SetLog(GetLangText("msgMaxedBuilding")&$Level, $COLOR_RED)
			ClickP($TopLeftClient, 2, 250)
			Return False
		EndIf
		If $Level >= 8 Then
			$res=MsgBox($MB_YESNOCANCEL,"Walls","Walls with level "&$Level&" Can be upgraden with gold or elixir"&@CR&"Do you want to use gold (Yes), elixir (No)")
			If $res=$IDCANCEL Then Return False
			If $res=$IDNO Then $UpgradeResource=1
		EndIf
		$UpgradeCost=$UPWall[$Level]
	Else 
		SetLog("Unknown building "&$MenuBar, $COLOR_RED)
		ClickP($TopLeftClient, 2, 250)
		Return False
	EndIf
	
	$Name=$MenuBar
	Return True
EndFunc
