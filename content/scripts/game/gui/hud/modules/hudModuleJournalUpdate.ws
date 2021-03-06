struct SJournalUpdate
{
	var text		: string;
	var title		: string;
	var status		: EJournalStatus;
	var journalEntry: CJournalBase;
	var iconPath	: string;
	var panelName	: name; // #B for alchemy and crafting
	var entryTag	: name; // #B for alchemy and crafting
	var soundEvent	: string;
	var isQuestUpdate: bool;
	var displayTime : float;
	default title = "";
};

class CR4HudModuleJournalUpdate extends CR4HudModuleBase
{	
	private var _bDuringDisplay : bool;		default _bDuringDisplay = false;
	private var m_fxShowJournalUpdateSFF	: CScriptedFlashFunction;
	private var m_fxSetJournalUpdateStatusSFF	: CScriptedFlashFunction;
	private var m_fxSetJournalUpdateStatusTextSFF	: CScriptedFlashFunction;
	private var m_fxClearJournalUpdateSFF	: CScriptedFlashFunction;
	private var m_fxSetIconSFF	: CScriptedFlashFunction;
	private var questsUpdates	: array< CJournalQuest>;
	private var journalUpdates	: array< SJournalUpdate>;
	private var manager : CWitcherJournalManager;
	private var m_guiManager : CR4GuiManager;	
	private var m_flashValueStorage 	: CScriptedFlashValueStorage;
	private var m_defaultInputBindings : array<SKeyBinding>;
	private var bWasRemoved : bool;
	private var defaultDisplayTime : float;
	private var defaultTrackableDisplayTime : float;
	default defaultDisplayTime = 3000; // #B 3 [s]
	default defaultTrackableDisplayTime = 6000;
	default bWasRemoved = true;
	
	event /* flash */ OnConfigUI()
	{		
		var flashModule : CScriptedFlashSprite;
		var hud : CR4ScriptedHud;
		
		m_anchorName = "mcAnchorJournalUpdate";
		super.OnConfigUI();
	
		flashModule = GetModuleFlash();
		m_flashValueStorage = GetModuleFlashValueStorage();
		m_fxShowJournalUpdateSFF = flashModule.GetMemberFlashFunction( "ShowJournalUpdate" );
		m_fxSetJournalUpdateStatusSFF = flashModule.GetMemberFlashFunction( "SetJournalUpdateStatus" );
		m_fxClearJournalUpdateSFF = flashModule.GetMemberFlashFunction( "ClearJournalUpdate" );
		m_fxSetIconSFF = flashModule.GetMemberFlashFunction( "SetIcon" );
		manager = theGame.GetJournalManager();
		m_guiManager = theGame.GetGuiManager();
		
		hud = (CR4ScriptedHud)theGame.GetHud();
						
		//if (hud)
		//{
		//	hud.UpdateHudConfig('JournalUpdateModule', true);
		//}
	}

	event OnTick( timeDelta : float )
	{
		if( !_bDuringDisplay )
		{
			if( CheckPending() )
			{
				DisplayPending();
			}
		}
		else if(journalUpdates.Size() > 0)
		{
			if( !CheckSceneAndCutsceneDisplay(journalUpdates[0].status,journalUpdates[0].isQuestUpdate) )
			{
				m_fxClearJournalUpdateSFF.InvokeSelf();
				OnRemoveUpdate();
				OnShowUpdateEnd();
			}
		}
	}

	event OnInputHandled(NavCode:string, KeyCode:int, ActionId:int)
	{
		// I don't know what it is for and why it's called, but I don't want to see log spammed with missing event messages
	}

	function CheckPending() : bool
	{	
		if( GetPendingSize() > 0 && theInput.GetContext() != 'RadialMenu' && theInput.GetContext() != 'Death' )
		{
			return true;
		}
		return false;
	}

