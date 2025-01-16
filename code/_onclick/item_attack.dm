/**
 *This is the proc that handles the order of an item_attack.
 *The order of procs called is:
 *tool_act on the target. If it returns TRUE, the chain will be stopped.
 *pre_attack() on src. If this returns TRUE, the chain will be stopped.
 *attackby on the target. If it returns TRUE, the chain will be stopped.
 *and lastly
 *afterattack. The return value does not matter.
 */
/obj/item/proc/melee_attack_chain(mob/user, atom/target, params, attackchain_flags, damage_multiplier = 1)
	// if(user != target && !isitem(target) && user.incapacitated() && !extract_ckey(target)) // no attacking mobs, other players is okay
	// 	to_chat(user, span_danger("You are to messed up to use [src] on anything but yourself!"))
	// 	return
	if(isliving(user))
		var/mob/living/L = user
		if(!CHECK_MOBILITY(L, MOBILITY_USE) && !(attackchain_flags & ATTACK_IS_PARRY_COUNTERATTACK))
			to_chat(L, span_warning("You are unable to swing [src] right now!"))
			return
		if(SEND_SIGNAL(src, COMSIG_ITEM_ATTACKCHAIN, user, target, params) & COMPONENT_ITEM_NO_ATTACK)
			return
		if(min_reach && GET_DIST_EUCLIDEAN(user, target) < min_reach)
			return
	. = attackchain_flags
	if(tool_behaviour && ((. = target.tool_act(user, src, tool_behaviour)) & STOP_ATTACK_PROC_CHAIN))
		return
	if((. |= pre_attack(target, user, params, ., damage_multiplier)) & STOP_ATTACK_PROC_CHAIN)
		return
	if((. |= target.attackby(src, user, params, ., damage_multiplier)) & STOP_ATTACK_PROC_CHAIN)
		return
	if(QDELETED(src) || QDELETED(target))
		return
	. |= afterattack(target, user, TRUE, params)

/// Like melee_attack_chain but for ranged.
/obj/item/proc/ranged_attack_chain(mob/user, atom/target, params)
	if(isliving(user))
		var/mob/living/L = user
		if(!CHECK_MOBILITY(L, MOBILITY_USE))
			to_chat(L, span_warning("You are unable to raise [src] right now!"))
			return
		if(SEND_SIGNAL(src, COMSIG_ITEM_ATTACKCHAIN, user, target, params) & COMPONENT_ITEM_NO_ATTACK)
			return
		if((. |= pre_attack(target, user, params, ., 1)) & STOP_ATTACK_PROC_CHAIN)
			return
		if(max_reach >= 2 && has_range_for_melee_attack(target, user))
			return ranged_melee_attack(target, user, params)
	return afterattack(target, user, FALSE, params)

// Called when the item is in the active hand, and clicked; alternately, there is an 'activate held object' verb or you can hit pagedown.
/obj/item/proc/attack_self(mob/user)
	if(SEND_SIGNAL(src, COMSIG_ITEM_ATTACK_SELF, user) & COMPONENT_NO_INTERACT)
		return
	interact(user)

/obj/item/proc/pre_attack(atom/A, mob/living/user, params, attackchain_flags, damage_multiplier) //do stuff before attackby!
	if(SEND_SIGNAL(src, COMSIG_ITEM_PRE_ATTACK, A, user, params) & COMPONENT_NO_ATTACK)
		return STOP_ATTACK_PROC_CHAIN
	if(!(attackchain_flags & ATTACK_IGNORE_CLICKDELAY) && !CheckAttackCooldown(user, A))
		return STOP_ATTACK_PROC_CHAIN

/atom/proc/attackby(obj/item/W, mob/user, params, damage_override)
	if(SEND_SIGNAL(src, COMSIG_PARENT_ATTACKBY, W, user, params) & COMPONENT_NO_AFTERATTACK)
		return STOP_ATTACK_PROC_CHAIN

/obj/attackby(obj/item/I, mob/living/user, params, damage_override)
	. = ..()
	if(. & STOP_ATTACK_PROC_CHAIN)
		return
	if(obj_flags & CAN_BE_HIT)
		. |= I.attack_obj(src, user, damage_override)
	else
		. |= I.attack_obj_nohit(src, user, damage_override)

