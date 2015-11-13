//---=== modPreparations ===---
state ExplorationMeditation in W3PlayerWitcher extends Exploration
{
	private var updatedGameTime : GameTime;
	private var storedHoursPerMinute, hoursPerMinute : float;
	private var startedFastforwardSecs : float;
	private var fullHealth, meditationIdle, startedFastforward : bool;
	private	var noSaveLock : int;
	
	public function StartFastforward()
	{
		var fastForward : CGameFastForwardSystem;

		if( meditationIdle && !startedFastforward )
		{
			startedFastforward = true;
			startedFastforwardSecs = theGame.GetEngineTimeAsSeconds();
			updatedGameTime = theGame.GetGameTime();
			hoursPerMinute = storedHoursPerMinute;
			fullHealth = ( parent.GetStat( BCS_Vitality ) >= parent.GetStatMax( BCS_Vitality ) );
			fastForward = theGame.GetFastForwardSystem();
			fastForward.BeginFastForward();
		}
	}

	public function EndFastforward()
	{
		var fastForward : CGameFastForwardSystem;
	
		if( startedFastforward )
		{
			fastForward = theGame.GetFastForwardSystem();
			fastForward.AllowFastForwardSelfCompletion();
			theGame.SetHoursPerMinute( storedHoursPerMinute );
			startedFastforward = false;
			startedFastforwardSecs = 0;
		}
	}

	public function IsMeditationIdle() : bool
	{
		return meditationIdle;
	}

	event OnBehaviorGraphNotification( notificationName : name, stateName : name )
	{
		if ( parent.GetPlayerAction() == PEA_Meditation )
		{
			if( notificationName == 'OnPlayerActionStartFinished' && !meditationIdle )
			{
				meditationIdle = true;
			}
		}
		parent.OnBehaviorGraphNotification( notificationName, stateName );
	}
	
	event OnEnterState( prevStateName : name )
	{	
		super.OnEnterState( prevStateName );
		
		//parent.DisplayHudMessage( "ExplorationMeditation begin" );
		meditationIdle = false;
		BlockGameplayActions( true );
		theGame.CreateNoSaveLock( "in_exploration_meditation", noSaveLock );
		storedHoursPerMinute = theGame.GetHoursPerMinute();
		HideItemsInHands();
		BeginExplorationMeditation();
		//---=== modFriendlyHUD ===---
		if ( theGame.IsHudMeditationModulesEnabled() )
		{
			thePlayer.RemoveTimer( 'MeditationOffTimer' );
			ToggleMeditModules( true, "RealTimeMeditation" );
		}
		//---=== modFriendlyHUD ===---
	}

	event OnLeaveState( nextStateName : name )
	{
		//parent.DisplayHudMessage( "ExplorationMeditation end" );
		meditationIdle = false;
		BlockGameplayActions( false );
		theGame.ReleaseNoSaveLock( noSaveLock );
		EndExplorationMeditation();
		//---=== modFriendlyHUD ===---
		if ( theGame.IsHudMeditationModulesEnabled()  )
		{
			thePlayer.AddTimer( 'MeditationOffTimer' , GetFHUDConfig().fadeOutTimeSeconds, false );
		}
		//---=== modFriendlyHUD ===---
		super.OnLeaveState( nextStateName );
	}
	
	event OnPlayerTickTimer( deltaTime : float )
	{
		super.OnPlayerTickTimer( deltaTime );
		
		if( parent.GetPlayerAction() != PEA_Meditation )
		{
			parent.EndExplorationMeditation();
		}
		else if( startedFastforward )
		{
			MeditationUpdate();
		}
	}
	
	private function BeginExplorationMeditation()
	{
		startedFastforward = false;
		if( ( !thePlayer.IsInInterior() || GetPreparationsConfig().allowCampFireInInterior ) && !parent.foundOpenFire )
		{
			parent.SetBehaviorVariable( 'MeditateWithIgnite', 1 );
			thePlayer.AddTimer( 'SpawnCampFireTimer', 4.5, false );
		}
		else if( parent.foundOpenFire )
		{
			ToggleOpenFire();
		}
		//parent.SetBehaviorVariable( 'HasCampfire', 1 );
		parent.PlayerStartAction( PEA_Meditation );
	}
	
	private function ToggleOpenFire()
	{
		var glComponent : CGameplayLightComponent;
		
		if( !parent.openFireEnt )
		{
			return;
		}
		glComponent = (CGameplayLightComponent)parent.openFireEnt.GetComponentByClassName( 'CGameplayLightComponent' );
		if( !glComponent.IsLightOn() )
		{
			glComponent.ToggleLight();
		}
	}
	
	timer function SpawnCampFireTimer(dt : float, id : int)
	{
		var template : CEntityTemplate;
		var pos : Vector;
		var z : float;
		var rot : EulerAngles;

		if( thePlayer.inv.GetItemQuantityByName( 'Timber' ) >= GetPreparationsConfig().timberAmount )
		{
			thePlayer.inv.RemoveItemByName( 'Timber', GetPreparationsConfig().timberAmount );
		}
		else if( thePlayer.inv.GetItemQuantityByName( 'Hardened timber' ) >= GetPreparationsConfig().hardTimberAmount )
		{
			thePlayer.inv.RemoveItemByName( 'Hardened timber', GetPreparationsConfig().hardTimberAmount );
		}
		template = (CEntityTemplate)LoadResource( "environment\decorations\light_sources\campfire\campfire_01.w2ent", true);
		pos = thePlayer.GetWorldPosition() + VecFromHeading( thePlayer.GetHeading() ) * Vector(0.8, 0.8, 0);
		if( theGame.GetWorld().NavigationComputeZ( pos, pos.Z - 128, pos.Z + 128, z ) )
		{
			pos.Z = z;
		}
		if( theGame.GetWorld().PhysicsCorrectZ( pos, z ) )
		{
			pos.Z = z;
		}
		rot = thePlayer.GetWorldRotation();
		parent.spawnedCampFire = (W3Campfire)theGame.CreateEntity(template, pos, rot);
		parent.spawnedCampFire.ToggleFire( true );
	}
	
	private function EndExplorationMeditation()
	{
		thePlayer.RemoveTimer( 'SpawnCampFireTimer' );
		if( parent.spawnedCampFire )
		{
			parent.spawnedCampFire.ToggleFire( false );
			parent.spawnedCampFire.Destroy();
			parent.spawnedCampFire = NULL;
		}
		if( startedFastforward )
		{
			EndFastforward();
		}
		//parent.SetBehaviorVariable( 'HasCampfire', 0 );
		parent.SetBehaviorVariable( 'MeditateWithIgnite', 0 );
		if( parent.GetPlayerAction() == PEA_Meditation )
		{
			parent.PlayerStopAction( PEA_Meditation );
		}
	}
	
	private function MeditationUpdate()
	{
		var realTimeSecs, gameTimeSec : float;
		
		if( GetDayPart( theGame.GetGameTime() ) != GetDayPart( updatedGameTime ) )
		{
			theGame.VibrateControllerVeryLight();
		}
		gameTimeSec = GameTimeToSeconds( theGame.GetGameTime() - updatedGameTime );
		realTimeSecs = ConvertGameSecondsToRealTimeSeconds( gameTimeSec );
		parent.UpdateEffectsAccelerated( realTimeSecs, hoursPerMinute / storedHoursPerMinute );
		if( !fullHealth )
		{
			fullHealth = NotifyOnHealthRegenEnded();
		}
		if( hoursPerMinute < GetPreparationsConfig().MAX_HOURS_PER_MINUTE )
		{
			hoursPerMinute = MinF( GetPreparationsConfig().MAX_HOURS_PER_MINUTE, storedHoursPerMinute + ( theGame.GetEngineTimeAsSeconds() - startedFastforwardSecs ) * GetPreparationsConfig().HOURS_PER_MINUTE_PER_SECOND );
			theGame.SetHoursPerMinute( hoursPerMinute );
		}
		updatedGameTime = theGame.GetGameTime();
	}
	
	private function NotifyOnHealthRegenEnded() : bool
	{
		if ( parent.GetStat( BCS_Vitality ) >= parent.GetStatMax( BCS_Vitality ) )
		{
			theGame.VibrateControllerLight();
			return true;
		}
		return false;
	}
	
	private function HideItemsInHands()
	{
		if ( parent.GetCurrentMeleeWeaponType() != PW_None )
		{
			parent.OnEquipMeleeWeapon( PW_None, true, true );
		}
		if ( parent.IsHoldingItemInLHand() )
		{
			parent.HideUsableItem( true );
		}
		if ( parent.rangedWeapon )
		{
			parent.OnRangedForceHolster( true, true, false );
		}
	}
	
	function BlockGameplayActions( lock : bool )
	{
		var exceptions : array< EInputActionBlock >;
		
		exceptions.PushBack( EIAB_MeditationWaiting );
		exceptions.PushBack( EIAB_OpenFastMenu );
		exceptions.PushBack( EIAB_OpenInventory );
		exceptions.PushBack( EIAB_OpenAlchemy );
		exceptions.PushBack( EIAB_OpenCharacterPanel );
		exceptions.PushBack( EIAB_OpenJournal );
		exceptions.PushBack( EIAB_OpenMap );
		exceptions.PushBack( EIAB_OpenGlossary );
		exceptions.PushBack( EIAB_RadialMenu );
	
		if ( lock )
		{
			thePlayer.BlockAllActions( 'ExplorationMeditationLock', true, exceptions );
		}	
		else
		{
			thePlayer.BlockAllActions( 'ExplorationMeditationLock', false);
		}
	}
}
//---=== modPreparations ===---
