//Pokemon!

/mob/living/simple_animal/advanced
	name = "creature"
	desc = "That's a creature all right."
	icon = 'modular_coyote/icons/mob/pokemon64.dmi'
	icon_state = "eevee"
	icon_living = "eevee"
	icon_dead = "eevee_d"
	/// The default resting icon will always be "[icon_living]_rest" unless you set this variable, which will override it.
	icon_resting
	unsuitable_atmos_damage = 0
	mob_armor = ARMOR_VALUE_MEDIUM
	health = 200
	maxHealth = 200
	speed = 0
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "bops"
	response_disarm_simple = "bop"
	response_harm_continuous = "kicks"
	response_harm_simple = "kick"
	attack_verb_continuous = "attacks"
	attack_verb_simple = "attack"
	friendly_verb_continuous = "nuzzles"
	friendly_verb_simple = "nuzzle"
	attack_sound = 'sound/weapons/bladeslice.ogg'
	melee_damage_lower = 5
	melee_damage_upper = 15
	turns_per_move = 5
	var/is_blacklisted = FALSE // THis variable lets you stop mobs from being joinable roundstart
	pass_flags = PASSTABLE //Impossible to climb tables so just pass over them for now
	possible_a_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB, INTENT_HARM)
	// Sprites are already rotated for lying down while resting.
	rotate_on_lying = FALSE
	//Can use hands
	dextrous = TRUE
	dextrous_hud_type = /datum/hud/dextrous/drone
	//Need this to have the hands appear on the HUD
	held_items = list(null, null)
	sas_key = null // prevent sassery
	///The pokemon-types that this mob has. Used to auto-generate moves(abilities) and some other attributes.
	var/list/p_types = list()
	///Moves that aren't automatically granted based on their type. Will be assigned during Initialize()
	var/list/p_additional_moves = list()
	///List of passive traits/flags
	var/list/p_traits = list()
	///Moves/Abilities that this mob is currently using
	var/list/p_active_moves = list()

/mob/living/simple_animal/advanced/Initialize()
	. = ..()
	recenter_wide_sprite()
	var/datum/action/cooldown/pokemon_rest/R = new(src)
	R.Grant(src)
	regenerate_icons()
	add_verb(src, /mob/living/proc/mob_sleep)
	GLOB.advanced_mob_list += src

/mob/living/simple_animal/advanced/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/sleeping_regeneration)

///Will recenter a mob's icon on their tile if it's wider than 32 pixels. Will do nothing if it's 32 or less. To use correctly, position the mob in the center of the icon_state in your dmi.
/mob/proc/recenter_wide_sprite()
	var/icon/I = icon(icon)
	var/icon_width = I.Width()
	if(icon_width>32) //This proc only fixes sprites that are too wide.
		var/matrix/M = matrix(transform)
		transform = M.Translate(-((icon_width-32)/2),0) //Adjust pixel offset left by half of their icon's width past 32
		return TRUE
	return FALSE

/mob/living/simple_animal/advanced/regenerate_icons()
	if(stat == DEAD)
		icon_state = icon_dead
	else if(stat != DEAD && !CHECK_MOBILITY(src, MOBILITY_STAND))//Not dead but can't move
		if(isnull(icon_resting) || icon_resting == "")
			icon_state = "[icon_living]_rest"
		else
			icon_state = icon_resting
	else
		icon_state = icon_living

/mob/living/simple_animal/advanced/update_mobility()
	. = ..()
	regenerate_icons()

/mob/living/simple_animal/advanced/Destroy()
	GLOB.advanced_mob_list -= src
	. = ..()

///////////////////////////////
//////ALPHABETICAL PLEASE//////
///////////////////////////////

/mob/living/simple_animal/advanced/absol
	name = "absol"
	icon_state = "absol"
	icon_living = "absol"
	icon_dead = "absol_d"
	p_types = list(P_TYPE_DARK)
	p_traits = list(P_TRAIT_RIDEABLE)

/mob/living/simple_animal/advanced/megaabsol
	name = "mega absol"
	icon_state = "megaabsol"
	icon_living = "megaabsol"
	icon_dead = "megaabsol_d"
	p_types = list(P_TYPE_DARK)
	p_traits = list(P_TRAIT_RIDEABLE)