/mob/living/attackby(obj/item/I, mob/living/user, params, attackchain_flags, damage_multiplier)
	. = ..()
	if(. & STOP_ATTACK_PROC_CHAIN)
		return
	. |= I.attack(src, user, attackchain_flags, damage_multiplier)
	if(!(. & NO_AUTO_CLICKDELAY_HANDLING))	// SAFETY NET - unless the proc tells us we should not handle this, give them the basic melee cooldown!
		I.ApplyAttackCooldown(user, src, attackchain_flags)

/**
 * Called when someone uses us to attack a mob in melee combat.
 *
 * This proc respects CheckAttackCooldown() default clickdelay handling.
 *
 * @params
 * * mob/living/M - target
 * * mob/living/user - attacker
 * * attackchain_Flags - see [code/__DEFINES/_flags/return_values.dm]
 * * damage_multiplier - what to multiply the damage by
 */
/obj/item/proc/attack(mob/living/M, mob/living/user, attackchain_flags = NONE, damage_multiplier = 1, damage_override)
	if(SEND_SIGNAL(src, COMSIG_ITEM_ATTACK, M, user) & COMPONENT_ITEM_NO_ATTACK)
		return
	SEND_SIGNAL(user, COMSIG_MOB_ITEM_ATTACK, M, user)
	if(item_flags & NOBLUDGEON)
		return

	//-->Pacifism Lesser Trait, most important section of it
	if(iscarbon(M))
		if(iscarbon(user))  //is our firer a carbon that can have traits?
			if(force)  //if the item is harmless, there's no need for pacifism lesser to even begin the query.
				var/mob/living/carbon/C = M
				if(HAS_TRAIT(user, TRAIT_PACIFISM_LESSER) && C.last_mind)  //does the user actually has the PACIFISM_LESSER trait? And is the target sapient?
					trait_pacifism_lesser_consequences(user)
					return FALSE
	//<--

	if((force || damage_override) && damtype != STAMINA)
		if(HAS_TRAIT(user, TRAIT_PACIFISM))
			to_chat(user, span_warning("You don't want to harm other living beings!"))
			return
		else if(!PVPcheck(user, M, src))
			to_chat(user, span_alert("You both need to have Combat Intent enabled to hurt each other!"))
			return

	//var/bigleagues = 10 //flat additive
	//var/littleleagues = 5
	//var/gentle = -5
	//var/wimpy = -10
	//var/FEVbonus = force*0.35 //used to be a flat additive of 20. changed after someone beat someone to death with a book. TODO: balance this further, possibly with a switch statement depending on force value
	//var/buffout = force*0.25
	//var/smutant = force*0.25 //Not using this for FEV mutated as this could let you do a lot of trolling.
	//var/ghoulmelee = force*0.25 //negative trait, this will cut 25% of the damage done by melee

	var/regular = force*(user.special_s/100)//SPECIAL integration

	force += regular//SPECIAL integration

	var/force_modifier = 0
	if(force >= 5)
		if(HAS_TRAIT(user, TRAIT_GHOULMELEE))
			force_modifier = (-force * 0.2) // You do 80% damage because you're a walking corpse
		if(HAS_TRAIT(user, TRAIT_PANICKED_ATTACKER))
			force_modifier = (-force * 0.8) // You do 20% damage because of fear
		if(user.health < user.crit_threshold)
			force_modifier = (-force * 0.2) // You do 80% damage because you're in critical condition
		else
			if(HAS_TRAIT(user, TRAIT_BIG_LEAGUES))
				force_modifier += 25
			if(HAS_TRAIT(user, TRAIT_LITTLE_LEAGUES))
				force_modifier += 18
			if(HAS_TRAIT(user, TRAIT_GENTLE))
				force_modifier += -18
			if(HAS_TRAIT(user, TRAIT_WIMPY))
				force_modifier += -25
			if(HAS_TRAIT(user, TRAIT_BUFFOUT_BUFF))
				force_modifier += 50
			if(HAS_TRAIT(user, TRAIT_FEV))
				force_modifier += (force * 0.1)
			if(HAS_TRAIT(user, TRAIT_SMUTANT))
				force_modifier += (force * 0.1)
	force_modifier = clamp(force_modifier, -force, force * 0.25)
	if(ishostile(M))
		user.in_crit_HP_penalty = HOSTILES_ATTACK_UNTIL_THIS_FAR_INTO_CRIT

	var/force_out = force + force_modifier
	if(force_out <= 0)
		playsound(loc, pokesound, get_clamped_volume(), 1, -1)
	else if(hitsound)
		playsound(loc, hitsound, get_clamped_volume(), 1, -1)

	M.lastattacker = user.real_name
	M.lastattackerckey = user.ckey
	if(isanimal(M))
		var/mob/living/simple_animal/SA = M
		SA.give_credit(user)

	user.do_attack_animation(M)
	if(damage_override)
		var/dammod = min(damage_override / max(1, force), 1)
		damage_override += (force_modifier * dammod)
	M.attacked_by(src, user, attackchain_flags, damage_multiplier, damage_addition = force_modifier, damage_override = damage_override)

	log_combat(user, M, "attacked", src.name, "(INTENT: [uppertext(user.a_intent)]) (DAMTYPE: [uppertext(damtype)])")
	add_fingerprint(user)

