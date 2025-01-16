/* 
 * File: stats_n_skills.dm
 * Author: Bingfox
 *
 */

SUBSYSTEM_DEF(sas)
	name = "SAS"
	priority = FIRE_PRIORITY_MOBS
	flags = SS_KEEP_TIMING | SS_NO_INIT
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME

	// master list of defaults
	var/list/reference_stocks = list()
	var/list/reference_stats = list()
	var/list/reference_skills = list()
	var/list/stat_invokers = list()
	var/max_total_stats = 40
	// everyone's thingy!
	var/list/sheets = list()

/datum/controller/subsystem/sas/Initialize(start_timeofday)
	build_statskills()
	build_stocks()
	. = ..()

/datum/controller/subsystem/sas/proc/build_statskills()
	for(var/skul in subtypesof(/datum/statskill))
		var/datum/statskill/S = new skul()
		if(S.is_skill)
			reference_skills[S.key] = S
		if(S.is_stat)
			reference_stats[S.key] = S

/datum/controller/subsystem/sas/proc/build_stocks()
	for(var/skul in subtypesof(/datum/stats_and_skills_holder))
		var/datum/stats_and_skills_holder/S = new skul()
		reference_stocks[S.key] = S

/datum/controller/subsystem/sas/proc/give_holder_to_player(someone)
	var/p_quid = SSeconomy.extract_quid(someone)
	if(LAZYACCESS(sheets, p_quid))
		return // already have their thing there!
	var/mob/player = extract_mob(someone)
	if(!player || player.sas_key == SAS_DEFAULT)
		return
	var/datum/stats_and_skills/SAS = new()
	sheets["[p_quid]"] = SAS
	SAS.set_player(p_quid)
	SAS.load_stats()
	player.sas_key = "[p_quid]"

/datum/controller/subsystem/sas/proc/get_sas(someone)
	var/mob/such = extract_mob(such)
	if(!such)
		return
	var/datum/stats_and_skills/ses = LAZYACCESS(sheets, such.sas_key)
	if(!ses) // invalid ses, give em a default (might be a player, that'll be fixed soon enuf)
		such.sas_key = "default"
		ses = LAZYACCESS(sheets, such.sas_key)
	return ses

/datum/controller/subsystem/sas/proc/get_stat(someone, which)
	var/datum/stats_and_skills/ses = get_sas(someone)
	return LAZYACCESS(ses.stats, which)

/datum/controller/subsystem/sas/proc/do_roll(performer, stat, threshold, flags)
	var/datum/stats_and_skills/doer_sass = get_sas(performer)
	var/datum/roll_results/doer_roll = doer_sass.do_roll(stat, threshold, flags)
	return doer_roll

/datum/controller/subsystem/sas/proc/get_skills()
	var/list/skullz = list()
	for(var/skill in reference_skills)
		var/datum/statskill/S = reference_skills[skill]
		skullz += S.displayname

/datum/controller/subsystem/sas/proc/get_stat_triggers()
	var/list/skullz = list()
	for(var/ivk in stat_invokers)
		if(!islist(skullz[stat_invokers[ivk]]))
			skullz[stat_invokers[ivk]] = list()
		skullz[stat_invokers[ivk]] |= lowertext(ivk)
	var/list/retmsg = list()
	for(var/kind in skullz)
		retmsg += "<u><b>[kind]</b></u>"
		for(var/bingus in skullz[kind])
			retmsg += "[bingus]"
	return retmsg.Join("\n")

/datum/controller/subsystem/sas/proc/get_num_dice(dicetring)
	var/list/splode = splode_dice(dicetring)
	if(splode["bad"])
		return 1
	return numberfy(LAZYACCESS(splode, "DICE"))

/datum/controller/subsystem/sas/proc/get_crit_success(dicetring)
	var/list/splode = splode_dice(dicetring)
	if(splode["bad"])
		return 20
	return numberfy(LAZYACCESS(splode, "SIDES"))

/datum/controller/subsystem/sas/proc/get_crit_fail(dicetring)
	return 1

/// Expects format: "NUMdNUM+NUM"
/datum/controller/subsystem/sas/proc/splode_dice(dicetring)
	dicetring = lowertext(dicetring)
	var/list/split1 = splittext(dicetring, "d")
	var/numdice = LAZYACCESS(split1, 1)
	if(numdice > 2)
		return list("bad" = TRUE)
	replacetext(LAZYACCESS(split1, 2), "+", "BBB")
	replacetext(LAZYACCESS(split1, 2), "-", "BBB")
	var/list/split2 = splittext(LAZYACCESS(split1, 2), "BBB")
	if(LAZYLEN(split2) > 2)
		return list("bad" = TRUE)
	var/numsides = LAZYACCESS(split2, 1)
	var/mod = LAZYACCESS(split2, 2)
	. = list()
	.["DICE"] = numdice || 0
	.["SIDES"] = numsides || 0
	.["MOD"] = mod || 0

