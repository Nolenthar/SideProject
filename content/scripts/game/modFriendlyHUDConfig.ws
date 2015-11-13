//---=== modFriendlyHUD ===---
class CModFriendlyHUDConfig
{
	//--- Configurable section begin ---
	
	//---====================---
	//---=== HUD Settings ===---
	//---====================---
	
	//This variable sets the delay to hide temporarily visible modules
	const var fadeOutTimeSeconds : float; default fadeOutTimeSeconds = 2.0;

	//These are modules, which appear while you're holding Enter, M, J and K hotkeys
	const var essentialModulesStr : string; default
		essentialModulesStr = "WolfHeadModule; BuffsModule; ItemInfoModule; DamagedItemsModule; Minimap2Module; QuestsModule";
	const var minimapModulesStr : string; default
		minimapModulesStr = "Minimap2Module";
	const var questsModulesStr : string; default
		questsModulesStr = "QuestsModule";
	const var characterModulesStr : string; default
		characterModulesStr = "WolfHeadModule; BuffsModule; ItemInfoModule; DamagedItemsModule";
	
	//you can disable all hold-to-see hard-coded bindings with this if they conflict with your custom bindings
	const var disableHoldToSeeDefaultBindings : bool; default disableHoldToSeeDefaultBindings = false;
	
	//These are modules, which appear under certain conditions if enabled
	const var combatModulesStr : string; default
		combatModulesStr = "WolfHeadModule; BuffsModule; ItemInfoModule; DamagedItemsModule";
	const var witcherSensesModulesStr : string; default
		witcherSensesModulesStr = "Minimap2Module; QuestsModule";
	const var meditationModulesStr : string; default
		meditationModulesStr = "Minimap2Module";
	//Radial module flash script auto-hides top-left and top-right modules (WolfHeadModule, Minimap2Module), impossible to fix now
	const var radialMenuModulesStr : string; default
		radialMenuModulesStr = "ItemInfoModule";
	
	//These are triggers to enable conditional modules
	
	//MODSOR++
	//const var enableCombatModules : bool; default enableCombatModules = true;
	//public var enableCombatModules : bool;
	//enableCombatModules = theGame.GetInGameConfigWrapper().GetVarValue('FriendlyHud','menuEnableCombatModules');
	//const var enableCombatModulesOnUnsheathe : bool; default enableCombatModulesOnUnsheathe = false;
	//const var enableWolfModuleOnVitalityChanged: bool; default enableWolfModuleOnVitalityChanged = true;
	//MODSOR--

	//A threshold to display Wolf Module on vitality increase:
	//use 0 if you want to see healthbar for every vitality increase, including natural regeneration;
	//use 12 (bigger than normal + Sun and Stars) to exclude natural vitality regen;
	//use 999999 (any number big enough) to never see Wolf Module on vitality increase.
	const var vitalityRiseThreshold: float; default vitalityRiseThreshold = 12;
	
	//MODSOR++
	//const var enableWitcherSensesModules : bool; default enableWitcherSensesModules = false;
	//const var enableMeditationModules : bool; default enableMeditationModules = true;
	//const var enableRadialMenuModules : bool; default enableRadialMenuModules = true;
	//MODSOR--

	//These are zoom values for minimap - smaller values mean that it'll be zoomed out, bigger values it'll be zoomed in
	const var minimapZoomExterior : float; default minimapZoomExterior = 0.5; // vanilla value is 1.0
	const var minimapZoomInterior : float; default minimapZoomInterior = 1.0; // vanilla value is 2.0
	const var minimapZoomBoat : float; default minimapZoomBoat = 0.5; // vanilla value is 0.5
	
	//---=================================---
	//---=== General Markers Settings ===---
	//---=================================---

	//If true, makes direction markers (quest and compass markers) always visible (if enabled)
	//if false - they're visible only while using witcher senses
	
	//MODSOR++
	//const var directionMarkersAlwaysVisible : bool; default directionMarkersAlwaysVisible = false;
	//MODSOR--
	
	//---=================================---
	//---=== 3D Quest Markers Settings ===---
	//---=================================---
	