/mob/living/simple_animal/advanced/aggron
	name = "aggron"
	icon_state = "aggron"
	icon_living = "aggron"
	icon_dead = "aggron_d"
	p_types = list(P_TYPE_STEEL)
	mob_size = MOB_SIZE_LARGE
	p_traits = list(P_TRAIT_RIDEABLE)

/mob/living/simple_animal/advanced/alolanvulpix
	name = "alolan vulpix"
	icon_state = "alolanvulpix"
	icon_living = "alolanvulpix"
	icon_dead = "alolanvulpix_d"
	p_types = list(P_TYPE_ICE)
	mob_size = MOB_SIZE_SMALL
	p_traits = list(P_TRAIT_RIDEABLE)

/mob/living/simple_animal/advanced/ampharos
	name = "ampharos"
	icon_state = "ampharos"
	icon_living = "ampharos"
	icon_dead = "ampharos_d"
	p_types = list(P_TYPE_ELEC)
	mob_size = MOB_SIZE_LARGE

/mob/living/simple_animal/advanced/articuno
	name = "Articuno"
	icon_state = "articuno"
	icon_living = "articuno"
	icon_dead = "articuno_d"
	icon = 'modular_coyote/icons/mob/pokemon96.dmi'
	p_types = list(P_TYPE_ICE, P_TYPE_FLY)
	mob_size = MOB_SIZE_LARGE

/mob/living/simple_animal/advanced/arcanine
	name = "Acanine"
	icon_state = "arcanine"
	icon_living = "arcanine"
	icon_dead = "arcanine_d"
	p_types = list(P_TYPE_FIRE)

/mob/living/simple_animal/advanced/blastoise
	name = "blastoise"
	icon_state = "blastoise"
	icon_living = "blastoise"
	icon_dead = "blastoise_d"
	p_types = list(P_TYPE_WATER)

/mob/living/simple_animal/advanced/braixen
	name = "braixen"
	icon_state = "braixen"
	icon_living = "braixen"
	icon_dead = "braixen_d"
	p_types = list(P_TYPE_FIRE)

/mob/living/simple_animal/advanced/celebi
	name = "celebi"
	icon_state = "celebi"
	icon_living = "celebi"
	icon_dead = "celebi_d"
	p_types = list(P_TYPE_PSYCH, P_TYPE_GRASS)
	mob_size = MOB_SIZE_SMALL

/mob/living/simple_animal/advanced/charmander
	name = "charmander"
	icon_state = "charmander"
	icon_living = "charmander"
	icon_dead = "charmander_d"
	p_types = list(P_TYPE_FIRE)
	mob_size = MOB_SIZE_SMALL
	p_traits = list(P_TRAIT_RIDEABLE)

/mob/living/simple_animal/advanced/charizard
	name = "charizard"
	icon_state = "charizard"
	icon_living = "charizard"
	icon_dead = "charizard_d"
	p_types = list(P_TYPE_FIRE)
	mob_size = MOB_SIZE_SMALL
	p_traits = list(P_TRAIT_RIDEABLE)

/mob/living/simple_animal/advanced/ditto
	name = "ditto"
	icon_state = "ditto"
	icon_living = "ditto"
	icon_dead = "ditto_d"
	p_types = list(P_TYPE_NORM)
//	p_additional_moves = list(/mob/living/proc/hide, /mob/living/simple_animal/advanced/proc/move_imposter)//amogus
	mob_size = MOB_SIZE_SMALL

/mob/living/simple_animal/advanced/dragonair
	name = "dragonair"
	desc = "A Dragonair stores an enormous amount of energy inside its body. It is said to alter the weather around it by loosing energy from the crystals on its neck and tail."
	icon_state = "dragonair"
	icon_living = "dragonair"
	icon_dead = "dragonair_d"
	p_types = list(P_TYPE_DRAGON)
//	aquatic_movement = 1
//	p_additional_moves = list(/mob/living/simple_animal/advanced/proc/move_fly,
//							/mob/living/simple_animal/advanced/proc/move_hover)
	p_traits = list(P_TRAIT_RIDEABLE)
	mob_size = MOB_SIZE_LARGE

