struct OnelinerDefinition
{
	//---=== modFriendlyHUD ===---
	var m_Target : CEntity;
	//---=== modFriendlyHUD ===---
	var m_Text	 : string;
	var m_ID	 : int;
};

//---=== modFriendlyHUD ===---
struct QuestMarkerDefinition
{
	var location		: Vector;
	var distance		: float;
	var radius			: float;
	var isHighlighted	: bool;
	var isUser			: bool;
};
//---=== modFriendlyHUD ===---

class CR4HudModuleOneliners extends CR4HudModuleBase
{	
	private	var m_hud 						: CR4ScriptedHud;
	private	var m_fxCreateOnelinerSFF		: CScriptedFlashFunction;
	private	var m_fxRemoveOnelinerSFF		: CScriptedFlashFunction;
	private var m_flashModule 				: CScriptedFlashSprite;
	private var m_oneliners 				: array< OnelinerDefinition >;

	//---=== modFriendlyHUD ===---
	var questMarkers						: array< QuestMarkerDefinition >;
	var questMarkerEntities					: array< CEntity >;
	var questMarkersCurrentlyShown			: bool;
	var questMarkersLastShownTime			: float;
	var compassMarkerEntities				: array< CEntity >;
	var compassMarkersCurrentlyShown		: bool;
	var compassLastShownTime				: float;
	//---=== modFriendlyHUD ===---
	
	private const var VISIBILITY_DISTANCE_SQUARED : float;	default VISIBILITY_DISTANCE_SQUARED = 2025; // 45 * 45;

	event /* flash */ OnConfigUI()
	{
		m_anchorName = "ScaleOnly";
		
		m_flashModule 			= GetModuleFlash();
		
		//m_fxUpdateOneliner		= m_flashModule.GetMemberFlashFunction( "UpdateOneliner" );
		m_fxCreateOnelinerSFF	= m_flashModule.GetMemberFlashFunction( "CreateOneliner" );
		m_fxRemoveOnelinerSFF	= m_flashModule.GetMemberFlashFunction( "RemoveOneliner" );
		
		super.OnConfigUI();
		
		m_hud 					= (CR4ScriptedHud)theGame.GetHud();
		
		if (m_hud)
		{
			m_hud.UpdateHudConfig('OnelinersModule', true);
		}
	}
	//>-----------------------------------------------------------------------------------------------------------------
	//------------------------------------------------------------------------------------------------------------------
	event OnTick( timeDelta : float )
	{
		//---=== modFriendlyHUD ===---
		var target				: CEntity;
		//---=== modFriendlyHUD ===---
		var screenPos			: Vector;
		var i 					: int;
		var mcOneliner			: CScriptedFlashSprite;
		var shouldProject		: bool;
		//---=== modFriendlyHUD ===---
		var screenMargin		: float = 0.025;
		var marginLeftTop		: Vector;
		var marginRightBottom	: Vector;
		
		if ( theGame.IsThreedQuestmarkersEnabled() )
		{
			UpdateQuestMarkers();
		}
		if ( GetFHUDConfig().compassMarkersEnabled )
		{
			UpdateCompassMarkers();
		}
		//---=== modFriendlyHUD ===---

		for( i = 0; i < m_oneliners.Size(); i += 1 )
		{
			mcOneliner = m_flashModule.GetChildFlashSprite( "mcOneliner" + m_oneliners[ i ].m_ID );
			if ( mcOneliner )
			{
				target = m_oneliners[ i ].m_Target;
				//---=== modFriendlyHUD ===---
				shouldProject = GetFHUDConfig().compassMarkersEnabled && GetFHUDConfig().project3DMarkersOnCompass;
				marginLeftTop = m_hud.GetScaleformPoint( screenMargin, screenMargin );
				marginRightBottom = m_hud.GetScaleformPoint( 1 - screenMargin, 1 - screenMargin );
				if ( target && m_oneliners[ i ].m_ID >= 100500 && m_oneliners[ i ].m_ID <= 100555 )
				{
					if( shouldProject && GetBaseScreenPosition( screenPos, target, NULL, 0, true ) )
					{
						if ( GetFHUDConfig().compassMarkersTop )
						{
							screenPos.Y = marginLeftTop.Y;
						}
						else
						{
							screenPos.Y = marginRightBottom.Y;
						}
						mcOneliner.SetPosition( screenPos.X, screenPos.Y );
						mcOneliner.SetVisible( true );
					}
					else if ( !shouldProject && GetBaseScreenPosition( screenPos, target ) )
					{
						screenPos.Y -= 45;
						if ( screenPos.X < marginLeftTop.X )
						{
							screenPos.X = marginLeftTop.X;
						}
						else if ( screenPos.X > marginRightBottom.X )
						{
							screenPos.X = marginRightBottom.X;
						}
						if ( screenPos.Y < marginLeftTop.Y )
						{
							screenPos.Y = marginLeftTop.Y;
						}
						else if ( screenPos.Y > marginRightBottom.Y )
						{
							screenPos.Y = marginRightBottom.Y;
						}
						mcOneliner.SetPosition( screenPos.X, screenPos.Y );
						mcOneliner.SetVisible( true );
					}
					else
					{
						mcOneliner.SetVisible( false );
					}
				}
				else if ( target && m_oneliners[ i ].m_ID >= 100600 && m_oneliners[ i ].m_ID <= 100609 )
				{
					if ( GetBaseScreenPosition( screenPos, target, NULL, 0, true ) )
					{
						if ( GetFHUDConfig().compassMarkersTop )
						{
							screenPos.Y = marginLeftTop.Y;
						}
						else
						{
							screenPos.Y = marginRightBottom.Y;
						}
						mcOneliner.SetPosition( screenPos.X, screenPos.Y );
						mcOneliner.SetVisible( true );
					}
					else
					{
						mcOneliner.SetVisible( false );
					}
				}
				else if ( target && IsTargetCloseEnough( target ) )
				//---=== modFriendlyHUD ===---
				{
					if ( GetBaseScreenPosition( screenPos, target, NULL, 0, true ) )
					{
						screenPos.Y -= 90;
						mcOneliner.SetPosition( screenPos.X, screenPos.Y );
						mcOneliner.SetVisible( true );
					}
					else
					{
						mcOneliner.SetVisible( false );
					}
				}
				else
				{
					mcOneliner.SetVisible( false );
				}
			}
		}
	}

