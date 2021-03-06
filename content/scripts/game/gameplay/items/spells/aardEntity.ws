/***********************************************************************/
/** Copyright © 2012-2013 Patryk Fiutowski, Tomek Kozera
/***********************************************************************/

struct SAardEffects
{
	editable var baseCommonThrowEffect 				: name;
	editable var baseCommonThrowEffectUpgrade1		: name;
	editable var baseCommonThrowEffectUpgrade2		: name;
	editable var baseCommonThrowEffectUpgrade3		: name;

	editable var throwEffectSoil					: name;
	editable var throwEffectSoilUpgrade1			: name;
	editable var throwEffectSoilUpgrade2			: name;
	editable var throwEffectSoilUpgrade3			: name;
	
	editable var throwEffectSPNoUpgrade				: name;
	editable var throwEffectSPUpgrade1				: name;
	editable var throwEffectSPUpgrade2				: name;
	editable var throwEffectSPUpgrade3				: name;
	
	editable var throwEffectDmgNoUpgrade			: name;
	editable var throwEffectDmgUpgrade1				: name;
	editable var throwEffectDmgUpgrade2				: name;
	editable var throwEffectDmgUpgrade3				: name;
	
	editable var throwEffectWater 					: name;
	editable var throwEffectWaterUpgrade1			: name;
	editable var throwEffectWaterUpgrade2			: name;
	editable var throwEffectWaterUpgrade3			: name;
	
	editable var cameraShakeStrength				: float;
}

struct SAardAspect
{
	editable var projTemplate		: CEntityTemplate;
	editable var cone				: float;
	editable var distance			: float;
	editable var distanceUpgrade1	: float;
	editable var distanceUpgrade2	: float;
	editable var distanceUpgrade3	: float;
}