/mob/living/simple_animal/advanced/dragonairshiny
	name = "shiny dragonair"
	icon_state = "shinydragonair"
	icon_living = "shinydragonair"
	icon_dead = "shinydragonair_d"

/mob/living/simple_animal/advanced/dunsparce
	name = "dunsparce"
	icon_state = "dunsparce"
	icon_living = "dunsparce"
	icon_dead = "dunsparce_d"

/mob/living/simple_animal/advanced/dragonite
	name = "dragonite"
	desc = "It can circle the globe in just 16 hours. It is a kindhearted Pokemon that leads lost and foundering ships in a storm to the safety of land."
	icon_state = "dragonite"
	icon_living = "dragonite"
	icon_dead = "dragonite_d"
	p_types = list(P_TYPE_DRAGON, P_TYPE_FLY)
//	aquatic_movement = 1
	p_traits = list(P_TRAIT_RIDEABLE)
	mob_size = MOB_SIZE_LARGE

/mob/living/simple_animal/advanced/dratini
	name = "dratini"
	desc = "A Dratini continually molts and sloughs off its old skin. It does so because the life energy within its body steadily builds to reach uncontrollable levels."
	icon_state = "dratini"
	icon_living = "dratini"
	icon_dead = "dratini_d"
//	movement_cooldown = 3
//	aquatic_movement = 1
	p_types = list(P_TYPE_DRAGON)
	p_traits = list(P_TRAIT_RIDEABLE)

/mob/living/simple_animal/advanced/eevee
	name = "eevee"
	desc = "Eevee has an unstable genetic makeup that suddenly mutates due to its environment. Radiation from various stones causes this Pokemon to evolve."
	icon_state = "eevee"
	icon_living = "eevee"
	icon_dead = "eevee_d"
	p_types = list(P_TYPE_NORM)
	mob_size = MOB_SIZE_SMALL
	p_traits = list(P_TRAIT_RIDEABLE)

/mob/living/simple_animal/advanced/eeveealt
	name = "eevee, alt"
	desc = "Eevee has an unstable genetic makeup that suddenly mutates due to its environment. Radiation from various stones causes this Pokemon to evolve."
	icon_state = "eevee2"
	icon_living = "eevee2"
	icon_dead = "eevee2_d"
	p_types = list(P_TYPE_NORM)
	mob_size = MOB_SIZE_SMALL
	p_traits = list(P_TRAIT_RIDEABLE)

/mob/living/simple_animal/advanced/espeon
	name = "espeon"
	desc = "Espeon is extremely loyal to any trainer it considers to be worthy. It is said to have developed precognitive powers to protect its trainer from harm."
	icon_state = "espeon"
	icon_living = "espeon"
	icon_dead = "espeon_d"
	p_types = list(P_TYPE_PSYCH)
	p_traits = list(P_TRAIT_RIDEABLE)

/mob/living/simple_animal/advanced/fennekin
	name = "fennekin"
	icon_state = "fennekin"
	icon_living = "fennekin"
	icon_dead = "fennekin_d"
	p_types = list(P_TYPE_FIRE)
	mob_size = MOB_SIZE_SMALL
	p_traits = list(P_TRAIT_RIDEABLE)

/mob/living/simple_animal/advanced/flaaffy
	name = "flaaffy"
	icon_state = "flaaffy"
	icon_living = "flaaffy"
	icon_dead = "flaaffy_d"
	p_types = list(P_TYPE_ELEC)
	mob_size = MOB_SIZE_SMALL

/mob/living/simple_animal/advanced/flareon
	name = "flareon"
	desc = "Flareon's fluffy fur releases heat into the air so that its body does not get excessively hot. Its body temperature can rise to a maximum of 1,650 degrees F."
	icon_state = "flareon"
	icon_living = "flareon"
	icon_dead = "flareon_d"
	p_types = list(P_TYPE_FIRE)
	p_traits = list(P_TRAIT_RIDEABLE)

/mob/living/simple_animal/advanced/flygon
	name = "flygon"
	desc = "The flapping of its wings sounds something like singing. Those lured by the sound are enveloped in a sandstorm, becoming Flygon's prey."
	icon_state = "flygon"
	icon_living = "flygon"
	icon_dead = "flygon_d"
	p_types = list(P_TYPE_GROUND, P_TYPE_DRAGON)