	event OnCreateOneliner( target : CEntity, value : string, ID : int )
	{
		var oneliner : OnelinerDefinition;
		
		LogChannel( 'Oneliner', "SHOW " + ID + ": " + value + " [" + target.GetName() + "]" );
		//---=== modFriendlyHUD ===---
		if( ( theGame.isDialogDisplayDisabled || !m_hud.IsOnelinersModuleEnabled() ) )
		{
			if ( !( ID >= 100500 && ID <= 100555 ) && !( ID >= 100600 && ID <= 100609 ) )
		//---=== modFriendlyHUD ===---
			{
				value = "";
			}
		}
		//---=== modFriendlyHUD ===---
		oneliner.m_Target = target;
		//---=== modFriendlyHUD ===---
		oneliner.m_Text = value;
		oneliner.m_ID = ID;
		
		m_oneliners.PushBack(oneliner);
		
		m_fxCreateOnelinerSFF.InvokeSelfTwoArgs(FlashArgInt(ID),FlashArgString(value));
	}		

	event OnRemoveOneliner( ID : int )
	{
		var i : int;

		LogChannel( 'Oneliner', "HIDE " + ID );

		for( i = 0; i < m_oneliners.Size(); i += 1 )
		{
			if( m_oneliners[i].m_ID == ID )
			{
				m_oneliners.Erase(i);
				m_fxRemoveOnelinerSFF.InvokeSelfOneArg(FlashArgInt(ID));
				return true;
			}
		}
	}
	
	//---=== modFriendlyHUD ===---
	private function IsTargetCloseEnough( target : CEntity ) : bool
	//---=== modFriendlyHUD ===---
	{
		return VecDistanceSquared( target.GetWorldPosition(), thePlayer.GetWorldPosition() ) < VISIBILITY_DISTANCE_SQUARED;
	}
	
	protected function UpdateScale( scale : float, flashModule : CScriptedFlashSprite ) : bool
	{
		return false;
	}
	
	//---=== modFriendlyHUD ===---
	function UpdateQuestMarkers()
	{
		var i			: int;
		var showMarkers	: bool;
		
		showMarkers = ShouldShow3DMarkers();
		questMarkers = GetActiveMapMarkers();
		if ( questMarkerEntities.Size() != questMarkers.Size() )
		{
			ReSpawnQuestMarkerEntities();
		}
		for ( i = 0; i < questMarkers.Size(); i += 1 )
		{
			hideMarkerText( i );
			questMarkerEntities[ i ].Teleport( questMarkers[ i ].location );
			UpdateMarkerText( i, showMarkers );
		}
	}
	