statemachine class W3AardEntity extends W3SignEntity
{
	editable var aspects		: array< SAardAspect >;
	editable var effects		: array< SAardEffects >;
	editable var waterTestOffsetZ : float;
	editable var waterTestDistancePerc : float;
	
	var projectileCollision 		: array< name >;
	
	default skillEnum = S_Magic_1;
	default waterTestOffsetZ = -2;
	default waterTestDistancePerc = 0.5;


	
		hint waterTestOffsetZ = "Z offset added to Aard Entity when testing for water level";
		hint waterTestDistancePerc = "Percentage of sign distance to use along heading for water test";		
		
	public function GetSignType() : ESignType
	{
		return ST_Aard;
	}
		
	public editable var waveProjectileTemplate : CEntityTemplate;
		
	event OnStarted()
	{				
		if(IsAlternateCast())
		{
			//in case of 360 aard don't call super since we don't want any attachment done		
			
			if(owner.CanUseSkill(S_Magic_s30))
			{
				if ( thePlayer.GetStat(4,  /*NOP*/ ) >= 3)
				{	
					theGame.GetGameCamera().PlayEffect('frost',  /*NOP*/ );		// double for more effect, since it gets deleted right away
					theGame.GetGameCamera().PlayEffect('frost',  /*NOP*/ );	
					theGame.GetGameCamera().StopEffect('frost',  /*NOP*/ );
					theGame.SetTimeScale(0.2f, theGame.GetTimescaleSource(7), theGame.GetTimescalePriority(7), false);
					thePlayer.AddTimer('RemoveAardFreezeSloMo', 0.3);
					//action.AddEffectInfo(EET_SlowdownFrost);	
				}
			}
			
			if((CPlayer)owner.GetActor())
				GetWitcherPlayer().FailFundamentalsFirstAchievementCondition();
		}		
		else
		{
			super.OnStarted();
		}
		
		projectileCollision.Clear();
		projectileCollision.PushBack( 'Projectile' );
		projectileCollision.PushBack( 'Door' );
		projectileCollision.PushBack( 'Static' );		
		projectileCollision.PushBack( 'Character' );
		projectileCollision.PushBack( 'ParticleCollider' ); //Added so it can collide with Aard, but Geralt isn't blocked. Used for QFM_Hit_By_Aard on otherwise non-colliding objects. DZ
		
		if ( owner.ChangeAspect( this, S_Magic_s01 ) )
		{
			CacheActionBuffsFromSkill();
			GotoState( 'AardCircleCast' );
		}
		else
		{
			GotoState( 'AardConeCast' );
		}
	}

	//ignore
	event OnAardHit( sign : W3AardProjectile ) {}

	// HACK: postponing ProcessThrow to MainTick
	// We do this to avoid calling StaticTrace during physics fetch - ProcessThrow is triggered by animation event.
	
	var processThrow_alternateCast : bool;
	
	protected function ProcessThrow( alternateCast : bool )
	{
		if ( owner.IsPlayer() )
		{
			// player's ProcessThrow() is already called on MainTick
			ProcessThrow_MainTick( alternateCast );
		}
		else
		{
			processThrow_alternateCast = alternateCast;
			AddTimer( 'ProcessThrowTimer', 0.00000001f, , , TICK_Main );
		}
	}
	
	timer function ProcessThrowTimer( dt : float, id : int )
	{
		ProcessThrow_MainTick( processThrow_alternateCast );
	}
	
	// HACK ends here
	
	protected function ProcessThrow_MainTick( alternateCast : bool )
	{
		var projectile	: W3AardProjectile;
		var spawnPos, collisionPos, collisionNormal, waterCollTestPos : Vector;
		var spawnRot : EulerAngles;
		var heading : Vector;
		var distance, waterZ, staminaDrain : float;
		var ownerActor : CActor;
		var dispersionLevel : int;
		var attackRange : CAIAttackRange;
		var movingAgent : CMovingPhysicalAgentComponent;
		var hitsWater : bool;
		var collisionGroupNames : array<name>;
		var player : CR4Player;
		
		var action : W3DamageAction;
		
		ownerActor = owner.GetActor();
		
		if ( owner.IsPlayer() )
		{
			GCameraShake(effects[fireMode].cameraShakeStrength, true, this.GetWorldPosition(), 30.0f);
		}
		
		//set distance 
		if ( owner.CanUseSkill( S_Magic_s20 ) )
		{
			switch(owner.GetSkillLevel(S_Magic_s20))
			{
				case 1 :
					distance = aspects[fireMode].distanceUpgrade1;
					break;
				case 2 :
					distance = aspects[fireMode].distanceUpgrade2;
					break;
				case 3 :
					distance = aspects[fireMode].distanceUpgrade3;
					break;
				default :
					LogAssert(false, "W3AardEntity.ProcessThrow: S_Magic_s20 skill level out of bounds!");
			}
		}
		else
		{
			distance = aspects[fireMode].distance;
		}	
		
		if ( owner.HasCustomAttackRange() )
		{
			attackRange = theGame.GetAttackRangeForEntity( this, owner.GetCustomAttackRange() );
		}
		else if( owner.CanUseSkill( S_Magic_s20 ) )
		{
			dispersionLevel = owner.GetSkillLevel(S_Magic_s20);
			
			if(dispersionLevel == 1)
			{
				if ( !alternateCast )
					attackRange = theGame.GetAttackRangeForEntity( this, 'cone_upgrade1' );
				else
					attackRange = theGame.GetAttackRangeForEntity( this, 'blast_upgrade1' );
			}
			else if(dispersionLevel == 2)
			{
				if ( !alternateCast )
					attackRange = theGame.GetAttackRangeForEntity( this, 'cone_upgrade2' );
				else
					attackRange = theGame.GetAttackRangeForEntity( this, 'blast_upgrade2' );
			}
			else if(dispersionLevel == 3)
			{
				if ( !alternateCast )
					attackRange = theGame.GetAttackRangeForEntity( this, 'cone_upgrade3' );
				else
					attackRange = theGame.GetAttackRangeForEntity( this, 'blast_upgrade3' );
			}
		}
		else
		{
			if ( !alternateCast )
				attackRange = theGame.GetAttackRangeForEntity( this, 'cone' );
			else
				attackRange = theGame.GetAttackRangeForEntity( this, 'blast' );
		}
		
		// set spawning position
		spawnPos = GetWorldPosition();
		spawnRot = GetWorldRotation();
		heading = this.GetHeadingVector();
		
		//we move the projectile back as a hackfix for situations where:
		// geralt would stand facing a wall and thus create projectile inside wall causing it to work on the other side of the collision
		// geralt would stande close to a fireplace and his projectile would be created 'beyond' it and thus not work with it
		if ( alternateCast )
		{
			spawnPos.Z -= 0.5;
			
			projectile = (W3AardProjectile)theGame.CreateEntity( aspects[fireMode].projTemplate, spawnPos - heading * 0.7, spawnRot );				
			projectile.ExtInit( owner, skillEnum, this );	
			projectile.SetAttackRange( attackRange );
			projectile.SphereOverlapTest( distance, projectileCollision );			
		}
		else
		{			
			spawnPos -= 0.7 * heading;
			
			projectile = (W3AardProjectile)theGame.CreateEntity( aspects[fireMode].projTemplate, spawnPos, spawnRot );				
			projectile.ExtInit( owner, skillEnum, this );							
			projectile.SetAttackRange( attackRange );
			// shoot cake 3.5 m height and 30 m/s fast
			projectile.ShootCakeProjectileAtPosition( aspects[fireMode].cone, 3.5f, 0.0f, 30.0f, spawnPos + heading * distance, distance, projectileCollision );			
		}
		
		if(ownerActor.HasAbility('Glyphword 6 _Stats', true))
		{
			staminaDrain = CalculateAttributeValue(ownerActor.GetAttributeValue('glyphword6_stamina_drain_perc'));
			projectile.SetStaminaDrainPerc(staminaDrain);			
		}
		//FX - different fx when hitting water
		if(alternateCast)
		{
			movingAgent = (CMovingPhysicalAgentComponent)ownerActor.GetMovingAgentComponent();
			hitsWater = movingAgent.GetSubmergeDepth() < 0;
		}
		else
		{
			waterCollTestPos = GetWorldPosition() + heading * distance * waterTestDistancePerc;			
			waterCollTestPos.Z += waterTestOffsetZ;
			collisionGroupNames.PushBack('Terrain');
			
			//water Z
			waterZ = theGame.GetWorld().GetWaterLevel(waterCollTestPos, true);
			
			//terrain collision
			if(theGame.GetWorld().StaticTrace(GetWorldPosition(), waterCollTestPos, collisionPos, collisionNormal, collisionGroupNames))
			{
				//if water level is the highest of all
				if(waterZ > collisionPos.Z && waterZ > waterCollTestPos.Z)
					hitsWater = true;
				else
					hitsWater = false;
			}
			else
			{
				//no terrain - just water level check
				hitsWater = (waterCollTestPos.Z <= waterZ);
			}
		}
		
		PlayAardFX(hitsWater);
		ownerActor.OnSignCastPerformed(ST_Aard, alternateCast);
		AddTimer('DelayedDestroyTimer', 0.1, true, , , true);
	}
	
	//plays aard fx
	public final function PlayAardFX(hitsWater : bool)
	{
		var dispersionLevel : int;
		
		if ( owner.CanUseSkill( S_Magic_s20 ) )
		{
			dispersionLevel = owner.GetSkillLevel(S_Magic_s20);
			
			if(dispersionLevel == 1)
			{			
				//base
				PlayEffect( effects[fireMode].baseCommonThrowEffectUpgrade1 );
			
				//terrain specific
				if(hitsWater)
					PlayEffect( effects[fireMode].throwEffectWaterUpgrade1 );
				else
					PlayEffect( effects[fireMode].throwEffectSoilUpgrade1 );
			}
			else if(dispersionLevel == 2)
			{			
				//base
				PlayEffect( effects[fireMode].baseCommonThrowEffectUpgrade2 );
			
				//terrain specific
				if(hitsWater)
					PlayEffect( effects[fireMode].throwEffectWaterUpgrade2 );
				else
					PlayEffect( effects[fireMode].throwEffectSoilUpgrade2 );
			}
			else if(dispersionLevel == 3)
			{			
				//base
				PlayEffect( effects[fireMode].baseCommonThrowEffectUpgrade3 );
			
				//terrain specific
				if(hitsWater)
					PlayEffect( effects[fireMode].throwEffectWaterUpgrade3 );
				else
					PlayEffect( effects[fireMode].throwEffectSoilUpgrade3 );
			}
		}
		else
		{
			//base
			PlayEffect( effects[fireMode].baseCommonThrowEffect );
		
			//terrain specific
			if(hitsWater)
				PlayEffect( effects[fireMode].throwEffectWater );
			else
				PlayEffect( effects[fireMode].throwEffectSoil );
		}
		
		//bonus sp fx
		if(owner.CanUseSkill(S_Magic_s12))
		{
			//different fx based on what is the current range of aard
			switch(dispersionLevel)
			{
				case 0:
					PlayEffect( effects[fireMode].throwEffectSPNoUpgrade );
					break;
				case 1:
					PlayEffect( effects[fireMode].throwEffectSPUpgrade1 );
					break;
				case 2:
					PlayEffect( effects[fireMode].throwEffectSPUpgrade2 );
					break;
				case 3:
					PlayEffect( effects[fireMode].throwEffectSPUpgrade3 );
					break;
			}
		}
		
		//bonus dmg fx
		if(owner.CanUseSkill(S_Magic_s06))
		{
			//different fx based on what is the current range of aard
			switch(dispersionLevel)
			{
				case 0:
					PlayEffect( effects[fireMode].throwEffectDmgNoUpgrade );
					break;
				case 1:
					PlayEffect( effects[fireMode].throwEffectDmgUpgrade1 );
					break;
				case 2:
					PlayEffect( effects[fireMode].throwEffectDmgUpgrade2 );
					break;
				case 3:
					PlayEffect( effects[fireMode].throwEffectDmgUpgrade3 );
					break;
			}
		}
	}
	
	timer function DelayedDestroyTimer(dt : float, id : int)
	{
		var active : bool;
		
		if(owner.CanUseSkill(S_Magic_s20))
		{
			switch(owner.GetSkillLevel(S_Magic_s20))
			{
				case 1 :
					active = IsEffectActive( effects[fireMode].baseCommonThrowEffectUpgrade1 );
					break;
				case 2 :
					active = IsEffectActive( effects[fireMode].baseCommonThrowEffectUpgrade2 );
					break;
				case 3 :
					active = IsEffectActive( effects[fireMode].baseCommonThrowEffectUpgrade3 );
					break;
				default :
					LogAssert(false, "W3AardEntity.DelayedDestroyTimer: S_Magic_s20 skill level out of bounds!");
			}
		}
		else
		{
			active = IsEffectActive( effects[fireMode].baseCommonThrowEffect );
		}
		
		if(!active)
			Destroy();
	}
}

