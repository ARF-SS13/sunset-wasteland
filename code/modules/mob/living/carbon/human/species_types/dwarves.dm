/datum/species/dwarf //not to be confused with the genetic manlets
	name = "Dwarf"
	id = SPECIES_DWARF //Also called Homo sapiens pumilionis
	limbs_id = BODYTYPE_HUMAN
	default_color = "FFFFFF"

	species_traits = list(EYECOLOR,
		HAIR,
		FACEHAIR,
		LIPS,
		MUTCOLORS,
		HORNCOLOR,
		WINGCOLOR,
		HAS_FLESH,
		HAS_BONE
	)
	inherent_traits = list(
		TRAIT_DWARF
	)
	mutant_bodyparts = list(
		MBP_COLOR1 = "FFFFFF",
		MBP_COLOR2 = "FFFFFF",
		MBP_COLOR3 = "FFFFFF",
		MBP_SNOUT = "Husky",
		MBP_TAIL = "Husky",
		MBP_EARS = "Husky",
		MBP_WINGS_DECORATIVE = "None",
		MBP_MARKINGS_BODY = "Husky",
		MBP_TAUR = "None",
		MBP_HORNS = "None",
		MBP_LEGS = LIMB_PLANTIGRADE,
		MBP_MEAT_TYPE = MEAT_MAMMAL
	)
	skinned_type = /obj/item/stack/sheet/animalhide/human
	disliked_food = GROSS | TOXIC
	liked_food = JUNKFOOD | FRIED

	tail_type = MBP_TAIL_HUMAN
	wagging_type = MBP_TAIL_WAGGING_HUMAN

	allowed_limb_ids = list(
		BODYTYPE_HUMAN,
		BODYTYPE_FURRY,
		BODYTYPE_AQUATIC,
		BODYTYPE_AVIAN
	)


/mob/living/carbon/human/species/dwarf //species admin spawn path
	race = /datum/species/dwarf //and the race the path is set to.

/datum/species/dwarf/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	. = ..()
	var/mob/living/carbon/human/H = C
	H.AddElement(/datum/element/dwarfism, COMSIG_SPECIES_LOSS, src)

/datum/species/dwarf/on_species_loss(mob/living/carbon/H, datum/species/new_species)
	. = ..()

