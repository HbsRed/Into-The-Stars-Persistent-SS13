/mob/living/simple_animal/hostile/tormented
	name = "Tormented"
	desc = "The wounds on its body don't look self inflicted."
	icon = 'icons/mob/critter.dmi'
	speak_emote = list("gibbers")
	icon_state = "tormented"
	icon_living = "tormented"
	icon_dead = "tormented_dead"
	health = 60
	maxHealth = 60
	speed = 12
	move_to_delay = 8
	destroy_surroundings = 1

	melee_damage_lower = 35
	melee_damage_upper = 50
	attacktext = "slashed"
	attack_sound = 'sound/weapons/slash.ogg'

	faction = "asteroid"

	//Space carp aren't affected by atmos.
	min_gas = null
	max_gas = null
	minbodytemp = 0

	should_save = 0

/mob/living/simple_animal/hostile/tormented/Found(var/atom/A)
	if(istype(A, /obj/machinery/mining/drill))
		var/obj/machinery/mining/drill/drill = A
		if(!drill.statu)
			stance = HOSTILE_STANCE_ATTACK
			return A
	if(istype(A, /obj/structure/ore_box))
		stance = HOSTILE_STANCE_ATTACK
		return A
	if(istype(A, /obj/item/stack/ore))
		stance = HOSTILE_STANCE_ATTACK
		return A


/mob/living/simple_animal/hostile/tormented/Allow_Spacemove(var/check_drift = 0)
	return 1 // Ripped from space carp, no more floating


/mob/living/simple_animal/hostile/tormented/New()
	..()

/mob/living/simple_animal/hostile/tormented/cult

	faction = "cult"

	min_gas = null
	max_gas = null
	minbodytemp = 0

	supernatural = 1

/mob/living/simple_animal/hostile/tormented/cult/cultify()
	return