	//MODSOR++
	//const var questMarkersEnabled : bool; default questMarkersEnabled = true;
	//MODSOR--
	//Min distance for displaying a marker
	const var markerMinDistance : float; default markerMinDistance = 4.0;
	//Font parameters for displaying quest markers (html)
	const var userMarkerTextFont : string; default userMarkerTextFont = "<font face=\"$BoldFont\" size=\"25\" color=\"#3CB371\">";
	const var currentMarkerTextFont : string; default currentMarkerTextFont = "<font face=\"$BoldFont\" size=\"25\" color=\"#FFD700\">";
	const var otherMarkerTextFont : string; default otherMarkerTextFont = "<font face=\"$NormalFont\" size=\"25\" color=\"#EEE8AA\">";
	const var upIndicator : string; default upIndicator = "<font face=\"$NormalFont\">^</font>";
	const var downIndicator : string; default downIndicator = "<font face=\"$NormalFont\">v</font>";
	
	//---================================---
	//---=== Compass Markers Settings ===---
	//---================================---
	
	const var compassMarkersEnabled : bool; default compassMarkersEnabled = false;
	//show 3D markers on compass instead of showing them in the world (3D markers must be enabled for this option to work)
	//set questMarkersAlwaysVisible parameter above to true, if you want to see 3D markers on compass all the time
	const var project3DMarkersOnCompass : bool; default project3DMarkersOnCompass = true;
	//if true, display compass at the top of the screen, if false display it at the bottom of the screen
	const var compassMarkersTop : bool; default compassMarkersTop = false;
	//compass text settings (html tags)
	const var compassMarkerTextFont : string; default compassMarkerTextFont = "<font face=\"$BoldFont\" size=\"25\" color=\"#FFFF00\">";
	
	//---===========================================---
	//---=== Quick Items In Radial Menu Settings ===---
	//---===========================================---
	
	const var enableItemsInRadialMenu : bool; default enableItemsInRadialMenu = true;
	//Use WASD for controller-like quick items navigation (C to use item)
	const var enableWASD : bool; default enableWASD = false;
	//Apply oil to currently drawn sword only (to fix compatibility issues with mods that allow applying the same oil to different sword types)
	const var applyOilToDrawnSword : bool; default applyOilToDrawnSword = false;
	//Allow applying oils in radial menu during combat
	const var allowOilsInCombat : bool; default allowOilsInCombat = false;
	//Default display mode when opening radial menu. Valid values: BDM_ShowPotions, BDM_ShowBombs, BDM_ShowOils, BDM_ShowBuffs
	const var defaultDisplayMode : EBuffsDisplayMode; default defaultDisplayMode = BDM_ShowBombs;
	//Show active buffs when cycling through display modes (Q key/Y button)
	const var cycleThroughBuffs : bool; default cycleThroughBuffs = true;
	//Set timescale for radial menu (vanilla value is 0.1)
	const var radialMenuTimescale : float; default radialMenuTimescale = 0.05;
	//Potions order in this list equals to hotkey order: 1-9, 0, -, = (buffs module flash can handle up to 12 items max!)
	const var potionsOrderStr : string; default
		potionsOrderStr = "Tawny_Owl; Thunderbolt; Blizzard; Swallow; White_Raffards_Decoction; Black_Blood; Full_Moon; Maribor_Forest; Petri_Philtre; Golden_Oriole; Cat; Killer_Whale";
	//Bombs order in this list equals to hotkey order: 1-8
	const var bombsOrderStr : string; default
		bombsOrderStr = "Dancing_Star; Devils_Puffball; Dragons_Dream; Grapeshot; Samum; White_Frost; Silver_Dust_Bomb; Dwimeritium_Bomb";
	//Oils order in this list equals to hotkey order: 1-9, 0, -, =
	const var oilsOrderStr : string; default
		oilsOrderStr = "Cursed_Oil; Draconide_Oil; Insectoid_Oil; Hybrid_Oil; Magicals_Oil; Necrophage_Oil; Ogre_Oil; Relic_Oil; Specter_Oil; Vampire_Oil; Beast_Oil; Hanged_Man_Venom";
	//Key strings (just text, doesn't affect actual bindings). Key bindings are displayed as pictures in-game and buffs module can't handle additional pictures.
	//This list is the best I can do for displaying your custom binds properly without going into much trouble.
	const var keysOrderStr : string; default
		keysOrderStr = "1; 2; 3; 4; 5; 6; 7; 8; 9; 0; -; =";
	//Since localized names have different length in different languages, you can use these settings to fine-tune quick items display to best fit the screen.
	//You can move <key> and <name> placeholders around and add separators. If you have hotkeys memorized, you can remove <key> indicator altogether.
	//And if using something like Better Icons mod that adds names directly to icons, you can remove <name> and leave only <key> for hotkey help.
	const var itemNamePattern : string; default itemNamePattern = "<key>:<name>";
	//Text color (html) for potions with zero quantity left
	const var zeroQuantityTextFont : string; default zeroQuantityTextFont = "<font color=\"#FF0000\">";
	//Controller related: current selection with zero quantity and current selection colors
	const var zeroQuantCurTextFont : string; default zeroQuantCurTextFont = "<font color=\"#FFFF00\">";
	const var currentTextFont : string; default currentTextFont = "<font color=\"#00FF00\">";
	
