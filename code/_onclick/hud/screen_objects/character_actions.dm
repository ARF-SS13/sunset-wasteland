//-->Addition of some character actions that go on the same spot

/atom/movable/screen/autowhisper
	name = "autowhisper"
	icon_state = "autowhisper0"
	screen_loc = ui_character_actions

/atom/movable/screen/autowhisper/Click(location,control,params)
	var/mob/M = usr
	M.is_autowhisper = M.is_autowhisper ? FALSE : TRUE
	if(M.is_autowhisper)
		to_chat(M, span_notice("You'll now whisper everything you say."))
		icon_state = "autowhisper1"
	else
		to_chat(M, span_notice("You'll no longer whisper everything you say."))
		icon_state = "autowhisper0"

/atom/movable/screen/pose
	name = "pose"
	icon_state = "pose"
	screen_loc = ui_character_actions

/atom/movable/screen/pose/Click(location,control,params)
	var/mob/M = usr
	M.manage_flavor_tests()

/atom/movable/screen/up
	name = "up"
	icon_state = "up"
	screen_loc = ui_character_actions

/atom/movable/screen/up/Click(location,control,params)
	var/mob/living/carbon/human/H = usr
	if(!ishuman(usr))
		to_chat(usr, span_alert("Sorry! You've gotta be a fully spawned in character with hopes and dreams to use this!"))
		return
	H.layershift_up()

/atom/movable/screen/down
	name = "down"
	icon_state = "down"
	screen_loc = ui_character_actions

/atom/movable/screen/down/Click(location,control,params)
	var/mob/living/carbon/human/H = usr
	if(!ishuman(usr))
		to_chat(usr, span_alert("Sorry! You've gotta be a fully spawned in character with hopes and dreams to use this!"))
		return
	H.layershift_down()

/atom/movable/screen/sleep_hud_button
	name = "sleep toggle"
	icon_state = "sleep"
	screen_loc = ui_character_actions

/atom/movable/screen/sleep_hud_button/Click(location,control,params)
	if(isliving(usr))
		var/mob/living/L = usr
		L.toggle_mob_sleep()

/atom/movable/screen/triage
	name = "triage button"
	icon_state = "triage"
	screen_loc = ui_character_actions

/atom/movable/screen/triage/Click(location,control,params)
	if(ishuman(usr))
		var/mob/living/carbon/human/H = usr
		if(isnull(H.get_active_held_item()))
			if(HAS_TRAIT(H, TRAIT_HEAL_TONGUE))
				H.emote("lick")
			else if(HAS_TRAIT(H, TRAIT_HEAL_TOUCH))
				H.emote("touch")
			else if(HAS_TRAIT(H, TRAIT_HEAL_TEND))
				H.emote("tend")

/atom/movable/screen/triage/DblClick(location,control,params)
	if(ishuman(usr))
		var/mob/living/carbon/human/H = usr
		var/obj/item/I = H.get_active_held_item()
		if(isnull(I))
			if(HAS_TRAIT(H, TRAIT_HEAL_TONGUE))
				H.emote("lick")
			else if(HAS_TRAIT(H, TRAIT_HEAL_TOUCH))
				H.emote("touch")
			else if(HAS_TRAIT(H, TRAIT_HEAL_TEND))
				H.emote("tend")

			I = H.get_active_held_item()
			I?.melee_attack_chain(H, H, params)

		else if(istype(I, /obj/item/hand_item/tactile/))
			I = H.get_active_held_item()
			I?.melee_attack_chain(H, H, params)

/atom/movable/screen/aooc_hud_button
	name = "AOOC"
	icon_state = "aooc"
	screen_loc = ui_character_actions

/atom/movable/screen/aooc_hud_button/Click(location,control,params)
	if(usr.client)
		var/msg = input(usr, "AOOC Message", "AOOC", null)
		usr.client.aooc(msg)

/atom/movable/screen/newbie_hud_button
	name = "Help/Newbie"
	icon_state = "newbie"
	screen_loc = ui_character_actions

/atom/movable/screen/newbie_hud_button/Click(location,control,params)
	if(usr.client)
		var/msg = input(usr, "Help/Newbie Message", "Help/Newbie", null)
		usr.client.newbie(msg)

/atom/movable/screen/chardir_hud_button
	name = "Character Directory"
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "chardir"
	screen_loc = ui_bayou

