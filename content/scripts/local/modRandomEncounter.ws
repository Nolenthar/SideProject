//--- RandomEncounters ---
// Made by Erxv
class CModRandomEncounters extends CPlayer
{		
	public 		var rExtra				: CModRExtra;

	public 		var entF 				: array<CEntity>;
	public 		var entT 				: array<CEntity>;
	public 		var entG 				: array<CEntity>;
	public		var	entH				: array<CEntity>;
	public 		var temp 				: CEntity;
	public 		var temp2 				: CEntity;
	public 		var temp3 				: CEntity;
	public		var horsePos			: Vector;
	public 		var isActive, taimer3, isMeditateActive, isIs, customFlying, customGround, isCityActive, mods	: bool;
	public	 	var isHosActive 	: int;
	private		var isMeditating		:CName;
	editable 	var attitudeToPlayer	: EAIAttitude;
	private 	var inGameConfigWrapper : CInGameConfigWrapper;
	private 	var isFlyingActive, isGroundActive, isHumanActive, isGroupActive : int;
	
	public 		var selectedFrequency	: int;
	public 		var selectedDifficulty	: int;
	
	//var currentArea 				: EAreaName;
	
	private var novbandit, pirate, bandit, nilf, cannibal, renegade, skelbandit : array<String>;
	private var gryphon, forktail, wyvern, cockatrice, harpy, siren, leshen, werewolf : array<String>;
	private var fiend, chort, endrega, fogling, fatass, ghoul, alghoul, bear, golem, elemental, hag, nekker : array<String>;
	private var vampire, whh, drowner, rotfiend, nightwraith, noonwraith, troll, wolf, wraith : array<String>;
	private var tempArray, human, spider : array<String>;
	
	private var isGryphons, isCockatrice, isWyverns, isForktails : int;
	private var isLeshens, isWerewolves, isFiends, isVampires, isBears, isGolems, isElementals: int;
	private var isNightWraiths, isNoonWraiths, isHags, isFogling, isEndrega, isGhouls, isAlghouls : int;
	private var isNekkers, isWildhuntHounds, isDrowners, isRotfiends, isWolves, isWraiths, isSpiders : int;
	
	private var isCGryphons, isCCockatrice, isCWyverns, isCForktails : bool;
	private var isCLeshens, isCWerewolves, isCFiends, isCVampires, isCBears, isCGolems, isCElementals: bool;
	private var isCNightWraiths, isCNoonWraiths, isCHags, isCFogling, isCEndrega, isCGhouls, isCAlghouls : bool;
	private var isCNekkers, isCWildhuntHounds, isCDrowners, isCRotfiends, isCWolves, isCWraiths, isCSpiders : bool;
	
	default taimer3 = false;
	default isActive = false;
	default selectedFrequency = 2;

	function Init()
	{			
		rExtra = new CModRExtra in this;
	
		inGameConfigWrapper = theGame.GetInGameConfigWrapper();
		
		MonsterPathArrays();
		
		selectedFrequency = StringToInt(inGameConfigWrapper.GetVarValue('RandomEncountersMENU', 'Frequency'));	
		
		isFlyingActive  = StringToInt(inGameConfigWrapper.GetVarValue('RandomEncountersMENU', 'enableFlyingMonsters')); 
		isGroundActive = StringToInt(inGameConfigWrapper.GetVarValue('RandomEncountersMENU', 'enableGroundMonsters'));	
		isHumanActive = StringToInt(inGameConfigWrapper.GetVarValue('RandomEncountersMENU', 'enableHumanEnemies'));
		isGroupActive = StringToInt(inGameConfigWrapper.GetVarValue('RandomEncountersMENU', 'enableGroupMonsters'));
		isHosActive = StringToInt(inGameConfigWrapper.GetVarValue('RandomEncountersMENU', 'enableHOS'));
		isCityActive = inGameConfigWrapper.GetVarValue('RandomEncountersMENU', 'enableCity');
		//isMeditateActive = inGameConfigWrapper.GetVarValue('RandomEncountersMENU', 'enableMeditateEncounter');		
		
		customFlyingMonsterList();
		flyingMonsterList();
		customGroundMonsterList();
		groundMonsterList();
 
		//selectedFrequency = StringToInt(inGameConfigWrapper.GetVarValue('custom', 'Frequency'));					
		
	}
	

	
	
	function flyingMonsterList ()
	{
		inGameConfigWrapper = theGame.GetInGameConfigWrapper();
		
		isCGryphons = inGameConfigWrapper.GetVarValue('monsterList', 'Gryphons');
		isCCockatrice = inGameConfigWrapper.GetVarValue('monsterList', 'Cockatrice');
		isCWyverns = inGameConfigWrapper.GetVarValue('monsterList', 'Wyverns');
		isCForktails = inGameConfigWrapper.GetVarValue('monsterList', 'Forktails');
	}
	
	function groundMonsterList ()
	{
		inGameConfigWrapper = theGame.GetInGameConfigWrapper();
		
		isCLeshens = inGameConfigWrapper.GetVarValue('monsterList', 'Leshens');
		isCWerewolves = inGameConfigWrapper.GetVarValue('monsterList', 'Werewolves');
		isCFiends = inGameConfigWrapper.GetVarValue('monsterList', 'Fiends');
		isCVampires = inGameConfigWrapper.GetVarValue('monsterList', 'Vampires');
		isCBears = inGameConfigWrapper.GetVarValue('monsterList', 'Bears');
		isCGolems = inGameConfigWrapper.GetVarValue('monsterList', 'Golems');
		isCElementals = inGameConfigWrapper.GetVarValue('monsterList', 'Elementals');
		isCNightWraiths = inGameConfigWrapper.GetVarValue('monsterList', 'NightWraiths');
		isCNoonWraiths = inGameConfigWrapper.GetVarValue('monsterList', 'NoonWraiths');
		
		isCHags = inGameConfigWrapper.GetVarValue('monsterList', 'Hags');
		isCFogling = inGameConfigWrapper.GetVarValue('monsterList', 'Fogling');
		isCEndrega = inGameConfigWrapper.GetVarValue('monsterList', 'Endrega');
		isCGhouls = inGameConfigWrapper.GetVarValue('monsterList', 'Ghouls');
		isCAlghouls = inGameConfigWrapper.GetVarValue('monsterList', 'Alghouls');
		isCNekkers = inGameConfigWrapper.GetVarValue('monsterList', 'Nekkers');
		isCWildhuntHounds = inGameConfigWrapper.GetVarValue('monsterList', 'WildhuntHounds');
		isCDrowners = inGameConfigWrapper.GetVarValue('monsterList', 'Drowners');
		isCRotfiends = inGameConfigWrapper.GetVarValue('monsterList', 'Rotfiends');
		isCWolves = inGameConfigWrapper.GetVarValue('monsterList', 'Wolves');
		isCWraiths = inGameConfigWrapper.GetVarValue('monsterList', 'Wraiths');
		isCSpiders = inGameConfigWrapper.GetVarValue('monsterList', 'Spiders');
	}

	function customFlyingMonsterList ()
	{
		inGameConfigWrapper = theGame.GetInGameConfigWrapper();
	
		isGryphons = StringToInt(inGameConfigWrapper.GetVarValue('customFlying', 'Gryphons'));
		isCockatrice = StringToInt(inGameConfigWrapper.GetVarValue('customFlying', 'Cockatrice'));
		isWyverns = StringToInt(inGameConfigWrapper.GetVarValue('customFlying', 'Wyverns'));
		isForktails = StringToInt(inGameConfigWrapper.GetVarValue('customFlying', 'Forktails'));
	}	
	function customGroundMonsterList ()
	{
		inGameConfigWrapper = theGame.GetInGameConfigWrapper();
		
		isLeshens = StringToInt(inGameConfigWrapper.GetVarValue('customGround', 'Leshens'));
		isWerewolves = StringToInt(inGameConfigWrapper.GetVarValue('customGround', 'Werewolves'));
		isFiends = StringToInt(inGameConfigWrapper.GetVarValue('customGround', 'Fiends'));
		isVampires = StringToInt(inGameConfigWrapper.GetVarValue('customGround', 'Vampires'));
		isBears = StringToInt(inGameConfigWrapper.GetVarValue('customGround', 'Bears'));
		isGolems = StringToInt(inGameConfigWrapper.GetVarValue('customGround', 'Golems'));
		isElementals = StringToInt(inGameConfigWrapper.GetVarValue('customGround', 'Elementals'));
		isNightWraiths = StringToInt(inGameConfigWrapper.GetVarValue('customGround', 'NightWraiths'));
		isNoonWraiths = StringToInt(inGameConfigWrapper.GetVarValue('customGround', 'NoonWraiths'));
		
		isHags = StringToInt(inGameConfigWrapper.GetVarValue('customGround', 'Hags'));
		isFogling = StringToInt(inGameConfigWrapper.GetVarValue('customGround', 'Fogling'));
		isEndrega = StringToInt(inGameConfigWrapper.GetVarValue('customGround', 'Endrega'));
		isGhouls = StringToInt(inGameConfigWrapper.GetVarValue('customGround', 'Ghouls'));
		isAlghouls = StringToInt(inGameConfigWrapper.GetVarValue('customGround', 'Alghouls'));
		isNekkers = StringToInt(inGameConfigWrapper.GetVarValue('customGround', 'Nekkers'));
		isWildhuntHounds = StringToInt(inGameConfigWrapper.GetVarValue('customGround', 'WildhuntHounds'));
		isDrowners = StringToInt(inGameConfigWrapper.GetVarValue('customGround', 'Drowners'));
		isRotfiends = StringToInt(inGameConfigWrapper.GetVarValue('customGround', 'Rotfiends'));
		isWolves = StringToInt(inGameConfigWrapper.GetVarValue('customGround', 'Wolves'));
		isWraiths = StringToInt(inGameConfigWrapper.GetVarValue('customGround', 'Wraiths'));
		isSpiders = StringToInt(inGameConfigWrapper.GetVarValue('customGround', 'Spiders'));
	}		
	