	//---===========================---
	//---=== Meditation Settings ===---
	//---===========================---
	
	//---=== Meditation Menu ===---
	//This variable is used by menu meditation solely
	const var fullHealthRegenAnyDifficulty : bool; default fullHealthRegenAnyDifficulty = false;
	
	//---=== Real Time Meditation ===---
	//you can disable RT meditation hard-coded binding with this if it conflicts with your custom bindings
	const var disableRTMeditationDefaultBinding : bool; default disableRTMeditationDefaultBinding = false;
	//When using real time meditation, all stats and buffs are updated in real time adjusted by current acceleration factor
	const var REFILL_INTERVAL_SECONDS : float; default REFILL_INTERVAL_SECONDS = 3600;
	const var MAX_HOURS_PER_MINUTE : float;	default MAX_HOURS_PER_MINUTE = 60;
	const var HOURS_PER_MINUTE_PER_SECOND : float; default HOURS_PER_MINUTE_PER_SECOND = 6;
	//TimeScale replaces FastForward and accelerates the whole game, including scripts and animations.
	//WARNING! Turning this feature on may cause game instability and graphical glitches! Use at you own risk!
	//If you decide to turn it on, do not use high values for HOURS_PER_MINUTE_PER_SECOND and MAX_HOURS_PER_MINUTE,
	//as it may lead to even more bugs and occasional CTDs, especially in crowded places.
	//Note that TimeScale affects engine time and breaks controller vibration timings as a result.
	const var useTimeScale : bool; default useTimeScale = false;
	
	//---=== Common Meditation Settings ===---
	//These settings are applied both for menu and real time meditation modes
	const var fireplaceOnly : bool; default fireplaceOnly = true;
	// If fireplaceOnly == true campFireOnly option is used to limit fireplaces to campfires
	const var campFireOnly : bool; default campFireOnly = false;
	const var refillPotionsWhileMeditating : bool; default refillPotionsWhileMeditating = false;
	//This option makes refill toggle act as temporary switch: after meditating refill setting will be restored to refillPotionsWhileMeditating value
	const var resetRefillSettingToDefaultAfterMeditation : bool; default resetRefillSettingToDefaultAfterMeditation = false;
	//You can localize these messages to your own language
	const var potionsRefillOnMessage : string; default potionsRefillOnMessage = "Meditation: potions refill is on";
	const var potionsRefillOffMessage : string; default potionsRefillOffMessage = "Meditation: potions refill is off";
	
	//---=====================---
	//---=== Menu settings ===---
	//---=====================---
	