//	p_additional_moves = list(/mob/living/simple_animal/advanced/proc/move_fly,
//							/mob/living/simple_animal/advanced/proc/move_hover)
	p_traits = list(P_TRAIT_RIDEABLE)
	mob_size = MOB_SIZE_LARGE

/mob/living/simple_animal/advanced/furret
	name = "furret"
	icon_state = "furret"
	icon_living = "furret"
	icon_dead = "furret_d"
	p_types = list(P_TYPE_NORM)
	p_traits = list(P_TRAIT_RIDEABLE)

/mob/living/simple_animal/advanced/furret/shiny
	name = "shiny furret"
	icon_state = "furret_shiny"
	icon_living = "furret_shiny"
	icon_dead = "furret_shiny_d"
	p_types = list(P_TYPE_NORM)
	p_traits = list(P_TRAIT_RIDEABLE)

/mob/living/simple_animal/advanced/gallade
	name = "gallade"
	icon_state = "gallade"
	icon_living = "gallade"
	icon_dead = "gallade_d"
	p_types = list(P_TYPE_PSYCH, P_TYPE_FIGHT)

/mob/living/simple_animal/advanced/gardevoir
	name = "gardevoir"
	icon_state = "gardevoir"
	icon_living = "gardevoir"
	icon_dead = "gardevoir_d"
	p_types = list(P_TYPE_PSYCH, P_TYPE_FAIRY)

/mob/living/simple_animal/advanced/gastly
	name = "gastly"
	desc = "Almost invisible, this gaseous Pokemon cloaks the target and puts it to sleep without notice."
	icon_state = "gastly"
	icon_living = "gastly"
	icon_dead = "gastly_d"
	p_types = list(P_TYPE_GHOST, P_TYPE_POISON)

/mob/living/simple_animal/advanced/gengar
	name = "gengar"
	desc = "It hides in shadows. It is said that if Gengar is hiding, it cools the area by nearly 10 degrees F."
	icon_state = "gengar"
	icon_living = "gengar"
	icon_dead = "gengar_d"
	p_types = list(P_TYPE_GHOST, P_TYPE_POISON)


/mob/living/simple_animal/advanced/glaceon
	name = "glaceon"
	desc = "By controlling its body heat, it can freeze the atmosphere around it to make a diamond-dust flurry."
	icon_state = "glaceon"
	icon_living = "glaceon"
	icon_dead = "glaceon_d"
	p_types = list(P_TYPE_ICE)
	p_traits = list(P_TRAIT_RIDEABLE)

/mob/living/simple_animal/advanced/haunter
	name = "haunter"
	desc = "If you get the feeling of being watched in darkness when nobody is around, Haunter may be there."
	icon_state = "haunter"
	icon_living = "haunter"
	icon_dead = "haunter_d"
	p_types = list(P_TYPE_GHOST, P_TYPE_POISON)

/mob/living/simple_animal/advanced/jirachi
	name = "jirachi"
	desc = "Generations have believed that any wish written on a note on its head will come true when it awakens."
	icon_state = "jirachi"
	icon_living = "jirachi"
	icon_dead = "jirachi_d"
	p_types = list(P_TYPE_STEEL, P_TYPE_PSYCH)
//	p_additional_moves = list(/mob/living/simple_animal/advanced/proc/move_fly,
//							/mob/living/simple_animal/advanced/proc/move_hover)

/mob/living/simple_animal/advanced/jolteon
	name = "jolteon"
	desc = "Its cells generate weak power that is amplified by its fur's static electricity to drop thunderbolts. The bristling fur is made of electrically charged needles."
	icon_state = "jolteon"
	icon_living = "jolteon"
	icon_dead = "jolteon_d"
	p_types = list(P_TYPE_ELEC)
	p_traits = list(P_TRAIT_RIDEABLE)

/mob/living/simple_animal/advanced/jolteon/bud
	name = "Bud"
	p_active_moves = list(M_SHOCK) //Shocks you by default