	function LowestCustomFrequency() : int
	{
		inGameConfigWrapper = theGame.GetInGameConfigWrapper();
		return StringToInt(inGameConfigWrapper.GetVarValue('custom', 'customFrequencyLow'));
	}
	
	function HighestCustomFrequency() : int
	{
		inGameConfigWrapper = theGame.GetInGameConfigWrapper();
		return StringToInt(inGameConfigWrapper.GetVarValue('custom', 'customFrequencyHigh'));
	}
	
	event OnActive ()
	{
		var raskus, i : int;
		inGameConfigWrapper = theGame.GetInGameConfigWrapper();	

		selectedFrequency = StringToInt(inGameConfigWrapper.GetVarValue('RandomEncountersMENU', 'Frequency'));		
		selectedDifficulty = StringToInt(inGameConfigWrapper.GetVarValue('RandomEncountersMENU', 'Difficulty'));

		OnSetFrequency(selectedFrequency);		
		
		if (isFlyingActive != 0 || isGroundActive != 0 || isHumanActive != 0 || isGroupActive != 0)
		{
		
			if (selectedDifficulty == 3){ raskus = 2;}
			else { raskus = 1;}
			
			for ( i=0; i<raskus;i+=1)
			{
				OnREPressed();
				continue;
			}
		}	
	}
	
	event OnREPressed ()
	{
		var quantity : int;
		var resourcePath,s	: string;
		var template : CEntityTemplate;
		var pos, pos2, cameraDir, player, posFin, posFin2, normal : Vector;
		var rot : EulerAngles;
		var i,j,k,h, nr : int;
		var choose : array<Int32>;
		var zoneName 					: string;
		var currentArea 				: String; 
		
		
		s = "";
		
		rot = thePlayer.GetWorldRotation();    
		rot.Yaw += 180;                          
		player = thePlayer.GetWorldPosition();        	   
		pos =   player + VecRingRand(5,8);  
		
		// ### RABBIT ###
		//characters\npc_entities\animals\hare.w2ent		
		resourcePath = "characters\npc_entities\animals\hare.w2ent";
		template = (CEntityTemplate)LoadResource( resourcePath, true );
		
		temp2.Destroy();
		temp2 = theGame.CreateEntity(template, pos, rot);		

		((CNewNPC)temp2).SetGameplayVisibility(false);
		((CNewNPC)temp2).SetVisibility(false);		
		((CActor)temp2).EnableCharacterCollisions(false);
		((CActor)temp2).EnableDynamicCollisions(false);
		((CActor)temp2).EnableStaticCollisions(false);
		((CActor)temp2).SetImmortalityMode(AIM_Immortal, AIC_Default);
				
		// !thePlayer.GetCurrentStateName() == 'Meditation' || !thePlayer.GetCurrentStateName() == 'MeditationWaiting' || 
		isMeditating = thePlayer.GetCurrentStateName();
		
		/*
		isMeditateActive		
		if (isMeditateActive && (isMeditating == 'Meditation' || isMeditating == 'MeditationWaiting'))
		{		
		}
		else if (!isMeditateActive && (isMeditating == 'Meditation' || isMeditating == 'MeditationWaiting'))
		{		
		}
		*/
		isFlyingActive  = StringToInt(inGameConfigWrapper.GetVarValue('RandomEncountersMENU', 'enableFlyingMonsters')); 
		isGroundActive = StringToInt(inGameConfigWrapper.GetVarValue('RandomEncountersMENU', 'enableGroundMonsters'));	
		isHumanActive = StringToInt(inGameConfigWrapper.GetVarValue('RandomEncountersMENU', 'enableHumanEnemies'));
		isGroupActive = StringToInt(inGameConfigWrapper.GetVarValue('RandomEncountersMENU', 'enableGroupMonsters'));
		isCityActive = inGameConfigWrapper.GetVarValue('RandomEncountersMENU', 'enableCity');
		isHosActive = StringToInt(inGameConfigWrapper.GetVarValue('RandomEncountersMENU', 'enableHOS'));	
		
		zoneName = rExtra.getZone();
		
		if (isCityActive && (zoneName == "novigrad" || zoneName == "oxenfurt" || zoneName == "crows" || zoneName == "trolde" || zoneName == "nospawn"))
		{
			OnSetTaimerT();
		}
		else 
		{
			if ( (isMeditating != 'Meditation' && isMeditating != 'MeditationWaiting') && !thePlayer.IsInInterior() && !thePlayer.IsInCombat() && !thePlayer.IsUsingBoat() && !thePlayer.IsInFistFightMiniGame() && !thePlayer.IsSwimming() && !theGame.IsDialogOrCutscenePlaying() && !thePlayer.IsInNonGameplayCutscene() && !thePlayer.IsInGameplayScene() && !theGame.IsCurrentlyPlayingNonGameplayScene() && !theGame.IsFading() && !theGame.IsBlackscreen() )        
			{			 
				OnSetTaimerF();
				
				if (isGroundActive != 0){for (j=0; j<isGroundActive; j+=1){choose.PushBack(1);}}
				if (isFlyingActive != 0){for (i=0; i<isFlyingActive; i+=1){choose.PushBack(2);}}
				if (isHumanActive != 0)	{for (k=0; k<isHumanActive; k+=1){choose.PushBack(3);}}
				if (isGroupActive != 0)	{for (h=0; h<isGroupActive; h+=1){choose.PushBack(4);}}

				nr = choose[ RandRange(0, choose.Size() ) ];
				
				if (nr == 1)
				{
					s = "solo";
					whichGround(s);
				}
				else if (nr == 2)
				{
					OnFlyingCreature();
				}
				else if (nr == 3)
				{
					OnHuman();					
				}
				else if (nr == 4)
				{
					s = "group";
					whichGround(s);
				}	
				
			}	
			else
			{
				OnSetTaimerT();
			}
		}		
	}	
	