	function DisplayPending()
	{
		var title : string;
		var offset : int;
		var isTrackableQuest : bool;
		
		_bDuringDisplay = true;
		if( (CJournalQuest)journalUpdates[0].journalEntry )
		{
			if( !CheckSceneAndCutsceneDisplay(journalUpdates[0].status,journalUpdates[0].isQuestUpdate) )
			{
				if( journalUpdates.Size() > 0 )
				{
					journalUpdates.Erase(0);
				}
				_bDuringDisplay = false;
				return;
			}
		}
		
		title =  journalUpdates[0].title;
		offset = 1;
		if(	journalUpdates[0].iconPath != "" )
		{
			offset += 4;
		}
		
		m_fxSetJournalUpdateStatusSFF.InvokeSelfOneArg(FlashArgInt(journalUpdates[0].status + offset));
		
		isTrackableQuest = IsTrackableQuest();
		if( journalUpdates[0].displayTime == 0 )
		{
			if (isTrackableQuest)
			{
				journalUpdates[0].displayTime = defaultTrackableDisplayTime;
			}
			else
			{
				journalUpdates[0].displayTime = defaultDisplayTime;
			}
		}
		m_fxShowJournalUpdateSFF.InvokeSelfThreeArgs( FlashArgString(journalUpdates[0].text), FlashArgString(title), FlashArgNumber(journalUpdates[0].displayTime) );
		m_fxSetIconSFF.InvokeSelfOneArg(FlashArgString(journalUpdates[0].iconPath));
		ShowElement(true);
		
		//hack fix for TTP 109403 by Shadi Dadenji (I cannot be expected to understand this heiroglyphic labirynth of spaghetti crap for a P3)
		if ( journalUpdates[0].soundEvent == "" )
			journalUpdates[0].soundEvent = "gui_ingame_quest_active";
		
		if( journalUpdates[0].soundEvent != "" && bWasRemoved )
		{
			if( !( theGame.IsBlackscreen() || theGame.IsFading() ) )
			{
				OnPlaySoundEvent( journalUpdates[0].soundEvent );
			}
		}
		
		m_defaultInputBindings.Clear();
		if( ( theInput.GetContext() != 'Scene' ) && ( journalUpdates[0].journalEntry || IsNameValid( journalUpdates[0].entryTag ) && !thePlayer.IsCiri() ) )
		{			
			if( isTrackableQuest )
			{
				RegisterTrackQuestBindings();
			}
			SetButtons( ( (CJournalQuest)journalUpdates[0].journalEntry ) );
		}
		UpdateInputFeedback();
		bWasRemoved = false;
	}	
	
	function RegisterTrackQuestBindings()
	{
		var outKeys 				: array< EInputKey >;
		var outKeysPC 				: array< EInputKey >;
		
		//if( thePlayer.IsActionAllowed(EIAB_HighlightObjective) )
		//{
			outKeys.Clear();
			outKeysPC.Clear();
			theInput.GetPadKeysForAction( 'TrackQuest' ,outKeys );
			theInput.GetPCKeysForAction( 'TrackQuest' ,outKeysPC );
			
			theInput.RegisterListener( this, 'OnTrackQuest', 'TrackQuest' );
			//thePlayer.BlockAction( EIAB_HighlightObjective, 'JournalUpdate', false );
			if( outKeys.Size() + outKeysPC.Size() > 0 )
			{
				//AddInputBinding("panel_button_journal_track", InputKeyToString(outKeys[0]), outKeysPC[0]);
				// #Y TODO: Auto switch on 'hold' icon if we have 'delay' param in the input config, for now — hardcode															  
				
				if (outKeysPC.Size() > 0)
				{
					AddInputBinding("panel_button_journal_track", "gamepad_R_Hold", outKeysPC[0]);
				}
				else
				{
					AddInputBinding("panel_button_journal_track", "gamepad_R_Hold", -1);
				}
			}
		//}
	}
	
