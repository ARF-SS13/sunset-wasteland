/// A screenshot test for every humanoid species with a handful of jobs.
/datum/unit_test/screenshot_humanoids

/datum/unit_test/screenshot_humanoids/Run()
	for (var/datum/species/species_type as anything in subtypesof(/datum/species))
		test_screenshot("[species_type]", get_flat_icon_for_all_directions(make_dummy(species_type, /datum/outfit/job)))

/datum/unit_test/screenshot_humanoids/proc/get_flat_icon_for_all_directions(atom/thing)
	var/icon/output = icon('icons/effects/effects.dmi', "nothing")
	COMPILE_OVERLAYS(thing)

	for (var/direction in GLOB.cardinals)
		var/icon/partial = getFlatIcon(thing, defdir = direction, no_anim = TRUE)
		output.Insert(partial, dir = direction)

	return output

/datum/unit_test/screenshot_humanoids/proc/make_dummy(species, job_outfit)
	var/mob/living/carbon/human/dummy/consistent/dummy = allocate(/mob/living/carbon/human/dummy/consistent)
	dummy.set_species(species)
	dummy.equipOutfit(job_outfit, visualsOnly = TRUE)
	return dummy


/// Provides a dummy that is consistently bald, white, naked, etc.
/mob/living/carbon/human/dummy/consistent

/mob/living/carbon/human/dummy/consistent/Initialize()
	. = ..()
	setup_human_dna()


/mob/living/carbon/human/dummy/consistent/proc/setup_human_dna()
	create_dna(src)
	dna.initialize_dna(null, FALSE)
	// dna.features["body_markings"] = ACCESSORY_NONE
	// dna.features[MBP_EARS_LIZARD] = ACCESSORY_NONE
	// dna.features["ethcolor"] = COLOR_WHITE
	// dna.features[MBP_FRILLS] = ACCESSORY_NONE
	// dna.features[MBP_HORNS] = ACCESSORY_NONE
	// dna.features[FEATURE_COLOR_1] = "00FF00"
	// dna.features["moth_antennae"] = "Plain"
	// dna.features["moth_markings"] = ACCESSORY_NONE
	// dna.features[MBP_WINGS_MOTH] = "Plain"
	// dna.features[MBP_SNOUT_LIZARD] = "Round"
	// dna.features[MBP_TAIL_SPINES] = ACCESSORY_NONE
	// dna.features["tail_cat"] = ACCESSORY_NONE
	// dna.features[MBP_TAIL_LIZARD] = "Smooth"
	// dna.features["pod_hair"] = "Ivy"
	// dna.features["grad_style"] = ACCESSORY_ICON_STATE_NONE
	// dna.features["grad_color"] = COLOR_ALMOST_BLACK
	facial_hair_style = "Shaved"
	hair_style = "Bald"
	hair_color = "FF0000"