	//---=== Map Menu ===---
	//These are zoom multipliers for area map, mapZoomMaxCoef also defines starting zoom level when you open area map
	const var mapZoomMinCoef : float; default mapZoomMinCoef = 2.5; // 1 - vanilla, > 1 - you'll be able to zoom out farther
	const var mapZoomMaxCoef : float; default mapZoomMaxCoef = 0.5; // 1 - vanilla, > 1 - you'll be able to zoom in closer
	//mapUnlimitedZoom unlocks unlimited zoom for area map.
	//If enabled, min and max zoom values are ignored when zooming, but mapZoomMaxCoef still defines starting zoom level.
	//For personal use I prefer to set mapZoomMaxCoef to smaller value to start slightly zoomed out and set unlimited zoom
	//to true to still be able to zoom in closer when needed.
	const var mapUnlimitedZoom : bool; default mapUnlimitedZoom = true;
	
	//---=== Journal Menu ===---
	//Known bug (minor): tracked quest is selected, but not highlighted, category tab is highlighted instead
	const var showTrackedQuest : bool; default showTrackedQuest = true;
	
	//---=== Inventory Menu ===---
	const var blockInventoryInCombat : bool; default blockInventoryInCombat = true;
	//Makes alchemy (potions, bombs, etc) tab opened by default (instead of weapons tab) when entering inventory menu
	const var potionsTabOpensByDefault : bool; default potionsTabOpensByDefault = false;
	//Applies new sorting order to alchemy tab: oils, bombs, potions, mutagen potions, others.
	//New sorting is only applied when you open the tab, it's not applied when using quick-sorting or other sorting filters.
	//Important note: this setting won't work for controller, only for keyboard/mouse. When using controller, quick sorting
	//is forced from inside actionscript (a scripted part of menu flash object). This sorting is done internally and is
	//impossible to control from ws scripts.
	const var newPotionsTabSorting : bool; default newPotionsTabSorting = true;
	//This setting allows to automatically reset new items flag for certain inventory tabs.
	//Valid tabs names: Weapons, Alchemy, Quest, Default, Ingredients, Books.
	const var resetNewItemsInTabsStr : string; default
		resetNewItemsInTabsStr = "Alchemy; Default; Ingredients";
	const var enableResetNewItems : bool; default enableResetNewItems = true;
	
	//---=====================================---
	//---=== Quest markers on NPC settings ===---
	//---=====================================---
	//enable or disable quest markers over NPC's heads
	const var enableNPCQuestMarkers : bool; default enableNPCQuestMarkers = true;

	//---===========================---
	//---=== Automation settings ===---
	//---===========================---
	//disallows switching swords in combat and auto-sheathing swords on combat finished
	const var dontTouchMySwords : bool; default dontTouchMySwords = true;
	
	//---==============================---
	//---=== Oil indicator settings ===---
	//---==============================---
	//Show applied oil indicator in buffs module
	const var showOilIndicator : bool; default showOilIndicator = true;
	//If set to true, the oil buff will be displayed for both swords at all times,
	//if set to false, the oil icon will only display the oil applied to the currently drawn sword.
	const var alwaysDisplayOil : bool; default alwaysDisplayOil = false;

	//---========================================---
	//---=== Quen duration indicator settings ===---
	//---========================================---
	const var showQuenDuration : bool; default showQuenDuration = true;
	//if you're using a mod that changes quen max duration in non-standard way, change
	//maxQuenDurationOverride value to fit the one from the mod
	const var maxQuenDurationOverride : float; default maxQuenDurationOverride = -1;
	
	//---==========================---
	//---=== Talk icon settings ===---
	//---==========================---
	//show/hide talk icon over NPC's heads
	const var showTalkIcon : bool; default showTalkIcon = false;
	
	//--- End of configurable section ---
	
	//public var directionMarkersAlwaysVisibleToggle	: bool;
	public var refillPotionsWhileMeditatingToggle	: bool;
	private var potionsOrder						: array< string >;
	private var bombsOrder							: array< string >;
	private var oilsOrder							: array< string >;
	private var keysOrder							: array< string >;
	public var essentialModules						: array< string >;
	public var minimapModules						: array< string >;
	public var questsModules						: array< string >;
	public var characterModules						: array< string >;
	public var combatModules						: array< string >;
	public var witcherSensesModules					: array< string >;
	public var meditationModules					: array< string >;
	public var radialMenuModules					: array< string >;
	private var resetNewItemsInTabs					: array< string >;
	