	function IsTrackableQuest() : bool
	{
		var curUpdatedQuest : CJournalQuest;
		var curTrackedQuest : CJournalQuest;
		
		curUpdatedQuest = (CJournalQuest)manager.GetEntryByGuid(journalUpdates[0].journalEntry.guid);
		
		if (!curUpdatedQuest)
		{
			curUpdatedQuest = (CJournalQuest)journalUpdates[0].journalEntry;
		}
		
		curTrackedQuest = theGame.GetJournalManager().GetTrackedQuest();
		if(curUpdatedQuest && curUpdatedQuest != curTrackedQuest && journalUpdates[0].status < 2 && manager.GetEntryStatus(curUpdatedQuest) < 2)
		{
			return true;
		}
		return false;
	}

	function GetQuestStatusTitle( status : EJournalStatus, questType : eQuestType ) : string
	{
		var str : string;
		if( questType == MonsterHunt )
		{
			switch(status)
			{
				case JS_Active :
					str = "panel_journal_monstercontract_update_active";
					break;	
				case JS_Success :
					str = "panel_journal_monstercontract_update_success";
					break;
				case JS_Failed :
					str = "panel_journal_monstercontract_update_failed";
					break;		
				case JS_Inactive : // #B Is a new 
					str = "panel_journal_monstercontract_update_new";
					break;
			}
		}
		else
		{
			switch(status)
			{
				case JS_Active :
					str = "panel_journal_quest_update_active";
					break;	
				case JS_Success :
					str = "panel_journal_quest_update_success";
					break;
				case JS_Failed :
					str = "panel_journal_quest_update_failed";
					break;		
				case JS_Inactive : // #B Is a new 
					str = "panel_journal_quest_update_new";
					break;
			}
		}
		
		return GetLocStringByKeyExt(str);
	}	
	
	function GetPendingSize() : int
	{
		return journalUpdates.Size();
	}	

	function AddQuestUpdate(journalQuest : CJournalQuest, isQuestUpdate : bool ) : void 
	{
		var newJournalUpdate : SJournalUpdate;
		var status : EJournalStatus;
		
		newJournalUpdate.journalEntry = journalQuest;
		newJournalUpdate.text = GetLocStringById( journalQuest.GetTitleStringId() );
		newJournalUpdate.isQuestUpdate = isQuestUpdate;
		status = manager.GetEntryStatus(journalQuest);
		
		if( thePlayer.IsNewQuest( newJournalUpdate.journalEntry.guid ) && status == JS_Active )
		{
			newJournalUpdate.status = JS_Inactive; // #B Is a new 
			newJournalUpdate.soundEvent = "gui_ingame_quest_active"; 
		}
		else
		{
			newJournalUpdate.status = status;
			switch( status )
			{
				case JS_Active : 
					newJournalUpdate.soundEvent = "gui_ingame_new_journal"; 
					break;		
				case JS_Success : 
					newJournalUpdate.soundEvent = "gui_ingame_quest_success"; 
					break;		
				case JS_Failed : 
					newJournalUpdate.soundEvent = "gui_ingame_quest_fail"; 
					break;
			}
		}
		newJournalUpdate.title = GetQuestStatusTitle(newJournalUpdate.status,journalQuest.GetType());
		
		if( !HasQuestPendingUpdate( journalQuest, newJournalUpdate.status ) )
		{
			journalUpdates.PushBack(newJournalUpdate);
		}
	}
	
	function CheckSceneAndCutsceneDisplay( status : EJournalStatus, isQuestUpdate : bool ) : bool
	{
		if( theInput.GetContext() == 'Scene' && journalUpdates[0].iconPath == "" )
		{
			if( isQuestUpdate )
			{
				if( status == JS_Success || status == JS_Failed )
				{
					return true;
				}
				else
				{
					return false;
				}
			}
			else
			{
				return false;
			}
		}
		return true;
	}