	function hideMarkerText( ID : int )
	{
		OnRemoveOneliner( 100500 + ID );
	}
	
	function ShouldShow3DMarkers() : bool
	{
		if ( theGame.IsAlwaysVisibleDirectionMarkersEnabled() )
		{
			return true;
		}
		else
		{
			if ( theGame.IsThreedQuestmarkersEnabled() )
			{
				if( theGame.GetFocusModeController().IsActive() )
				{
					questMarkersLastShownTime = theGame.GetEngineTimeAsSeconds();
					return true;
				}
				if( questMarkersCurrentlyShown && ( theGame.GetEngineTimeAsSeconds() - questMarkersLastShownTime ) < GetFHUDConfig().fadeOutTimeSeconds )
				{
					return true;
				}
				return false;
			}
			else
				return false;
		}
	}
	
	function UpdateMarkerText( ID : int, showMarkers : bool )
	{
		var markerText, markerTextFont, ZlevelIndicator : string;
		var playerLoc : Vector;
		var ZDiff : float;
		
		if ( showMarkers )
		{
			playerLoc = thePlayer.GetWorldPosition();
			ZDiff = playerLoc.Z - questMarkers[ ID ].location.Z;
			if ( AbsF( ZDiff ) >= 1.5 && !questMarkers[ ID ].isUser )
			{
				if ( ZDiff < 0 )
				{
					ZlevelIndicator = GetFHUDConfig().upIndicator;
				}
				else
				{
					ZlevelIndicator = GetFHUDConfig().downIndicator;
				}
			}
			else
			{
				ZlevelIndicator = "";
			}
			if ( questMarkers[ ID ].isUser )
			{
				markerTextFont = GetFHUDConfig().userMarkerTextFont;
			}
			else if ( questMarkers[ ID ].isHighlighted )
			{
				markerTextFont = GetFHUDConfig().currentMarkerTextFont;
			}
			else
			{
				markerTextFont = GetFHUDConfig().otherMarkerTextFont;
			}
			markerText = markerTextFont + "[ " + ZlevelIndicator + FloatToStringPrec( FloorF( questMarkers[ ID ].distance ), 0 ) + " ]</font>";
			OnCreateOneliner( questMarkerEntities[ ID ], markerText, 100500 + ID );
			questMarkersCurrentlyShown = true;
		}
		else
		{
			questMarkersCurrentlyShown = false;
		}
	}
	
	function ReSpawnQuestMarkerEntities()
	{
		var i				: int;
		var template		: CEntityTemplate;
		var entity			: CEntity;
		var rot				: EulerAngles;
		
		EulerSetZeros(rot);
		while ( questMarkerEntities.Size() > questMarkers.Size() )
		{
			if ( questMarkerEntities[ questMarkerEntities.Size() - 1 ] )
			{
				questMarkerEntities[ questMarkerEntities.Size() - 1 ].Destroy();
			}
			questMarkerEntities.PopBack();
		}
		while ( questMarkerEntities.Size() < questMarkers.Size() )
		{
			if ( !template )
			{
				template = (CEntityTemplate) LoadResource( "fx_dummy_entity" );
			}
			entity = theGame.CreateEntity( template, thePlayer.GetWorldPosition(), rot );
			questMarkerEntities.PushBack( entity );
		}
	}
	
	function ShouldShowCompass() : bool
	{
		if ( theGame.IsAlwaysVisibleDirectionMarkersEnabled() )
		{
			return true;
		}
		if( theGame.GetFocusModeController().IsActive() )
		{
			compassLastShownTime = theGame.GetEngineTimeAsSeconds();
			return true;
		}
		if( compassMarkersCurrentlyShown && ( theGame.GetEngineTimeAsSeconds() - compassLastShownTime ) < GetFHUDConfig().fadeOutTimeSeconds )
		{
			return true;
		}
		return false;
	}
	