/proc/PVPcheck(mob/living/attacker, mob/living/hurted)
	if(!attacker || !hurted)
		return TRUE // sure do whatever
	if(isanimal(hurted))
		return TRUE // mob
	if(!attacker.client || !hurted.client)
		return TRUE // one of them lacks a clint
	// now the real PVP check
	if(attacker.enabled_combat_indicator && hurted.enabled_combat_indicator)
		return TRUE
	return FALSE

//the equivalent of the standard version of attack() but for object targets.
/obj/item/proc/attack_obj(obj/O, mob/living/user, damage_override)
	if(SEND_SIGNAL(src, COMSIG_ITEM_ATTACK_OBJ, O, user) & COMPONENT_NO_ATTACK_OBJ)
		return
	if(item_flags & NOBLUDGEON)
		return
	user.do_attack_animation(O)
	O.attacked_by(src, user, NONE, 1, 0, damage_override)

/obj/item/proc/attack_obj_nohit(obj/O, mob/living/user, damage_override)
	if(SEND_SIGNAL(src, COMSIG_ITEM_ATTACK_OBJ_NOHIT, O, user) & COMPONENT_NO_ATTACK_OBJ)
		return

/atom/movable/proc/attacked_by()
	return

/obj/attacked_by(obj/item/I, mob/living/user, attackchain_flags = NONE, damage_multiplier = 1, damage_addition = 0, damage_override)
	var/totitemdamage
	if(damage_override)
		totitemdamage = damage_override
	else
		totitemdamage = (I.force * damage_multiplier) + damage_addition
	var/bad_trait

	var/stamloss = user.getStaminaLoss()
	if(stamloss > STAMINA_NEAR_SOFTCRIT) //The more tired you are, the less damage you do.
		var/penalty = (stamloss - STAMINA_NEAR_SOFTCRIT)/(STAMINA_NEAR_CRIT - STAMINA_NEAR_SOFTCRIT)*STAM_CRIT_ITEM_ATTACK_PENALTY
		totitemdamage *= 1 - penalty

	if(SEND_SIGNAL(user, COMSIG_COMBAT_MODE_CHECK, COMBAT_MODE_INACTIVE))
		bad_trait = SKILL_COMBAT_MODE //blacklist combat skills.

	if(I.used_skills && user.mind)
		if(totitemdamage)
			totitemdamage = user.mind.item_action_skills_mod(I, totitemdamage, I.skill_difficulty, SKILL_ATTACK_OBJ, bad_trait)
		for(var/skill in I.used_skills)
			if(!(SKILL_TRAIN_ATTACK_OBJ in I.used_skills[skill]))
				continue
			user.mind.auto_gain_experience(skill, I.skill_gain)
	if(!(attackchain_flags & NO_AUTO_CLICKDELAY_HANDLING))
		I.ApplyAttackCooldown(user, src, attackchain_flags)
	if(totitemdamage)
		visible_message(span_danger("[user] has hit [src] with [I]!"), null, null, COMBAT_MESSAGE_RANGE)
		//only witnesses close by and the victim see a hit message.
		log_combat(user, src, "attacked", I)
	take_damage(totitemdamage, I.damtype, "melee", 1, attacked_by = user)