/atom/movable/screen/chardir_hud_button/Click(location,control,params)
	if(usr.client)
		usr.client.show_character_directory()

/atom/movable/screen/who
	name = "Who"
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "who" // milhouse who
	screen_loc = "EAST-3:-4, SOUTH+1:-13"

/atom/movable/screen/who/Click(location,control,params)
	SSwho.Who(usr.client)

/atom/movable/screen/flirt_hud_button
	name = "Flirt with people!"
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "flirt"
	screen_loc = ui_flirt

/atom/movable/screen/flirt_hud_button/Click(location,control,params)
	var/mob/living/carbon/human/H = usr
	if(!ishuman(usr))
		to_chat(usr, span_alert("Sorry! You've gotta be a fully spawned in character with hopes and dreams to use this!"))
		return
	H.emote("flirt")

/atom/movable/screen/erp_button
	name = "ERP with someone!"
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "erp"
	screen_loc = "EAST-1:4, SOUTH+2:11"

/atom/movable/screen/erp_button/Click(location,control,params)
	var/mob/living/carbon/human/H = usr
	if(!ishuman(usr))
		to_chat(usr, span_alert("Sorry! You've gotta be a fully spawned in character with hopes and dreams to use this!"))
		return
	H.emote("erp")

/atom/movable/screen/merp_button
	name = "Open mechanical ERP window!"
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "merp"
	screen_loc = ui_merp

/atom/movable/screen/merp_button/Click(location,control,params)
	var/mob/living/carbon/human/H = usr
	if(!ishuman(H))
		to_chat(H, span_alert("Sorry! You've gotta be a fully spawned in character with hopes and dreams to use this!"))
		return
	var/obj/item/hand_item/merp_doer/brick = new(H)

	if(H.put_in_hands(brick))
		to_chat(H, span_notice("Now click someone with this thing (or yourself)! Range is infinite, so you can totally interact with people across the bar!"))
	else
		qdel(brick)

/// special cool button that turns into more buttons!
/atom/movable/screen/foldout
	name = "Cool Foldabutton"
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "vore"
	var/icon/closed_icon = 'icons/mob/screen_gen.dmi'
	var/closed_state = "vore"
	var/closed_loc = "EAST-1:-11, SOUTH+2:12"
	var/icon/open_icon = 'icons/mob/screen_gen.dmi'
	var/open_state = "vore"
	var/open_loc = "EAST-1:-22, SOUTH+2:12"
	var/list/foldies = list()
	var/open = FALSE

/atom/movable/screen/foldout/Initialize(mapload)
	. = ..()
	InitButtons()

/atom/movable/screen/foldout/Click(location,control,params)
	if(!usr.client || !ismob(usr))
		return
	if(open)
		FoldUp(usr)
	else
		UnFold(usr)

/atom/movable/screen/foldout/proc/UnFold(mob/user)
	if(open)
		return
	open = TRUE
	for(var/atom/movable/screen/sub_button/S in foldies)
		S.Show()
	icon = open_icon
	icon_state = open_state
	screen_loc = open_loc

/atom/movable/screen/foldout/proc/FoldUp(mob/user)
	if(!open)
		return
	open = FALSE
	for(var/atom/movable/screen/sub_button/S in foldies)
		S.Hide()
	icon = closed_icon
	icon_state = closed_state
	screen_loc = closed_loc

/atom/movable/screen/foldout/proc/InitButtons(mob/user)
	var/list/inittedbuttons = list()
	for(var/i in 1 to LAZYLEN(foldies))
		var/atom/movable/screen/sub_button/S = foldies[i]
		S = new S()
		S.parent = src
		S.hud = hud
		S.Hide()
		inittedbuttons += S
	foldies = inittedbuttons

////////////////////////////////////////////////////////////
/atom/movable/screen/sub_button // aka, my cl-
	name = "sub_button"
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "sub_button"
	// screen_loc = ui_vore_b1
	var/atom/movable/screen/foldout/parent

/atom/movable/screen/sub_button/Click(location,control,params)
	parent.FoldUp(usr)

/atom/movable/screen/sub_button/proc/Hide()
	alpha = 0
	mouse_opacity = 0
	var/client/C = extract_client(usr)
	if(C)
		C.screen -= src