/datum/stats_and_skills
	var/stock_key
	var/owner_quid
	var/virgin = TRUE
	var/list/stats = list(
		STAT_STR = 5,
		STAT_PER = 5,
		STAT_END = 5,
		STAT_CHA = 5,
		STAT_INT = 5,
		STAT_AGI = 5,
		STAT_LCK = 5,
	)
	var/list/skills = list()
	var/max_total  = 40

/datum/stats_and_skills/New()
	. = ..()
	var/list/nustats = list()
	// first go through the stats and get our defaults
	for(var/stat in SSsas.reference_stats)
		var/datum/statskill/S = SSsas.reference_stats[stat]
		var/datum/statskill/ours = new S.type()
		if(stats[stat])
			ours.set_stat(stats[stat])
		nustats[ours.key] = ours
	stats = nustats()
	// now the skills
	var/list/nuskills = list()
	// first go through the stats and get our defaults
	for(var/skill in SSsas.reference_skills)
		var/datum/statskill/S = SSsas.reference_skills[skill]
		var/datum/statskill/ours = new S.type()
		if(skills[skill])
			ours.set_skill(skills[skill])
		nuskills[ours.key] = ours
	skills = nuskills()

/datum/stats_and_skills/proc/load_from_prefs()
	if(!virgin)
		return
	virgin = FALSE
	var/mob/plyr = extract_mob(smth)
	if(!plyr)
		return
	var/datum/preferences/P = extract_prefs(plyr)
	if(!P)
		return
	for(var/stat in stats)
		var/datum/statskill/S = stats[stat]
		S.load_from_prefs(P)
	set_player(plyr)
	if(hax()) // only applies to stats loaded from prefs
		return

/datum/stats_and_skills/proc/hax()
	var/total = 0
	for(var/stat in stats)
		var/datum/statskill/S = stats[stat]
		total += S.current
	if(total > SSsas.max_total_stats)
		var/mob/master = get_owner()
		if(master)
			message_admins(span_alertalien("WEEOO WEEOO [master.name] ([master.ckey]) just spawned in with more than [max_total] stat points!!"))
			master.gib()
			return TRUE

/datum/stats_and_skills/proc/set_player(mob/player)
	owner_quid = SSeconomy.extract_quid(player)

/datum/stats_and_skills/proc/do_roll(which, dice, threshold, flags = SAS_STAT | SAS_MODS)
	if(!stats[which])
		return new /datum/roll_results()
	if(!dice)
		dice = "1d20"
	var/datum/statskill/S = stats[which]
	return S.rollstat(dice, threshold, flags)

/datum/statskill // issue
	var/key
	var/is_skill = FALSE
	var/is_stat = FALSE
	var/displayname = "Stat"
	var/default = 5
	var/maxval = 10 // only obeyed in the prefs menu!
	var/minval = 1
	var/current = 1
	var/list/modifiers = list()
	// hide from the prefs menu
	var/hidden
	/// rollmote stuff
	var/list/rollmote_triggers = list()
	var/list/rollmote_initial = list()
	var/list/rollmote_success = list()
	var/list/rollmote_success_crit = list(
		"Ring-a-ding baby!",
		"Wow!",
	)
	var/list/rollmote_fail = list()
	var/list/rollmote_fail_crit = list(
		"OOF, what a spectacular failure!",
		"The game was rigged from the start.",
	)

/datum/statskill/New()
	. = ..()
	if(!SSsas.reference_stats[key])
		for(var/inv in rollmote_triggers)
			SSsas.stat_invokers[lowertext(inv)] = key
		SSsas.stat_invokers[key] = key // hue
		SSsas.stat_invokers[lowertext(key)] = key // hue
		SSsas.stat_invokers[displayname] = key // hue
		SSsas.stat_invokers[lowertext(displayname)] = key // hue

/datum/statskill/proc/set_stat(neval)
	current = neval

/datum/statskill/proc/rollstat(dice, threshold, flags)
	dice = formattify_dice(dice)
	var/datum/roll_return/RT = new()
	var/mod = get_mofidiers()
	// var/numdice = SSsas.get_num_dice(dice)
	var/critsucc = SSsas.get_crit_success(dice)
	var/critfail = SSsas.get_crit_fail(dice)
	var/porm = mod >= 0 ? "+" : "-"
	var/randroll = roll("[dice][porm][mod]")
	RT.resultnum = randroll
	RT.base = current
	RT.mods = mod
	RT.displayname = displayname
	RT.pre_msg = formattify(safepick(rollmote_initial))
	if(!threshold || randroll >= threshold)
		RT.passed = TRUE
		RT.msg = formattify(safepick(rollmote_success))
	else
		RT.passed = FALSE
		RT.msg = formattify(safepick(rollmote_fail))
	if(randroll >= critsucc)
		RT.crit_success = TRUE
		RT.msg += " [formattify(safepick(rollmote_success_crit))]"
	if(randroll <= critfail)
		RT.crit_fail = TRUE
		RT.msg += " [formattify(safepick(rollmote_success_fail))]"
	return RT