	public function Init()
	{
		//InitToggleableValues();
		InitArrays();
	}
	
	
	/*public function InitToggleableValues()
	{
		directionMarkersAlwaysVisibleToggle = directionMarkersAlwaysVisible;
		refillPotionsWhileMeditatingToggle = refillPotionsWhileMeditating;
	}
	
	public function ToggleQuestMarkers()
	{
		//directionMarkersAlwaysVisibleToggle = ( !directionMarkersAlwaysVisibleToggle );
	}*/
	
	public function ResetRefillPotionsWhileMeditating()
	{
		refillPotionsWhileMeditatingToggle = refillPotionsWhileMeditating;
	}
	
	public function ToggleRefillPotionsWhileMeditating()
	{
		refillPotionsWhileMeditatingToggle = ( !refillPotionsWhileMeditatingToggle );
		if ( refillPotionsWhileMeditatingToggle )
		{
			thePlayer.DisplayHudMessage( potionsRefillOnMessage );
		}
		else
		{
			thePlayer.DisplayHudMessage( potionsRefillOffMessage );
		}
	}
	
	public function ShowNewItmesInTab( tabName : string ) : bool
	{
		if ( enableResetNewItems && resetNewItemsInTabs.Contains( tabName ) )
		{
			return false;
		}
		return true;
	}

	public function FillPotionNames( out potionNames : array< string > )
	{
		potionNames = potionsOrder;
	}
	
	public function FillBombNames( out bombNames : array< string > )
	{
		bombNames = bombsOrder;
	}
	
	public function FillOilNames( out oilNames : array< string > )
	{
		oilNames = oilsOrder;
	}
	
	public function FillKeyNames( out keyNames : array< string > )
	{
		keyNames = keysOrder;
	}
	
	
	function InitArrays()
	{
		potionsOrder = StrToArrStr( potionsOrderStr, ";" );
		bombsOrder = StrToArrStr( bombsOrderStr, ";" );
		oilsOrder = StrToArrStr( oilsOrderStr, ";" );
		keysOrder = StrToArrStr( keysOrderStr, ";" );
		essentialModules = StrToArrStr( essentialModulesStr, ";" );
		minimapModules = StrToArrStr( minimapModulesStr, ";" );
		questsModules = StrToArrStr( questsModulesStr, ";" );
		characterModules = StrToArrStr( characterModulesStr, ";" );
		combatModules = StrToArrStr( combatModulesStr, ";" );
		witcherSensesModules = StrToArrStr( witcherSensesModulesStr, ";" );
		meditationModules = StrToArrStr( meditationModulesStr, ";" );
		radialMenuModules = StrToArrStr( radialMenuModulesStr, ";" );
		resetNewItemsInTabs = StrToArrStr( resetNewItemsInTabsStr, ";" );
	}
}

function GetFHUDConfig() : CModFriendlyHUDConfig
{
	return thePlayer.fHUDConfig;
}

function EatWhite( str : string ) : string
{
	var res : string;
	res = StrReplaceAll( str, " ", "" );
	res = StrReplaceAll( res, "\t", "" );
	res = StrReplaceAll( res, "\n", "" );
	res = StrReplaceAll( res, "\r", "" );
	res = StrReplaceAll( res, "\v", "" );
	res = StrReplaceAll( res, "\f", "" );
	return res;
}

function RestoreSpaces( str : string ) : string
{
	return StrReplaceAll( str, "_", " " );
}

function StrToArrStr( str, div : string ) : array< string >
{
	var ret : array< string >;
	var item, res, left, right : string;
	var spl : bool;
	spl = true;
	res = str;
	while( spl )
	{
		spl = StrSplitFirst( res, div, left, right );
		if ( spl )
		{
			item = RestoreSpaces( EatWhite( left ) );
			res = right;
		}
		else
		{
			item = RestoreSpaces( EatWhite( res ) );
		}
		ret.PushBack( item );
	}
	return ret;
}


//---=== modFriendlyHUD ===---
