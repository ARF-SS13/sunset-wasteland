
GLOBAL_LIST_INIT(special_skill_list, list(
	STAT_STR,
	STAT_PER,
	STAT_END,
	STAT_CHA,
	STAT_INT,
	STAT_AGI,
	STAT_LCK,
	STAT_GEN))

/mob/living/verb/STAT_str()
	set name = "Roll Brawn"
	set desc = "Roll for bicep circumfrence."
	set category = "Roleplaying"
	emote("special_strength")

/mob/living/verb/STAT_per()
	set name = "Roll Awareness"
	set desc = "Roll for eyeball circumfrence."
	set category = "Roleplaying"
	emote("special_perception")

/mob/living/verb/STAT_end()
	set name = "Roll Toughness"
	set desc = "Roll for heart circumfrence."
	set category = "Roleplaying"
	emote("special_endurance")

/mob/living/verb/STAT_cha()
	set name = "Roll Moxie"
	set desc = "Roll for beauty circumfrence."
	set category = "Roleplaying"
	emote("special_charisma")

/mob/living/verb/STAT_int()
	set name = "Roll Smarts"
	set desc = "Roll for brain circumfrence."
	set category = "Roleplaying"
	emote("special_intelligence")

/mob/living/verb/STAT_agi()
	set name = "Roll Deftness"
	set desc = "Roll for wiggly circumfrence."
	set category = "Roleplaying"
	emote("special_agility")

/mob/living/verb/STAT_luc()
	set name = "Roll Fate"
	set desc = "Roll for some sort of circumfrence."
	set category = "Roleplaying"
	emote("special_luck")

/datum/emote/living/special
	key = "special"
	message = null
	cooldown = 2.5 SECONDS // longer than it takes for the emote to run
	stat_allowed = UNCONSCIOUS
	/// Delay between doing the emote and getting the results
	var/special_delay = 2 SECONDS
	/// So keybinds can use these emotes ezpz
	var/special_override

/datum/emote/living/special/s
	key = "special_strength"
	special_override = STAT_STR

/datum/emote/living/special/p
	key = "special_perception"
	special_override = STAT_PER

/datum/emote/living/special/e
	key = "special_endurance"
	special_override = STAT_END

/datum/emote/living/special/c
	key = "special_charisma"
	special_override = STAT_CHA

/datum/emote/living/special/i
	key = "special_intelligence"
	special_override = STAT_INT

/datum/emote/living/special/a
	key = "special_agility"
	special_override = STAT_AGI

/datum/emote/living/special/l
	key = "special_luck"
	special_override = STAT_LCK

/datum/emote/living/special/run_emote(mob/user, params, type_override, intentional = FALSE)
	if(!can_run_emote(user, TRUE, intentional))
		return FALSE
	if(jobban_isbanned(user, "emote"))	// emote ban
		to_chat(user, "You cannot send emotes (banned).")
		return FALSE
	else if(user.client && user.client.prefs.muted & MUTE_IC)	// muted
		to_chat(user, "You cannot send IC messages (muted).")
		return FALSE

	var/special_phrase_input = special_override ? lowertext(special_override) : lowertext(params)
	var/datum/statskill/SK = SSsas.get_stat_by_trigger(special_phrase_input)

	if(!SK)
		to_chat(user, span_alert("That's not a valid stat!"))
		to_chat(user, span_notice("To use this emote, type '*special' followed by a SPECIAL stat. For instance, '*special luck' will do a (luck*10)% roll and say if you passed or not."))
		var/valid_specials = SSsas.get_stat_triggers()
		to_chat(user, span_notice("Some of the valid SPECIAL keywords are:[valid_specials]."))
		return
	
	var/init_message = SK.get_rollmote_initial_msg(user)
	var/datum/roll_return/RT = SSsas.do_roll(user, SK.key, "1d20", 15)
	var/modshow = ""
	if(modshow > 0)
		modshow = "+[RT.mods]"
	if(modshow < 0)
		modshow = "[RT.mods]"
	var/message_first = span_notice("\[[SK.displayname], 1d20+[RT.base][modshow] DC 15] <b>[user]</b> [RT.pre_msg].")	// [Luck, 100%] User tests their Luck.
	var/turf/T = get_turf(user)

	T.visible_message(
		message = message_first,
		blind_message = message_first)
	user.emote_for_ghost_sight(message_first)

	playsound(get_turf(user), 'sound/effects/statroll.ogg', 75, TRUE)

	spawn(special_delay)
		if(!user)
			return
		if(!can_run_emote(user, TRUE,intentional))
			return

		var/message_second = RT.msg
		if(RT.passed)
			message_second = span_green(message_second)
		else
			message_second = span_red(span_green(message_second))

		T.visible_message(
			message = message_second,
			blind_message = message_second)
		user.emote_for_ghost_sight(message_second)