	event OnFlyingCreature ()
	{
		var ent2 						: CEntity;
		var pos, player, posFin			: Vector;
		var rot 						: EulerAngles;
		var FlyingTemplate 				: CEntityTemplate;
		var template 					: CEntityTemplate;
		var quantity 					: int;
		var resourcePathFlying			: string;		
		var h							: float;			
		var randomHeight 				: Float;                              
        var debugstring 				: string;			
		var animcomp 					: CComponent;
		var meshcomp 					: CComponent;		
		var ran, nr						: int;		
		var lvl, i,j,k					: int;
		var currentArea					: string;
		var emptyArr					: array<string>;
		var choose 						: array<Int32>;
		var zoneName					: string;
		
		currentArea = AreaTypeToName(theGame.GetCommonMapManager().GetCurrentArea());
		zoneName = rExtra.getZone();
		
		inGameConfigWrapper = theGame.GetInGameConfigWrapper();
		customFlying = inGameConfigWrapper.GetVarValue('customFlying', 'customFlyingMonsters'); 
		
		customFlyingMonsterList();
		flyingMonsterList();
		
		if (customFlying)
		{
		
			if (currentArea == "prolog_village")
			{
				if (isGryphons != 0)	{for (i=0; i<isGryphons; i+=1){choose.PushBack(2);	}}
				if (isCockatrice != 0)	{for (j=0; j<isCockatrice; j+=1){choose.PushBack(1);}}
				
				nr = choose[ RandRange(0, choose.Size())];	
				
				if 		(nr == 2)	{tempArray = gryphon;}
				else if (nr == 1)	{tempArray = cockatrice;}
			}
			else if (currentArea == "skellige" || currentArea == "novigrad" || currentArea == "kaer_morhen" || currentArea == "no_mans_land")
			{
				if (isGryphons != 0)	{for (i=0; i<isGryphons; i+=1)	{choose.PushBack(4);}}
				if (isCockatrice != 0)	{for (j=0; j<isCockatrice; j+=1){choose.PushBack(1);}}
				if (isWyverns != 0)		{for (k=0; k<isWyverns; k+=1)	{choose.PushBack(2);}}
				if (isForktails != 0)	{for (k=0; k<isForktails; k+=1){choose.PushBack(3);}}
				
				nr = choose[ RandRange(0, choose.Size())];	
				
				if 		(nr == 4){tempArray = gryphon;}
				else if (nr == 1){tempArray = cockatrice;}
				else if (nr == 2){tempArray = wyvern;}
				else if (nr == 3){tempArray = forktail;}	
			}	
		}
		else if (!customFlying)
		{
			if (currentArea == "prolog_village")
			{
				if (isCGryphons)	{for (i=0; i<3; i+=1){choose.PushBack(2);}}
				if (isCCockatrice)	{for (j=0; j<1; j+=1){choose.PushBack(1);}}
				
				nr = choose[ RandRange(0, choose.Size())];	
				
				if 		(nr == 2)	{tempArray = gryphon;}
				else if (nr == 1)	{tempArray = cockatrice;}
			}
			else if (currentArea == "skellige" || currentArea == "novigrad" || currentArea == "kaer_morhen" || currentArea == "no_mans_land")
			{
				if (isCGryphons)	{for (i=0; i<3; i+=1)	{choose.PushBack(4);}}
				if (isCCockatrice)	{for (j=0; j<2; j+=1){choose.PushBack(1);}}
				if (isCWyverns)		{for (k=0; k<1; k+=1)	{choose.PushBack(2);}}
				if (isCForktails)	{for (k=0; k<1; k+=1){choose.PushBack(3);}}
				
				nr = choose[ RandRange(0, choose.Size())];	
				
				if 		(nr == 4){tempArray = gryphon;}
				else if (nr == 1){tempArray = cockatrice;}
				else if (nr == 2){tempArray = wyvern;}
				else if (nr == 3){tempArray = forktail;}	
			}	
		}
			
			
		ran = RandRange(0,tempArray.Size());		
		resourcePathFlying = tempArray[ran];
		FlyingTemplate = (CEntityTemplate)LoadResource( resourcePathFlying, true);
		
		pos = VecConeRand(theCamera.GetCameraHeading(), 240, 150, 200);
		posFin = theCamera.GetCameraPosition() - pos;				
		randomHeight = RandRangeF(20.000,50.000);
		posFin.Z += randomHeight;
		
		if (tempArray == forktail || tempArray == wyvern)
		{
			pos = VecConeRand(theCamera.GetCameraHeading(), 240, 90, 130);
			posFin = theCamera.GetCameraPosition() -pos;				
			randomHeight = RandRangeF(10.000,20.000);
			posFin.Z += randomHeight;
		}				
		if (selectedDifficulty == 0)
		{
			if ( GetWitcherPlayer().GetLevel() < 4 )
			{
				lvl = RandRange(0,2);
			}
			else
			{
				lvl = RandRange(-7,1);
			}
		}
		else if (selectedDifficulty == 1)
		{
			if ( GetWitcherPlayer().GetLevel() < 4 )
			{
				lvl = RandRange(0,4);
			}
			else
			{
				lvl = RandRange(-4,4);
			}
		}
		else if (selectedDifficulty == 2 || selectedDifficulty == 3)
		{
			if ( GetWitcherPlayer().GetLevel() < 4 )
			{
				lvl = RandRange(0,5);
			}
			else
			{
				lvl = RandRange(1,6);
			}
		}	
		temp = theGame.CreateEntity(FlyingTemplate, posFin, rot);				
		((CNewNPC)temp).SetLevel(GetWitcherPlayer().GetLevel()+lvl);                    
		((CNewNPC)temp).SetTemporaryAttitudeGroup( 'monsters', AGP_Default );
		((CNewNPC)temp).NoticeActor(((CNewNPC)temp2));			
		
		animcomp = temp.GetComponentByClassName('CAnimatedComponent');
		meshcomp = temp.GetComponentByClassName('CMeshComponent');
		
		switch (lvl){
		case -7:
		case -6:
			h = 0.89;
			break;
		case -5:
		case -4:
		case -3:
			h = 0.91;
			break;
		case -2:
		case -1:
			h = 0.93;
			break;
		case 0:
			h = 1.0;
			break;
		case 1:
		case 2:
			h = 1.06;
			break;
		case 3:
		case 4:
			h = 1.08;
			break;
		case 5:
			h = 1.1;
			break;
		}		
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));
		
		entF.PushBack(temp);
		
		OnSetEntityF(entF);
		OnSetTemp(temp2);	
		
		//debugstring = "Spawning at:" + " X: " + pos.X + " Y: " + pos.Y + " Z: " + pos.Z;	
		//debugstring = "Current Area: " + currentArea + " Current Zone: " + zoneEnum ; 
		//theGame.GetGuiManager().ShowNotification(debugstring);		
	}

	event OnGroundCreature ( tempArray : array<string> ) 
	{
		var pos : Vector;
		var rot : EulerAngles;
		var GroundTemplate : CEntityTemplate;
		var distance, h : float;
		var resourcePathGround	: string;                            
        var debugstring : string;
		var ran : int;
		var howMany : int;
		var i,j, k, lvl, nr : int;
		
		var animcomp 					: CComponent;
		var meshcomp 					: CComponent;	
			
		if (selectedDifficulty == 0)
		{
			if (tempArray == alghoul || tempArray == fogling || tempArray == whh || tempArray == wraith || tempArray == spider)
			{
				howMany = RandRange(2,4);
			}
			else
			{
				howMany = RandRange(2,5);
			}
		}
		else if (selectedDifficulty == 1)
		{
			if (tempArray == alghoul || tempArray == fogling || tempArray == whh || tempArray == wraith || tempArray == spider)
			{
				howMany = RandRange(2,4);
			}
			else
			{
				howMany = RandRange(2,6);
			}
		}
		else if (selectedDifficulty == 2 || selectedDifficulty == 3)
		{
			if (tempArray == alghoul || tempArray == fogling || tempArray == whh || tempArray == wraith || tempArray == spider)
			{
				howMany = RandRange(2,5);
			}
			else
			{
				howMany = RandRange(2,7);
			}
		}
		if (tempArray == hag){ howMany = RandRange(1,3);}
		
		if (tempArray == werewolf || tempArray == leshen || tempArray == fiend || tempArray == vampire || tempArray == bear || tempArray == nightwraith || tempArray == noonwraith || tempArray == golem || tempArray == elemental)
		{
			howMany = 1;
		}
		
		pos = VecConeRand(theCamera.GetCameraHeading(), 240, 30, 34);
		pos = theCamera.GetCameraPosition() - pos;			
		
		for (i = 0; i < howMany; i+=1)
		{
			ran = RandRange(0,tempArray.Size()); 		
			resourcePathGround = tempArray[ran];
			GroundTemplate = (CEntityTemplate)LoadResource( resourcePathGround, true);					
								   
			temp = theGame.CreateEntity(GroundTemplate, pos, rot);	 	

			if (selectedDifficulty == 0)
			{				
				if ( GetWitcherPlayer().GetLevel() < 4 )
				{
					lvl = RandRange(0,1);
				}
				else
				{
					lvl = RandRange(-7,1);
				}
			}
			else if (selectedDifficulty == 1)
			{			
				if ( GetWitcherPlayer().GetLevel() < 4 )
				{
					lvl = RandRange(0,4);
				}
				else
				{
					lvl = RandRange(-4,4);
				}
			}
			else if (selectedDifficulty == 2 || selectedDifficulty == 3)
			{				
				if ( GetWitcherPlayer().GetLevel() < 4 )
				{
					lvl = RandRange(0,5);
				}
				else
				{
					if (tempArray == drowner)
					{
						lvl = RandRange(0,1);
					}
					else
					{
						lvl = RandRange(1,6);
					}
				}
			}
			
		
			((CNewNPC)temp).SetLevel(GetWitcherPlayer().GetLevel()+lvl);                    
			((CNewNPC)temp).SetTemporaryAttitudeGroup( 'monsters', AGP_Default );
			((CNewNPC)temp).NoticeActor(((CNewNPC)temp2));
			entG.PushBack(temp);
			
			animcomp = temp.GetComponentByClassName('CAnimatedComponent');
			meshcomp = temp.GetComponentByClassName('CMeshComponent');
			
			switch (lvl){
			case -7:
			case -6:
				h = 0.91;
				break;
			case -5:
			case -4:
			case -3:
				h = 0.94;
				break;
			case -2:
			case -1:
				h = 0.96;
				break;
			case 0:
				h = 1.0;
				break;
			case 1:
			case 2:
				h = 1.04;
				break;
			case 3:
			case 4:
				h = 1.06;
				break;
			case 5:
				h = 1.09;
				break;
			}
			
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));
			
		}		
		
		//debugstring = "Spawning at:" + " X: " + pos.X + " Y: " + pos.Y + " Z: " + pos.Z;	
		//debugstring = "Current Area: " + currentArea + " Current Zone: " + zoneEnum ; 
		//theGame.GetGuiManager().ShowNotification(debugstring);	
		
		OnSetEntityG(entG);
		OnSetTemp(temp2);	
	}
	
	function whichGround( s : string)
	{
		var currentArea : string;
		var emptyArr : array<string>;		
		var choose : array<Int32>;
		var nr,i,j,k,h,ran : int;
		
		currentArea = AreaTypeToName(theGame.GetCommonMapManager().GetCurrentArea());
		
		inGameConfigWrapper = theGame.GetInGameConfigWrapper();
		customGround = inGameConfigWrapper.GetVarValue('customGround', 'customGroundMonsters'); 
		isGroundActive = StringToInt(inGameConfigWrapper.GetVarValue('RandomEncountersMENU', 'enableGroundMonsters'));	
		isGroupActive = StringToInt(inGameConfigWrapper.GetVarValue('RandomEncountersMENU', 'enableGroupMonsters'));

		customGroundMonsterList();
		groundMonsterList();
		
		choose.Clear();
		if (customGround)
		{
			if ( s == "solo")
			{
				if (currentArea == "prolog_village")
				{
					if (isWerewolves != 0)		{for (j=0; j<isWerewolves; j+=1){choose.PushBack(1);}}
					if (isBears != 0)			{for (i=0; i<isBears; i+=1){choose.PushBack(2);}}
					if (isNightWraiths != 0)	{for (k=0; k<isNightWraiths; k+=1){choose.PushBack(3);}}
					if (isNoonWraiths != 0)		{for (i=0; i<isNoonWraiths; i+=1){choose.PushBack(4);}}
					
					nr = choose[ RandRange(0, choose.Size())];	
					
					if 		(nr == 1){tempArray = werewolf;}	
					else if (nr == 2){tempArray = bear;}
					else if (nr == 3){tempArray = nightwraith;}
					else if (nr == 4){tempArray = noonwraith;}			
				}		
				else if (currentArea == "skellige" || currentArea == "novigrad" || currentArea == "kaer_morhen" || currentArea == "no_mans_land")
				{
					if (isLeshens != 0)		{for (i=0; i<isLeshens; i+=1){choose.PushBack(9);}}
					if (isWerewolves != 0)	{for (j=0; j<isWerewolves; j+=1){choose.PushBack(1);}}
					if (isFiends != 0)		{for (k=0; k<isFiends; k+=1){choose.PushBack(2);}}
					if (isVampires != 0)	{for (k=0; k<isVampires; k+=1){choose.PushBack(3);}}
					if (isBears != 0)		{for (i=0; i<isBears; i+=1){choose.PushBack(4);}}
					if (isGolems != 0)		{for (j=0; j<isGolems; j+=1){choose.PushBack(5);}}
					if (isElementals != 0)	{for (k=0; k<isElementals; k+=1){choose.PushBack(6);}}
					if (isNightWraiths != 0){for (k=0; k<isNightWraiths; k+=1){choose.PushBack(7);}}
					if (isNoonWraiths != 0)	{for (i=0; i<isNoonWraiths; i+=1){choose.PushBack(8);}}
					
					nr = choose[ RandRange(0, choose.Size())];	
					
					if 		(nr == 9){tempArray = leshen;}
					else if (nr == 1){tempArray = werewolf;}
					else if (nr == 2){tempArray = fiend;}
					else if (nr == 3){tempArray = vampire;}	
					else if (nr == 4){tempArray = bear;}	
					else if (nr == 5){tempArray = golem;}	
					else if (nr == 6){tempArray = elemental;}
					else if (nr == 7){tempArray = nightwraith;}
					else if (nr == 8){tempArray = noonwraith;}
				}		
			}
			else if ( s == "group")
			{
				if (currentArea == "prolog_village")
				{
					if (isGhouls != 0)		{for (i=0; i<isGhouls; i+=1){choose.PushBack(5);}}
					if (isNekkers != 0)		{for (k=0; k<isNekkers; k+=1){choose.PushBack(1);}}
					if (isDrowners != 0)	{for (i=0; i<isDrowners; i+=1){choose.PushBack(2);}}
					if (isWolves != 0)		{for (k=0; k<isWolves; k+=1){choose.PushBack(3);}}
					if (isWraiths != 0)		{for (k=0; k<isWraiths; k+=1){choose.PushBack(4);}}
					
					nr = choose[ RandRange(0, choose.Size())];	
					
					if 		(nr == 5){tempArray = ghoul;}	
					else if (nr == 1){tempArray = nekker;}	
					else if (nr == 2){tempArray = drowner;}
					else if (nr == 3){tempArray = wolf;}	
					else if (nr == 4){tempArray = wraith;}			
				}		
				else if (currentArea == "skellige" || currentArea == "novigrad" || currentArea == "kaer_morhen" || currentArea == "no_mans_land")
				{
					if (isHags != 0)		{for (j=0; j<isHags; j+=1){choose.PushBack(12);}}
					if (isFogling != 0)		{for (k=0; k<isFogling; k+=1){choose.PushBack(1);}}
					if (isEndrega != 0)		{for (k=0; k<isEndrega; k+=1){choose.PushBack(2);}}
					if (isGhouls != 0)		{for (i=0; i<isGhouls; i+=1){choose.PushBack(3);}}
					if (isAlghouls != 0)	{for (j=0; j<isAlghouls; j+=1){choose.PushBack(4);}}
					if (isNekkers != 0)		{for (k=0; k<isNekkers; k+=1){choose.PushBack(5);}}
					if (isWildhuntHounds != 0){for (k=0; k<isWildhuntHounds; k+=1){choose.PushBack(6);}}
					if (isDrowners != 0)	{for (i=0; i<isDrowners; i+=1){choose.PushBack(7);}}
					if (isRotfiends != 0)	{for (j=0; j<isRotfiends; j+=1){choose.PushBack(8);}}
					if (isWolves != 0)		{for (k=0; k<isWolves; k+=1){choose.PushBack(9);}}
					if (isWraiths != 0)		{for (k=0; k<isWraiths; k+=1){choose.PushBack(10);}}
					if (isSpiders != 0 && isHosActive) {for (k=0; k<isSpiders; k+=1){choose.PushBack(11);}}
					
					nr = choose[ RandRange(0, choose.Size())];		
					
					if 		(nr == 12){tempArray = hag;}	
					else if (nr == 1){tempArray = fogling;}	
					else if (nr == 2){tempArray = endrega;}
					else if (nr == 3){tempArray = ghoul;}
					else if (nr == 4){tempArray = alghoul;}	
					else if (nr == 5){tempArray = nekker;}	
					else if (nr == 6){tempArray = whh;}	
					else if (nr == 7){tempArray = drowner;}
					else if (nr == 8){tempArray = rotfiend;}
					else if (nr == 9){tempArray = wolf;}	
					else if (nr == 10){tempArray = wraith;}	
					else if (nr == 11 && isHosActive){tempArray = spider;}			
				}		
			}
		}
		else if (!customGround)
		{
			if ( s == "solo")
			{
				if (currentArea == "prolog_village")
				{	
					if (isCWerewolves)		{for (j=0; j<2; j+=1){choose.PushBack(1);}}
					if (isCBears)			{for (i=0; i<2; i+=1){choose.PushBack(2);}}
					if (isCNightWraiths)	{for (k=0; k<1; k+=1){choose.PushBack(3);}}
					if (isCNoonWraiths)		{for (i=0; i<1; i+=1){choose.PushBack(4);}}
					
					nr = choose[ RandRange(0, choose.Size())];	
					
					if 		(nr == 1)	{tempArray = werewolf;}	
					else if (nr == 2)	{tempArray = bear;}
					else if (nr == 3)	{tempArray = nightwraith;}
					else if (nr == 4)	{tempArray = noonwraith;}				
				}		
				else if (currentArea == "skellige" || currentArea == "novigrad" || currentArea == "kaer_morhen" || currentArea == "no_mans_land")
				{
					if (isCLeshens)		{for (i=0; i<2; i+=1){choose.PushBack(9);}}
					if (isCWerewolves)	{for (j=0; j<4; j+=1){choose.PushBack(1);}}
					if (isCFiends)		{for (k=0; k<2; k+=1){choose.PushBack(2);}}
					if (isCVampires)	{for (k=0; k<1; k+=1){choose.PushBack(3);}}
					if (isCBears)		{for (i=0; i<1; i+=1){choose.PushBack(4);}}
					if (isCGolems)		{for (j=0; j<1; j+=1){choose.PushBack(5);}}
					if (isCElementals)	{for (k=0; k<1; k+=1){choose.PushBack(6);}}
					if (isCNightWraiths){for (k=0; k<1; k+=1){choose.PushBack(7);}}
					if (isCNoonWraiths)	{for (i=0; i<1; i+=1){choose.PushBack(8);}}
					
					nr = choose[ RandRange(0, choose.Size())];	
					
					if 		(nr == 9){tempArray = leshen;}
					else if (nr == 1){tempArray = werewolf;}
					else if (nr == 2){tempArray = fiend;}
					else if (nr == 3){tempArray = vampire;}	
					else if (nr == 4){tempArray = bear;}	
					else if (nr == 5){tempArray = golem;}	
					else if (nr == 6){tempArray = elemental;}
					else if (nr == 7){tempArray = nightwraith;}
					else if (nr == 8){tempArray = noonwraith;}
				}		
			}
			else if ( s == "group")
			{
				if (currentArea == "prolog_village")
				{
					if (isCGhouls)		{for (i=0; i<4; i+=1){choose.PushBack(5);}}
					if (isCNekkers)		{for (k=0; k<4; k+=1){choose.PushBack(1);}}
					if (isCDrowners)	{for (i=0; i<2; i+=1){choose.PushBack(2);}}
					if (isCWolves)		{for (k=0; k<2; k+=1){choose.PushBack(3);}}
					if (isCWraiths)		{for (k=0; k<1; k+=1){choose.PushBack(4);}}
					
					nr = choose[ RandRange(0, choose.Size())];	
					
					if 		(nr == 5){tempArray = ghoul;}	
					else if (nr == 1){tempArray = nekker;}	
					else if (nr == 2){tempArray = drowner;}
					else if (nr == 3){tempArray = wolf;}	
					else if (nr == 4){tempArray = wraith;}			
				}		
				else if (currentArea == "skellige" || currentArea == "novigrad" || currentArea == "kaer_morhen" || currentArea == "no_mans_land")
				{
					if (isCHags)			{for (j=0; j<1; j+=1){choose.PushBack(12);}}
					if (isCFogling)			{for (k=0; k<2; k+=1){choose.PushBack(1);}}
					if (isCEndrega)			{for (k=0; k<2; k+=1){choose.PushBack(2);}}
					if (isCGhouls)			{for (i=0; i<2; i+=1){choose.PushBack(3);}}
					if (isCAlghouls)		{for (j=0; j<1; j+=1){choose.PushBack(4);}}
					if (isCNekkers)			{for (k=0; k<4; k+=1){choose.PushBack(5);}}
					if (isCWildhuntHounds)	{for (k=0; k<1; k+=1){choose.PushBack(6);}}
					if (isCDrowners)		{for (i=0; i<2; i+=1){choose.PushBack(7);}}
					if (isCRotfiends)		{for (j=0; j<4; j+=1){choose.PushBack(8);}}
					if (isCWolves)			{for (k=0; k<1; k+=1){choose.PushBack(9);}}
					if (isCWraiths)			{for (k=0; k<1; k+=1){choose.PushBack(10);}}
					if (isCSpiders && isHosActive){for (k=0; k<2; k+=1){choose.PushBack(11);}}
					
					nr = choose[ RandRange(0, choose.Size())];		
					
					if 		(nr == 12){tempArray = hag;}	
					else if (nr == 1){tempArray = fogling;}	
					else if (nr == 2){tempArray = endrega;}
					else if (nr == 3){tempArray = ghoul;}
					else if (nr == 4){tempArray = alghoul;}	
					else if (nr == 5){tempArray = nekker;}	
					else if (nr == 6){tempArray = whh;}	
					else if (nr == 7){tempArray = drowner;}
					else if (nr == 8){tempArray = rotfiend;}
					else if (nr == 9){tempArray = wolf;}	
					else if (nr == 10){tempArray = wraith;}	
					else if (nr == 11 && isHosActive){tempArray = spider;}				
				}		
			}
		}		
		OnGroundCreature(tempArray);
	}
	
	event OnHuman ( ) 
	{
		var ent2 : CEntity;
		var pos, pos2, cameraDir, player, posFin, posFin2, normal : Vector;
		var rot : EulerAngles;
		var GroundTemplate : CEntityTemplate;
		var template : CEntityTemplate;
		var distance, h : float;
		var quantity : int;
		var resourcePath	: string;
		var resourcePathGround	: string;                            
        var debugstring : string;
		var ran : int;
		var many : bool;
		var howMany : int;
		var i, lvl, x : int;
		var emptyArr : array<string>;
		var currentArea : string;
		var zoneName	: string;
		
		var animcomp 					: CComponent;
		var meshcomp 					: CComponent;	
		
		var moveType : EMoveType;
	
		currentArea = AreaTypeToName(theGame.GetCommonMapManager().GetCurrentArea());
		zoneName = rExtra.getZone();
		
		if (currentArea == "prolog_village")
		{
			ran = RandRange(3,10);
			switch(ran){
			case 3:
			case 4:
			case 5:
				tempArray = bandit;
				break;
			case 7:
			case 8:
				tempArray = cannibal;
				break;
			case 9:
				tempArray = renegade;
				break;
			}			
			
		}	
		else if (currentArea == "skellige")
		{
			tempArray = skelbandit;
		}
		else if (currentArea == "novigrad" || currentArea == "kaer_morhen" || currentArea == "no_mans_land")
		{
			ran = RandRange(0,10);
			switch(ran){
			case 0:
				tempArray = novbandit;
				break;
			case 1:
			case 2:
				tempArray = pirate;
				break;
			case 3:
			case 4:
			case 5:
				tempArray = bandit;
				break;
			case 6:
				tempArray = nilf;
				break;
			case 7:
			case 8:
				tempArray = cannibal;
				break;
			case 9:
				tempArray = renegade;
				break;
			}			
		}		
		
		if (selectedDifficulty == 0)
		{
			howMany = RandRange(3,6);
		}
		else if (selectedDifficulty == 1)
		{
			howMany = RandRange(4,7);
		}
		else if (selectedDifficulty == 2 || selectedDifficulty == 3)
		{
			howMany = RandRange(5,9);
		}
		
		pos = VecConeRand(theCamera.GetCameraHeading(), 240, 20, 24);
		pos = theCamera.GetCameraPosition() - pos;	
		
		for (i = 0; i < howMany; i+=1)
		{
			ran = RandRange(0,tempArray.Size()); 		
			resourcePathGround = tempArray[ran];
			GroundTemplate = (CEntityTemplate)LoadResource( resourcePathGround, true);								
								   
			temp = theGame.CreateEntity(GroundTemplate, pos, rot);	 	

			if (selectedDifficulty == 0)
			{				
				if ( GetWitcherPlayer().GetLevel() < 4 )
				{
					lvl = RandRange(0,1);
				}
				else
				{
					lvl = RandRange(-7,1);
				}
			}
			else if (selectedDifficulty == 1)
			{			
				if ( GetWitcherPlayer().GetLevel() < 4 )
				{
					lvl = RandRange(0,4);
				}
				else
				{
					lvl = RandRange(-4,4);
				}
			}
			else if (selectedDifficulty == 2 || selectedDifficulty == 3)
			{				
				if ( GetWitcherPlayer().GetLevel() < 4 )
				{
					lvl = RandRange(0,5);
				}
				else
				{
					lvl = RandRange(1,6);					
				}
			}
		
			((CNewNPC)temp).SetLevel(GetWitcherPlayer().GetLevel()+lvl);                    
			((CNewNPC)temp).SetTemporaryAttitudeGroup( 'hostile_to_player', AGP_Default );
			((CNewNPC)temp).NoticeActor(thePlayer);
			entH.PushBack(temp);
			
			
		}		
		
		//debugstring = "Spawning at:" + " X: " + pos.X + " Y: " + pos.Y + " Z: " + pos.Z;	
		//debugstring = "Current Area: " + currentArea + " Current Zone: " + zoneEnum ; 
		//theGame.GetGuiManager().ShowNotification(debugstring);	
		
		OnSetEntityH(entH);
		OnSetTemp(temp2);	
	}
	
	event OnSetEntityF( entF : array<CEntity> )
	{
		this.entF = entF;
	}	
	function OnGetEntityF() : array<CEntity>
	{
		return this.entF;
	}	
	
	
	event OnSetEntityG( entG : array<CEntity> )
	{
		this.entG = entG;
	}	
	function OnGetEntityG() : array<CEntity>
	{
		return this.entG;
	}	
	
	event OnSetEntityH( entH : array<CEntity> )
	{
		this.entH = entH;
	}	
	function OnGetEntityH() : array<CEntity>
	{
		return this.entH;
	}	
	
	
	event OnSetTemp( temp2 : CEntity )
	{
		this.temp2 = temp2;
	}	
	function OnGetTemp() : CEntity
	{
		return this.temp2;
	}		
	
	
	event OnSetTaimerT ()
	{
		taimer3 = true;
	}	
	event OnSetTaimerF ()
	{
		taimer3 = false;
	}	
	event OnGetTaimer ()
	{
		return this.taimer3;
	}
	
	
	event OnSetFrequency( selectedFrequency : int )
	{
		this.selectedFrequency = selectedFrequency;
	}
	function OnGetFrequency() : int
	{
		return this.selectedFrequency;
	}
	