/datum/statskill/proc/formattify_dice(dice)
	dice = replacetext(dice, "$STATMODS", "[current + get_mods()]")
	dice = replacetext(dice, "$STAT", "[current]")
	return dice

/datum/statskill/proc/formattify(phrase)
	var/mob/whom = get_owner()
	phrase = replacetext(phrase, "%MOBNAME", "[whom.name]")
	phrase = replacetext(phrase, "%MOBTHEIR", "[whom.p_their()]")
	phrase = replacetext(phrase, "%MOBTHEY", "[whom.p_they()]")
	return phrase

/datum/statskill/proc/get_mods()
	. = 0
	for(var/mod in modifiers)
		. += modifiers[mod]

/datum/statskill/strength
	key = STAT_STR
	displayname = "Strength"
	is_stat = TRUE
	rollmote_triggers = list(
		"b",
		"brn",
		"brawn",
	)
	rollmote_initial = list(
		"%MOBNAME tests %MOBTHEIR brawn...",
		"%MOBNAME flexes %MOBTHEIR arm(s)...",
		"%MOBNAME prepares to lift...",
		"%MOBNAME puts %MOBTHEIR back into it..."
	)
	rollmote_success = list(
		"%MOBNAME is strong!",
		"%MOBNAME is beefy!",
		"%MOBNAME has some serious guns!",
		"%MOBNAME had some strength behind it!"
	)
	rollmote_fail = list(
		"%MOBNAME was too weak.",
		"%MOBNAME was a little wet noodle.",
		"%MOBNAME would loose an arm wrestling match with a mouse.",
		"%MOBNAME has some serious atrophy. it's a wonder %MOBTHEY can move at all."
	)

/datum/statskill/perception
	key = STAT_PER
	displayname = "Perception"
	is_stat = TRUE
	rollmote_triggers = list(
		"a",
		"aware",
		"awareness",
	)
	rollmote_initial = list(
		"%MOBNAME takes a good, long look...",
		"%MOBNAME squints...",
		"%MOBNAME looks around...",
		"%MOBNAME focuses in..."
	)
	rollmote_success = list(
		"%MOBNAME was perceptive!",
		"%MOBNAME noticed things!",
		"%MOBNAME has eyes like a hawk!",
		"%MOBNAME could find Doc Mitchell's keys!",
		"%MOBNAME noticed whatever %MOBTHEY were trying to see!"
	)
	rollmote_fail = list(
		"%MOBNAME was totally oblivious.",
		"%MOBNAME forgot %MOBTHEIR glasses.",
		"%MOBNAME didn't see anything."
	)

/datum/statskill/endurance
	key = STAT_END
	displayname = "Endurance"
	is_stat = TRUE
	rollmote_triggers = list(
		"tough",
		"tuff",
		"end",
		"toughness",
	)
	rollmote_initial = list(
		"%MOBNAME tests %MOBTHEIR toughness...",
		"%MOBNAME braces %MOBTHEMSELF..."
	)
	rollmote_success = list(
		"%MOBNAME was tough!",
		"%MOBNAME was one tough cookie!",
		"%MOBNAME doesn't even flinch!",
		"%MOBNAME is solid as an oak!",
		"%MOBNAME endured!"
	)
	rollmote_fail = list(
		"%MOBNAME is a floppy lil' noodle.",
		"%MOBNAME is made of paper.",
		"%MOBNAME would be torn to shreds by a light breeze.",
		"%MOBNAME crumpled up and blew away."
	)

/datum/statskill/charisma
	key = STAT_CHA
	displayname = "Charisma"
	is_stat = TRUE
	rollmote_triggers = list(
		"mox",
		"moxie",
		"cha",
	)
	rollmote_initial = list(
		"%MOBNAME starts to be charismatic...",
		"%MOBNAME puts on the charm..."
	)
	rollmote_success = list(
		"%MOBNAME was charismatic!",
		"%MOBNAME is an absolute charmer!",
		"%MOBNAME was good and charming!"
	)
	rollmote_fail = list(
		"%MOBNAME was totally uncharismatic.",
		"%MOBNAME isn't fooling anyone.",
		"%MOBNAME put %MOBTHEIR foot in %MOBTHEIR mouth.",
		"%MOBNAME could hear a pin drop.",
		"%MOBNAME's spaghetti is showing.",
		"%MOBNAME had %MOBTHEIR charms fall flat."
	)