state AardConeCast in W3AardEntity extends NormalCast
{		
	event OnThrowing()
	{
		var player : CR4Player;
		var cost, stamina : float;
	
		if( super.OnThrowing() )
		{
			parent.ProcessThrow( false );
			
			player = caster.GetPlayer();
			
			//modSOTR - Remove Rage Management (Perk_9)
			if(player == caster.GetActor() && player /* && player.CanUseSkill(S_Perk_09)*/ )
			{
				
				cost = player.GetStaminaActionCost(ESAT_Ability, SkillEnumToName( parent.skillEnum ), 0);
				stamina = player.GetStat(BCS_Stamina, true);
				
				if(cost > stamina)
					player.DrainFocus(1);
				else
					caster.GetActor().DrainStamina( ESAT_Ability, 0, 0, SkillEnumToName( parent.skillEnum ) );
			}
			else
				caster.GetActor().DrainStamina( ESAT_Ability, 0, 0, SkillEnumToName( parent.skillEnum ) );
		}
	}
}

state AardCircleCast in W3AardEntity extends NormalCast
{
	event OnThrowing()
	{
		var player : CR4Player;
		var cost, stamina : float;
		
		if( super.OnThrowing() )
		{
			parent.ProcessThrow( true );
			
			player = caster.GetPlayer();
			if(player == caster.GetActor() && player && player.CanUseSkill(S_Magic_s31) && thePlayer.GetStat(BCS_Focus) >= 3 )
			{
				caster.GetActor().DrainStamina( ESAT_Ability, 0, 0, SkillEnumToName( parent.skillEnum ) );
				//player.DrainFocus(3);


			/*
			//modSOTR - Remove Rage Management (Perk_9)
			//if(player == caster.GetActor() && player && player.CanUseSkill(S_Perk_09))
			if(player == caster.GetActor() && player)
			{
				cost = player.GetStaminaActionCost(ESAT_Ability, SkillEnumToName( parent.skillEnum ), 0);
				stamina = player.GetStat(BCS_Stamina, true);
				
				if(cost > stamina)
					player.DrainFocus(1);
				else
					caster.GetActor().DrainStamina( ESAT_Ability, 0, 0, SkillEnumToName( parent.skillEnum ) );*/
			}	
			else
				caster.GetActor().DrainStamina( ESAT_Ability, 0, 0, SkillEnumToName( parent.skillEnum ) );
		}
	}
}