/*
/mob/living/simple_animal/advanced/kirlia
	name = "kirlia"
	icon_state = "kirlia"
	icon_living = "kirlia"
	icon_dead = "kirlia_d"
	p_types = list(P_TYPE_PSYCH, P_TYPE_FAIRY)
	mob_size = MOB_SIZE_SMALL
*/
/mob/living/simple_animal/advanced/larvitar
	name = "larvitar"
	desc = "It is born deep underground. It can't emerge until it has entirely consumed the soil around it."
	icon_state = "larvitar"
	icon_living = "larvitar"
	icon_dead = "larvitar_d"
	p_types = list(P_TYPE_ROCK, P_TYPE_GROUND)
	mob_size = MOB_SIZE_SMALL

/mob/living/simple_animal/advanced/leafeon
	name = "leafeon"
	icon_state = "leafeon"
	icon_living = "leafeon"
	icon_dead = "leafeon_d"
	p_types = list(P_TYPE_GRASS)
	p_traits = list(P_TRAIT_RIDEABLE)

/mob/living/simple_animal/advanced/linoone
	name = "linoone"
	icon_state = "linoone"
	icon_living = "linoone"
	icon_dead = "linoone_d"
	p_types = list(P_TYPE_NORM)
	p_traits = list(P_TRAIT_RIDEABLE)
	mob_size = MOB_SIZE_SMALL

/mob/living/simple_animal/advanced/lugia
	name = "Lugia"
	icon_state = "lugia"
	icon_living = "lugia"
	icon_dead = "lugia_d"
	icon = 'modular_coyote/icons/mob/pokemon96.dmi'
	p_types = list(P_TYPE_PSYCH, P_TYPE_FLY)
	mob_size = MOB_SIZE_LARGE

/mob/living/simple_animal/advanced/growlithe
	name = "growlithe"
	icon_state = "growlithe"
	icon_living = "growlithe"
	icon_dead = "growlithe_d"
	p_types = list(P_TYPE_FIRE)
	p_traits = list(P_TRAIT_RIDEABLE)
	mob_size = MOB_SIZE_SMALL

/mob/living/simple_animal/advanced/mareep
	name = "mareep"
	icon_state = "mareep"
	icon_living = "mareep"
	icon_dead = "mareep_d"
	p_types = list(P_TYPE_ELEC)
	p_traits = list(P_TRAIT_RIDEABLE)
	mob_size = MOB_SIZE_SMALL
	p_traits = list(P_TRAIT_RIDEABLE)

/mob/living/simple_animal/advanced/mightyena
	name = "mightyena"
	icon_state = "mightyena"
	icon_living = "mightyena"
	icon_dead = "mightyena"
	p_types = list(P_TYPE_DARK)
	p_traits = list(P_TRAIT_RIDEABLE)

/mob/living/simple_animal/advanced/miltank
	name = "miltank"
	icon_state = "miltank"
	icon_living = "miltank"
	icon_dead = "miltank_d"
	p_types = list(P_TYPE_NORM)
	var/obj/item/udder/udder = null
	var/datum/reagent/milk_reagent = /datum/reagent/consumable/milk
//	movement_cooldown = 3

/mob/living/simple_animal/advanced/miltank/Initialize()
	. = ..()
	udder = new(src, milk_reagent)

/mob/living/simple_animal/advanced/miltank/BiologicalLife(seconds, times_fired)
	. = ..()
	if(stat == CONSCIOUS)
		if(prob(5))
			udder?.generateMilk(milk_reagent)

/* TODO fix milking i guess
/mob/living/simple_animal/advanced/miltank/attackby(var/obj/item/O as obj, var/mob/user as mob)
	var/obj/item/weapon/reagent_containers/glass/G = O
	if(stat == CONSCIOUS && istype(G) && G.is_open_container())
		user.visible_message(span_notice("[user] milks [src] using \the [O]."))
		var/transfered = udder.trans_id_to(G, "milk", rand(5,10))
		if(G.reagents.total_volume >= G.volume)
			user << "<font color='red'> The udder is dry. Wait a bit longer... </font>"
		if(!transfered)
			user << "<font color='red'> The udder is dry. Wait a bit longer... </font>"
		..()
*/