/atom/movable/screen/sub_button/proc/Show()
	alpha = 255
	mouse_opacity = 1
	var/client/C = extract_client(usr)
	if(C)
		C.screen |= src

////////////////////////////////////////////////////////////
/*
/atom/movable/screen/foldout/vore_button
	name = "Vore Menu Menu"
	desc = "It's the menu for the vore menu!"
	icon = 'icons/mob/screen_gen_vore.dmi'
	icon_state = "vore_off"
	screen_loc = "EAST-1:-11, SOUTH+2:23"
	closed_icon = 'icons/mob/screen_gen_vore.dmi'
	closed_state = "vore_off"
	closed_loc = "EAST-1:-11, SOUTH+2:23"
	open_icon = 'icons/mob/screen_gen_vore.dmi'
	open_state = "vore_on" // no YOURE the voreon
	open_loc = "EAST-1:-22, SOUTH+2:23"
	foldies = list(
		/atom/movable/screen/sub_button/vore_menu,
		/atom/movable/screen/sub_button/vorer_thing,
		/atom/movable/screen/sub_button/eater_thing,
		/atom/movable/screen/sub_button/enabler,
	)
*/
////////////////////////////////////////////////////////////
//stat roller

// Despite being defined, this doesn't render on screen in any capacity, didnt extensively test
/atom/movable/screen/roll_hud_button
	name = "Stat Roller Radial Menu"
	icon_state = "skillcheck"
	screen_loc = "RIGHT-2:-4,South+2:0"

/atom/movable/screen/roll_hud_button/Click(location,control,params,)
// This stuff needs to be changed because it was directly lifted from clothing
	var/static/list/choices = list(
			"Brawn" = image(icon = 'icons/mob/screen_gen.dmi', icon_state = "brawn"),
			"Awareness" = image(icon = 'icons/mob/screen_gen.dmi', icon_state = "awareness"),
			"Toughness" = image(icon = 'icons/mob/screen_gen.dmi', icon_state = "toughness"),
			"Moxie" = image(icon = 'icons/mob/screen_gen.dmi', icon_state = "moxie"),
			"Smarts" = image(icon = 'icons/mob/screen_gen.dmi', icon_state = "smarts"),
			"Deftness" = image(icon = 'icons/mob/screen_gen.dmi', icon_state = "deftness"),
			"Fate" = image(icon = 'icons/mob/screen_gen.dmi', icon_state = "fate"),
		)
	var/mob/user = usr
	var/choice = show_radial_menu(user, src, choices, radius = 32,)
	switch(choice)
		if("Brawn")
			user.emote("special_strength")
		if("Awareness")
			user.emote("special_perception")
		if("Toughness")
			user.emote("special_endurance")
		if("Moxie")
			user.emote("special_charisma")
		if("Smarts")
			user.emote("special_intelligence")
		if("Deftness")
			user.emote("special_agility")
		if("Fate")
			user.emote("special_luck")
		else
			return
