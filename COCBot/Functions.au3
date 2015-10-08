#include "functions\Attack\GoldElixirChange.au3"
#include "functions\Attack\ReturnHome.au3"
#include "functions\Attack\NameOfTroop.au3"

#include "functions\Config\applyConfig.au3"
#include "functions\Config\readConfig.au3"
#include "functions\Config\saveConfig.au3"
#include "functions\Config\ScreenCoordinates.au3"

#include "functions\Image Search\ImageSearch.au3"
#include "functions\Image Search\checkButtonUpgrade.au3"
#include "functions\Image Search\checkDeadBase.au3"
#include "functions\Image Search\checkWall.au3"

#include "functions\Main Screen\checkMainScreen.au3"
#include "functions\Main Screen\checkObstacles.au3"
#include "functions\Main Screen\waitMainScreen.au3"
#include "functions\Main Screen\ZoomOut.au3"

#include "functions\Notification\PushBullet.au3"

#include "functions\Other\_Sleep.au3"
#include "functions\Other\_PowerKeepAlive.au3"
#include "functions\Other\Click.au3"
#include "functions\Other\UpdateStat.au3"
#include "functions\Other\CreateLogFile.au3"
#include "functions\Other\FindPos.au3"
#include "functions\Other\getBSPos.au3"
#include "functions\Other\SetLog.au3"
#include "functions\Other\WriteStats.au3"
#include "functions\Other\Tab.au3"
#include "functions\Other\Time.au3"
#include "functions\Other\BlockInputEx.au3"
#include "functions\Other\_NumberFormat.au3"
#include "functions\Other\RandomGaussian.au3"
#include "functions\Other\stuckHandler.au3"
#include "functions\Other\Experience.au3"
#include "functions\Other\DisableBS.au3"
#include "functions\Other\EnableBS.au3"
#include "functions\Other\General Functions.au3"
#include "functions\Other\LootLogCleanup.au3"
#include "functions\Other\Pause.au3"
#include "functions\Other\RedLineDeploy.au3"
#include "functions\Other\ClickDrag.au3"
#include "functions\Other\TaskBarControl.au3"

#include "functions\Pixels\_CaptureRegion.au3"
#include "functions\Pixels\_ColorCheck.au3"
#include "functions\Pixels\_GetPixelColor.au3"
#include "functions\Pixels\_PixelSearch.au3"
#include "functions\Pixels\_MultiPixelSearch.au3"
#include "functions\Pixels\boolPixelSearch.au3"

#include "functions\Read Text\getChar.au3"
#include "functions\Read Text\getDarkElixir.au3"
#include "functions\Read Text\getDigit.au3"
#include "functions\Read Text\getDigitLarge.au3"
#include "functions\Read Text\getDigitSmall.au3"
#include "functions\Read Text\getElixir.au3"
#include "functions\Read Text\getGold.au3"
#include "functions\Read Text\getNormal.au3"
#include "functions\Read Text\getOther.au3"
#include "functions\Read Text\getTrophy.au3"
#include "functions\Read Text\getString.au3"
#include "functions\Read Text\getDigitLastRaid.au3"
#include "functions\Read Text\getDigitTH.au3"

#include "functions\Search\checkNextButton.au3"
#include "functions\Search\GetResources.au3"
#include "functions\Search\PrepareSearch.au3"

#include "functions\Strategies\strategies.au3"

#include "functions\Village\BoostAllBuilding.au3"
#include "functions\Village\BoostBarracks.au3"
#include "functions\Village\CheckFullSpellFactory.au3"
#include "functions\Village\DonateCC.au3"
#include "functions\Village\DonateCheckArmyCamp.au3"
#include "functions\Village\DonateTrain.au3"
#include "functions\Village\DropTrophy.au3"
#include "functions\Village\isGoldFull.au3"
#include "functions\Village\isElixirFull.au3"
#include "functions\Village\isDarkElixirFull.au3"
#include "functions\Village\LocateBuildings.au3"
#include "functions\Village\MainLoop.au3"
#include "functions\Village\ReArm.au3"
#include "functions\Village\RequestCC.au3"
#include "functions\Village\BotStopped.au3"
#include "functions\Village\UpgradeWall.au3"
#include "functions\Village\UpgradeBuilding.au3"
#include "functions\Village\VillageReport.au3"
#include "functions\Village\CheckCostPerSearch.au3"
#include "functions\Village\UpTroops.au3"
#include "functions\Village\UpgradeHeroes.au3" ;==>upgradeHeroes
#include "functions\Village\IdentifyBuilding.au3"

#include "functions\Custom Functions\customized.au3" ; custom functions
#include "functions\Custom Functions\Tesseract.au3"
#include "functions\Custom Functions\SnipeWhileTraining.au3"