	function AddCraftingSchematicUpdate( schematicName : name ) : void 
	{
		var newJournalUpdate : SJournalUpdate;	
		var m_definitionsManager	: CDefinitionsManagerAccessor;
		
		//if( !HasJournalPendingUpdate(journalEntry) ) // #b change to tag
		//{
			m_definitionsManager = theGame.GetDefinitionsManager();
		   	//modSOR_New_Names++
     	newJournalUpdate.text = inGameMenu_TryLocalize( m_definitionsManager.GetItemLocalisationKeyName( schematicName ));
    ///	newJournalUpdate.text = GetLocStringByKeyExt( m_definitionsManager.GetItemLocalisationKeyName( schematicName ));
		
       	//modSOR_New_Names--
    	//newJournalUpdate.journalEntry = journalEntry;
			newJournalUpdate.status = JS_Inactive;
			newJournalUpdate.iconPath = m_definitionsManager.GetItemIconPath( schematicName );
			newJournalUpdate.panelName = 'CraftingMenu';
			newJournalUpdate.entryTag = schematicName;
			newJournalUpdate.soundEvent = "gui_ingame_new_journal"; 
			
			newJournalUpdate.title = GetLocStringByKeyExt("panel_hud_craftingschematic_update_new_entry");
			journalUpdates.PushBack(newJournalUpdate);
		//}
	}		

	function AddAlchemySchematicUpdate( schematicName : name ) : void 
	{
		var newJournalUpdate : SJournalUpdate;	
		var m_definitionsManager	: CDefinitionsManagerAccessor;
		
		//if( !HasJournalPendingUpdate(journalEntry) ) // #b change to tag
		//{
			m_definitionsManager = theGame.GetDefinitionsManager();
				//modSOR_New_Names++
      //newJournalUpdate.text = GetLocStringByKeyExt( m_definitionsManager.GetItemLocalisationKeyName( schematicName ));
			 newJournalUpdate.text = inGameMenu_TryLocalize( m_definitionsManager.GetItemLocalisationKeyName( schematicName ));
      	//modSOR_New_Names--
      //newJournalUpdate.journalEntry = journalEntry;
			newJournalUpdate.status = JS_Inactive;
			newJournalUpdate.iconPath = m_definitionsManager.GetItemIconPath( schematicName );
			newJournalUpdate.panelName = 'AlchemyMenu';
			newJournalUpdate.entryTag = schematicName;
			newJournalUpdate.soundEvent = "gui_ingame_new_journal"; 
			
			newJournalUpdate.title = GetLocStringByKeyExt("panel_hud_alchemyschematic_update_new_entry");
			journalUpdates.PushBack(newJournalUpdate);
		//}
	}	

	function AddJournalUpdate( journalEntry : CJournalBase, isDescription : bool ) : void 
	{
		var newJournalUpdate : SJournalUpdate;		
		
		if( !HasJournalPendingUpdate(journalEntry) )
		{
			newJournalUpdate.text = GetEntryText(journalEntry);
			newJournalUpdate.journalEntry = journalEntry;
			newJournalUpdate.status = JS_Active;
			newJournalUpdate.soundEvent = "gui_ingame_new_journal"; 
			
			newJournalUpdate.title = GetEntryTitle(journalEntry, isDescription);
			journalUpdates.PushBack(newJournalUpdate);
		}
	}	
	
	function GetEntryText( journalEntry : CJournalBase ) : string
	{
		var str : string;
		var creatureEntry : CJournalCreature;
		var glossaryEntry : CJournalGlossary;
		var characterEntry : CJournalCharacter;
		
		creatureEntry = (CJournalCreature)journalEntry;
		glossaryEntry = (CJournalGlossary)journalEntry;
		characterEntry = (CJournalCharacter)journalEntry;
		
		if( creatureEntry )
		{
			str = GetLocStringById( creatureEntry.GetNameStringId() );
		}
		else if( glossaryEntry )
		{
			str = GetLocStringById( glossaryEntry.GetTitleStringId() );
		}	
		else if( characterEntry )
		{
			str = GetLocStringById( characterEntry.GetNameStringId() );
		}
		
		return str;
	}	

