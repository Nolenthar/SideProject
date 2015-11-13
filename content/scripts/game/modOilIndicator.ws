//---=== modFriendlyHUD ===---
enum EOilDisplayMode
{
	ODM_ShowDrawn,
	ODM_ShowBoth,
	ODM_NoShow
}

struct SOilData
{
	var oilName : name;
	var charges : int;
	var maxCharges : int;
	var swordID : SItemUniqueId;
	var isHeld : bool;
}

class CModOilIndicator
{
	private var displayMode		: EOilDisplayMode; default displayMode = ODM_ShowDrawn;
	private var currentOils		: array< SOilData >;
	private var previousOils	: array< SOilData >;
	private var playerInventory : CInventoryComponent;
	private var buffsModule		: CR4HudModuleBuffs;
	private var numEffects		: int;

	public function Init()
	{
		if( GetFHUDConfig().showOilIndicator == false )
		{
			displayMode = ODM_NoShow;
		}
		else if( GetFHUDConfig().alwaysDisplayOil == true )
		{
			displayMode = ODM_ShowBoth;
		}
		playerInventory = thePlayer.GetInventory();
		buffsModule = (CR4HudModuleBuffs)theGame.GetHud().GetHudModule( "BuffsModule" );
	}
	
	public function CheckForBuffsUpdate() : bool
	{
		if( displayMode == ODM_NoShow )
		{
			return false;
		}
		previousOils = currentOils;
		currentOils.Clear();
		GetCurrentOils();
		if( OilsHaveChanged() )
		{
			return true;
		}
		return false;
	}
	
	function GetCurrentOils()
	{
		var steelSwordId : SItemUniqueId;
		var silverSwordId : SItemUniqueId;
		var heldSwordId : SItemUniqueId;
		var witcher : W3PlayerWitcher;
		var steelOil : SOilData;
		var silverOil : SOilData;
	
		witcher = GetWitcherPlayer();
		witcher.GetItemEquippedOnSlot( EES_SteelSword, steelSwordId );
		witcher.GetItemEquippedOnSlot( EES_SilverSword, silverSwordId );
		steelOil = GetOilData( steelSwordId );
		silverOil = GetOilData( silverSwordId );
		if( ShouldShowOil( steelOil ) )
		{
			currentOils.PushBack( steelOil );
		}
		if( ShouldShowOil( silverOil ) )
		{
			currentOils.PushBack( silverOil );
		}
	}
	
	function GetOilData( swordID : SItemUniqueId ) : SOilData
	{
		var witcher : W3PlayerWitcher;
		var oilData : SOilData;
		
		witcher = GetWitcherPlayer();
		if( swordID != GetInvalidUniqueId() )
		{
			oilData.oilName = playerInventory.GetSwordOil( swordID );
			oilData.charges = witcher.GetCurrentOilAmmo( swordID );
			oilData.maxCharges = witcher.GetMaxOilAmmo( swordID );
			oilData.swordID = swordID;
			oilData.isHeld = playerInventory.IsItemHeld( swordID );
		}
		return oilData;
	}
	
	function ShouldShowOil( oilData : SOilData ) : bool
	{
		if( oilData.swordID == GetInvalidUniqueId() || oilData.oilName == '' || oilData.charges == 0 )
		{
			return false;
		}
		if( displayMode == ODM_ShowDrawn && oilData.isHeld == false )
		{
			return false;
		}
		return true;
	}
	
	function OilsHaveChanged() : bool
	{
		var i : int;
	
		if( previousOils.Size() == 0 && currentOils.Size() == 0 )
		{
			return false;
		}
		if( previousOils.Size() != currentOils.Size() )
		{
			return true;
		}
		for( i = 0; i < currentOils.Size(); i += 1 )
		{
			if( currentOils[i].oilName != previousOils[i].oilName ||
				currentOils[i].swordID != previousOils[i].swordID ||
				currentOils[i].isHeld != previousOils[i].isHeld )
			{
				return true;
			}
		}
		return false;
	}
	
	public function UpdateBuffsFlashArray( out l_flashArray : CScriptedFlashArray )
	{
		var i				: int;
		var l_flashObject	: CScriptedFlashObject;
		var titleText		: string;
		
		if( displayMode == ODM_NoShow )
		{
			return;
		}
		numEffects = l_flashArray.GetLength();
		for( i = 0; i < currentOils.Size(); i += 1 )
		{
			l_flashObject = buffsModule.GetTempFlashObject();
			l_flashObject.SetMemberFlashBool( "isVisible", true );
			l_flashObject.SetMemberFlashString( "iconName", playerInventory.GetItemIconPathByName( currentOils[i].oilName ) );
			l_flashObject.SetMemberFlashString( "title", GetOilLocalisedName( currentOils[i].oilName ) );
			l_flashObject.SetMemberFlashBool( "isPositive", true );
			l_flashObject.SetMemberFlashNumber( "duration", currentOils[i].charges * 60 );
			l_flashObject.SetMemberFlashNumber( "initialDuration", currentOils[i].maxCharges * 60 );
			l_flashArray.PushBackFlashObject( l_flashObject );
		}
	}
	
	function GetOilLocalisedName( oilName : name ) : string
	{
		var key, left, right : string;

		key = playerInventory.GetItemLocalizedNameByName( oilName );
		StrSplitLast( key, "_", left, right );
		return GetLocStringByKeyExt( left + "_1" );
	}
	
	public function UpdateOilPercent()
	{
		var i : int;

		for( i = 0; i < currentOils.Size(); i += 1 )
		{
			buffsModule.SetBuffsPercent( numEffects + i, currentOils[i].charges * 60, currentOils[i].maxCharges * 60 );
		}
	}
}
//---=== modFriendlyHUD ===---