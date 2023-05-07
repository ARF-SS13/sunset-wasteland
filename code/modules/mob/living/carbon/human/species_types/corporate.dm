/datum/species/corporate
	name = "Corporate Agent"
	id = SPECIES_AGENT
	limbs_id = BODYTYPE_AGENT
	hair_alpha = 0
	say_mod = "declares"
	speedmod = -2//Fast
	brutemod = 0.7//Tough against firearms
	burnmod = 0.65//Tough against lasers
	coldmod = 0
	heatmod = 0.5//it's a little tough to burn them to death not as hard though.
	punchdamagelow = 20
	punchdamagehigh = 30//they are inhumanly strong
	punchstunthreshold = 25
	attack_verb = "smash"
	attack_sound = 'sound/weapons/resonator_blast.ogg'
	blacklisted = TRUE
	species_traits = list(
		NOBLOOD,
		EYECOLOR,
		NOGENITALS
	)
	inherent_traits = list(
		TRAIT_RADIMMUNE,
		TRAIT_VIRUSIMMUNE,
		TRAIT_PIERCEIMMUNE,
		TRAIT_NODISMEMBER,
		TRAIT_NOLIMBDISABLE,
		TRAIT_NOHUNGER
	)
	sexes = 0
	gib_types = /obj/effect/gibspawner/robot
	species_type = SPECIES_TYPE_ROBOT