	function GetEntryTitle( journalEntry : CJournalBase, isDescription : bool ) : string
	{
		var str : string;
		var creatureEntry : CJournalCreature;
		var glossaryEntry : CJournalGlossary;
		var characterEntry : CJournalCharacter;
		
		creatureEntry = (CJournalCreature)journalEntry;
		glossaryEntry = (CJournalGlossary)journalEntry;
		characterEntry = (CJournalCharacter)journalEntry;
		
		if( creatureEntry )
		{
			str = "panel_hud_journal_entry_bestiary";
		}
		else if( glossaryEntry )
		{
			str = "panel_hud_journal_entry_glossary";
		}	
		else if( characterEntry )
		{
			str = "panel_hud_journal_entry_character";
		}
		if( isDescription )
		{
			str += "_update";
		}
		else
		{
			str += "_new";
		}
		
		return GetLocStringByKeyExt(str);
	}

	function AddLevelUpUpdate( level : int ) : void 
	{
		var newJournalUpdate : SJournalUpdate;
		var arrInt : array<int>;
		
		newJournalUpdate.soundEvent = "gui_ingame_level_up"; 
		
		newJournalUpdate.text = GetLocStringByKeyExt("panel_character_availablepoints") + ": " + GetWitcherPlayer().levelManager.GetPointsFree(ESkillPoint);
		newJournalUpdate.status = JS_Active;
		newJournalUpdate.iconPath = "icons\skills\level_gained.png";
		
		newJournalUpdate.displayTime = 7000;
		
		arrInt.PushBack(level);			
		newJournalUpdate.title = GetLocStringByKeyExtWithParams("panel_hud_level_update_level_reached",arrInt);
		
		journalUpdates.PushBack(newJournalUpdate);
	}	

	function AddExperienceUpdate( exp : int ) : void 
	{
		var newJournalUpdate : SJournalUpdate;
		var arrInt : array<int>;
	
		if(exp <= 0)
		{
			return;
		}
		
		newJournalUpdate.soundEvent = ""; 
		arrInt.PushBack(exp);
		newJournalUpdate.text = GetLocStringByKeyExtWithParams("hud_combat_log_gained_experience", arrInt);
		newJournalUpdate.status = JS_Active + 1; // sorry
		newJournalUpdate.iconPath = "icons\skills\exp_gained.png";
		newJournalUpdate.title = GetLocStringByKey("panel_hud_item_update_recived_experience");
		journalUpdates.PushBack(newJournalUpdate);
	}	

	function AddMapPinUpdate( mapPinName : name ) : void 
	{
		var newJournalUpdate : SJournalUpdate;
		newJournalUpdate.text = GetLocStringByKeyExt( StrLower("map_location_"+mapPinName) );
		newJournalUpdate.status = JS_Active;
		newJournalUpdate.soundEvent = "gui_ingame_new_mappin"; 
		newJournalUpdate.title = GetLocStringByKeyExt("panel_hud_map_update_new_entry");
		journalUpdates.PushBack(newJournalUpdate);
	}

	function AddItemRecivedDuringSceneUpdate( itemName : name, optional quantity : int ) : void 
	{
		var newJournalUpdate : SJournalUpdate;
		var inv : CInventoryComponent;
		inv = GetWitcherPlayer().GetInventory();
		 	//modSOR_New_Names++
		newJournalUpdate.text =  inGameMenu_TryLocalize( inv.GetItemLocalizedNameByName( itemName ));
	   //newJournalUpdate.text = GetLocStringByKeyExt( inv.GetItemLocalizedNameByName( itemName ));
   	//modSOR_New_Names--
  	newJournalUpdate.status = JS_Inactive;
		newJournalUpdate.iconPath = inv.GetItemIconPathByName( itemName );
		
		if( itemName == 'experience' )
		{
			newJournalUpdate.title = GetLocStringByKeyExt("panel_hud_item_update_recived_experience");
		}
		else
		{
			newJournalUpdate.title = GetLocStringByKeyExt("panel_hud_item_update_recived");
			newJournalUpdate.soundEvent = "gui_ingame_new_reward_item"; 
		}
		if( quantity > 1 )
		{
			newJournalUpdate.text += " x "+quantity;
		}
		journalUpdates.PushBack(newJournalUpdate);
	}
	