/*
////////////////////////////////////////////////////////////
/atom/movable/screen/sub_button/vore_menu
	name = "Open the Vore Options!"
	icon = 'icons/mob/screen_gen_vore.dmi'
	icon_state = "vore_options"
	screen_loc = "EAST-1:-22, SOUTH+2:23"

/atom/movable/screen/sub_button/vore_menu/Click(location,control,params)
	. = ..()
	var/mob/living/L = usr
	if(!ishuman(L))
		to_chat(L, span_alert("Sorry! You've gotta be a fully spawned in character with hopes and dreams to use this!"))
		return
	L?.insidePanel()
	to_chat(L, span_notice("You opened the vore options! Hopefully!"))

////////////////////////////////////////////////////////////
/atom/movable/screen/sub_button/vorer_thing
	name = "Vore someone!"
	desc = "This will either give you an item to vore someone with, or vore whoever youre grabbing!"
	icon = 'icons/mob/screen_gen_vore.dmi'
	icon_state = "vore_eat"
	screen_loc = "EAST-1:-22, SOUTH+2:23"

/atom/movable/screen/sub_button/vorer_thing/Click(location,control,params)
	. = ..()
	var/mob/living/L = usr
	if(!ishuman(L))
		to_chat(L, span_alert("Sorry! You've gotta be a fully spawned in character with hopes and dreams to use this!"))
		return
	L.emote("vore")

////////////////////////////////////////////////////////////

/atom/movable/screen/sub_button/eater_thing
	name = "Feed someone to someone!"
	desc = "This will either give you an item to feed someone to someone with, or feed whoever youre grabbing to whoever youre grabbing!"
	icon = 'icons/mob/screen_gen_vore.dmi'
	icon_state = "vore_feed"
	screen_loc = "EAST-1:-22, SOUTH+2:23"

/atom/movable/screen/sub_button/eater_thing/Click(location,control,params)
	. = ..()
	var/mob/living/L = usr
	if(!ishuman(L))
		to_chat(L, span_alert("Sorry! You've gotta be a fully spawned in character with hopes and dreams to use this!"))
		return
	L.emote("feed")

/atom/movable/screen/sub_button/enabler
	name = "Enable Vore!"
	desc = "Looks like your vore is off, click here to enable it!"
	icon = 'icons/mob/screen_gen_vore.dmi'
	icon_state = "vore_enable"
	screen_loc = "EAST-1:-22, SOUTH+2:23"

/atom/movable/screen/sub_button/enabler/Show()
	if(CHECK_PREFS(usr, VOREPREF_MASTER))
		return // already enabled
	. = ..() // WINDOWS G, ENABLE

/atom/movable/screen/sub_button/enabler/Click(location,control,params)
	. = ..()
	var/mob/living/L = usr
	if(!ishuman(L))
		to_chat(L, span_alert("Sorry! You've gotta be a fully spawned in character with hopes and dreams to use this!"))
		return
	var/datum/preferences/P = extract_prefs(L)
	P.allow_eating_sounds = TRUE
	P.allow_digestion_sounds = TRUE
	P.allow_digestion_damage = TRUE
	P.allow_digestion_death = TRUE
	P.allow_vore_messages = TRUE
	P.allow_death_messages = TRUE
	P.allow_being_prey = TRUE
	P.allow_being_fed_to_others = TRUE
	P.allow_being_fed_prey = TRUE
	P.allow_seeing_belly_descriptions = TRUE
	P.allow_being_sniffed = TRUE
	P.master_vore_toggle = TRUE
	P.save_character()
	to_chat(L, span_notice("Vore Core online! Be sure to set up your vore preferences!"))
*/
/atom/movable/screen/erp_tools_button
	name = "ERP Tools"
	icon_state = "erp_tools"
	screen_loc = "RIGHT-1:-7,South+2:0"