	function UpdateCompassMarkers()
	{
		var loc : Vector;
		var show : bool;
		
		if( compassMarkerEntities.Size() == 0 )
		{
			SpawnCompassEntities();
		}
		show = ShouldShowCompass();
		if( show )
		{
			loc = thePlayer.GetWorldPosition(); loc.X -= 100; loc.Y += 100; // NW
			compassMarkerEntities[ 0 ].Teleport( loc );
			loc = thePlayer.GetWorldPosition(); loc.Y += 100;               // N
			compassMarkerEntities[ 1 ].Teleport( loc );
			loc = thePlayer.GetWorldPosition(); loc.X += 100; loc.Y += 100; // NE
			compassMarkerEntities[ 2 ].Teleport( loc );
			loc = thePlayer.GetWorldPosition(); loc.X -= 100;               // W
			compassMarkerEntities[ 3 ].Teleport( loc );
			loc = thePlayer.GetWorldPosition(); loc.X += 100;               // E
			compassMarkerEntities[ 4 ].Teleport( loc );
			loc = thePlayer.GetWorldPosition(); loc.X -= 100; loc.Y -= 100; // SW
			compassMarkerEntities[ 5 ].Teleport( loc );
			loc = thePlayer.GetWorldPosition(); loc.Y -= 100;               // S
			compassMarkerEntities[ 6 ].Teleport( loc );
			loc = thePlayer.GetWorldPosition(); loc.X += 100; loc.Y -= 100; // SE
			compassMarkerEntities[ 7 ].Teleport( loc );
			if( !compassMarkersCurrentlyShown )
			{
				ShowCompassText();
				compassMarkersCurrentlyShown = true;
			}
		}
		else
		{
			if( compassMarkersCurrentlyShown )
			{
				HideCompassText();
				compassMarkersCurrentlyShown = false;
			}
		}
	}
	
	function ShowCompassText()
	{
		var markerTextFont : string;
		
		markerTextFont = GetFHUDConfig().compassMarkerTextFont;
		OnCreateOneliner( compassMarkerEntities[ 0 ], markerTextFont + "NW" + "</font>", 100600 );
		OnCreateOneliner( compassMarkerEntities[ 1 ], markerTextFont + "N"  + "</font>", 100601 );
		OnCreateOneliner( compassMarkerEntities[ 2 ], markerTextFont + "NE" + "</font>", 100602 );
		OnCreateOneliner( compassMarkerEntities[ 3 ], markerTextFont + "W"  + "</font>", 100603 );
		OnCreateOneliner( compassMarkerEntities[ 4 ], markerTextFont + "E"  + "</font>", 100604 );
		OnCreateOneliner( compassMarkerEntities[ 5 ], markerTextFont + "SW" + "</font>", 100605 );
		OnCreateOneliner( compassMarkerEntities[ 6 ], markerTextFont + "S"  + "</font>", 100606 );
		OnCreateOneliner( compassMarkerEntities[ 7 ], markerTextFont + "SE" + "</font>", 100607 );
	}

	function HideCompassText()
	{
		OnRemoveOneliner( 100600 );
		OnRemoveOneliner( 100601 );
		OnRemoveOneliner( 100602 );
		OnRemoveOneliner( 100603 );
		OnRemoveOneliner( 100604 );
		OnRemoveOneliner( 100605 );
		OnRemoveOneliner( 100606 );
		OnRemoveOneliner( 100607 );
	}
	
	function SpawnCompassEntities()
	{
		var template		: CEntityTemplate;
		var entity			: CEntity;
		var rot				: EulerAngles;
		
		EulerSetZeros(rot);
		template = (CEntityTemplate)LoadResource( "fx_dummy_entity" );
		while( compassMarkerEntities.Size() < 8 )
		{
			entity = theGame.CreateEntity( template, thePlayer.GetWorldPosition(), rot );
			compassMarkerEntities.PushBack( entity );
		}
	}
	//---=== modFriendlyHUD ===---
}

//---=== modFriendlyHUD ===---
function GetActiveMapMarkers() : array< QuestMarkerDefinition >
{
	var marker	: QuestMarkerDefinition;
	var markers	: array< QuestMarkerDefinition >;
	var result	: bool;
	
	result = GetActiveQuestMappinLocs( markers );
	if ( result ) // if outside quest area
	{
		marker = GetUserMappinLoc();
		if ( marker.distance > GetFHUDConfig().markerMinDistance ) // if inside min distance
		{
			markers.PushBack( marker ); // add user map marker
		}
	}
	return markers;
}

