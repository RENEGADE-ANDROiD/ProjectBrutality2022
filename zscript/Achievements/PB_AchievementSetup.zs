// PB 2022 achievement definitions (VUAS / Vortex Universal Achievement System).

class PB_AchievementSetup : VUAS_AchievementSetup
{
	override void DefineAchievements()
	{
		// --- Combat (auto kill tracking; targetClass uses replacement chain) ---
		VUAS_AchievementHandler.AddAchievement(
			"pb_first_blood", "First Blood",
			"Kill your first enemy.", "combat",
			1, TRACK_KILLS, '', "ACHVMT00");

		VUAS_AchievementHandler.AddAchievement(
			"pb_kill_250", "Exterminator",
			"Kill 250 enemies (cumulative).", "combat",
			250, TRACK_KILLS, '', "ACHVMT01");

		VUAS_AchievementHandler.AddAchievement(
			"pb_kill_500", "Scourge",
			"Kill 500 enemies (cumulative).", "combat",
			500, TRACK_KILLS, '', "ACHVMT02");

		VUAS_AchievementHandler.AddAchievement(
			"pb_kill_1000", "Genocide",
			"Kill 1,000 enemies (cumulative).", "combat",
			1000, TRACK_KILLS, '', "ACHVMT03");

		VUAS_AchievementHandler.AddAchievement(
			"pb_imp_slayer", "Imp Slayer",
			"Kill 100 Imps.", "combat",
			100, TRACK_KILLS, 'DoomImp', "ACHVMT04");

		VUAS_AchievementHandler.AddAchievement(
			"pb_zombie_menace", "Dead Men Walking",
			"Kill 100 Zombiemen.", "combat",
			100, TRACK_KILLS, 'ZombieMan', "ACHVMT05");

		VUAS_AchievementHandler.AddAchievement(
			"pb_shotgun_squad", "Shotgun Response",
			"Kill 75 Shotgun Guys.", "combat",
			75, TRACK_KILLS, 'ShotgunGuy', "ACHVMT06");

		VUAS_AchievementHandler.AddAchievement(
			"pb_chaingunner", "Lead Storm",
			"Kill 75 Chaingunners.", "combat",
			75, TRACK_KILLS, 'ChaingunGuy', "ACHVMT00");

		VUAS_AchievementHandler.AddAchievement(
			"pb_demon_hunter", "Hell's Least Wanted",
			"Kill 50 Demons.", "combat",
			50, TRACK_KILLS, 'Demon', "ACHVMT01");

		VUAS_AchievementHandler.AddAchievement(
			"pb_revenant_rider", "Bone Breaker",
			"Kill 50 Revenants.", "combat",
			50, TRACK_KILLS, 'Revenant', "ACHVMT02");

		VUAS_AchievementHandler.AddAchievement(
			"pb_caco_gourmet", "Eye Candy",
			"Kill 50 Cacodemons.", "combat",
			50, TRACK_KILLS, 'Cacodemon', "ACHVMT03");

		VUAS_AchievementHandler.AddAchievement(
			"pb_fatso_feast", "Calorie Burn",
			"Kill 30 Mancubi.", "combat",
			30, TRACK_KILLS, 'Fatso', "ACHVMT04");

		VUAS_AchievementHandler.AddAchievement(
			"pb_pain_lot", "Soul Harvest",
			"Kill 20 Pain Elementals.", "combat",
			20, TRACK_KILLS, 'PainElemental', "ACHVMT05");

		VUAS_AchievementHandler.AddAchievement(
			"pb_baron_breaker", "Knight of the Abyss",
			"Kill 25 Hell Knights.", "combat",
			25, TRACK_KILLS, 'HellKnight', "ACHVMT06");

		VUAS_AchievementHandler.AddAchievement(
			"pb_baron_bane", "Baron Breaker",
			"Kill 15 Barons of Hell.", "combat",
			15, TRACK_KILLS, 'BaronOfHell', "ACHVMT00");

		VUAS_AchievementHandler.AddAchievement(
			"pb_archvile_hunter", "Pyromaniac's Bane",
			"Kill 10 Archviles.", "combat",
			10, TRACK_KILLS, 'Archvile', "ACHVMT01");

		// --- Bosses ---
		VUAS_AchievementHandler.AddAchievement(
			"pb_cyber_down", "Tower Toppler",
			"Kill a Cyberdemon.", "boss",
			1, TRACK_KILLS, 'Cyberdemon', "ACHVMT02");

		VUAS_AchievementHandler.AddAchievement(
			"pb_cyber_hunter", "Cyber Slayer",
			"Kill 3 Cyberdemons.", "boss",
			3, TRACK_KILLS, 'Cyberdemon', "ACHVMT03");

		VUAS_AchievementHandler.AddAchievement(
			"pb_mastermind_down", "Brain Drain",
			"Kill a Spider Mastermind.", "boss",
			1, TRACK_KILLS, 'SpiderMastermind', "ACHVMT04");

		VUAS_AchievementHandler.AddAchievement(
			"pb_spider_hunter", "Web of Ruin",
			"Kill 3 Spider Masterminds.", "boss",
			3, TRACK_KILLS, 'SpiderMastermind', "ACHVMT05");

		// --- Glory Kills & finishers (PB hooks) ---
		VUAS_AchievementHandler.AddAchievement(
			"pb_first_glory_kill", "Intimate Violence",
			"Perform a Glory Kill.", "glory",
			1, TRACK_CUSTOM_EVENT, '', "ACHVMT06");

		VUAS_AchievementHandler.AddAchievement(
			"pb_blood_punch", "Crimson Fist",
			"Land a Blood Punch finisher.", "glory",
			1, TRACK_CUSTOM_EVENT, '', "ACHVMT00");

		VUAS_AchievementHandler.AddAchievement(
			"pb_glory_10", "Enforcer",
			"Perform 10 Glory Kills.", "glory",
			10, TRACK_CUSTOM_EVENT, '', "ACHVMT01");

		VUAS_AchievementHandler.AddAchievement(
			"pb_glory_25", "Butcher",
			"Perform 25 Glory Kills.", "glory",
			25, TRACK_CUSTOM_EVENT, '', "ACHVMT02");

		VUAS_AchievementHandler.AddAchievement(
			"pb_glory_100", "Executioner",
			"Perform 100 Glory Kills.", "glory",
			100, TRACK_CUSTOM_EVENT, '', "ACHVMT03");

		VUAS_AchievementHandler.AddAchievement(
			"pb_shoulder_flame", "Shoulder Roast",
			"Fire the Glory shoulder flame belch.", "glory",
			1, TRACK_CUSTOM_EVENT, '', "ACHVMT04");

		VUAS_AchievementHandler.AddAchievement(
			"pb_shoulder_ice", "Cold Shoulder",
			"Launch a Glory shoulder ice bomb.", "glory",
			1, TRACK_CUSTOM_EVENT, '', "ACHVMT05");

		VUAS_AchievementHandler.AddAchievement(
			"pb_shield_saw_throw", "Saw You Coming",
			"Throw the Shield Saw.", "glory",
			1, TRACK_CUSTOM_EVENT, '', "ACHVMT06");

		VUAS_AchievementHandler.AddAchievement(
			"pb_execution", "Up Close",
			"Trigger an experimental weapon execution.", "glory",
			1, TRACK_CUSTOM_EVENT, '', "ACHVMT00");

		VUAS_AchievementHandler.AddAchievement(
			"pb_frozen_statue", "Deep Freeze",
			"Shatter an enemy into a frozen-solid statue.", "glory",
			1, TRACK_CUSTOM_EVENT, '', "ACHVMT01");

		// --- Exploration ---
		VUAS_AchievementHandler.AddAchievement(
			"pb_secret_1", "Hidden Path",
			"Find a secret area.", "exploration",
			1, TRACK_SECRETS, '', "ACHVMT02");

		VUAS_AchievementHandler.AddAchievement(
			"pb_secret_10", "Cartographer",
			"Find 10 secret areas (cumulative).", "exploration",
			10, TRACK_SECRETS, '', "ACHVMT03");

		VUAS_AchievementHandler.AddAchievement(
			"pb_secret_25", "Treasure Hunter",
			"Find 25 secret areas (cumulative).", "exploration",
			25, TRACK_SECRETS, '', "ACHVMT04");

		// --- PDA codex (PB hooks) ---
		VUAS_AchievementHandler.AddAchievement(
			"pb_pda_weapon_found", "Arms Dealer",
			"Log a weapon in the PDA codex.", "pda",
			1, TRACK_CUSTOM_EVENT, '', "ACHVMT00");

		VUAS_AchievementHandler.AddAchievement(
			"pb_pda_weapons_10", "Arsenal",
			"Log 10 weapons in the PDA codex.", "pda",
			10, TRACK_CUSTOM_EVENT, '', "ACHVMT01");

		VUAS_AchievementHandler.AddAchievement(
			"pb_pda_weapons_25", "Quartermaster",
			"Log 25 weapons in the PDA codex.", "pda",
			25, TRACK_CUSTOM_EVENT, '', "ACHVMT02");

		VUAS_AchievementHandler.AddAchievement(
			"pb_pda_monster_found", "Field Research",
			"Log a monster in the PDA codex.", "pda",
			1, TRACK_CUSTOM_EVENT, '', "ACHVMT03");

		VUAS_AchievementHandler.AddAchievement(
			"pb_pda_monsters_10", "Xenobiologist",
			"Log 10 monsters in the PDA codex.", "pda",
			10, TRACK_CUSTOM_EVENT, '', "ACHVMT04");

		VUAS_AchievementHandler.AddAchievement(
			"pb_pda_monsters_25", "Demonologist",
			"Log 25 monsters in the PDA codex.", "pda",
			25, TRACK_CUSTOM_EVENT, '', "ACHVMT05");

		VUAS_AchievementHandler.AddAchievement(
			"pb_pda_equipment_found", "Tactician",
			"Log equipment in the PDA codex.", "pda",
			1, TRACK_CUSTOM_EVENT, '', "ACHVMT06");

		// --- Explosive movement (PB hooks) ---
		VUAS_AchievementHandler.AddAchievement(
			"pb_rocket_jump", "Rocket Rider",
			"Gain blast momentum from a rocket-jump explosion.", "movement",
			1, TRACK_CUSTOM_EVENT, '', "ACHVMT05");

		VUAS_AchievementHandler.AddAchievement(
			"pb_plasma_climb", "Plasma Boost",
			"Gain blast momentum from plasma wall-climb splash.", "movement",
			1, TRACK_CUSTOM_EVENT, '', "ACHVMT06");

		// --- Multi-kill (one blast / pierce) ---
		VUAS_AchievementHandler.AddAchievement(
			"pb_multikill_explosive", "Chain Reaction",
			"Kill 2+ enemies with one explosive shot or blast.", "technique",
			1, TRACK_CUSTOM_EVENT, '', "ACHVMT00");

		VUAS_AchievementHandler.AddAchievement(
			"pb_multikill_rail", "Line Them Up",
			"Kill 2+ enemies with one railgun shot.", "technique",
			1, TRACK_CUSTOM_EVENT, '', "ACHVMT01");

		VUAS_AchievementHandler.AddAchievement(
			"pb_multikill_bfg", "BFG Division",
			"Kill 2+ enemies with one BFG shot.", "technique",
			1, TRACK_CUSTOM_EVENT, '', "ACHVMT02");

		VUAS_AchievementHandler.AddAchievement(
			"pb_multikill_sniper", "Double Tap",
			"Kill 2+ enemies with one sniper shot.", "technique",
			1, TRACK_CUSTOM_EVENT, '', "ACHVMT03");

		VUAS_AchievementHandler.AddAchievement(
			"pb_multikill_plasma", "Overload",
			"Kill 2+ enemies with one plasma volley or orb.", "technique",
			1, TRACK_CUSTOM_EVENT, '', "ACHVMT04");

		VUAS_AchievementHandler.AddAchievement(
			"pb_multikill_equipment", "Area Denial",
			"Kill 2+ enemies with one equipment blast.", "technique",
			1, TRACK_CUSTOM_EVENT, '', "ACHVMT05");

		// --- Meta: damage, killstreaks & XP rank ---
		VUAS_AchievementHandler.AddAchievement(
			"pb_damage_dealer", "Heavy Hitter",
			"Deal 25,000 damage (cumulative).", "meta",
			25000, TRACK_DAMAGE_DEALT, '', "ACHVMT04");

		VUAS_AchievementHandler.AddAchievement(
			"pb_tough_skin", "Walking Wound",
			"Take 10,000 damage (cumulative).", "meta",
			10000, TRACK_DAMAGE_TAKEN, '', "ACHVMT05");

		VUAS_AchievementHandler.AddAchievement(
			"pb_killstreak_5", "On a Roll",
			"Earn a kill-streak reward at 5+ kills.", "meta",
			1, TRACK_CUSTOM_EVENT, '', "ACHVMT06");

		VUAS_AchievementHandler.AddAchievement(
			"pb_killstreak_10", "Unstoppable",
			"Earn a kill-streak reward at 10+ kills.", "meta",
			1, TRACK_CUSTOM_EVENT, '', "ACHVMT00");

		VUAS_AchievementHandler.AddAchievement(
			"pb_rank_5", "Operator",
			"Reach PB XP rank 5.", "meta",
			1, TRACK_CUSTOM_EVENT, '', "ACHVMT02");

		VUAS_AchievementHandler.AddAchievement(
			"pb_rank_10", "Veteran",
			"Reach PB XP rank 10.", "meta",
			1, TRACK_CUSTOM_EVENT, '', "ACHVMT03");

		VUAS_AchievementHandler.AddAchievement(
			"pb_rank_15", "Elite",
			"Reach PB XP rank 15.", "meta",
			1, TRACK_CUSTOM_EVENT, '', "ACHVMT04");

		// --- Challenge ---
		VUAS_AchievementHandler.AddAchievement(
			"pb_uv_warrior", "Ultraviolent",
			"Kill 50 enemies on Hurt Me Plenty or harder.", "challenge",
			50, TRACK_KILLS, '', "ACHVMT05",
			false, true, true, 2, 4);

		VUAS_AchievementHandler.AddAchievement(
			"pb_uv_200", "Night Shift",
			"Kill 200 enemies on Ultra-Violence or Nightmare.", "challenge",
			200, TRACK_KILLS, '', "ACHVMT06",
			false, true, true, 3, 4);

		VUAS_AchievementHandler.AddAchievement(
			"pb_nm_reaper", "Nightmare Reaper",
			"Kill 100 enemies on Nightmare.", "challenge",
			100, TRACK_KILLS, '', "ACHVMT00",
			false, true, true, 4, 4);

		// --- Hidden ---
		VUAS_AchievementHandler.AddAchievement(
			"pb_hidden_brutal", "Enhanced",
			"Enable Enhanced Brootality 2022 gore.", "secret",
			1, TRACK_MANUAL, '', "ACHVMT01", true);

		VUAS_AchievementHandler.AddAchievement(
			"pb_hidden_genocide", "???",
			"???", "secret",
			1000, TRACK_KILLS, '', "ACHVMT02", true);
	}

	override void WorldLoaded(WorldEvent e)
	{
		Super.WorldLoaded(e);
		if (!e || e.IsReopen)
			return;
		let cv = CVar.FindCVar("pb_enhanced_brutality_2022");
		if (cv && cv.GetBool())
			VUAS_AchievementHandler.Unlock("pb_hidden_brutal");
	}
}