/mob/living/simple_animal/advanced/poochyena
	name = "poochyena"
	icon_state = "poochyena"
	icon_living = "poochyena"
	icon_dead = "poochyena_d"
	p_types = list(P_TYPE_DARK)
	mob_size = MOB_SIZE_SMALL
	p_traits = list(P_TRAIT_RIDEABLE)

/mob/living/simple_animal/advanced/snivy
	name = "snivy"
	desc = "Being exposed to sunlight makes its movements swifter. It uses vines more adeptly than its hands."
	icon_state = "snivy"
	icon_living = "snivy"
	icon_dead = "snivy_d"
	mob_size = MOB_SIZE_SMALL
	p_types = list(P_TYPE_GRASS)

/mob/living/simple_animal/advanced/sprigatito
	name = "sprigatito"
	desc = "Its fluffy fur is similar in composition to plants. This Pokémon frequently washes its face to keep it from drying out."
	icon_state = "sprigatito"
	icon_living = "sprigatito"
	icon_dead = "sprigatito_d"
	mob_size = MOB_SIZE_SMALL
	p_types = list(P_TYPE_GRASS)

/mob/living/simple_animal/advanced/sylveon
	name = "sylveon"
	desc = "Sylveon, the Intertwining Pokemon. Sylveon affectionately wraps its ribbon-like feelers around its Trainer's arm as they walk together."
	icon_state = "sylveon"
	icon_living = "sylveon"
	icon_dead = "sylveon_d"
	p_types = list(P_TYPE_FAIRY)
	p_traits = list(P_TRAIT_RIDEABLE)

/mob/living/simple_animal/advanced/umbreon
	name = "umbreon"
	icon_state = "umbreon"
	icon_dead = "umbreon_d"
	icon_living = "umbreon"
	p_types = list(P_TYPE_DARK)
	p_traits = list(P_TRAIT_RIDEABLE)

/mob/living/simple_animal/advanced/vulpix
	name = "vulpix"
	icon_state = "vulpix"
	icon_living = "vulpix"
	icon_dead = "vulpix_d"
	p_types = list(P_TYPE_FIRE)
	mob_size = MOB_SIZE_SMALL
	p_traits = list(P_TRAIT_RIDEABLE)

/mob/living/simple_animal/advanced/tentacruel
	name = "tentacruel"
	icon_state = "tentacruel"
	icon_living = "tentacruel"
	icon_dead = "tentacruel_d"
//	movement_cooldown = 3
	p_types = list(P_TYPE_WATER)
	p_traits = list(P_TRAIT_RIDEABLE)

/mob/living/simple_animal/advanced/thievul
	name = "thievul"
	icon_state = "thievul"
	icon_living = "thievul"
	icon_dead = "thievul_d"
	p_types = list(P_TYPE_DARK)
	p_traits = list(P_TRAIT_RIDEABLE)

/mob/living/simple_animal/advanced/ninetales
	name = "ninetales"
	icon_state = "ninetales"
	icon_living = "ninetales"
	icon_dead = "ninetales_d"
	p_types = list(P_TYPE_FIRE)
//	p_additional_moves = list(/mob/living/simple_animal/advanced/proc/move_telepathy)
	p_traits = list(P_TRAIT_RIDEABLE)

/mob/living/simple_animal/advanced/ponyta
	name = "ponyta"
	icon_state = "ponyta"
	icon_living = "ponyta"
	icon_dead = "ponyta_d"
	p_types = list(P_TYPE_FIRE)
	p_traits = list(P_TRAIT_RIDEABLE)
	mob_size = MOB_SIZE_SMALL
	p_traits = list(P_TRAIT_RIDEABLE)

/mob/living/simple_animal/advanced/zubat
	name = "zubat"
	icon_state = "zubat"
	icon_living = "zubat"
	icon_dead = "zubat_d"
	desc = "Even though it has no eyes, it can sense obstacles using ultrasonic waves it emits from its mouth."
	p_types = list(P_TYPE_FLY, P_TYPE_POISON)
	mob_size = MOB_SIZE_SMALL

/mob/living/simple_animal/advanced/tangela
	name = "tangela"
	icon_state = "tangela"
	icon_living = "tangela"
	icon_dead = "tangela_d"
	p_types = list(P_TYPE_GRASS, P_TYPE_POISON)
	p_traits = list(P_TRAIT_RIDEABLE)