function GetActiveQuestMappinLocs( out markers : array< QuestMarkerDefinition > ) : bool
{
	var mapManager				: CCommonMapManager;
	var journalManager			: CWitcherJournalManager;
	var trackedObjectivesData	: array< SJournalQuestObjectiveData >;
	var currentObjective		: CJournalQuestObjective;
	var currentMappin			: CJournalQuestMapPin;
	var i, j, k, m				: int;
	var areaMapPins				: array< SAreaMapPinInfo >;
	var mapPinInstances			: array< SCommonMapPinInstance >;
	var marker					: QuestMarkerDefinition;
	var currentWorldPath		: string;
	
	markers.Clear();
	mapManager = theGame.GetCommonMapManager();
	currentWorldPath = theGame.GetWorld().GetDepotPath();
	areaMapPins = mapManager.GetAreaMapPins();
	journalManager = theGame.GetJournalManager();
	journalManager.GetTrackedQuestObjectivesData(trackedObjectivesData);
	for ( i = 0; i < trackedObjectivesData.Size(); i += 1 )
	{
		if ( trackedObjectivesData[i].status == JS_Active )
		{
			currentObjective = trackedObjectivesData[i].objectiveEntry;
			for ( j = 0 ; j < currentObjective.GetNumChildren(); j += 1 )
			{
				currentMappin = (CJournalQuestMapPin) currentObjective.GetChild( j );
				if ( currentMappin )
				{
					for ( k = 0; k < areaMapPins.Size(); k += 1 )
					{
						if ( areaMapPins[k].worldPath == currentWorldPath )
						{
							mapPinInstances	= mapManager.GetMapPinInstances( areaMapPins[k].worldPath );
							for ( m = 0; m < mapPinInstances.Size(); m += 1 )
							{
								if ( currentMappin.GetMapPinID() == mapPinInstances[m].tag )
								{
									marker.location = mapPinInstances[m].position;
									marker.radius = currentMappin.GetRadius();
									marker.distance = VecDistance( mapPinInstances[m].position, thePlayer.GetWorldPosition() );
									marker.isHighlighted = ( journalManager.GetHighlightedObjective() == currentObjective );
									marker.isUser = false;
									if ( marker.distance < marker.radius ) // if inside quest area
									{
										markers.Clear(); // remove all markers
										return false;
									}
									if ( marker.distance > GetFHUDConfig().markerMinDistance ) // if outside min distance
									{
										markers.PushBack( marker ); // add current marker
									}
								}
							}
						}
					}
				}
			}
		}
	}
	return true;
}

function GetUserMappinLoc() : QuestMarkerDefinition
{
	var mapManager : CCommonMapManager;
	var area : int;
	var pinX, pinY, pinZ : float;
	var loc, playerLoc : Vector;
	var marker : QuestMarkerDefinition;
	
	playerLoc = thePlayer.GetWorldPosition();
	marker.location = playerLoc;
	marker.distance = 0;
	marker.radius = 0;
	marker.isHighlighted = false;
	marker.isUser = true;
	mapManager = theGame.GetCommonMapManager();
	mapManager.GetUserMapPin( area, pinX, pinY );
	if ( area != mapManager.GetCurrentArea() )
	{
		return marker;
	}
	loc.X = pinX;
	loc.Y = pinY;
	loc.Z = playerLoc.Z + 1.5;
	marker.location = loc;
	marker.distance = VecDistance( loc, thePlayer.GetWorldPosition() );
	return marker;
}
//---=== modFriendlyHUD ===---

exec function sayoneliner( value : string, id : int )
{
	var hud : CR4ScriptedHud;
	var module : CR4HudModuleOneliners;

	hud = (CR4ScriptedHud)theGame.GetHud();
	module = (CR4HudModuleOneliners)hud.GetHudModule("OnelinersModule");
	module.OnCreateOneliner( GetWitcherPlayer(), value, id );
}

exec function sayoneliner2( tag : name, value : string, id : int )
{
	var hud : CR4ScriptedHud;
	var module : CR4HudModuleOneliners;
	var entity : CEntity;

	entity = theGame.GetEntityByTag( tag );
	if ( entity )
	{
		hud = (CR4ScriptedHud)theGame.GetHud();
		module = (CR4HudModuleOneliners)hud.GetHudModule("OnelinersModule");
		module.OnCreateOneliner( entity, value, id );
	}
}

exec function removeoneliner( id : int )
{
	var hud : CR4ScriptedHud;
	var module : CR4HudModuleOneliners;

	hud = (CR4ScriptedHud)theGame.GetHud();
	module = (CR4HudModuleOneliners)hud.GetHudModule("OnelinersModule");
	module.OnRemoveOneliner( id );
}