	function HasQuestPendingUpdate( journalQuest : CJournalQuest, status : EJournalStatus ) : bool
	{
		var i : int;
		
		if( status == JS_Active )
		{
			for( i = 0; i < journalUpdates.Size(); i += 1 )
			{
				if( journalUpdates[i].status != JS_Failed && journalUpdates[i].status != JS_Success )
				{
					if( journalUpdates[i].journalEntry.guid == journalQuest.guid )
					{
						return true;
					}
				}
			}
		}
		else if( status == JS_Success )
		{
			for( i = 0; i < journalUpdates.Size(); i += 1 )
			{
				if( journalUpdates[i].status == status )
				{
					if( journalUpdates[i].journalEntry.guid == journalQuest.guid )
					{
						return true;
					}
				}
			}
		}

		return false;
	}
	
	function HasJournalPendingUpdate( journalBase : CJournalBase ) : bool
	{
		var i : int;
		
		for( i = 0; i < journalUpdates.Size(); i += 1 )
		{
			if( journalUpdates[i].journalEntry.guid == journalBase.guid )
			{
				return true;
			}
		}
		return false;
	}

	function ForceAddJournalUpdateInfo(locKeyText : string, locKeyTitle : string ) : void
	{
		var newJournalUpdate : SJournalUpdate;
		var status : EJournalStatus;
		
		//newJournalUpdate.journalEntry = journalQuest;
		
		if( locKeyText == "" || locKeyText == " ")
		{
			newJournalUpdate.text = GetTrackedQuestName();
		}
		else
		{
			newJournalUpdate.text = GetLocStringByKeyExt( locKeyText );
		}
		newJournalUpdate.status = JS_Active; 
		if( locKeyTitle == "" || locKeyTitle == " ")
		{
			newJournalUpdate.title = GetQuestStatusTitle(newJournalUpdate.status,0);
		}
		else
		{
			newJournalUpdate.title = GetLocStringByKeyExt( locKeyTitle );
		}
		journalUpdates.PushBack(newJournalUpdate);
	}
	
	function GetTrackedQuestName() : string
	{
		var trackedQuests	: CJournalQuest;
		trackedQuests = manager.GetTrackedQuest();
		return GetLocStringById(trackedQuests.GetTitleStringId());
	}
	
	event /* flash */ OnRemoveUpdate()	
	{
		if( journalUpdates.Size() > 0 )
		{
			journalUpdates.Erase(0);
		}
		bWasRemoved = true;
	}
	
	event /* flash */ OnShowUpdateEnd()
	{
		theInput.UnregisterListener( this, 'OnShowEntryInPanel' );
		thePlayer.UnblockAction( EIAB_OpenFastMenu, 'JournalUpdate' );
				
		if(journalUpdates.Size() > 0 && (CJournalQuest)journalUpdates[0].journalEntry )
		{
			theInput.UnregisterListener( this, 'OnTrackQuest' );
			//thePlayer.UnblockAction( EIAB_HighlightObjective, 'JournalUpdate' );
		}
		
		_bDuringDisplay = false;
		LogChannel('JOURNALUPDATE',"OnShowUpdateEnd "+journalUpdates.Size());
	}
	
	event OnShowEntryInPanel( action : SInputAction )
	{
		if( IsReleased(action) && !thePlayer.IsCiri() )
		{
			LogChannel('JOURNALUPDATE',"OnShowEntryInPanel "+journalUpdates[0].journalEntry.baseName);
			OpenEntryInPanel();
		}
	}
	
	event OnTrackQuest( action : SInputAction )
	{
		var l_quest	: CJournalBase;
		var l_questStatus : EJournalStatus;
		var walkToggleAction : SInputAction;
		
		l_quest = journalUpdates[0].journalEntry;
		
		walkToggleAction = theInput.GetAction('WalkToggle');
		
		if ( IsReleased(action) && walkToggleAction.lastFrameValue < 0.7 && walkToggleAction.value < 0.7  && l_quest && !thePlayer.IsCiri() )
		{
			l_questStatus = manager.GetEntryStatus( l_quest );
			
			if( l_questStatus == JS_Active )
			{
				manager.SetTrackedQuest( l_quest );
			}
		}
	}
	