/datum/statskill/intelligence
	key = STAT_INT
	displayname = "Intelligence"
	is_stat = TRUE
	rollmote_triggers = list(
		"int",
		"i",
		"intelligence",
		"inteligence",
		"intelligance",
		"inteligance",
		"intel",
		"intell",
		"intelect",
		"intellect",
		"smart",
		"smartness",
		"nerd",
		"nerdiness",
		"dork",
		"dorkiness",
		"dweeb",
		"dweebishness",
		"smarts",
	)
	rollmote_initial = list(
		"%MOBNAME thinks hard...",
		"%MOBNAME ponders hard...",
		"%MOBNAME takes a moment to think...",
		"%MOBNAME furrows %MOBTHEIR brow..."
	)
	rollmote_success = list(
		"%MOBNAME was clever!",
		"%MOBNAME is a genius!",
		"%MOBNAME has a mind sharp as a whip!",
		"%MOBNAME had a thought!"
	)
	rollmote_fail = list(
		"%MOBNAME was dumb as a doornail.",
		"%MOBNAME burned %MOBTHEIR last braincell years ago.",
		"%MOBNAME is running low on braincells.",
		"%MOBNAME is denser than a collapsed idiot."
	)

/datum/statskill/agility
	key = STAT_AGI
	displayname = "Agility"
	is_stat = TRUE
	rollmote_triggers = list(
		"agi",
		"a",
		"agility",
		"agillity",
		"quick",
		"quickness",
		"fast",
		"fastness",
		"dex",
		"speed",
		"speediness",
		"initiative",
		"athleticism",
		"acrobatics",
		"escape",
		"dodge",
		"evade",
		"evasion",
		"cat",
		"deft",
		"deftness",
	)
	rollmote_initial = list(
		"%MOBNAME tries to get agile...",
		"%MOBNAME prepares %MOBTHEIR moves...",
		"%MOBNAME starts to get limber..."
	)
	rollmote_success = list(
		"%MOBNAME was very flexible!",
		"%MOBNAME had some excellent footwork!",
		"%MOBNAME was in perfect control!",
		"%MOBNAME was agile as a cat!",
		"%MOBNAME was agile as a fox!"
	)
	rollmote_fail = list(
		"%MOBNAME fell flat on %MOBTHEIR face.",
		"%MOBNAME fell flat on %MOBTHEIR back.",
		"%MOBNAME triped over themself.",
		"%MOBNAME has two left feet.",
		"%MOBNAME was clumsy as a cat.",
		"%MOBNAME was clumsy as a fox."
	)

/datum/statskill/luck
	key = STAT_LCK
	displayname = "Luck"
	is_stat = TRUE
	rollmote_triggers = list(
		"l",
		"lck",
		"luck",
		"lick",
		"lock",
		"lunk",
		"link",
		"chance",
		"fortune",
		"dice",
		"luk",
		"luc",
		"fat",
		"fate",
	)
	rollmote_initial = list(
		"%MOBNAME tries %MOBTHEIR luck...",
		"%MOBNAME takes a chance...",
		"%MOBNAME puts it all on red..."
	)
	rollmote_success = list(
		"%MOBNAME lucked out!",
		"%MOBNAME was the luckiest son-of-a-gun in the wasteland!",
		"%MOBNAME could make a bullet turn right around and climb back into the gun!",
		"%MOBNAME got lucky!"
	)
	rollmote_fail = list(
		"%MOBNAME was unlucky.",
		"%MOBNAME realized %MOBTHEIR game was rigged from the start.",
		"%MOBNAME showed that the house always wins."
	)

/datum/statskill/basic
	key = STAT_GEN
	displayname = "Coinflip"
	is_stat = TRUE
	hidden = TRUE
	rollmote_triggers = list(
		"x",
		"non",
		"none",
		"generic",
		"something",
		"else",
		"smth",
		"?",
		"rand",
		"huh",
		"stuff",
		"roll",
	)
	rollmote_initial = list(
		"%MOBNAME tests %MOBTHEIR skills...",
		"%MOBNAME tries %MOBTHEIR skills...",
		"%MOBNAME attempts to do a thing...",
		"%MOBNAME puts %MOBTHEIR skills to the test..."
	)
	rollmote_success = list(
		"%MOBNAME succeeded!",
		"%MOBNAME did it!"
	)
	rollmote_fail = list(
		"%MOBNAME was really bad at whatever they did.",
		"%MOBNAME just really sucked.",
		"%MOBNAME messed up real bad."
	)

/datum/roll_return
	var/base = 0
	var/crit_fail = FALSE
	var/crit_success = FALSE
	var/passed = FALSE
	var/displayname = "Result"
	var/mods = 0
	var/msg = "Something cool happened!"
	var/resultnum = 0

/////////////////////////////////////////////
/////////////////////////////////////////////
/// our system of skills, attributes, and stats!
/mob/var/sas_key
