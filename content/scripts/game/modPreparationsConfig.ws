//---=== modPreparations ===---
class CModPreparationsConfig
{
	//allow vanilla meditation menu (only for waiting purposes outside of real time meditation mode, no mod's restrictions apply)
	const var allowMenu : bool;					default allowMenu = true;
	//allow meditation near existing campfires
	const var allowCampFire : bool;				default allowCampFire = true;
	//allow meditation near fire sources (campfires are not fire sources)
	const var allowFireSource : bool;			default allowFireSource = true;
	//allow meditation near any light source (campfires and fire sources are also light sources)
	const var allowLightSource : bool;			default allowLightSource = false;
	//disallows meditating in interior
	const var disallowInterior : bool;			default disallowInterior = false;
	//disallows meditating in settlements (can still meditate in interior if disallowInterior = false)
	const var disallowSettlement : bool;		default disallowSettlement = false;
	//disallows meditating near non-allied NPCs
	const var disallowNPCs : bool;				default disallowNPCs = false;
	//min distance to NPC
	const var npcDistance : float;				default npcDistance = 20.0;
	//allow spawning campfire in interiors
	const var allowCampFireInInterior : bool;	default allowCampFireInInterior = false;
	//amount of timber needed to spawn campfire
	const var timberAmount : int;				default timberAmount = 1;
	//amount of hardened timber needed to spawn campfire (if player has no timber)
	const var hardTimberAmount : int;			default hardTimberAmount = 1;

	//disallows creating alchemy items while not meditating
	const var disallowAlchemy : bool;			default disallowAlchemy = true;
	//disallows repairing items while not meditating
	const var disallowRepair : bool;			default disallowRepair = true;
	//disallows upgrading items (runes, glyphs) while not meditating
	const var disallowUpgrade : bool;			default disallowUpgrade = true;
	//disallows buying new skills while not meditating
	const var disallowBuySkill : bool;			default disallowBuySkill = true;
	//disallows equipping/unequipping/swapping skills while not meditating
	const var disallowEquipSkill : bool;		default disallowEquipSkill = true;
	//disallows equipping/unequipping mutagens while not meditating
	const var disallowEquipMutagen : bool;		default disallowEquipMutagen = true;
	
	//time in seconds to create alchemy item
	const var timeToCreateItemSec : int;		default timeToCreateItemSec = 1800;
	//time in seconds to repair an item
	const var timeToRepairItemSec : int;		default timeToRepairItemSec = 3600;
	//time in seconds to upgrade an item
	const var timeToUpgradeItemSec : int;		default timeToUpgradeItemSec = 3600;
	//time in seconds to buy skill
	const var timeToBuySkillSec : int;			default timeToBuySkillSec = 7200;
	//time in seconds to equip skill (unequip/swap takes no time)
	const var timeToEquipSkillSec : int;		default timeToEquipSkillSec = 900;
	//time in seconds to equip mutagen (unequipping takes no time)
	const var timeToEquipMutagenSec : int;		default timeToEquipMutagenSec = 7200;

	//real time meditation acceleration parameters
	const var MAX_HOURS_PER_MINUTE : float;		default MAX_HOURS_PER_MINUTE = 60;
	const var HOURS_PER_MINUTE_PER_SECOND : float;	default HOURS_PER_MINUTE_PER_SECOND = 6;
	
	//max oil charges
	const var maxOilCharges : int;				default maxOilCharges = 4;
}

function GetPreparationsConfig() : CModPreparationsConfig
{
	return GetWitcherPlayer().prepConfig;
}
//---=== modPreparations ===---