/atom/movable/screen/erp_tools_button/Click(location,control,params)
	var/mob/living/carbon/human/H = usr
	if(!ishuman(usr))
		to_chat(usr, span_alert("Sorry! You've gotta be a fully spawned in character with hopes and dreams to use this!"))
		return
	var/static/list/choices = list(
			"Smooch people, intent, direction and location varianced"   = image(icon = 'icons/mob/screen_gen.dmi', icon_state = "kiss"         ),
			"Feel people up, intent, direction and location varianced"  = image(icon = 'icons/mob/screen_gen.dmi', icon_state = "touch"        ),
			"Lick people, intent, direction, and location varianced"    = image(icon = 'icons/mob/screen_gen.dmi', icon_state = "lick"         ),
			"Flirt Menu"                                                = image(icon = 'icons/mob/screen_gen.dmi', icon_state = "flirt"        ),
			"Subtlest - Long & Short Range"                             = image(icon = 'icons/mob/screen_gen.dmi', icon_state = "erp"          ),
			"Vore Menu"                                                 = image(icon = 'icons/mob/screen_gen.dmi', icon_state = "vore"         ),
			"Mechanical Erotic Roleplay"                                = image(icon = 'icons/mob/screen_gen.dmi', icon_state = "merp"         ),
			"Private Panel"                                             = image(icon = 'icons/mob/screen_gen.dmi', icon_state = "privatepanel" ),
		)
	var/mob/user = usr
	var/choice = show_radial_menu(user, src, choices, radius = 28, ultradense = TRUE, linedir = NORTH)
	if(!ishuman(usr))//Check after they select something just in case they've somehow switched to a non-human in the mean time
		return
	switch(choice)
		if("Smooch people, intent, direction and location varianced")
			H.emote("kisshorny")
		if("Feel people up, intent, direction and location varianced")
			H.emote("touchhorny")
		if("Lick people, intent, direction, and location varianced")
			H.emote("lickhorny")
		if("Flirt Menu")
			H.emote("flirt")
		if("Subtlest - Long & Short Range")
			H.emote("erp")
		if("Mechanical Erotic Roleplay")
			var/obj/item/hand_item/merp_doer/brick = new(H)
			if(H.put_in_hands(brick))
				to_chat(H, span_notice("Now click someone with this thing (or yourself)! Range is infinite, so you can totally interact with people across the bar!"))
			else
				qdel(brick)
		if("Private Panel")
			H.toggle_genitals()
		if("Vore Menu")
			var/static/list/vchoices = list(
					"Vore"    = image(icon = 'icons/mob/screen_gen_vore.dmi', icon_state = "vore_eat"     ),
					"Feed"    = image(icon = 'icons/mob/screen_gen_vore.dmi', icon_state = "vore_feed"    ),
					"Enable"  = image(icon = 'icons/mob/screen_gen_vore.dmi', icon_state = "vore_enable"  ),
					"Options" = image(icon = 'icons/mob/screen_gen_vore.dmi', icon_state = "vore_options" ),
			)
			var/vchoice = show_radial_menu(user, src, vchoices, radius = 28, ultradense = TRUE, linedir = NORTH)
			if(!ishuman(usr))//Check after they select something just in case they've somehow switched to a non-human in the mean time
				return
			switch(vchoice)
				if("Vore")
					H.emote("vore")
				if("Feed")
					H.emote("feed")
				if("Enable")
					var/datum/preferences/P = extract_prefs(H)
					P.allow_eating_sounds = TRUE
					P.allow_digestion_sounds = TRUE
					P.allow_digestion_damage = TRUE
					P.allow_digestion_death = TRUE
					P.allow_vore_messages = TRUE
					P.allow_death_messages = TRUE
					P.allow_being_prey = TRUE
					P.allow_being_fed_to_others = TRUE
					P.allow_being_fed_prey = TRUE
					P.allow_seeing_belly_descriptions = TRUE
					P.allow_being_sniffed = TRUE
					P.master_vore_toggle = TRUE
					P.save_character()
					to_chat(H, span_notice("Vore Core online! Be sure to set up your vore preferences!"))
				if("Options")
					H?.insidePanel()
					to_chat(H, span_notice("You opened the vore options! Hopefully!"))


/atom/movable/screen/hand_items_button
	name = "Personal Tools"
	icon_state = "handitems"
	screen_loc = "RIGHT-0:-4,South+2:0"

/atom/movable/screen/hand_items_button/Click(location,control,params)
	var/mob/living/carbon/human/H = usr
	if(!ishuman(usr))
		to_chat(usr, span_alert("Sorry! You've gotta be a fully spawned in character with hopes and dreams to use this!"))
		return
	var/static/list/choices = list(
			"Tail"        = image(icon = 'icons/mob/screen_gen.dmi', icon_state = "tail"    ),
			"Butt"        = image(icon = 'icons/mob/screen_gen.dmi', icon_state = "butt"    ),
			"Claw"        = image(icon = 'icons/mob/screen_gen.dmi', icon_state = "claw"    ),
			"Bite"        = image(icon = 'icons/mob/screen_gen.dmi', icon_state = "bite"    ),
			"Beans"       = image(icon = 'icons/mob/screen_gen.dmi', icon_state = "beans"   ),
			"Tend"        = image(icon = 'icons/mob/screen_gen.dmi', icon_state = "tend"    ),
			"Cuphand"     = image(icon = 'icons/mob/screen_gen.dmi', icon_state = "cuphand" ),
		)
	var/mob/user = usr
	var/choice = show_radial_menu(user, src, choices, radius = 28, ultradense = TRUE, linedir = NORTH)
	if(!ishuman(usr))//Check after they select something just in case they've somehow switched to a non-human in the mean time
		return
	switch(choice)
		if("Tail")
			H.emote("tailer")
		if("Butt")
			H.emote("butt")
		if("Claw")
			H.emote("claw")
		if("Bite")
			H.emote("bite")
		if("Beans")
			H.emote("beans")
		if("Tend")
			H.emote("tend")
		if("Cuphand")
			H.emote("cuphand")