	function OpenEntryInPanel()
	{
		if( (CJournalQuest)journalUpdates[0].journalEntry )
		{
			OpenQuestPanel();
		}	
		else if( (CJournalCreature)journalUpdates[0].journalEntry )
		{
			OpenGlossaryPanel('GlossaryBestiaryMenu');
		}
		else if( (CJournalCharacter)journalUpdates[0].journalEntry )
		{
			OpenGlossaryPanel('GlossaryEncyclopediaMenu');
		}
		else if( (CJournalGlossary)journalUpdates[0].journalEntry )
		{
			OpenGlossaryPanel('GlossaryEncyclopediaMenu');
		}
		else if( journalUpdates[0].entryTag )
		{
			OpenSchematicPanel();
		}
	}
	
	function OpenGlossaryPanel( panelName : name )
	{
		var uiSavedData : SUISavedData;
		var journalEntry : CJournalBase;
		
		if( thePlayer.IsActionAllowed(EIAB_OpenGlossary) )
		{
			journalEntry = journalUpdates[0].journalEntry;
			uiSavedData = m_guiManager.GetUISavedData(panelName);
			uiSavedData.selectedTag = journalEntry.GetUniqueScriptTag();
			uiSavedData.panelName = panelName;
			m_guiManager.UpdateUISavedData( panelName , uiSavedData.openedCategories, uiSavedData.selectedTag, uiSavedData.selectedModule );
			
			uiSavedData = m_guiManager.GetUISavedData('GlossaryParent');
			uiSavedData.selectedTag = panelName;
			uiSavedData.panelName = 'GlossaryParent';
			m_guiManager.UpdateUISavedData( 'GlossaryParent' , uiSavedData.openedCategories, uiSavedData.selectedTag, uiSavedData.selectedModule );
			theGame.RequestMenuWithBackground( panelName, 'CommonMenu' );
		}	
	}	

	function OpenSchematicPanel()
	{
		var uiSavedData : SUISavedData;
		
		if( thePlayer.IsActionAllowed(EIAB_OpenGlossary) )
		{
			uiSavedData = m_guiManager.GetUISavedData(journalUpdates[0].panelName);
			uiSavedData.selectedTag = journalUpdates[0].entryTag;
			uiSavedData.panelName = journalUpdates[0].panelName;
			m_guiManager.UpdateUISavedData( journalUpdates[0].panelName , uiSavedData.openedCategories, uiSavedData.selectedTag, uiSavedData.selectedModule );
			
			uiSavedData = m_guiManager.GetUISavedData('GlossaryParent');
			uiSavedData.selectedTag = journalUpdates[0].panelName;
			uiSavedData.panelName = 'GlossaryParent';
			m_guiManager.UpdateUISavedData( 'GlossaryParent' , uiSavedData.openedCategories, uiSavedData.selectedTag, uiSavedData.selectedModule );
			theGame.RequestMenuWithBackground( journalUpdates[0].panelName, 'CommonMenu' );
		}	
	}
	
	function OpenQuestPanel()
	{
		var uiSavedData : SUISavedData;
		var questEntry : CJournalQuest;
		var panelName : name;
		
		if( thePlayer.IsActionAllowed(EIAB_OpenJournal) )
		{
			questEntry = (CJournalQuest)journalUpdates[0].journalEntry;
			/*if( questEntry.GetType() == MonsterHunt )
			{
				panelName = 'JournalMonsterHuntingMenu';
			}
			else if( questEntry.GetType() == TreasureHunt )
			{
				panelName = 'JournalTreasureHuntingMenu';
			}
			else
			{*/
				panelName = 'JournalQuestMenu';
			//}
			
			uiSavedData = m_guiManager.GetUISavedData(panelName);
			uiSavedData.selectedTag = questEntry.GetUniqueScriptTag();
			uiSavedData.panelName = panelName;
			m_guiManager.UpdateUISavedData( panelName , uiSavedData.openedCategories, questEntry.GetUniqueScriptTag(), uiSavedData.selectedModule );
			
			uiSavedData = m_guiManager.GetUISavedData('JournalParent');
			uiSavedData.selectedTag = panelName;
			uiSavedData.panelName = 'JournalParent';
			m_guiManager.UpdateUISavedData( 'JournalParent' , uiSavedData.openedCategories, uiSavedData.selectedTag, uiSavedData.selectedModule );
			theGame.RequestMenuWithBackground( panelName, 'CommonMenu' );
		}		
	}
	