/mob/living/attacked_by(obj/item/I, mob/living/user, attackchain_flags = NONE, damage_multiplier = 1, damage_addition = 0, damage_override)
	var/list/block_return = list()
	var/totitemdamage
	if(damage_override)
		totitemdamage = damage_override
	else
		totitemdamage = max(((pre_attacked_by(I, user) * damage_multiplier) + damage_addition), 0)
	if((user != src) && mob_run_block(I, totitemdamage, "the [I.name]", ((attackchain_flags & ATTACK_IS_PARRY_COUNTERATTACK)? ATTACK_IS_PARRY_COUNTERATTACK : NONE) | ATTACK_TYPE_MELEE, I.armour_penetration, user, null, block_return) & BLOCK_SUCCESS)
		return FALSE
	totitemdamage = block_calculate_resultant_damage(totitemdamage, block_return)
	var/armorcheck = "melee"
	switch(I.damtype)
		if(BRUTE)
			armorcheck = "melee"
		if(BURN)
			armorcheck = "laser"		
	var/armor = run_armor_check(null, armorcheck, null, null, 0, null)
	var/dt = max(run_armor_check(null, "damage_threshold", null, null, 0, null), 0)
	send_item_attack_message(I, user, null, totitemdamage)
	I.do_stagger_action(src, user, totitemdamage)
	if(I.force)
		apply_damage(
			totitemdamage, 
			I.damtype,
			BODY_ZONE_CHEST,
			armor,
			FALSE,
			FALSE,
			0,
			0,
			I.sharpness,
			dt,
			TRUE
		)
		if(I.damtype == BRUTE)
			if(prob(33))
				I.add_mob_blood(src)
				var/turf/location = get_turf(src)
				add_splatter_floor(location)
				if(totitemdamage >= 10 && get_dist(user, src) <= 1)	//people with TK won't get smeared with blood
					user.add_mob_blood(src)
		return TRUE //successful attack

/mob/living/simple_animal/attacked_by(obj/item/I, mob/living/user, attackchain_flags = NONE, damage_multiplier = 1, damage_addition, damage_override)
	if(I.force < force_threshold || I.damtype == STAMINA)
		playsound(src, 'sound/weapons/tap.ogg', I.get_clamped_volume(), 1, -1)
	else
		return ..()

/mob/living/proc/pre_attacked_by(obj/item/I, mob/living/user)
	. = I.force
	if(!.)
		return

	var/stamloss = user.getStaminaLoss()
	var/stam_mobility_mult = 1
	if(stamloss > STAMINA_NEAR_SOFTCRIT) //The more tired you are, the less damage you do.
		var/penalty = (stamloss - STAMINA_NEAR_SOFTCRIT)/(STAMINA_NEAR_CRIT - STAMINA_NEAR_SOFTCRIT)*STAM_CRIT_ITEM_ATTACK_PENALTY
		stam_mobility_mult -= penalty
	if(stam_mobility_mult > LYING_DAMAGE_PENALTY && !CHECK_MOBILITY(user, MOBILITY_STAND)) //damage penalty for fighting prone, doesn't stack with the above.
		stam_mobility_mult = LYING_DAMAGE_PENALTY
	. *= stam_mobility_mult

	if(!user.mind || !I.used_skills)
		return
	if(.)
		. = user.mind.item_action_skills_mod(I, ., I.skill_difficulty, SKILL_ATTACK_MOB)
	for(var/skill in I.used_skills)
		if(!(SKILL_TRAIN_ATTACK_MOB in I.used_skills[skill]))
			continue
		var/datum/skill/S = GLOB.skill_datums[skill]
		user.mind.auto_gain_experience(skill, I.skill_gain*S.item_skill_gain_multi)

/**
 * Called after attacking something if the melee attack chain isn't interrupted before.
 * Also called when clicking on something with an item without being in melee range
 *
 * WARNING: This does not automatically check clickdelay if not in a melee attack! Be sure to account for this!
 *
 * @params
 * * target - The thing we clicked
 * * user - mob of person clicking
 * * proximity_flag - are we in melee range/doing it in a melee attack
 * * click_parameters - mouse control parameters, check BYOND ref.
 */
/obj/item/proc/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	SEND_SIGNAL(src, COMSIG_ITEM_AFTERATTACK, target, user, proximity_flag, click_parameters)
	SEND_SIGNAL(user, COMSIG_MOB_ITEM_AFTERATTACK, target, user, proximity_flag, click_parameters)


