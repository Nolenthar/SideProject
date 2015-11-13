//---=== modFriendlyHUD ===---
struct SQuenStatus
{
	var active : bool;
	var duration : float;
	var maxDuration : float;
}

class CModQuenDuration
{
	private var showQuenDuration : bool; default showQuenDuration = true;
	private var maxQuenDuration : float; default maxQuenDuration = -1;
	private var buffsModule : CR4HudModuleBuffs;
	private var prevStatus, curStatus : SQuenStatus;
	private var numEffects : int;

	public function Init()
	{
		showQuenDuration = GetFHUDConfig().showQuenDuration;
		maxQuenDuration = GetFHUDConfig().maxQuenDurationOverride;
		buffsModule = (CR4HudModuleBuffs)theGame.GetHud().GetHudModule( "BuffsModule" );
	}
	
	public function CheckForQuenUpdate() : bool
	{
		prevStatus = curStatus;
		curStatus = GetQuenStatus();
		if( showQuenDuration && prevStatus.active != curStatus.active )
		{
			return true;
		}
		return false;
	}
	
	function GetQuenStatus() : SQuenStatus
	{
		var status : SQuenStatus;
		
		status.active = IsQuenActive();
		status.duration = GetQuenDuration();
		status.maxDuration = GetMaxQuenDuration();
		return status;
	}
	
	function IsQuenActive() : bool
	{
		var quen : W3QuenEntity;
		
		quen = (W3QuenEntity)GetWitcherPlayer().GetSignEntity( ST_Quen );
		return ( quen.GetCurrentStateName() == 'ShieldActive' && quen.GetShieldHealth() > 0 );
	}
	
	function GetQuenDuration() : float
	{
		var quen : W3QuenEntity;
		
		quen = (W3QuenEntity)GetWitcherPlayer().GetSignEntity( ST_Quen );
		return quen.GetShieldRemainingDuration();
	}
	
	function GetMaxQuenDuration() : float
	{
		if( maxQuenDuration > -1 )
		{
			return maxQuenDuration;
		}
		return CalculateAttributeValue( thePlayer.GetSkillAttributeValue( S_Magic_4, 'shield_duration', true, true ) );
	}
	
	public function UpdateBuffsFlashArray( out l_flashArray : CScriptedFlashArray )
	{
		var l_flashObject	: CScriptedFlashObject;
	
		if( curStatus.active && showQuenDuration )
		{
			numEffects = l_flashArray.GetLength();
			l_flashObject = buffsModule.GetTempFlashObject();
			l_flashObject.SetMemberFlashBool( "isVisible", true );
			l_flashObject.SetMemberFlashString( "iconName", "hud/radialmenu/mcQuen.png" );
			l_flashObject.SetMemberFlashString( "title", GetLocStringByKeyExt( "skill_name_magic_4" ) );
			l_flashObject.SetMemberFlashBool( "isPositive", true );
			l_flashObject.SetMemberFlashNumber( "duration", curStatus.duration );
			l_flashObject.SetMemberFlashNumber( "initialDuration", curStatus.maxDuration );
			l_flashArray.PushBackFlashObject( l_flashObject );
		}
	}
	
	public function UpdateQuenPercent()
	{
		if( curStatus.active && showQuenDuration )
		{
			buffsModule.SetBuffsPercent( numEffects, curStatus.duration, curStatus.maxDuration );
		}
	}
}
//---=== modFriendlyHUD ===---