////////////////////////////////////////////////////////////
/*
/atom/movable/screen/touch_hud_button
	name = "Touch on people!"
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "touch"
	screen_loc = ui_touch

/atom/movable/screen/touch_hud_button/Click(location,control,params)
	var/mob/living/carbon/human/H = usr
	if(!ishuman(usr))
		to_chat(usr, span_alert("Sorry! You've gotta be a fully spawned in character with hopes and dreams to use this!"))
		return
	H.emote("touchhorny")

/atom/movable/screen/lick_hud_button
	name = "lick on people!"
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "lick"
	screen_loc = ui_lick

/atom/movable/screen/lick_hud_button/Click(location,control,params)
	var/mob/living/carbon/human/H = usr
	if(!ishuman(usr))
		to_chat(usr, span_alert("Sorry! You've gotta be a fully spawned in character with hopes and dreams to use this!"))
		return
	H.emote("lickhorny")

/atom/movable/screen/kiss_hud_button
	name = "kiss on people!"
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "kiss"
	screen_loc = ui_kiss

/atom/movable/screen/kiss_hud_button/Click(location,control,params)
	var/mob/living/carbon/human/H = usr
	if(!ishuman(usr))
		to_chat(usr, span_alert("Sorry! You've gotta be a fully spawned in character with hopes and dreams to use this!"))
		return
	H.emote("kisshorny")

////////////////////////////////////////////////////////////
/// Private panel button
/atom/movable/screen/private_panel_button
	name = "fool with your privates!"
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "privatepanel"
	screen_loc = "EAST-0:-4, SOUTH+3:-3"

/atom/movable/screen/private_panel_button/Click(location,control,params)
	var/mob/living/carbon/human/H = usr
	if(!ishuman(usr))
		to_chat(usr, span_alert("Sorry! You've gotta be a fully spawned in character with hopes and dreams to use this!"))
		return
	H.toggle_genitals()
*/
////////////////////////////////////////////////////////////
/// give button
/atom/movable/screen/give_button
	name = "give somebody something!"
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "give"
	screen_loc = "CENTER+1:15,SOUTH+1:3"

/atom/movable/screen/give_button/Click(location,control,params)
	var/mob/living/carbon/human/H = usr
	if(!ishuman(usr))
		to_chat(usr, span_alert("Sorry! You've gotta be a fully spawned in character with hopes and dreams to use this!"))
		return
	H.give()

////////////////////////////////////////////////////////////
/// reload button
/atom/movable/screen/reload_button
	name = "reload a firearm!"
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "reload"
	screen_loc = "CENTER+2:11,SOUTH+1:3"

/atom/movable/screen/reload_button/Click(location,control,params)
	var/mob/living/carbon/human/H = usr
	if(!ishuman(usr))
		to_chat(usr, span_alert("Sorry! You've gotta be a fully spawned in character with hopes and dreams to use this!"))
		return
	H.ReloadGun()

////////////////////////////////////////////////////////////
/// Bite button
/atom/movable/screen/bite_hud_button
	name = "bite on people!"
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "bite"
	screen_loc = "EAST-1:28, SOUTH+5:-14"

/atom/movable/screen/bite_hud_button/Click(location,control,params)
	var/mob/living/carbon/human/H = usr
	if(!ishuman(usr))
		to_chat(usr, span_alert("Sorry! You've gotta be a fully spawned in character with hopes and dreams to use this!"))
		return
	H.emote("bite")

////////////////////////////////////////////////////////////
/// Claw button
/atom/movable/screen/claw_hud_button
	name = "claw on people!"
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "claw"
	screen_loc = "EAST-1:28, SOUTH+5:-9"

/atom/movable/screen/claw_hud_button/Click(location,control,params)
	var/mob/living/carbon/human/H = usr
	if(!ishuman(usr))
		to_chat(usr, span_alert("Sorry! You've gotta be a fully spawned in character with hopes and dreams to use this!"))
		return
	H.emote("claw")

////////////////////////////////////////////////////////////
/// Tail button
/atom/movable/screen/tail_hud_button
	name = "tail on people!"
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "tail"
	screen_loc = "EAST-1:28, SOUTH+4:-3"

/atom/movable/screen/tail_hud_button/Click(location,control,params)
	var/mob/living/carbon/human/H = usr
	if(!ishuman(usr))
		to_chat(usr, span_alert("Sorry! You've gotta be a fully spawned in character with hopes and dreams to use this!"))
		return
	H.emote("tailer")