////////////////////////////////////////////////////
////////////////////////////////////////////////////
/datum/emote/living/rollfor
	key = "rollfor"

/datum/emote/living/rollfor/run_emote(mob/user, params, type_override, intentional = FALSE)
	if(!can_run_emote(user, TRUE, intentional))
		return FALSE
	if(jobban_isbanned(user, "emote"))	// emote ban
		to_chat(user, "You cannot send emotes (banned).")
		return FALSE
	else if(user.client && user.client.prefs.muted & MUTE_IC)	// muted
		to_chat(user, "You cannot send IC messages (muted).")
		return FALSE

	if(isnull(user.special_a))
		to_chat(user, span_phobia("You arent special."))
		to_chat(user, span_notice("Mainly because you're playing a mob withough any special skills. This is probably a bug~"))
		return FALSE

	var/paramlist = splittext(params, " ")
	var/skill_name

	var/special_phrase_input = LAZYACCESS(paramlist, 1)
	var/datum/statskill/SK = SSsas.get_stat_by_trigger(special_phrase_input)

	if(!SK)
		to_chat(user, span_alert("That's not a valid stat!"))
		to_chat(user, span_notice("To use this emote, type '*special' followed by a SPECIAL stat. For instance, '*special luck' will do a (luck*10)% roll and say if you passed or not."))
		var/valid_specials = SSsas.get_stat_triggers()
		to_chat(user, span_notice("Some of the valid SPECIAL keywords are:\n[valid_specials]."))
		return

	var/dice = paramlist[2]
	if(isnull(roll(dice)))
		return

	var/init_message = SK.get_rollmote_initial_msg(user)
	var/datum/roll_return/RT = SSsas.do_roll(user, SK.key, dice)
	var/first_phrase = RT.msg_pre
	var/modshow = ""
	if(modshow > 0)
		modshow = "+[RT.mods]"
	if(modshow < 0)
		modshow = "[RT.mods]"
	var/turf/T = get_turf(user)

	var/message_first = span_notice("\[[SK.displayname], [dice]+[RT.base][modshow]\] <b>[user]</b> [first_phrase].") // [Luck, 1d20+5] Player tests their luck.
	T.visible_message(
		message = message_first,
		self_message = message_first,
		blind_message = message_first)
	user.emote_for_ghost_sight(message_first)

	playsound(get_turf(user), 'sound/effects/statroll.ogg', 75, TRUE)

	spawn(2 SECONDS)
		if(!user)
			return
		if(!can_run_emote(user, TRUE,intentional))
			return
	
		var/result_message = span_notice("[user] rolled [RT.resultnum]!")
		T.visible_message(
			message = result_message,
			self_message = result_message,
			blind_message = result_message)
		user.emote_for_ghost_sight(result_message)


//////////////////////////////////////////////////
//////////////////////////////////////////////////
/mob/living/verb/suggest_skillcheck(mob/living/target)
	set category = "Roleplaying"
	set name = "Suggest Skillcheck"
	var/skill = input(usr, "Which skill?", "Skill Suggester 9000", null) as null|anything in SSsas.get_skills()
	if(isnull(skill))
		return
	to_chat(target, span_info("[usr.name] would like you to perform a [skill] check."))

/mob/living/verb/skill_contest(mob/living/target)
	set category = "Roleplaying"
	set name = "Skill Contest"
	// decide skill
	var/skill = input(usr, "Which skill?", "Skill Chooser 9001", null) as null|anything in SSsas.get_skills()
	if(isnull(skill))
		return

	// decide the contest
	var/dice = input(usr, "What kind of dice? (ex: 1d20) \nIf nothing happens, you probably typed this wrong.", null) as null|text
	if(isnull(roll(dice)))
		return
	// get consent
	var/consent = alert(target, "[usr.name] would like to compete in a [dice] [skill] contest.",, "Agree", "Deny")
	if(consent == "Deny")
		to_chat(usr, span_info("[target.name] doesn't seem like they want to participate in a contest."))
		return

	var/datum/statskill/SK = SSsas.get_stat_by_trigger(skill)
	var/datum/return_roll/my_roll = SSsas.do_roll(usr, SK.key, dice)
	var/datum/return_roll/their_roll = SSsas.do_roll(target, SK.key, dice)

	if(my_roll.resultnum > their_roll.resultnum)
		winner = usr
		winner_result = my_roll.resultnum
		loser = target
		loser_result = their_roll.resultnum
	else
		winner = target
		winner_result = their_roll.resultnum
		loser = usr
		loser_result = my_roll.resultnum

	to_chat(winner, span_green("You won the [skill] contest! ([winner_result] vs [loser_result])"))
	to_chat(loser, span_alert("You lost the [skill] contest! ([loser_result] vs [winner_result])"))