/obj/item/proc/has_range_for_melee_attack(atom/target, mob/living/user, reach_min, reach_max)
	if(user.z != target.z)
		return FALSE
	var/minimum_reach = reach_min ? reach_min : min_reach
	var/maximum_reach = reach_max ? reach_max : max_reach
	var/euclidean_distance = GET_DIST_EUCLIDEAN(user, target)
	if(euclidean_distance < max(minimum_reach, 2) || round(euclidean_distance) > maximum_reach)
		return FALSE // No need to waste time calculating the path.
	return user.euclidian_reach(target, maximum_reach, REACH_ATTACK) == get_turf(target)


/obj/item/proc/ranged_melee_attack(atom/target, mob/living/user, params)
	melee_attack_chain(user, target, params)


/obj/item/proc/get_clamped_volume()
	if(w_class)
		if(force)
			return clamp((force + w_class) * 4, 30, 100)// Add the item's force to its weight class and multiply by 4, then clamp the value between 30 and 100
		else
			return clamp(w_class * 6, 10, 100) // Multiply the item's weight class by 6, then clamp the value between 10 and 100

/mob/living/proc/send_item_attack_message(obj/item/I, mob/living/user, hit_area, obj/item/bodypart/hit_bodypart)
	var/message_verb = "attacked"
	if(length(I.attack_verb))
		message_verb = "[pick(I.attack_verb)]"
	else if(!I.force)
		return
	var/message_hit_area = ""
	if(hit_area)
		message_hit_area = " in the [hit_area]"
	var/attack_message = "[src] is [message_verb][message_hit_area] with [I]!"
	var/attack_message_local = "You're [message_verb][message_hit_area] with [I]!"
	if(user in viewers(src, null))
		attack_message = "[user] [message_verb] [src][message_hit_area] with [I]!"
		attack_message_local = "[user] [message_verb] you[message_hit_area] with [I]!"
	if(user == src)
		attack_message_local = "You [message_verb] yourself[message_hit_area] with [I]"
	visible_message(span_danger("[attack_message]"),\
		span_userdanger("[attack_message_local]"), null, COMBAT_MESSAGE_RANGE)
	return 1

/// How much stamina this takes to swing this is not for realism purposes hecc off.
/obj/item/proc/getweight(mob/living/user, multiplier = 1, trait = SKILL_STAMINA_COST)
	. = (total_mass || w_class * STAM_COST_W_CLASS_MULT) * multiplier
	if(!user)
		return
	var/bad_trait
	if(SEND_SIGNAL(user, COMSIG_COMBAT_MODE_CHECK, COMBAT_MODE_INACTIVE))
		. *= STAM_COST_NO_COMBAT_MULT
		bad_trait = SKILL_COMBAT_MODE
	if(used_skills && user.mind)
		. = user.mind.item_action_skills_mod(src, ., skill_difficulty, trait, bad_trait, FALSE)
	var/total_health = user.getStaminaLoss()
	. = clamp(., 0, STAMINA_NEAR_CRIT - total_health)

/// How long this staggers for. 0 and negatives supported.
/obj/item/proc/melee_stagger_duration(force_override)
	if(!isnull(stagger_force))
		return stagger_force
	/// totally not an untested, arbitrary equation.
	return clamp((1.5 + (w_class/7.5)) * ((force_override || force) / 2), 0, 10 SECONDS)

/obj/item/proc/do_stagger_action(mob/living/target, mob/living/user, force_override)
	if(!CHECK_BITFIELD(target.status_flags, CANSTAGGER))
		return FALSE
	if(target.combat_flags & COMBAT_FLAG_SPRINT_ACTIVE)
		target.do_staggered_animation()
	var/duration = melee_stagger_duration(force_override)
	if(!duration)		//0
		return FALSE
	else if(duration > 0)
		target.Stagger(duration)
	else				//negative
		target.AdjustStaggered(duration)
	return TRUE

/mob/proc/do_staggered_animation()
	set waitfor = FALSE
	animate(src, pixel_x = -2, pixel_y = -2, time = 1, flags = ANIMATION_RELATIVE | ANIMATION_PARALLEL)
	animate(pixel_x = 4, pixel_y = 4, time = 1, flags = ANIMATION_RELATIVE)
	animate(pixel_x = -2, pixel_y = -2, time = 0.5, flags = ANIMATION_RELATIVE)