/mob/living/simple_animal/advanced/pinsir
	name = "pinsir"
	icon_state = "pinsir"
	icon_living = "pinsir"
	icon_dead = "pinsir_d"
	p_types = list(P_TYPE_BUG)

/mob/living/simple_animal/advanced/omanyte
	name = "omanyte"
	icon_state = "omanyte"
	icon_living = "omanyte"
	icon_dead = "omanyte_d"
//	movement_cooldown = 3
	p_types = list(P_TYPE_ROCK, P_TYPE_WATER)
	mob_size = MOB_SIZE_SMALL

/mob/living/simple_animal/advanced/magmar
	name = "magmar"
	icon_state = "magmar"
	icon_living = "magmar"
	icon_dead = "magmar_d"
//	movement_cooldown = 3
	p_types = list(P_TYPE_FIRE)

/mob/living/simple_animal/advanced/magicarp
	name = "magicarp"
	icon_state = "magicarp"
	icon_living = "magicarp"
	icon_dead = "magicarp_d"
//	movement_cooldown = 5
	p_types = list(P_TYPE_WATER)
	p_traits = list(P_TRAIT_RIDEABLE)
	mob_size = MOB_SIZE_SMALL

/mob/living/simple_animal/advanced/lapras
	name = "lapras"
	icon_state = "lapras"
	icon_living = "lapras"
	icon_dead = "lapras_d"
//	movement_cooldown = 3
	p_types = list(P_TYPE_WATER)
	p_traits = list(P_TRAIT_RIDEABLE)

/mob/living/simple_animal/advanced/lycanroc
	name = "lycanroc"
	desc = "Its quick movements confuse its enemies. Well equipped with claws and fangs, it also uses the sharp rocks in its mane as weapons."
	icon_state = "lycanroc"
	icon_living = "lycanroc"
	icon_dead = "lycanroc_d"
	p_types = list(P_TYPE_ROCK)

/mob/living/simple_animal/advanced/kabuto
	name = "kabuto"
	icon_state = "Kabuto"
	icon_living = "Kabuto"
	icon_dead = "Kabuto_d"
	p_types = list(P_TYPE_ROCK, P_TYPE_WATER)

/mob/living/simple_animal/advanced/aerodactyl
	name = "aerodactyl"
	icon_state = "Aerodactyl"
	icon_living = "Aerodactyl"
	icon_dead = "Aerodactyl_d"
	p_types = list(P_TYPE_ROCK, P_TYPE_FLY)
	p_traits = list(P_TRAIT_RIDEABLE)

/mob/living/simple_animal/advanced/lickitung
	name = "lickitung"
	icon_state = "lickitung"
	icon_living = "lickitung"
	icon_dead = "lickitung_d"
	p_types = list(P_TYPE_NORM)

/mob/living/simple_animal/advanced/cubone
	name = "cubone"
	icon_state = "cubone"
	icon_living = "cubone"
	icon_dead = "cubone_d"
	p_types = list(P_TYPE_GROUND)
	mob_size = MOB_SIZE_SMALL

/mob/living/simple_animal/advanced/mew
	name = "mew"
	icon_state = "mew"
	icon_living = "mew"
	icon_dead = "mew_d"
	p_types = list(P_TYPE_PSYCH)
//	p_additional_moves = list(/mob/living/simple_animal/advanced/proc/move_fly,
//							/mob/living/simple_animal/advanced/proc/move_hover,
//							/mob/living/simple_animal/advanced/proc/move_imposter,
//							/mob/living/simple_animal/advanced/proc/move_invisibility)
	mob_size = MOB_SIZE_SMALL

/mob/living/simple_animal/advanced/mewtwo
	name = "mewtwo"
	icon_state = "mewtwo"
	icon_living = "mewtwo"
	icon_dead = "mewtwo_d"
	p_types = list(P_TYPE_PSYCH)
//	p_additional_moves = list(/mob/living/simple_animal/advanced/proc/move_fly,
//							/mob/living/simple_animal/advanced/proc/move_hover)

