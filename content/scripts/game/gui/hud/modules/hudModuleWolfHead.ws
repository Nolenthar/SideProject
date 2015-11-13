class CR4HudModuleWolfHead extends CR4HudModuleBase
{	
	private	var m_fxSetVitality						: CScriptedFlashFunction;
	private	var m_fxSetStamina						: CScriptedFlashFunction;
	private	var m_fxSetToxicity						: CScriptedFlashFunction;
	private	var m_fxSetExperience					: CScriptedFlashFunction;
	private	var m_fxSetLockedToxicity				: CScriptedFlashFunction;
	private	var m_fxSetDeadlyToxicity				: CScriptedFlashFunction;
	private	var m_fxShowStaminaNeeded				: CScriptedFlashFunction;
	private	var m_fxSwitchWolfActivation			: CScriptedFlashFunction;
	private var m_fxSetPositiveEffectsCounterSFF	: CScriptedFlashFunction;
	private var m_fxSetNegativeEffectsCounterSFF	: CScriptedFlashFunction;
	private var m_fxSetSignIconSFF					: CScriptedFlashFunction;
	private var m_fxSetSignTextSFF					: CScriptedFlashFunction;
	private var m_fxSetFocusPointsSFF				: CScriptedFlashFunction;
	private var m_fxLockFocusPointsSFF				: CScriptedFlashFunction;	
	private var m_fxSetCiriAsMainCharacter			: CScriptedFlashFunction;
	private var m_fxSetCoatOfArms					: CScriptedFlashFunction;
	private var m_fxSetShowNewLevelIndicator		: CScriptedFlashFunction;
	private var m_fxSetAlwaysDisplayed				: CScriptedFlashFunction;
	private var m_fxDisplayOverloadedIcon			: CScriptedFlashFunction;
	
	private	var	m_LastVitality				: float;
	private	var	m_LastMaxVitality			: float;
	private	var	m_LastStamina				: float;	
	private	var	m_LastMaxStamina			: float;	
	private	var	m_LastExperience			: float;	
	private	var	m_LastMaxExperience			: float;
	private	var	m_LastToxicity				: float;
	private	var	m_LastLockedToxicity		: float;
	private	var	m_LastMaxToxicity			: float;
	private	var	m_bLastDeadlyToxicity		: bool;
	private	var	m_medallionActivated		: bool;
	private var m_oveloadedIconVisible		: bool;
	private var m_focusPoints				: int;
	private var m_iCurrentPositiveEffectsSize : int;
	private var m_iCurrentNegativeEffectsSize : int;
	private var m_signIconName 				: string;
	private var m_CurrentSelectedSign 		: ESignType;
	private var m_IsPlayerCiri				: bool;
	
	private var m_curToxicity				: float;
	private var m_lockedToxicity			: float;
	private var m_curVitality				: float;
	private var m_maxVitality				: float;
	//---=== modFriendlyHUD ===---		
	private var m_lastUpdateTime			: float;
	private var m_lastUpdateVitality		: float;
	//---=== modFriendlyHUD ===---
		
		
	default m_iCurrentPositiveEffectsSize = 0;
	default m_iCurrentNegativeEffectsSize = 0;
	default m_IsPlayerCiri				  = false;

	/* flash */ event OnConfigUI()
	{
		var flashModule : CScriptedFlashSprite;
		var hud : CR4ScriptedHud;
		
		m_anchorName = "mcAnchorWolfHead";
		
		super.OnConfigUI();
		
		flashModule = GetModuleFlash();	
		
		m_fxSetVitality						= flashModule.GetMemberFlashFunction( "setVitality" );
		m_fxSetStamina						= flashModule.GetMemberFlashFunction( "setStamina" );
		m_fxSetToxicity						= flashModule.GetMemberFlashFunction( "setToxicity" );
		m_fxSetExperience					= flashModule.GetMemberFlashFunction( "setExperience" );
		m_fxSetLockedToxicity				= flashModule.GetMemberFlashFunction( "setLockedToxicity" );
		m_fxSetDeadlyToxicity				= flashModule.GetMemberFlashFunction( "setDeadlyToxicity" );
		m_fxShowStaminaNeeded				= flashModule.GetMemberFlashFunction( "showStaminaNeeded" );
		m_fxSwitchWolfActivation			= flashModule.GetMemberFlashFunction( "switchWolfActivation" );
		m_fxSetPositiveEffectsCounterSFF	= flashModule.GetMemberFlashFunction( "setPositiveEffectsCounter" );
		m_fxSetNegativeEffectsCounterSFF 	= flashModule.GetMemberFlashFunction( "setNegativeEffectsCounter" );
		m_fxSetSignIconSFF 					= flashModule.GetMemberFlashFunction( "setSignIcon" );
		m_fxSetSignTextSFF 					= flashModule.GetMemberFlashFunction( "setSignText" );
		m_fxSetFocusPointsSFF				= flashModule.GetMemberFlashFunction( "setFocusPoints" );
		m_fxLockFocusPointsSFF				= flashModule.GetMemberFlashFunction( "lockFocusPoints" );
		m_fxSetCiriAsMainCharacter			= flashModule.GetMemberFlashFunction( "setCiriAsMainCharacter" );
		m_fxSetCoatOfArms					= flashModule.GetMemberFlashFunction( "setCoatOfArms" );
		m_fxSetShowNewLevelIndicator		= flashModule.GetMemberFlashFunction( "setShowNewLevelIndicator" );
		m_fxSetAlwaysDisplayed				= flashModule.GetMemberFlashFunction( "setAlwaysDisplayed" );
		m_fxDisplayOverloadedIcon 			= flashModule.GetMemberFlashFunction( "displayOverloadedIcon" );
		
		m_CurrentSelectedSign = thePlayer.GetEquippedSign();
		m_fxSetSignIconSFF.InvokeSelfOneArg(FlashArgString(GetSignIcon()));
		
		SetTickInterval( 0.5 );
		hud = (CR4ScriptedHud)theGame.GetHud();
		if (hud)
		{
			hud.UpdateHudConfig('WolfMedalion', true);
		}
		DisplayNewLevelIndicator();
		
		UpdateCoatOfArms();
	}
	
	function DisplayNewLevelIndicator()
	{
		var levelManager : W3LevelManager;
		levelManager = GetWitcherPlayer().levelManager;
		if( levelManager.GetPointsFree(ESkillPoint) > 0)
		{
			if( !thePlayer.IsCiri() )
			{
				m_fxSetShowNewLevelIndicator.InvokeSelfOneArg(FlashArgBool(true));
			}
			else
			{
				m_fxSetShowNewLevelIndicator.InvokeSelfOneArg(FlashArgBool(false));
			}
		}
		else
		{
			m_fxSetShowNewLevelIndicator.InvokeSelfOneArg(FlashArgBool(false));
		}
	}

	event OnTick( timeDelta : float )
	{
		UpdateVitality();
		UpdateStamina();
		UpdateToxicity();
		UpdateSignData();
		
		if ( !CanTick( timeDelta ) )
		{
			return true;
		}
		
		UpdateExperience();
		UpdateMedallion();
		//UpdateBuffsCounter();
		UpdateFocusPoints();
		UpdateStateByPlayer();
		//UpdateOverloadedIcon();
		
		//always wolf's head when combat music is playing OR if our toxicity is above 0 OR if our health is below MAX
		//---=== modFriendlyHUD ===---
		if ( IsVisibleTemporarily() || thePlayer.IsCombatMusicEnabled() || (m_curToxicity > 0.f || m_lockedToxicity > 0.f) || (m_curVitality < m_maxVitality) )
		//---=== modFriendlyHUD ===---
			SetAlwaysDisplayed( true );
		else
			SetAlwaysDisplayed( false );	
	}

	public function UpdateVitality() : void
	{
		var l_currentVitality 		: float;
		var l_currentMaxVitality 	: float;
		//---=== modFriendlyHUD ===---
		var l_timeDelta				: float;
		var l_vitalityDelta			: float;
		//---=== modFriendlyHUD ===---
		
		thePlayer.GetStats( BCS_Vitality, l_currentVitality, l_currentMaxVitality );

		m_curVitality = l_currentVitality;
		m_maxVitality = l_currentMaxVitality;

		//---=== modFriendlyHUD ===---
		l_timeDelta = theGame.GetEngineTimeAsSeconds() - m_lastUpdateTime;
		if( theGame.IsCombatModulesEnabled() && l_timeDelta >= 0.5 && m_LastVitality != 0 )
		{
			l_vitalityDelta = GetFHUDConfig().vitalityRiseThreshold * l_timeDelta;
			//CeilF is here to fix weird (rounding?) bug with l_currentVitality being slightly lowered after using character menu
			if ( ( CeilF( l_currentVitality ) < m_lastUpdateVitality || l_currentVitality > m_lastUpdateVitality + l_vitalityDelta ) && m_lastUpdateVitality != 0 )
			{
				thePlayer.RemoveTimer( 'DamageOffTimer' );
				ToggleHUDModule( "WolfHeadModule", true, "OnDamage" );
				thePlayer.AddTimer( 'DamageOffTimer' , 3.0, false );
			}
			m_lastUpdateTime = theGame.GetEngineTimeAsSeconds();
			m_lastUpdateVitality = l_currentVitality;
		}
		//---=== modFriendlyHUD ===---
		
		if( l_currentVitality != m_LastVitality ||  l_currentMaxVitality != m_LastMaxVitality )
		{
			//Percentage is between 0 and 1
			m_fxSetVitality.InvokeSelfOneArg( FlashArgNumber(  l_currentVitality / l_currentMaxVitality ) );
			m_LastVitality = l_currentVitality;
			m_LastMaxVitality = l_currentMaxVitality;
		}
	}
	
	private var playStaminaSoundCue : bool;
	
	public function UpdateStamina() : void
	{
		var l_curStamina 				: float;
		var l_curMaxStamina 			: float;
		var l_tooLowStaminaIndication 	: float = thePlayer.GetShowToLowStaminaIndication();

		thePlayer.GetStats( BCS_Stamina, l_curStamina, l_curMaxStamina );
		
		if ( m_LastStamina != l_curStamina || m_LastMaxStamina != l_curMaxStamina )
		{			
			m_fxSetStamina.InvokeSelfOneArg( FlashArgNumber ( l_curStamina / l_curMaxStamina ) );
			
			m_LastStamina 	 = l_curStamina;
			m_LastMaxStamina = l_curMaxStamina;
			
			if ( l_curStamina <= l_curMaxStamina*0.60 ) // if 60% of stamina play soundcue
				playStaminaSoundCue = true;
				
			if ( l_curStamina <= 0 )
			{
				thePlayer.SoundEvent("gui_no_stamina");
				theGame.VibrateControllerVeryLight(); // no stamina
			}
			else if ( l_curStamina >= l_curMaxStamina && playStaminaSoundCue )
			{
				thePlayer.SoundEvent("gui_stamina_recharged");
				theGame.VibrateControllerVeryLight(); // stamina recharged
				playStaminaSoundCue = false;
			}
		}
		
		if( l_tooLowStaminaIndication > 0 )
		{
			m_fxShowStaminaNeeded.InvokeSelfOneArg( FlashArgNumber ( l_tooLowStaminaIndication / l_curMaxStamina ) );
			thePlayer.SetShowToLowStaminaIndication( 0 );
		}
	}

	public function UpdateToxicity() : void
	{
		var curToxicity 	: float;	//current toxicity WITHOUT offset lock
		var curMaxToxicity 	: float;
		var curLockedToxicity: float;
		var damageThreshold	: float;
		var curDeadlyToxicity : bool;
		
		thePlayer.GetStats( BCS_Toxicity, curToxicity, curMaxToxicity );
		
		curLockedToxicity = thePlayer.GetStat(BCS_Toxicity) - curToxicity;
		
		//need to keep track of these for displaying/hiding the module
		m_curToxicity = curToxicity;
		m_lockedToxicity = curLockedToxicity;
		
		if ( m_LastToxicity != curToxicity || m_LastMaxToxicity != curMaxToxicity || m_LastLockedToxicity != curLockedToxicity )
		{
			//update locked toxicity if lock or max changed
			if( m_LastLockedToxicity != curLockedToxicity || m_LastMaxToxicity != curMaxToxicity)
			{
				m_fxSetLockedToxicity.InvokeSelfOneArg( FlashArgNumber( ( curLockedToxicity )/ curMaxToxicity ) );
				m_LastLockedToxicity = curLockedToxicity;
			}
			m_fxSetToxicity.InvokeSelfOneArg( FlashArgNumber( ( curToxicity + m_LastLockedToxicity )/ curMaxToxicity ) );
			m_LastToxicity 	= curToxicity;
			m_LastMaxToxicity = curMaxToxicity;
			
			damageThreshold = GetWitcherPlayer().GetToxicityDamageThreshold();
			curDeadlyToxicity = ( curToxicity >= damageThreshold * curMaxToxicity );
			if( m_bLastDeadlyToxicity != curDeadlyToxicity ) 
			{
				m_fxSetDeadlyToxicity.InvokeSelfOneArg( FlashArgBool( curDeadlyToxicity ) );
				m_bLastDeadlyToxicity = curDeadlyToxicity;
			}
			
			//keep the wolfhead module displayed if 
		}
	}

	public function UpdateExperience() : void
	{
		var curExperience 	: float;
		var curMaxExperience 	: float;
		
		curExperience = GetCurrentExperience() - GetLevelExperience();
		curMaxExperience = GetTargetExperience() - GetLevelExperience();
		
		if ( m_LastExperience != curExperience || m_LastMaxExperience != curMaxExperience )
		{			
			m_fxSetExperience.InvokeSelfOneArg( FlashArgNumber(curExperience / curMaxExperience));
			
			m_LastExperience 	 = curExperience;
			m_LastMaxExperience = curMaxExperience;
		}
	}
	
	private function GetCurrentExperience() : float
	{
		var levelManager : W3LevelManager;
		
		levelManager = GetWitcherPlayer().levelManager;
		
		return levelManager.GetPointsTotal(EExperiencePoint);;
	}
	
	private function GetLevelExperience() : float
	{
		var levelManager : W3LevelManager;
		
		levelManager = GetWitcherPlayer().levelManager;
		return levelManager.GetTotalExpForCurrLevel();
	}

	private function GetTargetExperience() : float
	{
		var levelManager : W3LevelManager;
		
		levelManager = GetWitcherPlayer().levelManager;
		return levelManager.GetTotalExpForNextLevel();
	}
	
	public function UpdateMedallion() : void
	{
		var l_curMedallionActivated : bool = GetWitcherPlayer().GetMedallion().IsActive();
		
		if( m_medallionActivated != l_curMedallionActivated )
		{
			m_medallionActivated = l_curMedallionActivated;
			m_fxSwitchWolfActivation.InvokeSelfOneArg( FlashArgBool( m_medallionActivated ) );
		}
	}
	
	private function UpdateFocusPoints()
	{
		var curFocusPoints : int = FloorF( GetWitcherPlayer().GetStat( BCS_Focus ) );
		
		if ( m_focusPoints != curFocusPoints )
		{
			m_focusPoints = curFocusPoints;
			
			m_fxSetFocusPointsSFF.InvokeSelfOneArg( FlashArgInt( m_focusPoints) );
		}
	}

	public function ResetFocusPoints()
	{
		var curFocusPoints : int = FloorF( GetWitcherPlayer().GetStat( BCS_Focus ) );
		m_fxSetFocusPointsSFF.InvokeSelfOneArg( FlashArgInt(curFocusPoints) );
	}
	
	public function LockFocusPoints( value : int )
	{
		//we only have 3 adrenaline points
		if ( value <= 3 )
			m_fxLockFocusPointsSFF.InvokeSelfOneArg( FlashArgInt( value) );
	}
	
	// #J Moved into buffs module. Keeping here in case we change our mind
	/*private function UpdateOverloadedIcon():void
	{
		var isPlayerOveloaded : bool;
		var encumbrance 	  : int;
		var encumbranceMax    : int;
		
		isPlayerOveloaded = thePlayer.HasBuff( EET_OverEncumbered );
		if (m_oveloadedIconVisible != isPlayerOveloaded)
		{
			m_oveloadedIconVisible = isPlayerOveloaded;
			m_fxDisplayOverloadedIcon.InvokeSelfOneArg( FlashArgBool(m_oveloadedIconVisible) );
		}
	}*/
	
	// #J Will now always show the full buffs list. Keeping this code in case we change our mind
	/*private function UpdateBuffsCounter()
	{
		var l_PositiveEffectsSize : int;
		var l_NegativeEffectsSize : int;
		var effectArray : array< CBaseGameplayEffect >;
		var i : int;
		
		effectArray = thePlayer.GetCurrentEffects();
		l_PositiveEffectsSize = 0;
		l_NegativeEffectsSize = 0;
		
		for ( i = 0; i < effectArray.Size(); i += 1 )
		{
			if(effectArray[i].ShowOnHUD())
			{				
				if(effectArray[i].IsPositive() )
				{
					l_PositiveEffectsSize += 1;
				}
				else
				{
					l_NegativeEffectsSize += 1;
				}
			}
		}
		
		if( l_PositiveEffectsSize != m_iCurrentPositiveEffectsSize )
		{
			m_iCurrentPositiveEffectsSize = l_PositiveEffectsSize;
			m_fxSetPositiveEffectsCounterSFF.InvokeSelfOneArg(FlashArgInt(m_iCurrentPositiveEffectsSize));
		}		
		if( l_NegativeEffectsSize != m_iCurrentNegativeEffectsSize )
		{
			m_iCurrentNegativeEffectsSize = l_NegativeEffectsSize;
			m_fxSetNegativeEffectsCounterSFF.InvokeSelfOneArg(FlashArgInt(m_iCurrentNegativeEffectsSize));
		}
	}*/
	
	public function UpdateSignData()
	{
		if( thePlayer.GetEquippedSign() != m_CurrentSelectedSign )
		{
			m_CurrentSelectedSign = thePlayer.GetEquippedSign();
			m_fxSetSignIconSFF.InvokeSelfOneArg(FlashArgString(GetSignIcon()));
			m_fxSetSignTextSFF.InvokeSelfOneArg(FlashArgString(GetLocStringByKeyExt(SignEnumToString(m_CurrentSelectedSign))));
		}
	}
	
	public function UpdateStateByPlayer()
	{
		if( thePlayer.IsCiri() != m_IsPlayerCiri )
		{
			m_IsPlayerCiri = thePlayer.IsCiri();
			m_fxSetCiriAsMainCharacter.InvokeSelfOneArg(FlashArgBool(m_IsPlayerCiri));
			DisplayNewLevelIndicator();
		}
	}
	
	public function SetCoatOfArms( val : bool )
	{
		thePlayer.SetUsingCoatOfArms( val );
		
		UpdateCoatOfArms();
	}
	
	private function UpdateCoatOfArms()
	{
		m_fxSetCoatOfArms.InvokeSelfOneArg( FlashArgBool( thePlayer.IsUsingCoatOfArms() ) );
	}
	
	private function GetSignIcon() : string
	{
		if((W3ReplacerCiri)thePlayer)
		{
			return "hud/radialmenu/mcCiriPower.png";
		}
		return GetSignIconByType(m_CurrentSelectedSign); 
	}
	
	private function GetSignIconByType( signType : ESignType ) : string
	{
		switch( signType )
		{
			case ST_Aard:		return "hud/radialmenu/mcAard.png";
			case ST_Yrden:		return "hud/radialmenu/mcYrden.png";
			case ST_Igni:		return "hud/radialmenu/mcIgni.png";
			case ST_Quen:		return "hud/radialmenu/mcQuen.png";
			case ST_Axii:		return "hud/radialmenu/mcAxii.png";
			default : return "";
		}
	}
	
	public function ShowLevelUpIndicator( value : bool )
	{
		m_fxSetShowNewLevelIndicator.InvokeSelfOneArg(FlashArgBool(value));
	}

	public function SetAlwaysDisplayed( value : bool )
	{
		m_fxSetAlwaysDisplayed.InvokeSelfOneArg(FlashArgBool(value));
	}
}

exec function AlwaysDisplayHUD( value : bool )
{
	var hudWolfHeadModule : CR4HudModuleWolfHead;		
	var hud : CR4ScriptedHud;
	hud = (CR4ScriptedHud)theGame.GetHud();
	
	hudWolfHeadModule = (CR4HudModuleWolfHead)hud.GetHudModule( "WolfHeadModule" );
	if ( hudWolfHeadModule )
	{
		hudWolfHeadModule.SetAlwaysDisplayed(value);
	}
}

exec function coa( val : bool )
{
	var hud : CR4ScriptedHud;
	var hudWolfHeadModule : CR4HudModuleWolfHead;		

	hud = (CR4ScriptedHud)theGame.GetHud();
	if ( hud )
	{
		hudWolfHeadModule = (CR4HudModuleWolfHead)hud.GetHudModule( "WolfHeadModule" );
		if ( hudWolfHeadModule )
		{
			hudWolfHeadModule.SetCoatOfArms( val );
		}
	}
}