////////////////////////////////////////////////////////////
/// Cuphand button
/atom/movable/screen/cuphand_hud_button
	name = "cuphand on people!"
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "cuphand"
	screen_loc = "EAST-1:4, SOUTH+4: 12"

/atom/movable/screen/cuphand_hud_button/Click(location,control,params)
	var/mob/living/carbon/human/H = usr
	if(!ishuman(usr))
		to_chat(usr, span_alert("Sorry! You've gotta be a fully spawned in character with hopes and dreams to use this!"))
		return
	H.emote("cuphand")

////////////////////////////////////////////////////////////
/// Beans button
/atom/movable/screen/beans_hud_button
	name = "bean on people!"
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "beans"
	screen_loc = "EAST-1:4, SOUTH+4:8"

/atom/movable/screen/beans_hud_button/Click(location,control,params)
	var/mob/living/carbon/human/H = usr
	if(!ishuman(usr))
		to_chat(usr, span_alert("Sorry! You've gotta be a fully spawned in character with hopes and dreams to use this!"))
		return
	H.emote("beans")

////////////////////////////////////////////////////////////
/// Tend button
/atom/movable/screen/tend_hud_button
	name = "tend on people!"
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "tend"
	screen_loc = "CENTER+3:8, SOUTH+1:-6"

/atom/movable/screen/tend_hud_button/Click(location,control,params)
	var/mob/living/carbon/human/H = usr
	if(!ishuman(usr))
		to_chat(usr, span_alert("Sorry! You've gotta be a fully spawned in character with hopes and dreams to use this!"))
		return
	H.emote("tend")

////////////////////////////////////////////////////////////
/// Butt button
/atom/movable/screen/butt_hud_button
	name = "butt on people!"
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "butt"
	screen_loc = "EAST-1:28, SOUTH+4:-14"

/atom/movable/screen/butt_hud_button/Click(location,control,params)
	var/mob/living/carbon/human/H = usr
	if(!ishuman(usr))
		to_chat(usr, span_alert("Sorry! You've gotta be a fully spawned in character with hopes and dreams to use this!"))
		return
	if(!H.has_butt())
		to_chat(H, span_alert("[H], you have no butt!"))
		return
	H.emote("butt")

/atom/movable/screen/pvp_focus_toggle
	name = "PVP focus On/Off"
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "pvp_blank"
	screen_loc = ui_pvpbuttons
	var/mytobe

/atom/movable/screen/pvp_focus_toggle/Initialize(mapload)
	. = ..()
	update_icon()

/atom/movable/screen/pvp_focus_toggle/Click(location,control,params)
	if(!usr.client || !ismob(usr))
		return

	var/changeto = PVP_NEUTRAL
	var/_y = text2num(params2list(params)["icon-y"])
	if(_y>=25) // PVP focus on
		if(HAS_TRAIT(usr, TRAIT_PVPFOC))
			changeto = PVP_NEUTRAL
		else
			if(HAS_TRAIT(usr, TRAIT_NO_PVP_EVER))
				to_chat(usr, span_alert("My role/quirks/setup doesn't allow for PVP!"))
				return
			changeto = PVP_YES
	else if(_y>=17) // PVP opt out on
		if(HAS_TRAIT(usr, TRAIT_PVEFOC))
			changeto = PVP_NEUTRAL
		else
			changeto = PVP_NO
	usr.SetPVPflag(changeto, TRUE)

/atom/movable/screen/pvp_focus_toggle/proc/update_intento(towhat)
	mytobe = towhat
	update_icon()

/atom/movable/screen/pvp_focus_toggle/update_overlays()
	. = ..()
	var/mutable_appearance/top = mutable_appearance('icons/mob/screen_gen.dmi')
	var/mutable_appearance/bottom = mutable_appearance('icons/mob/screen_gen.dmi')
	switch(mytobe)
		if(PVP_NEUTRAL)
			top.icon_state = "pvp_top_off"
			bottom.icon_state = "pvp_bottom_off"
		if(PVP_YES)
			top.icon_state = "pvp_top_on"
			bottom.icon_state = "pvp_bottom_off"
		if(PVP_NO)
			top.icon_state = "pvp_top_off"
			bottom.icon_state = "pvp_bottom_on"
	. += top
	. += bottom