// ### MONSTER PATHS ###
		
	// +++ Flying Monsters +++ //
	
	function MonsterPathArrays()
	{	
		// ###//-HUMANS //-###
		/* # Witch Hunters #
		human.PushBack("gameplay\templates\characters\presets\inquisition\inq_1h_sword_t2.w2ent");
		human.PushBack("gameplay\templates\characters\presets\inquisition\inq_1h_mace_t2.w2ent");
		human.PushBack("gameplay\templates\characters\presets\inquisition\inq_crossbow.w2ent");
		human.PushBack("gameplay\templates\characters\presets\inquisition\inq_2h_sword.w2ent");
		*/			
		//# Novigrad bandit/thugs #
		novbandit.PushBack("gameplay\templates\characters\presets\novigrad\nov_1h_club.w2ent");
		novbandit.PushBack("gameplay\templates\characters\presets\novigrad\nov_1h_mace_t1.w2ent");
		novbandit.PushBack("gameplay\templates\characters\presets\novigrad\nov_2h_hammer.w2ent");
		novbandit.PushBack("gameplay\templates\characters\presets\novigrad\nov_1h_sword_t1.w2ent");
		
		//# Skellige bandits # 		
		skelbandit.PushBack("gameplay\templates\characters\presets\skellige\ske_1h_axe_t1.w2ent");
		skelbandit.PushBack("gameplay\templates\characters\presets\skellige\ske_1h_club.w2ent");
		skelbandit.PushBack("gameplay\templates\characters\presets\skellige\ske_bow.w2ent"); // can be any bandit
		skelbandit.PushBack("gameplay\templates\characters\presets\skellige\ske_2h_spear.w2ent");
		skelbandit.PushBack("gameplay\templates\characters\presets\skellige\ske_shield_axe_t1.w2ent");
		skelbandit.PushBack("gameplay\templates\characters\presets\skellige\ske_shield_club.w2ent");
		skelbandit.PushBack("gameplay\templates\characters\presets\skellige\ske_1h_axe_t2.w2ent");
		skelbandit.PushBack("gameplay\templates\characters\presets\skellige\ske_1h_sword.w2ent");
		skelbandit.PushBack("gameplay\templates\characters\presets\skellige\ske_shield_axe_t2.w2ent");
		skelbandit.PushBack("gameplay\templates\characters\presets\skellige\ske_shield_sword.w2ent");
		
		//# Renegade #
		renegade.PushBack("living_world\enemy_templates\baron_renegade_2h_axe.w2ent");
		renegade.PushBack("living_world\enemy_templates\baron_renegade_axe.w2ent");
		renegade.PushBack("living_world\enemy_templates\baron_renegade_blunt.w2ent");
		renegade.PushBack("living_world\enemy_templates\baron_renegade_boss.w2ent");
		renegade.PushBack("living_world\enemy_templates\baron_renegade_bow.w2ent");
		renegade.PushBack("living_world\enemy_templates\baron_renegade_crossbow.w2ent");
		renegade.PushBack("living_world\enemy_templates\baron_renegade_shield.w2ent");
		renegade.PushBack("living_world\enemy_templates\baron_renegade_sword_hard.w2ent");
		renegade.PushBack("living_world\enemy_templates\baron_renegade_sword_normal.w2ent");
		
		//# Cannibals #
		cannibal.PushBack("living_world\enemy_templates\lw_giggler_boss.w2ent");
		cannibal.PushBack("living_world\enemy_templates\lw_giggler_melee.w2ent");
		cannibal.PushBack("living_world\enemy_templates\lw_giggler_melee_spear.w2ent");
		cannibal.PushBack("living_world\enemy_templates\lw_giggler_ranged.w2ent");
		
		//# Nilfgaaridan deserter #
		nilf.PushBack("living_world\enemy_templates\nilfgaardian_deserter_bow.w2ent");
		nilf.PushBack("living_world\enemy_templates\nilfgaardian_deserter_shield.w2ent");
		nilf.PushBack("living_world\enemy_templates\nilfgaardian_deserter_sword_hard.w2ent");
		
		//# Regular bandits/deserters #
		bandit.PushBack("living_world\enemy_templates\nml_deserters_axe_normal.w2ent");
		bandit.PushBack("living_world\enemy_templates\nml_deserters_bow.w2ent");
		bandit.PushBack("living_world\enemy_templates\nml_deserters_sword_easy.w2ent");
		bandit.PushBack("living_world\enemy_templates\novigrad_bandit_shield_1haxe.w2ent");
		bandit.PushBack("living_world\enemy_templates\novigrad_bandit_shield_1hclub.w2ent");
		bandit.PushBack("living_world\enemy_templates\skellige_bandit_axe1h_hard.w2ent");
		bandit.PushBack("living_world\enemy_templates\skellige_bandit_axe1h_normal.w2ent");
		bandit.PushBack("living_world\enemy_templates\skellige_bandit_axe2h.w2ent");
		bandit.PushBack("living_world\enemy_templates\skellige_bandit_blunt_hard.w2ent");
		bandit.PushBack("living_world\enemy_templates\skellige_bandit_blunt_normal.w2ent");
		bandit.PushBack("living_world\enemy_templates\skellige_bandit_bow.w2ent");
		bandit.PushBack("living_world\enemy_templates\skellige_bandit_crossbow.w2ent");
		bandit.PushBack("living_world\enemy_templates\skellige_bandit_hammer2h.w2ent");
		bandit.PushBack("living_world\enemy_templates\skellige_bandit_shield_axe1h_normal.w2ent");
		bandit.PushBack("living_world\enemy_templates\skellige_bandit_shield_mace1h_normal.w2ent");
		bandit.PushBack("living_world\enemy_templates\skellige_bandit_sword_easy.w2ent");
		bandit.PushBack("living_world\enemy_templates\skellige_bandit_sword_hard.w2ent");
		bandit.PushBack("living_world\enemy_templates\skellige_bandit_sword_normal.w2ent");
		
		//# Pirates #
		pirate.PushBack("living_world\enemy_templates\nml_pirates_axe_normal.w2ent");
		pirate.PushBack("living_world\enemy_templates\nml_pirates_blunt.w2ent");
		pirate.PushBack("living_world\enemy_templates\nml_pirates_bow.w2ent");
		pirate.PushBack("living_world\enemy_templates\nml_pirates_crossbow.w2ent");
		pirate.PushBack("living_world\enemy_templates\nml_pirates_sword_easy.w2ent");
		pirate.PushBack("living_world\enemy_templates\nml_pirates_sword_hard.w2ent");
		pirate.PushBack("living_world\enemy_templates\nml_pirates_sword_normal.w2ent");
		pirate.PushBack("living_world\enemy_templates\skellige_pirate_axe1h_hard.w2ent");
		pirate.PushBack("living_world\enemy_templates\skellige_pirate_axe1h_normal.w2ent");
		pirate.PushBack("living_world\enemy_templates\skellige_pirate_axe2h.w2ent");
		pirate.PushBack("living_world\enemy_templates\skellige_pirate_blunt_hard.w2ent");
		pirate.PushBack("living_world\enemy_templates\skellige_pirate_blunt_normal.w2ent");
		pirate.PushBack("living_world\enemy_templates\skellige_pirate_bow.w2ent");
		pirate.PushBack("living_world\enemy_templates\skellige_pirate_crossbow.w2ent");
		pirate.PushBack("living_world\enemy_templates\skellige_pirate_hammer2h.w2ent");
		pirate.PushBack("living_world\enemy_templates\skellige_pirate_swordshield.w2ent");
		pirate.PushBack("living_world\enemy_templates\skellige_pirate_sword_easy.w2ent");
		pirate.PushBack("living_world\enemy_templates\skellige_pirate_sword_hard.w2ent");
		pirate.PushBack("living_world\enemy_templates\skellige_pirate_sword_normal.w2ent");		
		
		
		
		// ###//- Gryphons //-###
		
		gryphon.PushBack("characters\npc_entities\monsters\gryphon_lvl1.w2ent");
		gryphon.PushBack("characters\npc_entities\monsters\gryphon_lvl1.w2ent");
		gryphon.PushBack("characters\npc_entities\monsters\gryphon_lvl2.w2ent");		
		gryphon.PushBack("characters\npc_entities\monsters\gryphon_lvl2.w2ent");
		gryphon.PushBack("characters\npc_entities\monsters\gryphon_lvl3__volcanic.w2ent");		// Arch		
		gryphon.PushBack("characters\npc_entities\monsters\gryphon_mh__volcanic.w2ent");  		// Arch
		
		//gryphon.PushBack("dlc\erxvdlc\monsters\gryphon_custom.w2ent");
		
		// ###//- Forktail //-###
		forktail.PushBack("characters\npc_entities\monsters\forktail_lvl1.w2ent");  	//smaller view distance
		forktail.PushBack("characters\npc_entities\monsters\forktail_lvl2.w2ent");  	//smaller view distance
		forktail.PushBack("characters\npc_entities\monsters\forktail_mh.w2ent");		//smaller view distance
		
		// ###//- Wyverns //-###
		wyvern.PushBack("characters\npc_entities\monsters\wyvern_lvl1.w2ent"); 		// smaller view distance
		wyvern.PushBack("characters\npc_entities\monsters\wyvern_lvl2.w2ent"); 		// smaller view distance
		wyvern.PushBack("characters\npc_entities\monsters\wyvern_mh.w2ent");   		// Royal //- smaller view distance
		
		// ###//- Basilisk/Cockatrice //-###
		cockatrice.PushBack("characters\npc_entities\monsters\basilisk_lvl1.w2ent");  	// smaller view distance.....
		cockatrice.PushBack("characters\npc_entities\monsters\cockatrice_lvl1.w2ent");
		cockatrice.PushBack("characters\npc_entities\monsters\cockatrice_mh.w2ent");
		
	 // --- Flying Monsters --- //

		

	// +++ Ground Monsters +++ //
	
		// ###//- Leshens //-###
		leshen.PushBack("characters\npc_entities\monsters\lessog_lvl1.w2ent");
		leshen.PushBack("characters\npc_entities\monsters\lessog_lvl2__ancient.w2ent");
		leshen.PushBack("characters\npc_entities\monsters\lessog_mh.w2ent");  
		
		// ###//- Werewolves //-###
		werewolf.PushBack("characters\npc_entities\monsters\werewolf_lvl1.w2ent");
		werewolf.PushBack("characters\npc_entities\monsters\werewolf_lvl2.w2ent");
		werewolf.PushBack("characters\npc_entities\monsters\werewolf_lvl3__lycan.w2ent");
		werewolf.PushBack("characters\npc_entities\monsters\werewolf_lvl4__lycan.w2ent");
		werewolf.PushBack("characters\npc_entities\monsters\werewolf_lvl5__lycan.w2ent");
		
		werewolf.PushBack("characters\npc_entities\monsters\_quest__werewolf.w2ent");
		werewolf.PushBack("characters\npc_entities\monsters\_quest__werewolf_01.w2ent");
		werewolf.PushBack("characters\npc_entities\monsters\_quest__werewolf_02.w2ent");
		
		// ## Fiends ## //
		fiend.PushBack("characters\npc_entities\monsters\bies_lvl1.w2ent");  // fiends
		fiend.PushBack("characters\npc_entities\monsters\bies_lvl2.w2ent");  // red fiend
		fiend.PushBack("characters\npc_entities\monsters\bies_mh.w2ent");    // grey fiend
		
		// ## Chort ## //
		chort.PushBack("characters\npc_entities\monsters\czart_lvl1.w2ent"); // chort
		chort.PushBack("characters\npc_entities\monsters\czart_mh.w2ent");	// chort 2		
		
		// ## Fatasses ## //
		fatass.PushBack("characters\npc_entities\monsters\fugas_lvl1.w2ent");					// fire fatty
		fatass.PushBack("characters\npc_entities\monsters\fugas_lvl2.w2ent");					// red fire fatty
		fatass.PushBack("characters\npc_entities\monsters\gargoyle_lvl1.w2ent");				// gargoyle
		
		// ## Bears ## //
		bear.PushBack("characters\npc_entities\monsters\bear_berserker_lvl1.w2ent");		// red/brown
		bear.PushBack("characters\npc_entities\monsters\bear_lvl1__black.w2ent");			// black, like it says :)
		bear.PushBack("characters\npc_entities\monsters\bear_lvl2__grizzly.w2ent");			// light brown
		bear.PushBack("characters\npc_entities\monsters\bear_lvl3__grizzly.w2ent");			// light brown
		bear.PushBack("characters\npc_entities\monsters\bear_lvl3__white.w2ent");			// polarbear		
		
		// ## Golem ## //
		golem.PushBack("characters\npc_entities\monsters\golem_lvl1.w2ent");					// normal greenish golem
		golem.PushBack("characters\npc_entities\monsters\golem_lvl1_boss.w2ent");			// normal greenish golem
		golem.PushBack("characters\npc_entities\monsters\golem_lvl2.w2ent");					// normal greenish golem
		golem.PushBack("characters\npc_entities\monsters\golem_lvl2__ifryt.w2ent");			// fire golem
		golem.PushBack("characters\npc_entities\monsters\golem_lvl3.w2ent");					// weird yellowish golem
		
		// ## Elementals ## //
		elemental.PushBack("characters\npc_entities\monsters\elemental_dao_lvl1.w2ent");			// earth elemental
		elemental.PushBack("characters\npc_entities\monsters\elemental_dao_lvl2.w2ent");			// stronger and cliffier elemental
		elemental.PushBack("characters\npc_entities\monsters\elemental_dao_mh.w2ent");			// stronger and cliffier elemental
		
		// ## Vampires ## //
		vampire.PushBack("characters\npc_entities\monsters\vampire_ekima_lvl1.w2ent");		// white vampire
		vampire.PushBack("characters\npc_entities\monsters\vampire_ekima_mh.w2ent");		// white vampire
		vampire.PushBack("characters\npc_entities\monsters\vampire_katakan_lvl1.w2ent");	// cool blinky vampire
		vampire.PushBack("characters\npc_entities\monsters\vampire_katakan_lvl3.w2ent");	// cool blinky vamp
		vampire.PushBack("characters\npc_entities\monsters\vampire_katakan_mh.w2ent");		// cool blinky vamp
		
		// ## NightWraiths ## //
		nightwraith.PushBack("characters\npc_entities\monsters\nightwraith_lvl1.w2ent");
		nightwraith.PushBack("characters\npc_entities\monsters\nightwraith_lvl2.w2ent");
		nightwraith.PushBack("characters\npc_entities\monsters\nightwraith_lvl3.w2ent");
		nightwraith.PushBack("characters\npc_entities\monsters\nightwraith_mh.w2ent");
				
		// ## NoonWraiths ## //
		noonwraith.PushBack("characters\npc_entities\monsters\noonwraith_lvl1.w2ent");
		noonwraith.PushBack("characters\npc_entities\monsters\noonwraith_lvl2.w2ent");
		noonwraith.PushBack("characters\npc_entities\monsters\noonwraith_lvl3.w2ent");
		noonwraith.PushBack("characters\npc_entities\monsters\noonwraith_mh.w2ent");
		
		// ## Trolls ## //
		//troll.PushBack("characters\npc_entities\monsters\troll_cave_lvl1.w2ent");		// grey
		//troll.PushBack("characters\npc_entities\monsters\troll_cave_lvl3__ice.w2ent");	// ice
		//troll.PushBack("characters\npc_entities\monsters\troll_cave_lvl4__ice.w2ent");	// ice
		//troll.PushBack("characters\npc_entities\monsters\troll_cave_mh__black.w2ent");	// cool black
		//troll.PushBack("characters\npc_entities\monsters\troll_ice_lvl13.w2ent");		// ice		
		
		// ## Hags ## //
		hag.PushBack("characters\npc_entities\monsters\hag_grave_lvl1.w2ent");					// grave hag 1
		hag.PushBack("characters\npc_entities\monsters\hag_grave_lvl1__barons_wife.w2ent");	// grave hag 2
		hag.PushBack("characters\npc_entities\monsters\hag_grave__mh.w2ent");					// grave hag 3
		hag.PushBack("characters\npc_entities\monsters\hag_water_lvl1.w2ent");					// grey  water hag
		hag.PushBack("characters\npc_entities\monsters\hag_water_lvl2.w2ent");					// greenish water hag
		hag.PushBack("characters\npc_entities\monsters\hag_water_mh.w2ent");					// grey water hag
		
		
	// MULTIPLE
	
		// ## Harpies ## //
		harpy.PushBack("characters\npc_entities\monsters\harpy_lvl1.w2ent");				// harpy
		harpy.PushBack("characters\npc_entities\monsters\harpy_lvl2.w2ent");				// harpy
		harpy.PushBack("characters\npc_entities\monsters\harpy_lvl2_customize.w2ent");		// harpy
		harpy.PushBack("characters\npc_entities\monsters\harpy_lvl3__erynia.w2ent");		// harpy
		
		// ## Sirens ## //
		siren.PushBack("characters\npc_entities\monsters\siren_lvl1.w2ent");
		siren.PushBack("characters\npc_entities\monsters\siren_lvl2__lamia.w2ent");
		siren.PushBack("characters\npc_entities\monsters\siren_mh__lamia.w2ent");			// darker wings
		siren.PushBack("characters\npc_entities\monsters\_quest__210_morszczynka.w2ent");   // siren thing
	
		// ## Endrega ## //
		endrega.PushBack("characters\npc_entities\monsters\endriaga_lvl1__worker.w2ent");    	// small endrega
		endrega.PushBack("characters\npc_entities\monsters\endriaga_lvl2__tailed.w2ent");	  	// bigger tailed endrega
		//endrega.PushBack("characters\npc_entities\monsters\endriaga_lvl3__spikey.w2ent");	  	// big tailless endrega
		endrega.PushBack("characters\npc_entities\monsters\_quest__endriaga_spiral.w2ent");    // freaky fast bug thing
		
		// ## Fogling ## //
		fogling.PushBack("characters\npc_entities\monsters\fogling_lvl1.w2ent");			  	// normal fogling
		fogling.PushBack("characters\npc_entities\monsters\fogling_lvl2.w2ent");				// normal fogling
		fogling.PushBack("characters\npc_entities\monsters\fogling_lvl3__willowisp.w2ent");	// green fogling
		fogling.PushBack("characters\npc_entities\monsters\fogling_mh.w2ent");					// spiky folging
		fogling.PushBack("characters\npc_entities\monsters\_quest__fogling.w2ent");			// fogler
		
		// ## Ghouls ## //
		ghoul.PushBack("characters\npc_entities\monsters\ghoul_lvl1.w2ent");					// normal ghoul   spawns from the ground
		ghoul.PushBack("characters\npc_entities\monsters\ghoul_lvl2.w2ent");					// red ghoul   spawns from the ground
		ghoul.PushBack("characters\npc_entities\monsters\ghoul_lvl3.w2ent");					// tiny spike ghoul   spawns from the ground
		ghoul.PushBack("characters\npc_entities\monsters\_quest__miscreant_greater.w2ent");  // ghoul/botchling		
		
		// ## Alghouls ## //
		alghoul.PushBack("characters\npc_entities\monsters\alghoul_lvl1.w2ent");				// dark
		alghoul.PushBack("characters\npc_entities\monsters\alghoul_lvl2.w2ent");				// dark reddish
		alghoul.PushBack("characters\npc_entities\monsters\alghoul_lvl3.w2ent");				// greyish
		alghoul.PushBack("characters\npc_entities\monsters\alghoul_lvl4.w2ent");				// greyish color
		alghoul.PushBack("characters\npc_entities\monsters\alghoul_mh.w2ent");					// dark red
		
		// ## NEKKERS ## //
		nekker.PushBack("characters\npc_entities\monsters\nekker_lvl1.w2ent");
		nekker.PushBack("characters\npc_entities\monsters\nekker_lvl2.w2ent");
		nekker.PushBack("characters\npc_entities\monsters\nekker_lvl2_customize.w2ent");
		nekker.PushBack("characters\npc_entities\monsters\nekker_lvl3_customize.w2ent");
		nekker.PushBack("characters\npc_entities\monsters\nekker_lvl3__warrior.w2ent");
		nekker.PushBack("characters\npc_entities\monsters\nekker_lvl5_customize.w2ent");
		nekker.PushBack("characters\npc_entities\monsters\nekker_mh__warrior.w2ent");
		
		// ## Wild hunt Hounds ## //
		whh.PushBack("characters\npc_entities\monsters\wildhunt_minion_lvl1.w2ent");	// hound of the wild hunt
		whh.PushBack("characters\npc_entities\monsters\wildhunt_minion_lvl2.w2ent");	// spikier hound
		whh.PushBack("characters\npc_entities\monsters\wildhunt_minion_mh.w2ent");		// greenish hound
		
		// ## Drowners ## //
		drowner.PushBack("characters\npc_entities\monsters\drowner_lvl1.w2ent");				// drowner
		drowner.PushBack("characters\npc_entities\monsters\drowner_lvl1__underwater.w2ent");	// has +4 levels looks cool
		drowner.PushBack("characters\npc_entities\monsters\drowner_lvl2.w2ent");				// drowner
		drowner.PushBack("characters\npc_entities\monsters\drowner_lvl3.w2ent");				// pink drowner
		drowner.PushBack("characters\npc_entities\monsters\drowner_lvl4__dead.w2ent");			// dark drowner
		
		// ## Rotfiends ## //
		rotfiend.PushBack("characters\npc_entities\monsters\rotfiend_lvl1.w2ent");
		rotfiend.PushBack("characters\npc_entities\monsters\rotfiend_lvl2.w2ent");	// creepy
		
		// ## Wolves ## //
		wolf.PushBack("characters\npc_entities\monsters\wolf_lvl1.w2ent");				// +4 lvls	grey/black wolf STEEL
		wolf.PushBack("characters\npc_entities\monsters\wolf_lvl1__alpha.w2ent");		// +4 lvls brown warg  		STEEL
		wolf.PushBack("characters\npc_entities\monsters\wolf_lvl1__summon.w2ent");		// +2 lvls cool black  		SILVER
		wolf.PushBack("characters\npc_entities\monsters\wolf_lvl1__summon_were.w2ent");	// grey/black wolf 			SILVER
		wolf.PushBack("characters\npc_entities\monsters\wolf_lvl2__alpha.w2ent");		// +7 lvls brown warg		STEEL
		wolf.PushBack("characters\npc_entities\monsters\wolf_white_lvl2.w2ent");		// lvl 51 white wolf		STEEL
		wolf.PushBack("characters\npc_entities\monsters\wolf_white_lvl3__alpha.w2ent");	// lvl 51 white wolf 		STEEL  37
		
		// ## Wraiths ## //
		wraith.PushBack("characters\npc_entities\monsters\wraith_lvl1.w2ent");			// all look the bloody same....
		wraith.PushBack("characters\npc_entities\monsters\wraith_lvl2.w2ent");
		wraith.PushBack("characters\npc_entities\monsters\wraith_lvl2_customize.w2ent");
		wraith.PushBack("characters\npc_entities\monsters\wraith_lvl3.w2ent");
		wraith.PushBack("characters\npc_entities\monsters\wraith_lvl4.w2ent");
		wraith.PushBack("characters\npc_entities\monsters\wraith_mh.w2ent");				// except this cool black one...
		
		spider.PushBack("dlc\ep1\data\characters\npc_entities\monsters\black_spider.w2ent");
		spider.PushBack("dlc\ep1\data\characters\npc_entities\monsters\black_spider_large.w2ent");	
	}
}
	// --- Ground Monsters --- //
	
		
	// ### MONSTER PATHS ###
















