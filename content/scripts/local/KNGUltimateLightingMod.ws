class CKNGULM
{
	private var blendOutTime			 			: Int32;
	private var envID 								: Int32;
	private var environmentDefinitions 				: array<String>;
	private var isActive 							: bool;
	private var isTurboModeEnabled					: bool;
	private var isColorPickerEnabled 				: bool;

	private var inGameConfigWrapper 				: CInGameConfigWrapper;

	private var selectedEnvironmentId 				: Int32;
	private var selectedEnvPriorityValue 			: Int32;
	private var selectedEnvBlendValue 				: Float;
	private var selectedBlurValue					: Float;

	 
	public function Init()
	{
		inGameConfigWrapper = theGame.GetInGameConfigWrapper();

		isActive = inGameConfigWrapper.GetVarValue('KNGMenu', 'EnableEnv');	
		isTurboModeEnabled = inGameConfigWrapper.GetVarValue('KNGMenuTurbo', 'TurboMode');
			   
		blendOutTime = 0;
		SetActionForKeyBinding();

		EnvironmentDefinitionsArray();
		
		selectedEnvironmentId = StringToInt (inGameConfigWrapper.GetVarValue('KNGMenu', 'EnvironmentDefinition'));
		
		if (isActive)
		{
			ActivateSelectedEnvironmentDefinition();
			
			if (isTurboModeEnabled)
				EnableTurboMode();
				
			DisplayWelcomeMessage();
		}
	}

	 
	public function SetActionForKeyBinding()
	{
		theInput.RegisterListener( this, 'OnPressButton', 'ReloadULM' );
		theInput.RegisterListener( this, 'OnPressButton', 'NextULM' );
		theInput.RegisterListener( this, 'OnPressButton', 'PreviousULM' );
		theInput.RegisterListener( this, 'OnPressButton', 'DisableULM' );
		theInput.RegisterListener( this, 'OnPressButton', 'Favorite1ULM' );
		theInput.RegisterListener( this, 'OnPressButton', 'Favorite2ULM' );
		theInput.RegisterListener( this, 'OnPressButton', 'Favorite3ULM' );
		theInput.RegisterListener( this, 'OnPressButton', 'EnvPlusULM' );
		theInput.RegisterListener( this, 'OnPressButton', 'EnvMinusULM' );
	}

	public function EnvironmentDefinitionsArray()
	{
		environmentDefinitions.PushBack("environment\definitions\cutscenes_definition\cutscen_definition_global.env");
		environmentDefinitions.PushBack("environment\definitions\env_skellige\env_pbr_skellige_v7_tm_fog_sky_b_tm_exp.env");
		environmentDefinitions.PushBack("environment\definitions\cutscenes_definition\cutscen_definition_kaer_morhen.env");
		environmentDefinitions.PushBack("environment\definitions\cutscenes_definition\envs_for_cutscenes\dandelion_cellar_cutscene.env");
		environmentDefinitions.PushBack("environment\definitions\env_island_of_mist\env_island_fog_1.env");
		environmentDefinitions.PushBack("environment\definitions\env_island_of_mist\env_island_of_mist.env");
		environmentDefinitions.PushBack("environment\definitions\env_island_of_mist\env_island_of_mist_2.env");
		environmentDefinitions.PushBack("environment\definitions\env_island_of_mist\env_island_of_mist_dark.env");
		environmentDefinitions.PushBack("environment\definitions\env_island_of_mist\env_island_of_mist_dark_cutscen.env");
		environmentDefinitions.PushBack("environment\definitions\env_nomansland\env_nml_global_dark_sunset.env");
		environmentDefinitions.PushBack("environment\definitions\env_nomansland\env_nml_global_dark_sunset_interior.env");
		environmentDefinitions.PushBack("environment\definitions\env_nomansland\barons_lair\env_nml_barons_castle_v2.env");
		environmentDefinitions.PushBack("environment\definitions\env_nomansland\crossroads_inn\env_nml_crossroads_inn_v2.env");
		environmentDefinitions.PushBack("environment\definitions\env_nomansland\keira_swcret_room\env_keira_secret_2.env");
		environmentDefinitions.PushBack("environment\definitions\env_nomansland\nml_global\env_nml_swamps_v1.env");
		environmentDefinitions.PushBack("environment\definitions\env_nomansland\nml_global\env_nml_swamps_v1_a_ps4_flat24.env");
		environmentDefinitions.PushBack("environment\definitions\env_nomansland\salt_mines\wip\env_salt_mine_filmic_01.env");
		environmentDefinitions.PushBack("environment\definitions\env_novigrad\env_interior.env");
		environmentDefinitions.PushBack("environment\definitions\env_novigrad\env_novigrad_cave.env");
		environmentDefinitions.PushBack("environment\definitions\env_novigrad\env_novigrad_cave_blizzard.env");
		environmentDefinitions.PushBack("environment\definitions\env_novigrad\env_novigrad_cave_dark.env");
		environmentDefinitions.PushBack("environment\definitions\env_novigrad\env_novigrad_cave_red_water.env");
		environmentDefinitions.PushBack("environment\definitions\env_novigrad\env_novigrad_dark_clouds.env");
		environmentDefinitions.PushBack("environment\definitions\env_novigrad\env_novigrad_dark_clouds_heavy.env");
		environmentDefinitions.PushBack("environment\definitions\env_novigrad\env_novigrad_dark_clouds_heavy_rain_color.env");
		environmentDefinitions.PushBack("environment\definitions\env_novigrad\env_novigrad_int.env");
		environmentDefinitions.PushBack("environment\definitions\env_novigrad\env_novigrad_storm.env");
		environmentDefinitions.PushBack("environment\definitions\env_novigrad\env_novigrad_sunset.env");
		environmentDefinitions.PushBack("environment\definitions\env_novigrad\elven_king_dandelion\env_elven_king_dandelion_copy.env");
		environmentDefinitions.PushBack("environment\definitions\env_novigrad\env_novigrad_global\env_novigrad_city.env");
		environmentDefinitions.PushBack("environment\definitions\env_novigrad\env_novigrad_global\raw_novigrad\env_novigrad_0_storm_1.env");
		environmentDefinitions.PushBack("environment\definitions\env_novigrad\env_novigrad_global\raw_novigrad\underwater.env");
		environmentDefinitions.PushBack("environment\definitions\env_novigrad\interiors\dandelion\env_dandelion.env");
		environmentDefinitions.PushBack("environment\definitions\env_novigrad\interiors\dandelion\wip\env_interior_1.env");
		environmentDefinitions.PushBack("environment\definitions\env_novigrad\interiors\dandelion\wip\env_interior_2.env");
		environmentDefinitions.PushBack("environment\definitions\env_novigrad\novigrad_sewers\env_novigrad_sewers_filmic_v1.env");
		environmentDefinitions.PushBack("environment\definitions\env_prologue\env_prolog_colors_cinematic_tonemapping.env");
		environmentDefinitions.PushBack("environment\definitions\env_prologue\env_prolog_colors_interior.env");
		environmentDefinitions.PushBack("environment\definitions\env_prologue\env_prolog_colors_v1_b_sunset.env");
		environmentDefinitions.PushBack("environment\definitions\env_prologue\env_prolog_global\env_prolog_global_raw_v2_a_interior.env");
		environmentDefinitions.PushBack("environment\definitions\env_skellige\env_fight_island_arena_.env");
		environmentDefinitions.PushBack("environment\definitions\env_skellige\env_fight_ship.env");
		environmentDefinitions.PushBack("environment\definitions\env_skellige\env_pbr_skellige_len_temp.env");
		environmentDefinitions.PushBack("environment\definitions\env_skellige\env_skellige_brown.env");
		environmentDefinitions.PushBack("environment\definitions\env_skellige\env_skellige_brown_dark_clouds.env");
		environmentDefinitions.PushBack("environment\definitions\env_skellige\env_skellige_dark_clouds.env");
		environmentDefinitions.PushBack("environment\definitions\env_skellige\env_skellige_rain_storm.env");
		environmentDefinitions.PushBack("environment\definitions\env_skellige\env_skellige_rain_storm_arena.env");
		environmentDefinitions.PushBack("environment\definitions\env_skellige\env_winter_skellige.env");
		environmentDefinitions.PushBack("environment\definitions\env_skellige\cataclysm\env_skellige_cataclysm_1.env");
		environmentDefinitions.PushBack("environment\definitions\env_skellige\exteriors\env_skellige_leshy_forest_v3.env");
		environmentDefinitions.PushBack("environment\definitions\env_skellige\herbarium\env_herbarium_fall_2.env");
		environmentDefinitions.PushBack("environment\definitions\env_skellige\herbarium\wip\env_herbarium_mordor_1.env");
		environmentDefinitions.PushBack("environment\definitions\env_skellige\interiors\kt_castle\env_kaer_trolde_interior_1.env");
		environmentDefinitions.PushBack("environment\definitions\env_skellige\interiors\kt_castle\env_kaer_trolde_interior_2.env");
		environmentDefinitions.PushBack("environment\definitions\env_skellige\q203_him\env_skellige_udalryk.env");
		environmentDefinitions.PushBack("environment\definitions\env_skellige\q205\env_bathouse_v01.env");
		environmentDefinitions.PushBack("environment\definitions\env_skellige\q210\env_skellige_q210.env");
		environmentDefinitions.PushBack("environment\definitions\env_skellige\q501\q501_underwater.env");
		environmentDefinitions.PushBack("environment\definitions\env_skellige\q502\cutscen_definition_global_q502_wyzima.env");
		environmentDefinitions.PushBack("environment\definitions\env_skellige\q502\cutscen_definition_global_q502_wyzima_v2.env");
		environmentDefinitions.PushBack("environment\definitions\env_skellige\q502\cutscen_definition_global_q502_wyzima_v3.env");
		environmentDefinitions.PushBack("environment\definitions\env_skellige\q502\cutscen_definition_global_q502_wyzima_v4.env");
		environmentDefinitions.PushBack("environment\definitions\env_skellige\q502\env_kaer_morhen_v09_tm_q502_cold_light.env");
		environmentDefinitions.PushBack("environment\definitions\env_skellige\q502\env_skellige_brown_q502_by_light.env");
		environmentDefinitions.PushBack("environment\definitions\env_skellige\q502\env_skellige_brown_q502_by_light_2.env");
		environmentDefinitions.PushBack("environment\definitions\env_skellige\q502\env_skellige_brown_q502_by_light_3.env");
		environmentDefinitions.PushBack("environment\definitions\env_skellige\q502\env_skellige_brown_q502_by_light_4.env");
		environmentDefinitions.PushBack("environment\definitions\env_skellige\q502\env_skellige_brown_q502_end.env");
		environmentDefinitions.PushBack("environment\definitions\env_skellige\shore_cave_sq209\env_skellige_sq209_02.env");
		environmentDefinitions.PushBack("environment\definitions\env_skellige\shore_cave_sq209\env_skellige_sq209_03.env");
		environmentDefinitions.PushBack("environment\definitions\env_spiral\env_elven_city_4_11.env");
		environmentDefinitions.PushBack("environment\definitions\env_spiral\env_spiral_dark_valley.env");
		environmentDefinitions.PushBack("environment\definitions\env_spiral\env_spiral_snow_hour_6_22_cave.env");
		environmentDefinitions.PushBack("environment\definitions\env_winter\env_winter_epilog.env");
		environmentDefinitions.PushBack("environment\definitions\env_winter\env_winter_epilog_white_grass.env");
		environmentDefinitions.PushBack("environment\definitions\env_winter\env_winter_epilog_white_grass_hendriks_basement.env");
		environmentDefinitions.PushBack("environment\definitions\env_winter\env_winter_epilog_white_grass_hendriks_house.env");
		environmentDefinitions.PushBack("environment\definitions\env_winter\env_winter_v0_white_thaw.env");
		environmentDefinitions.PushBack("environment\definitions\kaer_morhen\cutscenes\kaer_morhen_nightmare.env");
		environmentDefinitions.PushBack("environment\definitions\kaer_morhen\interior\env_kaer_morhen_hdr_int.env");
		environmentDefinitions.PushBack("environment\definitions\kaer_morhen\kaer_morhen_battle\wip\env_km_dark_clouds_heavy_rain_color.env");
		environmentDefinitions.PushBack("environment\definitions\kaer_morhen\kaer_morhen_battle\wip\kaer_morhen_battle.env");
		environmentDefinitions.PushBack("environment\definitions\kaer_morhen\kaer_morhen_battle\wip\kaer_morhen_battle_preview_01.env");
		environmentDefinitions.PushBack("environment\definitions\kaer_morhen\kaer_morhen_global\env_kaer_morhen_v09_hdr_int.env");
		environmentDefinitions.PushBack("environment\definitions\kaer_morhen\kaer_morhen_global\env_kaer_morhen_v09_tm.env");
		environmentDefinitions.PushBack("environment\definitions\kaer_morhen\kaer_morhen_global\env_kaer_morhen_v09_usm_sex_scene.env");
		environmentDefinitions.PushBack("environment\definitions\kaer_morhen\kaer_morhen_global\env_kaer_morhen_v09_usm_sex_scene_v3.env");
		environmentDefinitions.PushBack("environment\definitions\kaer_morhen\kaer_morhen_global\env_kaer_morhen_vesemir_v0_hour_3_30.env");
		environmentDefinitions.PushBack("environment\definitions\kaer_morhen\kaer_morhen_global\q401\env_kaer_morhen_v09_q401.env");
		environmentDefinitions.PushBack("environment\definitions\novigrad\env_global_clear_interior.env");
		environmentDefinitions.PushBack("environment\definitions\skellige\env_abandoned_mine.env");
		environmentDefinitions.PushBack("environment\definitions\skellige\env_bies_hypnotize.env");
		environmentDefinitions.PushBack("environment\definitions\skellige\env_dense_fog_mq2041.env");
		environmentDefinitions.PushBack("environment\definitions\usm\battle_02.env");
		environmentDefinitions.PushBack("environment\definitions\usm\battle_02_copy.env");
		environmentDefinitions.PushBack("environment\definitions\usm\battle_02_copy_nofx.env");
		environmentDefinitions.PushBack("environment\definitions\usm\battle_02_no blue_lights.env");
		environmentDefinitions.PushBack("environment\definitions\usm\battle_02_no _sun.env");
		environmentDefinitions.PushBack("environment\definitions\usm\battle_02_shadow_light.env");
		environmentDefinitions.PushBack("environment\definitions\usm\cs002_wild_hunt_chase_p4.env");
		environmentDefinitions.PushBack("environment\definitions\usm\cs301_dream_ciri_and_jasker_p2.env");
		environmentDefinitions.PushBack("environment\definitions\usm\cs501_ciri_escape.env");
		environmentDefinitions.PushBack("environment\definitions\usm\cs501_naglfar_arrives.env");
		environmentDefinitions.PushBack("environment\definitions\usm\cs__departure_2.env");
		environmentDefinitions.PushBack("environment\definitions\usm\naglfar_freezes_p2.env");
		environmentDefinitions.PushBack("environment\definitions\usm\naglfar_freezes_p2_face.env");
		environmentDefinitions.PushBack("environment\definitions\wyzima\global\env_wyzima.env");
		environmentDefinitions.PushBack("environment\definitions\wyzima\global\env_wyzima_interior.env");
		environmentDefinitions.PushBack("fx\demos_and_temp_fx\darkness_upon_us.env");
		environmentDefinitions.PushBack("fx\quest\q103\q103_castle_fire_noshafts.env");
		environmentDefinitions.PushBack("fx\quest\q103\q103_env_barons_burial.env");
		environmentDefinitions.PushBack("fx\quest\q107\q107_env_witch_village_fog.env");
		environmentDefinitions.PushBack("quests\part_2\quest_files\q106_tower\entities\env_mist_q106.env");
		environmentDefinitions.PushBack("environment\definitions\cutscenes_definition\envs_for_cutscenes\q106_temp_island_env_int_cs.env");
		environmentDefinitions.PushBack("quests\part_2\quest_files\q106_tower\entities\q106_temp_island_env.env");
		environmentDefinitions.PushBack("quests\part_2\quest_files\q106_tower\entities\q106_temp_island_env_int.env");
		environmentDefinitions.PushBack("environment\definitions\dashdot_env_nvg_global_23_07_2013_copy.env");
		
		//HoS Envs
		
		environmentDefinitions.PushBack("environment\definitions\env_novigrad\env_novigrad_cave_simpa.env");
		environmentDefinitions.PushBack("environment\definitions\env_novigrad\env_novigrad_q602_sex_empty_1.env");
		environmentDefinitions.PushBack("environment\definitions\env_novigrad\env_novigrad_sunset_q602_dog.env");
		environmentDefinitions.PushBack("environment\definitions\env_novigrad\env_novigrad_sunset_q602_sex.env");
		environmentDefinitions.PushBack("environment\definitions\env_novigrad\env_novigrad_sunset_q603_heist_starts.env");
		
		environmentDefinitions.PushBack("dlc\ep1\environment\definitions\q601\env_novigrad_cave_frogarena.env");
		environmentDefinitions.PushBack("dlc\ep1\environment\definitions\q601\q601_dark_clouds_heavy_rain.env");
		environmentDefinitions.PushBack("dlc\ep1\environment\definitions\q601\q601_dark_clouds_heavy_rain_scene.env");
		environmentDefinitions.PushBack("dlc\ep1\environment\definitions\q602\q602_wedding_overlay.env");
		environmentDefinitions.PushBack("dlc\ep1\environment\definitions\q602\q602_wedding_overlay_2.env");
		environmentDefinitions.PushBack("dlc\ep1\environment\definitions\q605\env_novigrad_sunset_q605_temple_meeting_02.env");
		environmentDefinitions.PushBack("dlc\ep1\environment\definitions\q602\q605_no_wind.env");
		
		//More HoS Envs
		
		environmentDefinitions.PushBack("dlc\ep1\data\environment\definitions\trailer\bury_iris_side.env");
		environmentDefinitions.PushBack("dlc\ep1\data\environment\definitions\trailer\enter_painting_wide.env");		
		environmentDefinitions.PushBack("dlc\ep1\data\environment\definitions\in_progress\living_world\leshy_forest.env");	
		environmentDefinitions.PushBack("dlc\ep1\data\environment\definitions\in_progress\q601\env_novigrad_sunset_cs601_09.env");	
		environmentDefinitions.PushBack("dlc\ep1\data\environment\definitions\in_progress\q601\q601_ship.env");	
		environmentDefinitions.PushBack("dlc\ep1\data\environment\definitions\in_progress\q603\env_novigrad_sunset_nn.env");	
		environmentDefinitions.PushBack("dlc\ep1\data\environment\definitions\in_progress\q603\env_novigrad_sunset_nn_blu_.env");	
		environmentDefinitions.PushBack("dlc\ep1\data\environment\definitions\in_progress\q604\q604_blizzard.env");	
		environmentDefinitions.PushBack("dlc\ep1\data\environment\definitions\in_progress\q604\q604_blizzard_cs.env");	
		environmentDefinitions.PushBack("dlc\ep1\data\environment\definitions\in_progress\q604\q604_blizzard_cs_exit_painting.env");		
		environmentDefinitions.PushBack("dlc\ep1\data\environment\definitions\in_progress\q604\q604_blizzard_interior.env");	
		environmentDefinitions.PushBack("dlc\ep1\data\environment\definitions\in_progress\q604\q604_blizzard_interior_cs.env");	
		environmentDefinitions.PushBack("dlc\ep1\data\environment\definitions\in_progress\q604\q604_creepy.env");	
		environmentDefinitions.PushBack("dlc\ep1\data\environment\definitions\in_progress\q604\q604_creepy_cs.env");	
		environmentDefinitions.PushBack("dlc\ep1\data\environment\definitions\in_progress\q604\q604_creepy_interior.env");	
		environmentDefinitions.PushBack("dlc\ep1\data\environment\definitions\in_progress\q604\q604_dark_corridor.env");	
		environmentDefinitions.PushBack("dlc\ep1\data\environment\definitions\in_progress\q604\q604_dark_corridor_creepy.env");	
		environmentDefinitions.PushBack("dlc\ep1\data\environment\definitions\in_progress\q604\q604_dark_corridor_creepy_paint.env");	
		environmentDefinitions.PushBack("dlc\ep1\data\environment\definitions\in_progress\q604\q604_painting_cs.env");	
		environmentDefinitions.PushBack("dlc\ep1\data\environment\definitions\in_progress\q604\q604_painting_cs_closeup.env");	
		environmentDefinitions.PushBack("dlc\ep1\data\environment\definitions\in_progress\q604\q604_painting_cs_midshot.env");	
		environmentDefinitions.PushBack("dlc\ep1\data\environment\definitions\in_progress\q604\q604_painting_cs_wideshot.env");	
		environmentDefinitions.PushBack("dlc\ep1\data\environment\definitions\in_progress\q604\q604_painting_interior.env");	
		environmentDefinitions.PushBack("dlc\ep1\data\environment\definitions\in_progress\q604\q604_painting_interior_cs.env");	
		environmentDefinitions.PushBack("dlc\ep1\data\environment\definitions\in_progress\q604\q604_unmasking.env");	
		environmentDefinitions.PushBack("dlc\ep1\data\environment\definitions\in_progress\q604\q604_unmasking_dark.env");	
		environmentDefinitions.PushBack("dlc\ep1\data\environment\definitions\in_progress\q604\q604_unmasking_shadow_more_details.env");	
		environmentDefinitions.PushBack("dlc\ep1\data\environment\definitions\in_progress\q605\q605_hell_red_blockout.env");	
		environmentDefinitions.PushBack("dlc\ep1\data\environment\definitions\in_progress\q605\q605_hell_red_blockout_last_arena.env");	
		environmentDefinitions.PushBack("dlc\ep1\data\environment\definitions\in_progress\q605\q605_hell_red_blockout_mansion.env");	
	}


	public function ActivateCustomEnvironmentDefinition(blendInTime : float)
	{
		var environment : CEnvironmentDefinition;
				
		DeactivateCustomEnvironmentDefinition();
			
		//selectedEnvironmentId = StringToInt (inGameConfigWrapper.GetVarValue('KNGMenu', 'EnvironmentDefinition'));
				
		selectedEnvPriorityValue = StringToInt(inGameConfigWrapper.GetVarValue('KNGMenu', 'envPriority'));
		selectedEnvBlendValue = StringToFloat(inGameConfigWrapper.GetVarValue('KNGMenu', 'envBlend'));
		
		environment = ( CEnvironmentDefinition )LoadResource( environmentDefinitions[selectedEnvironmentId], true );

		if ( environment )
		{
			envID = ActivateEnvironmentDefinition(environment, selectedEnvPriorityValue, selectedEnvBlendValue, blendInTime);
			
			theGame.SetEnvironmentID(envID);
		}
			
		//GetWitcherPlayer().DisplayHudMessage(environmentDefinitions[selectedEnvironmentId]);
	}

	public function ActivateBlurEffect()
	{
		selectedBlurValue = StringToFloat(inGameConfigWrapper.GetVarValue('KNGMenu', 'fullscreenblur'));

		FullscreenBlurSetup(selectedBlurValue);
	}

	public function ActivateSelectedEnvironmentDefinition()
	{
		selectedEnvironmentId = StringToInt (inGameConfigWrapper.GetVarValue('KNGMenu', 'EnvironmentDefinition'));
		ActivateBlurEffect();
		ActivateCustomEnvironmentDefinition(1.0f);
	}

	public function ActivateNextEnvironmentDefintion()
	{
		var nextEnvironmentId : int;
		
		if (selectedEnvironmentId == environmentDefinitions.Size())
			nextEnvironmentId = 0;
		else
			nextEnvironmentId = selectedEnvironmentId + 1;
		
		selectedEnvironmentId = nextEnvironmentId;
		
		inGameConfigWrapper.SetVarValue('KNGMenu', 'EnvironmentDefinition', selectedEnvironmentId);
		
		ActivateCustomEnvironmentDefinition(1.0f);
	}

	public function ActivatePreviousEnvironmentDefinition()
	{
		var previousEnvironemntId : int;
		
		if (selectedEnvironmentId == 0)
			previousEnvironemntId = environmentDefinitions.Size();
		else
			previousEnvironemntId = selectedEnvironmentId - 1;
		
		selectedEnvironmentId = previousEnvironemntId;
		
		inGameConfigWrapper.SetVarValue('KNGMenu', 'EnvironmentDefinition', selectedEnvironmentId);
		
		ActivateCustomEnvironmentDefinition(1.0f);
	}

	public function ActivateAddEnvPriority()
	{
		var envPriority : int;
		envPriority = StringToInt(inGameConfigWrapper.GetVarValue('KNGMenu', 'envPriority'));
		if (envPriority < 1000)
			inGameConfigWrapper.SetVarValue('KNGMenu', 'envPriority', Clamp(envPriority + 100, 0, 1000));
			
		ActivateCustomEnvironmentDefinition(0.0f);
	}
	
	public function ActivateMinusEnvPriority()
	{
		var envPriority : int;
		envPriority = StringToInt(inGameConfigWrapper.GetVarValue('KNGMenu', 'envPriority'));
		if (envPriority > 0)
			inGameConfigWrapper.SetVarValue('KNGMenu', 'envPriority', Clamp(envPriority - 100, 0, 1000));
			
		ActivateCustomEnvironmentDefinition(0.0f);
	}
	
	public function ActivateAddEnvBlend()
	{
		var envBlend : float;
		envBlend = StringToFloat(inGameConfigWrapper.GetVarValue('KNGMenu', 'envBlend'));
		if (envBlend < 1)
			inGameConfigWrapper.SetVarValue('KNGMenu', 'envBlend', ClampF(envBlend + 0.05f, 0.0f, 1.0f));
			
		ActivateCustomEnvironmentDefinition(0.0f);
	}
	
	public function ActivateMinusEnvBlend()
	{
		var envBlend : float;
		envBlend = StringToFloat(inGameConfigWrapper.GetVarValue('KNGMenu', 'envBlend'));
		if (envBlend > 0)
			inGameConfigWrapper.SetVarValue('KNGMenu', 'envBlend', ClampF(envBlend - 0.05f, 0.0f, 1.0f));
			
		ActivateCustomEnvironmentDefinition(0.0f);
	}
	
	public function ActivateFavorites( id : int)
	{
		if (id == 1)
		{
			inGameConfigWrapper.SetVarValue('KNGMenu', 'EnvironmentDefinition', StringToInt(inGameConfigWrapper.GetVarValue('KNGMenuFavorites1', 'EnvironmentDefinition')));
			inGameConfigWrapper.SetVarValue('KNGMenu', 'envPriority', StringToInt(inGameConfigWrapper.GetVarValue('KNGMenuFavorites1', 'envPriority')));
			inGameConfigWrapper.SetVarValue('KNGMenu', 'envBlend', StringToFloat(inGameConfigWrapper.GetVarValue('KNGMenuFavorites1', 'envBlend')));
			inGameConfigWrapper.SetVarValue('KNGMenu', 'fullscreenblur', StringToFloat(inGameConfigWrapper.GetVarValue('KNGMenuFavorites1', 'fullscreenblur')));
			inGameConfigWrapper.SetVarValue('KNGMenuTurbo', 'TurboMode', inGameConfigWrapper.GetVarValue('KNGMenuFavorites1', 'TurboMode'));
			inGameConfigWrapper.SetVarValue('KNGMenuTurbo', 'fogDensity', StringToFloat(inGameConfigWrapper.GetVarValue('KNGMenuFavorites1', 'fogDensity')));
			
			inGameConfigWrapper.SetVarValue('KNGMenuTurbo', 'EnableColorPicker', inGameConfigWrapper.GetVarValue('KNGMenuFavorites1', 'EnableColorPicker'));
			inGameConfigWrapper.SetVarValue('KNGMenuTurbo', 'Saturation', StringToFloat(inGameConfigWrapper.GetVarValue('KNGMenuFavorites1', 'Saturation')));
			inGameConfigWrapper.SetVarValue('KNGMenuTurbo', 'nearTintRange', StringToFloat(inGameConfigWrapper.GetVarValue('KNGMenuFavorites1', 'nearTintRange')));
			inGameConfigWrapper.SetVarValue('KNGMenuTurbo', 'nearTintRed', StringToInt(inGameConfigWrapper.GetVarValue('KNGMenuFavorites1', 'nearTintRed')));
			inGameConfigWrapper.SetVarValue('KNGMenuTurbo', 'nearTintGreen', StringToInt(inGameConfigWrapper.GetVarValue('KNGMenuFavorites1', 'nearTintGreen')));
			inGameConfigWrapper.SetVarValue('KNGMenuTurbo', 'nearTintBlue', StringToInt(inGameConfigWrapper.GetVarValue('KNGMenuFavorites1', 'nearTintBlue')));
			inGameConfigWrapper.SetVarValue('KNGMenuTurbo', 'nearTintAlpha', StringToInt(inGameConfigWrapper.GetVarValue('KNGMenuFavorites1', 'nearTintAlpha')));
			inGameConfigWrapper.SetVarValue('KNGMenuTurbo', 'farTintRed', StringToInt(inGameConfigWrapper.GetVarValue('KNGMenuFavorites1', 'farTintRed')));
			inGameConfigWrapper.SetVarValue('KNGMenuTurbo', 'farTintGreen', StringToInt(inGameConfigWrapper.GetVarValue('KNGMenuFavorites1', 'farTintGreen')));
			inGameConfigWrapper.SetVarValue('KNGMenuTurbo', 'farTintBlue', StringToInt(inGameConfigWrapper.GetVarValue('KNGMenuFavorites1', 'farTintBlue')));
			inGameConfigWrapper.SetVarValue('KNGMenuTurbo', 'farTintAlpha', StringToInt(inGameConfigWrapper.GetVarValue('KNGMenuFavorites1', 'farTintAlpha')));
		}
		else if (id == 2)
		{
			inGameConfigWrapper.SetVarValue('KNGMenu', 'EnvironmentDefinition', StringToInt(inGameConfigWrapper.GetVarValue('KNGMenuFavorites2', 'EnvironmentDefinition')));
			inGameConfigWrapper.SetVarValue('KNGMenu', 'envPriority', StringToInt(inGameConfigWrapper.GetVarValue('KNGMenuFavorites2', 'envPriority')));
			inGameConfigWrapper.SetVarValue('KNGMenu', 'envBlend', StringToFloat(inGameConfigWrapper.GetVarValue('KNGMenuFavorites2', 'envBlend')));
			inGameConfigWrapper.SetVarValue('KNGMenu', 'fullscreenblur', StringToFloat(inGameConfigWrapper.GetVarValue('KNGMenuFavorites2', 'fullscreenblur')));
			inGameConfigWrapper.SetVarValue('KNGMenuTurbo', 'TurboMode', inGameConfigWrapper.GetVarValue('KNGMenuFavorites2', 'TurboMode'));
			inGameConfigWrapper.SetVarValue('KNGMenuTurbo', 'fogDensity', StringToFloat(inGameConfigWrapper.GetVarValue('KNGMenuFavorites2', 'fogDensity')));
			
			inGameConfigWrapper.SetVarValue('KNGMenuTurbo', 'EnableColorPicker', inGameConfigWrapper.GetVarValue('KNGMenuFavorites2', 'EnableColorPicker'));
			inGameConfigWrapper.SetVarValue('KNGMenuTurbo', 'Saturation', StringToFloat(inGameConfigWrapper.GetVarValue('KNGMenuFavorites2', 'Saturation')));
			inGameConfigWrapper.SetVarValue('KNGMenuTurbo', 'nearTintRange', StringToFloat(inGameConfigWrapper.GetVarValue('KNGMenuFavorites2', 'nearTintRange')));
			inGameConfigWrapper.SetVarValue('KNGMenuTurbo', 'nearTintRed', StringToInt(inGameConfigWrapper.GetVarValue('KNGMenuFavorites2', 'nearTintRed')));
			inGameConfigWrapper.SetVarValue('KNGMenuTurbo', 'nearTintGreen', StringToInt(inGameConfigWrapper.GetVarValue('KNGMenuFavorites2', 'nearTintGreen')));
			inGameConfigWrapper.SetVarValue('KNGMenuTurbo', 'nearTintBlue', StringToInt(inGameConfigWrapper.GetVarValue('KNGMenuFavorites2', 'nearTintBlue')));
			inGameConfigWrapper.SetVarValue('KNGMenuTurbo', 'nearTintAlpha', StringToInt(inGameConfigWrapper.GetVarValue('KNGMenuFavorites2', 'nearTintAlpha')));
			inGameConfigWrapper.SetVarValue('KNGMenuTurbo', 'farTintRed', StringToInt(inGameConfigWrapper.GetVarValue('KNGMenuFavorites2', 'farTintRed')));
			inGameConfigWrapper.SetVarValue('KNGMenuTurbo', 'farTintGreen', StringToInt(inGameConfigWrapper.GetVarValue('KNGMenuFavorites2', 'farTintGreen')));
			inGameConfigWrapper.SetVarValue('KNGMenuTurbo', 'farTintBlue', StringToInt(inGameConfigWrapper.GetVarValue('KNGMenuFavorites2', 'farTintBlue')));
			inGameConfigWrapper.SetVarValue('KNGMenuTurbo', 'farTintAlpha', StringToInt(inGameConfigWrapper.GetVarValue('KNGMenuFavorites2', 'farTintAlpha')));
		}
		else if (id == 3)
		{
			inGameConfigWrapper.SetVarValue('KNGMenu', 'EnvironmentDefinition', StringToInt(inGameConfigWrapper.GetVarValue('KNGMenuFavorites3', 'EnvironmentDefinition')));
			inGameConfigWrapper.SetVarValue('KNGMenu', 'envPriority', StringToInt(inGameConfigWrapper.GetVarValue('KNGMenuFavorites3', 'envPriority')));
			inGameConfigWrapper.SetVarValue('KNGMenu', 'envBlend', StringToFloat(inGameConfigWrapper.GetVarValue('KNGMenuFavorites3', 'envBlend')));
			inGameConfigWrapper.SetVarValue('KNGMenu', 'fullscreenblur', StringToFloat(inGameConfigWrapper.GetVarValue('KNGMenuFavorites3', 'fullscreenblur')));
			inGameConfigWrapper.SetVarValue('KNGMenuTurbo', 'TurboMode', inGameConfigWrapper.GetVarValue('KNGMenuFavorites3', 'TurboMode'));
			inGameConfigWrapper.SetVarValue('KNGMenuTurbo', 'fogDensity', StringToFloat(inGameConfigWrapper.GetVarValue('KNGMenuFavorites3', 'fogDensity')));
			
			inGameConfigWrapper.SetVarValue('KNGMenuTurbo', 'EnableColorPicker', inGameConfigWrapper.GetVarValue('KNGMenuFavorites3', 'EnableColorPicker'));
			inGameConfigWrapper.SetVarValue('KNGMenuTurbo', 'Saturation', StringToFloat(inGameConfigWrapper.GetVarValue('KNGMenuFavorites3', 'Saturation')));
			inGameConfigWrapper.SetVarValue('KNGMenuTurbo', 'nearTintRange', StringToFloat(inGameConfigWrapper.GetVarValue('KNGMenuFavorites3', 'nearTintRange')));
			inGameConfigWrapper.SetVarValue('KNGMenuTurbo', 'nearTintRed', StringToInt(inGameConfigWrapper.GetVarValue('KNGMenuFavorites3', 'nearTintRed')));
			inGameConfigWrapper.SetVarValue('KNGMenuTurbo', 'nearTintGreen', StringToInt(inGameConfigWrapper.GetVarValue('KNGMenuFavorites3', 'nearTintGreen')));
			inGameConfigWrapper.SetVarValue('KNGMenuTurbo', 'nearTintBlue', StringToInt(inGameConfigWrapper.GetVarValue('KNGMenuFavorites3', 'nearTintBlue')));
			inGameConfigWrapper.SetVarValue('KNGMenuTurbo', 'nearTintAlpha', StringToInt(inGameConfigWrapper.GetVarValue('KNGMenuFavorites3', 'nearTintAlpha')));
			inGameConfigWrapper.SetVarValue('KNGMenuTurbo', 'farTintRed', StringToInt(inGameConfigWrapper.GetVarValue('KNGMenuFavorites3', 'farTintRed')));
			inGameConfigWrapper.SetVarValue('KNGMenuTurbo', 'farTintGreen', StringToInt(inGameConfigWrapper.GetVarValue('KNGMenuFavorites3', 'farTintGreen')));
			inGameConfigWrapper.SetVarValue('KNGMenuTurbo', 'farTintBlue', StringToInt(inGameConfigWrapper.GetVarValue('KNGMenuFavorites3', 'farTintBlue')));
			inGameConfigWrapper.SetVarValue('KNGMenuTurbo', 'farTintAlpha', StringToInt(inGameConfigWrapper.GetVarValue('KNGMenuFavorites3', 'farTintAlpha')));
		}

		isTurboModeEnabled = inGameConfigWrapper.GetVarValue('KNGMenuTurbo', 'TurboMode');
		
		if (isTurboModeEnabled)
			EnableTurboMode();
		
		ActivateSelectedEnvironmentDefinition();
		
		theGame.GetGuiManager().ShowNotification(GetSelectedEnvironmentName());
	}
	
	
	public function SaveFavorites( id : int)
	{
		if (id == 1)
		{
			inGameConfigWrapper.SetVarValue('KNGMenuFavorites1', 'EnvironmentDefinition', StringToInt(inGameConfigWrapper.GetVarValue('KNGMenu', 'EnvironmentDefinition')));
			inGameConfigWrapper.SetVarValue('KNGMenuFavorites1', 'envPriority', StringToInt(inGameConfigWrapper.GetVarValue('KNGMenu', 'envPriority')));
			inGameConfigWrapper.SetVarValue('KNGMenuFavorites1', 'envBlend', StringToFloat(inGameConfigWrapper.GetVarValue('KNGMenu', 'envBlend')));
			inGameConfigWrapper.SetVarValue('KNGMenuFavorites1', 'fullscreenblur', StringToFloat(inGameConfigWrapper.GetVarValue('KNGMenu', 'fullscreenblur')));
			inGameConfigWrapper.SetVarValue('KNGMenuFavorites1', 'TurboMode', inGameConfigWrapper.GetVarValue('KNGMenuTurbo', 'TurboMode'));
			inGameConfigWrapper.SetVarValue('KNGMenuFavorites1', 'fogDensity', StringToFloat(inGameConfigWrapper.GetVarValue('KNGMenuTurbo', 'fogDensity')));
			
			inGameConfigWrapper.SetVarValue('KNGMenuFavorites1', 'EnableColorPicker', inGameConfigWrapper.GetVarValue('KNGMenuTurbo', 'EnableColorPicker'));
			inGameConfigWrapper.SetVarValue('KNGMenuFavorites1', 'Saturation', StringToFloat(inGameConfigWrapper.GetVarValue('KNGMenuTurbo', 'Saturation')));
			inGameConfigWrapper.SetVarValue('KNGMenuFavorites1', 'nearTintRange', StringToFloat(inGameConfigWrapper.GetVarValue('KNGMenuTurbo', 'nearTintRange')));
			inGameConfigWrapper.SetVarValue('KNGMenuFavorites1', 'nearTintRed', StringToInt(inGameConfigWrapper.GetVarValue('KNGMenuTurbo', 'nearTintRed')));
			inGameConfigWrapper.SetVarValue('KNGMenuFavorites1', 'nearTintGreen', StringToInt(inGameConfigWrapper.GetVarValue('KNGMenuTurbo', 'nearTintGreen')));
			inGameConfigWrapper.SetVarValue('KNGMenuFavorites1', 'nearTintBlue', StringToInt(inGameConfigWrapper.GetVarValue('KNGMenuTurbo', 'nearTintBlue')));
			inGameConfigWrapper.SetVarValue('KNGMenuFavorites1', 'nearTintAlpha', StringToInt(inGameConfigWrapper.GetVarValue('KNGMenuTurbo', 'nearTintAlpha')));
			inGameConfigWrapper.SetVarValue('KNGMenuFavorites1', 'farTintRed', StringToInt(inGameConfigWrapper.GetVarValue('KNGMenuTurbo', 'farTintRed')));
			inGameConfigWrapper.SetVarValue('KNGMenuFavorites1', 'farTintGreen', StringToInt(inGameConfigWrapper.GetVarValue('KNGMenuTurbo', 'farTintGreen')));
			inGameConfigWrapper.SetVarValue('KNGMenuFavorites1', 'farTintBlue', StringToInt(inGameConfigWrapper.GetVarValue('KNGMenuTurbo', 'farTintBlue')));
			inGameConfigWrapper.SetVarValue('KNGMenuFavorites1', 'farTintAlpha', StringToInt(inGameConfigWrapper.GetVarValue('KNGMenuTurbo', 'farTintAlpha')));
		}
		else if (id == 2)
		{
			inGameConfigWrapper.SetVarValue('KNGMenuFavorites2', 'EnvironmentDefinition', StringToInt(inGameConfigWrapper.GetVarValue('KNGMenu', 'EnvironmentDefinition')));
			inGameConfigWrapper.SetVarValue('KNGMenuFavorites2', 'envPriority', StringToInt(inGameConfigWrapper.GetVarValue('KNGMenu', 'envPriority')));
			inGameConfigWrapper.SetVarValue('KNGMenuFavorites2', 'envBlend', StringToFloat(inGameConfigWrapper.GetVarValue('KNGMenu', 'envBlend')));
			inGameConfigWrapper.SetVarValue('KNGMenuFavorites2', 'fullscreenblur', StringToFloat(inGameConfigWrapper.GetVarValue('KNGMenu', 'fullscreenblur')));
			inGameConfigWrapper.SetVarValue('KNGMenuFavorites2', 'TurboMode', inGameConfigWrapper.GetVarValue('KNGMenuTurbo', 'TurboMode'));
			inGameConfigWrapper.SetVarValue('KNGMenuFavorites2', 'fogDensity', StringToFloat(inGameConfigWrapper.GetVarValue('KNGMenuTurbo', 'fogDensity')));
			
			inGameConfigWrapper.SetVarValue('KNGMenuFavorites2', 'EnableColorPicker', inGameConfigWrapper.GetVarValue('KNGMenuTurbo', 'EnableColorPicker'));
			inGameConfigWrapper.SetVarValue('KNGMenuFavorites2', 'Saturation', StringToFloat(inGameConfigWrapper.GetVarValue('KNGMenuTurbo', 'Saturation')));
			inGameConfigWrapper.SetVarValue('KNGMenuFavorites2', 'nearTintRange', StringToFloat(inGameConfigWrapper.GetVarValue('KNGMenuTurbo', 'nearTintRange')));
			inGameConfigWrapper.SetVarValue('KNGMenuFavorites2', 'nearTintRed', StringToInt(inGameConfigWrapper.GetVarValue('KNGMenuTurbo', 'nearTintRed')));
			inGameConfigWrapper.SetVarValue('KNGMenuFavorites2', 'nearTintGreen', StringToInt(inGameConfigWrapper.GetVarValue('KNGMenuTurbo', 'nearTintGreen')));
			inGameConfigWrapper.SetVarValue('KNGMenuFavorites2', 'nearTintBlue', StringToInt(inGameConfigWrapper.GetVarValue('KNGMenuTurbo', 'nearTintBlue')));
			inGameConfigWrapper.SetVarValue('KNGMenuFavorites2', 'nearTintAlpha', StringToInt(inGameConfigWrapper.GetVarValue('KNGMenuTurbo', 'nearTintAlpha')));
			inGameConfigWrapper.SetVarValue('KNGMenuFavorites2', 'farTintRed', StringToInt(inGameConfigWrapper.GetVarValue('KNGMenuTurbo', 'farTintRed')));
			inGameConfigWrapper.SetVarValue('KNGMenuFavorites2', 'farTintGreen', StringToInt(inGameConfigWrapper.GetVarValue('KNGMenuTurbo', 'farTintGreen')));
			inGameConfigWrapper.SetVarValue('KNGMenuFavorites2', 'farTintBlue', StringToInt(inGameConfigWrapper.GetVarValue('KNGMenuTurbo', 'farTintBlue')));
			inGameConfigWrapper.SetVarValue('KNGMenuFavorites2', 'farTintAlpha', StringToInt(inGameConfigWrapper.GetVarValue('KNGMenuTurbo', 'farTintAlpha')));
		}
		else if (id == 3)
		{
			inGameConfigWrapper.SetVarValue('KNGMenuFavorites3', 'EnvironmentDefinition', StringToInt(inGameConfigWrapper.GetVarValue('KNGMenu', 'EnvironmentDefinition')));
			inGameConfigWrapper.SetVarValue('KNGMenuFavorites3', 'envPriority', StringToInt(inGameConfigWrapper.GetVarValue('KNGMenu', 'envPriority')));
			inGameConfigWrapper.SetVarValue('KNGMenuFavorites3', 'envBlend', StringToFloat(inGameConfigWrapper.GetVarValue('KNGMenu', 'envBlend')));
			inGameConfigWrapper.SetVarValue('KNGMenuFavorites3', 'fullscreenblur', StringToFloat(inGameConfigWrapper.GetVarValue('KNGMenu', 'fullscreenblur')));
			inGameConfigWrapper.SetVarValue('KNGMenuFavorites3', 'TurboMode', inGameConfigWrapper.GetVarValue('KNGMenuTurbo', 'TurboMode'));
			inGameConfigWrapper.SetVarValue('KNGMenuFavorites3', 'fogDensity', StringToFloat(inGameConfigWrapper.GetVarValue('KNGMenuTurbo', 'fogDensity')));
			
			inGameConfigWrapper.SetVarValue('KNGMenuFavorites3', 'EnableColorPicker', inGameConfigWrapper.GetVarValue('KNGMenuTurbo', 'EnableColorPicker'));
			inGameConfigWrapper.SetVarValue('KNGMenuFavorites3', 'Saturation', StringToFloat(inGameConfigWrapper.GetVarValue('KNGMenuTurbo', 'Saturation')));
			inGameConfigWrapper.SetVarValue('KNGMenuFavorites3', 'nearTintRange', StringToFloat(inGameConfigWrapper.GetVarValue('KNGMenuTurbo', 'nearTintRange')));
			inGameConfigWrapper.SetVarValue('KNGMenuFavorites3', 'nearTintRed', StringToInt(inGameConfigWrapper.GetVarValue('KNGMenuTurbo', 'nearTintRed')));
			inGameConfigWrapper.SetVarValue('KNGMenuFavorites3', 'nearTintGreen', StringToInt(inGameConfigWrapper.GetVarValue('KNGMenuTurbo', 'nearTintGreen')));
			inGameConfigWrapper.SetVarValue('KNGMenuFavorites3', 'nearTintBlue', StringToInt(inGameConfigWrapper.GetVarValue('KNGMenuTurbo', 'nearTintBlue')));
			inGameConfigWrapper.SetVarValue('KNGMenuFavorites3', 'nearTintAlpha', StringToInt(inGameConfigWrapper.GetVarValue('KNGMenuTurbo', 'nearTintAlpha')));
			inGameConfigWrapper.SetVarValue('KNGMenuFavorites3', 'farTintRed', StringToInt(inGameConfigWrapper.GetVarValue('KNGMenuTurbo', 'farTintRed')));
			inGameConfigWrapper.SetVarValue('KNGMenuFavorites3', 'farTintGreen', StringToInt(inGameConfigWrapper.GetVarValue('KNGMenuTurbo', 'farTintGreen')));
			inGameConfigWrapper.SetVarValue('KNGMenuFavorites3', 'farTintBlue', StringToInt(inGameConfigWrapper.GetVarValue('KNGMenuTurbo', 'farTintBlue')));
			inGameConfigWrapper.SetVarValue('KNGMenuFavorites3', 'farTintAlpha', StringToInt(inGameConfigWrapper.GetVarValue('KNGMenuTurbo', 'farTintAlpha')));
		}
	}
	
	public function GetSelectedEnvironmentName() : String
	{
		var optionName : String;
			
		optionName = inGameConfigWrapper.GetVarOption('KNGMenu', 'EnvironmentDefinition', selectedEnvironmentId);
			
		return optionName;
	}

	public function GetEnvPriorityString() : string
	{
		var envPriority : String;
		envPriority = inGameConfigWrapper.GetVarValue('KNGMenu', 'envPriority');
		
		return envPriority;
	}
	
	public function GetEnvBlendString() : string
	{
		var envBlend : String;
		envBlend = inGameConfigWrapper.GetVarValue('KNGMenu', 'envBlend');
		
		return envBlend;
	}
	
	public function EnableTurboMode()
	{
		var selectedFogDensityValue : Float;
		var selectedNearTintRange 	: Float;
		var selectedSaturationValue : Float;

		var nearTintRed				: Int32;
		var nearTintGreen			: Int32; 	
		var nearTintBlue			: Int32; 
		var nearAlphaIntensity		: Int32; 

		var farTintRed				: Int32; 
		var farTintGreen			: Int32; 
		var farTintBlue				: Int32; 
		var farAlphaIntensity		: Int32; 

		isColorPickerEnabled = inGameConfigWrapper.GetVarValue('KNGMenuTurbo', 'EnableColorPicker');
		
		selectedFogDensityValue = StringToFloat(inGameConfigWrapper.GetVarValue('KNGMenuTurbo', 'fogDensity'));
		
		if(isColorPickerEnabled)
		{
			nearTintRed = StringToInt(inGameConfigWrapper.GetVarValue('KNGMenuTurbo', 'nearTintRed'));
			nearTintGreen = StringToInt(inGameConfigWrapper.GetVarValue('KNGMenuTurbo', 'nearTintGreen'));
			nearTintBlue = StringToInt(inGameConfigWrapper.GetVarValue('KNGMenuTurbo', 'nearTintBlue'));
			nearAlphaIntensity = StringToInt(inGameConfigWrapper.GetVarValue('KNGMenuTurbo', 'nearTintAlpha'));

			farTintRed = StringToInt(inGameConfigWrapper.GetVarValue('KNGMenuTurbo', 'farTintRed'));
			farTintGreen = StringToInt(inGameConfigWrapper.GetVarValue('KNGMenuTurbo', 'farTintGreen'));
			farTintBlue = StringToInt(inGameConfigWrapper.GetVarValue('KNGMenuTurbo', 'farTintBlue'));
			farAlphaIntensity = StringToInt(inGameConfigWrapper.GetVarValue('KNGMenuTurbo', 'farTintAlpha'));

			selectedNearTintRange = StringToFloat(inGameConfigWrapper.GetVarValue('KNGMenuTurbo', 'nearTintRange'));
			selectedSaturationValue = StringToFloat(inGameConfigWrapper.GetVarValue('KNGMenuTurbo', 'Saturation'));

			SetViewRangeCatViewFx(selectedNearTintRange);
			SetTintColorsCatViewFx(Vector(nearTintRed,nearTintGreen,nearTintBlue,nearAlphaIntensity), Vector(farTintRed,farTintGreen,farTintBlue,farAlphaIntensity),selectedSaturationValue);

			SetPositionCatViewFx(Vector(0,0,0,0) , true);
			SetFogDensityCatViewFx(selectedFogDensityValue);
			EnableCatViewFx(1.0f);
		}
		
		else if (!isColorPickerEnabled)
		{
			SetTintColorsCatViewFx(Vector(0,0,0,0), Vector(0,0,0,0),selectedSaturationValue);
			SetPositionCatViewFx(Vector(0,0,0,0) , true);
			SetFogDensityCatViewFx(selectedFogDensityValue);
			EnableCatViewFx(1.0f);
		} 
	}

	public function DisableTurboMode()
	{ 
		DisableCatViewFx(1.0f);	
	}

	public function DisplayWelcomeMessage()
	{
		var title : String;
		
		title = "Ultimate Lighting Mod - Modified by cvax. Original by KNGR.";
		
		GetWitcherPlayer().DisplayHudMessage(title);
		
		theGame.GetGuiManager().ShowNotification(GetSelectedEnvironmentName());
	}

	private var pressTimestamp : float;
	event OnPressButton (action : SInputAction)
	{
		isActive = inGameConfigWrapper.GetVarValue('KNGMenu', 'EnableEnv');
		isTurboModeEnabled = inGameConfigWrapper.GetVarValue('KNGMenuTurbo', 'TurboMode');
		
		if(IsPressed (action) && isTurboModeEnabled)
		{
			EnableTurboMode();				
		}
		else if (IsPressed (action) && !isTurboModeEnabled)
		{
			DisableTurboMode();				
		}
		
		// cvax: Timestamp check needed to differentiate pressing to reload vs holding to disable ULM
		if (isActive && action.aName == 'ReloadULM')
		{
			if (IsPressed (action))
				pressTimestamp = theGame.GetEngineTimeAsSeconds();
			else if (IsReleased(action) && pressTimestamp + 0.5 >= theGame.GetEngineTimeAsSeconds())
			{
				ActivateSelectedEnvironmentDefinition();
				GetWitcherPlayer().DisplayHudMessage("Ultimate Lighting Mod - Reloaded");
				theGame.GetGuiManager().ShowNotification(GetSelectedEnvironmentName());
			}
		}
		
		if(IsPressed (action) && isActive)
		{
			if (action.aName == 'NextULM')
			{
				ActivateNextEnvironmentDefintion();
				theGame.GetGuiManager().ShowNotification(GetSelectedEnvironmentName());
			}

			else if (action.aName == 'PreviousULM')
			{
				ActivatePreviousEnvironmentDefinition();
				theGame.GetGuiManager().ShowNotification(GetSelectedEnvironmentName());
			}
			
			else if (action.aName == 'DisableULM')
			{
				inGameConfigWrapper.SetVarValue('KNGMenu', 'EnableEnv', false);
				GetWitcherPlayer().DisplayHudMessage("Ultimate Lighting Mod - Disabled");
				FullscreenBlurSetup(0.0f);
				DisableTurboMode();
				DeactivateCustomEnvironmentDefinition();
			}
			
			else if (!theInput.IsActionPressed('SaveFavoritesULM') && action.aName == 'EnvPlusULM')
			{
				ActivateAddEnvBlend();
				theGame.GetGuiManager().ShowNotification("envBlend: " + GetEnvBlendString());
			}
			
			else if (!theInput.IsActionPressed('SaveFavoritesULM') && action.aName == 'EnvMinusULM')
			{
				ActivateMinusEnvBlend();
				theGame.GetGuiManager().ShowNotification("envBlend: " + GetEnvBlendString());
			}
			
			else if (theInput.IsActionPressed('SaveFavoritesULM') && action.aName == 'EnvPlusULM')
			{
				ActivateAddEnvPriority();
				theGame.GetGuiManager().ShowNotification("envPriority: " + GetEnvPriorityString());
			}
			
			else if (theInput.IsActionPressed('SaveFavoritesULM') && action.aName == 'EnvMinusULM')
			{
				ActivateMinusEnvPriority();
				theGame.GetGuiManager().ShowNotification("envPriority: " + GetEnvPriorityString());
			}
			
			else if (!theInput.IsActionPressed('SaveFavoritesULM') && action.aName == 'Favorite1ULM')
			{
				ActivateFavorites(1);
				GetWitcherPlayer().DisplayHudMessage("Ultimate Lighting Mod - Favorite #1 loaded");
			}
			
			else if (!theInput.IsActionPressed('SaveFavoritesULM') && action.aName == 'Favorite2ULM')
			{
				ActivateFavorites(2);
				GetWitcherPlayer().DisplayHudMessage("Ultimate Lighting Mod - Favorite #2 loaded");
			}
			
			else if (!theInput.IsActionPressed('SaveFavoritesULM') && action.aName == 'Favorite3ULM')
			{
				ActivateFavorites(3);
				GetWitcherPlayer().DisplayHudMessage("Ultimate Lighting Mod - Favorite #3 loaded");
			}
			
			else if (theInput.IsActionPressed('SaveFavoritesULM') && action.aName == 'Favorite1ULM')
			{
				SaveFavorites(1);
				GetWitcherPlayer().DisplayHudMessage("Ultimate Lighting Mod - Favorite #1 saved");
			}
			
			else if (theInput.IsActionPressed('SaveFavoritesULM') && action.aName == 'Favorite2ULM')
			{
				SaveFavorites(2);
				GetWitcherPlayer().DisplayHudMessage("Ultimate Lighting Mod - Favorite #2 saved");
			}
			
			else if (theInput.IsActionPressed('SaveFavoritesULM') && action.aName == 'Favorite3ULM')
			{
				SaveFavorites(3);
				GetWitcherPlayer().DisplayHudMessage("Ultimate Lighting Mod - Favorite #3 saved");
			}
		}
		else if (IsPressed (action) && !isActive)
		{
			if (action.aName != 'DisableULM')
			{
				FullscreenBlurSetup(0.0f);
				DisableTurboMode();
				DeactivateCustomEnvironmentDefinition();
			}
			
			else
			{
				inGameConfigWrapper.SetVarValue('KNGMenu', 'EnableEnv', true);
				Init();
			}
		}
	}
	 
	protected function DeactivateCustomEnvironmentDefinition()
	{
		DeactivateEnvironment(envID, blendOutTime);
	}
}

class CKNGULMInit extends W3PlayerWitcher
{ 
	event OnSpawned( spawnData : SEntitySpawnData ) {

	}
}

exec function KNGMode( optional enabled : bool )
{
	if( enabled )
	{
		SetTintColorsCatViewFx (Vector(0,0,0,0), Vector(0,0,0,0), 0.0f);
		SetPositionCatViewFx( Vector(0,0,0,0) , true );	
		SetFogDensityCatViewFx(0.0f);
		SetViewRangeCatViewFx(100000.0f);
		EnableCatViewFx( 1.0f );	
		
	}
	else
	{
		DisableCatViewFx( 1.0f );	
	}
}

exec function ULM()
{
	var mKNGChangeEnvironmentDefinitionClass : CKNGULM;
	
	mKNGChangeEnvironmentDefinitionClass = new CKNGULM in theGame;
	
	mKNGChangeEnvironmentDefinitionClass.Init();
}