/mob/living/simple_animal/advanced/purrloin
	name = "purrloin"
	icon_state = "purrloin"
	icon_living = "purrloin"
	icon_dead = "purrloin_d"
	p_types = list(P_TYPE_DARK)
	mob_size = MOB_SIZE_SMALL
/*
/mob/living/simple_animal/advanced/ralts
	name = "ralts"
	icon_state = "ralts"
	icon_living = "ralts"
	icon_dead = "ralts_d"
	p_types = list(P_TYPE_PSYCH, P_TYPE_FAIRY)
	mob_size = MOB_SIZE_SMALL
*/
/mob/living/simple_animal/advanced/raticate
	name = "raticate"
	icon_state = "raticate"
	icon_living = "raticate"
	icon_dead = "raticate_d"
	p_types = list(P_TYPE_NORM)
	p_traits = list(P_TRAIT_RIDEABLE)
	mob_size = MOB_SIZE_SMALL

/mob/living/simple_animal/advanced/rattata
	name = "rattata"
	icon_state = "rattata"
	icon_living = "rattata"
	icon_dead = "rattata_d"
	p_types = list(P_TYPE_NORM)
	p_traits = list(P_TRAIT_RIDEABLE)
	mob_size = MOB_SIZE_SMALL

/mob/living/simple_animal/advanced/rayquaza
	name = "Rayquaza"
	icon_state = "rayquaza"
	icon_living = "rayquaza"
	icon_dead = "rayquaza_d"
	icon = 'modular_coyote/icons/mob/pokemon96.dmi'
	p_types = list(P_TYPE_FLY)
	mob_size = MOB_SIZE_LARGE

/mob/living/simple_animal/advanced/skuntank
	name = "Skuntank"
	icon_state = "skunktank"
	icon_living = "skunktank"
	icon_dead = "skunktank_d"
	p_types = list(P_TYPE_POISON)

/mob/living/simple_animal/advanced/snorlax
	name = "snorlax"
	icon_state = "snorlax"
	icon_living = "snorlax"
	icon_dead = "snorlax_d"
	p_types = list(P_TYPE_NORM)
	p_traits = list(P_TRAIT_RIDEABLE)

/mob/living/simple_animal/advanced/vaporeon
	name = "vaporeon"
	icon_state = "vaporeon"
	icon_living = "vaporeon"
	icon_dead = "vaporeon_d"
	p_types = list(P_TYPE_WATER)
	p_traits = list(P_TRAIT_RIDEABLE)

/mob/living/simple_animal/advanced/zigzagoon
	name = "zigzagoon"
	icon_state = "zigzagoon"
	icon_living = "zigzagoon"
	icon_dead = "zigzagoon_d"
	p_types = list(P_TYPE_NORM)
	p_traits = list(P_TRAIT_RIDEABLE)
	mob_size = MOB_SIZE_SMALL

/mob/living/simple_animal/advanced/zoroark
	name = "zoroark"
	icon_state = "zoroark"
	icon_living = "zoroark"
	icon_dead = "zoroark_d"
	p_types = list(P_TYPE_DARK)
//	p_additional_moves = list(/mob/living/proc/hide, /mob/living/simple_animal/advanced/proc/move_imposter)

/mob/living/simple_animal/advanced/zorua
	name = "zorua"
	icon_state = "zorua"
	icon_living = "zorua"
	icon_dead = "zorua_d"
	p_types = list(P_TYPE_DARK)
//	p_additional_moves = list(/mob/living/proc/hide, /mob/living/simple_animal/advanced/proc/move_imposter)
	mob_size = MOB_SIZE_SMALL

/mob/living/simple_animal/advanced/zorua_hisuian
	name = "hisuian zorua"
	icon_state = "zorua_hisuian"
	icon_living = "zorua_hisuian"
	icon_dead = "zorua_hisuian_d"
	p_types = list(P_TYPE_NORM, P_TYPE_GHOST)
//	p_additional_moves = list(/mob/living/proc/hide, /mob/living/simple_animal/advanced/proc/move_imposter)
	mob_size = MOB_SIZE_SMALL

/////////////////////////////////////////////
//			ALPHABETICAL PLEASE			   //
//DON'T JUST ADD TO THE BOTTOM OF THIS FILE//
//				  OR ELSE				   //
/////////////////////////////////////////////