	protected function GatherBindersArray(out resultArray : CScriptedFlashArray, bindersList : array<SKeyBinding>, optional isContextBinding:bool)
	{
		var tempFlashObject	: CScriptedFlashObject;
		var bindingGFxData  : CScriptedFlashObject;
		var curBinding	    : SKeyBinding;
		var bindingsCount   : int;
		var i			    : int;
		
		bindingsCount = bindersList.Size();
		for( i =0; i < bindingsCount; i += 1 )
		{
			curBinding = bindersList[i];
			tempFlashObject = m_flashValueStorage.CreateTempFlashObject();
			bindingGFxData = tempFlashObject.CreateFlashObject("red.game.witcher3.data.KeyBindingData");
			bindingGFxData.SetMemberFlashString("gamepad_navEquivalent", curBinding.Gamepad_NavCode );
			bindingGFxData.SetMemberFlashInt("keyboard_keyCode", curBinding.Keyboard_KeyCode );
			bindingGFxData.SetMemberFlashString("label", GetLocStringByKeyExt(curBinding.LocalizationKey) );
			bindingGFxData.SetMemberFlashString("isContextBinding", isContextBinding);
			resultArray.PushBackFlashObject(bindingGFxData);
		}
	}
	
	protected function UpdateInputFeedback():void
	{
		var gfxDataList	: CScriptedFlashArray;
		gfxDataList = m_flashValueStorage.CreateTempFlashArray();
		GatherBindersArray(gfxDataList, m_defaultInputBindings);
		m_flashValueStorage.SetFlashArray("hud.journalupdate.buttons.setup", gfxDataList);
	}
		
	function SetButtons( isJournalEntry : bool )
	{	
		var outKeys 				: array< EInputKey >;
		var outKeysPC 				: array< EInputKey >;
		
		/*
		
		#Y feature removed
		
		if( thePlayer.IsActionAllowed(EIAB_OpenJournal) && isJournalEntry || thePlayer.IsActionAllowed(EIAB_OpenGlossary) && !isJournalEntry )
		{
			outKeys.Clear();
			outKeysPC.Clear();
			theInput.GetPadKeysForAction( 'ShowEntryInPanel' ,outKeys );
			theInput.GetPCKeysForActionStr( "ShowEntryInPanel" ,outKeysPC );
			theInput.RegisterListener( this, 'OnShowEntryInPanel', 'ShowEntryInPanel' );
			thePlayer.BlockAction( EIAB_OpenFastMenu, 'JournalUpdate', false );
			
			if( outKeys.Size() + outKeysPC.Size() > 0 )
			{
				if (theGame.GetPlatform() != Platform_PS4)
				{
					AddInputBinding("panel_button_common_more_info", InputKeyToString(IK_Pad_Start), outKeysPC[0]);
				}
				else
				{
					AddInputBinding("panel_button_common_more_info", InputKeyToString(IK_PS4_OPTIONS), outKeysPC[0]);
				}
			}
		}
		*/
	}	
	
	protected function AddInputBinding(label:string, padNavCode:string, optional keyboardKeyCode:int)
	{
		var bindingDef:SKeyBinding;
		bindingDef.Gamepad_NavCode = padNavCode;
		bindingDef.Keyboard_KeyCode = keyboardKeyCode;
		bindingDef.LocalizationKey = label;
		m_defaultInputBindings.PushBack(bindingDef);
	}
}
