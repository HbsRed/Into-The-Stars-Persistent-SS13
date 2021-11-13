/obj/item/projectile/beam
	name = "laser"
	icon_state = "laser"
	fire_sound='sound/weapons/Laser.ogg'
	pass_flags = PASS_FLAG_TABLE | PASS_FLAG_GLASS | PASS_FLAG_GRILLE
	damage = 40
	damage_type = BURN
	sharp = 1 //concentrated burns
	check_armour = "laser"
	eyeblur = 4
	hitscan = 1
	invisibility = 101	//beam projectiles are invisible as they are rendered by the effect engine

	muzzle_type = /obj/effect/projectile/laser/muzzle
	tracer_type = /obj/effect/projectile/laser/tracer
	impact_type = /obj/effect/projectile/laser/impact

/obj/item/projectile/beam/practice
	name = "laser"
	icon_state = "laser"
	fire_sound = 'sound/weapons/Taser.ogg'
	pass_flags = PASS_FLAG_TABLE | PASS_FLAG_GLASS | PASS_FLAG_GRILLE
	damage = 2
	damage_type = BURN
	check_armour = "laser"
	eyeblur = 2

/obj/item/projectile/beam/smalllaser
	damage = 25

/obj/item/projectile/beam/midlaser
	damage = 50
	armor_penetration = 10

/obj/item/projectile/beam/heavylaser
	name = "heavy laser"
	icon_state = "heavylaser"
	fire_sound = 'sound/weapons/lasercannonfire.ogg'
	damage = 60
	armor_penetration = 30

	muzzle_type = /obj/effect/projectile/laser_heavy/muzzle
	tracer_type = /obj/effect/projectile/laser_heavy/tracer
	impact_type = /obj/effect/projectile/laser_heavy/impact

/obj/item/projectile/beam/xray
	name = "x-ray beam"
	icon_state = "xray"
	fire_sound = 'sound/weapons/laser3.ogg'
	damage = 30
	armor_penetration = 30
	penetration_modifier = 0.8

	muzzle_type = /obj/effect/projectile/xray/muzzle
	tracer_type = /obj/effect/projectile/xray/tracer
	impact_type = /obj/effect/projectile/xray/impact

/obj/item/projectile/beam/xray/midlaser
	damage = 30
	armor_penetration = 50

/obj/item/projectile/beam/pulse
	name = "pulse"
	icon_state = "u_laser"
	fire_sound='sound/weapons/pulse.ogg'
	damage = 15 //lower damage, but fires in bursts

	muzzle_type = /obj/effect/projectile/laser_pulse/muzzle
	tracer_type = /obj/effect/projectile/laser_pulse/tracer
	impact_type = /obj/effect/projectile/laser_pulse/impact

/obj/item/projectile/beam/pulse/mid
	damage = 20

/obj/item/projectile/beam/pulse/heavy
	damage = 25

/obj/item/projectile/beam/pulse/destroy
	name = "destroyer pulse"
	damage = 100 //badmins be badmins I don't give a fuck
	armor_penetration = 100

/obj/item/projectile/beam/pulse/destroy/on_hit(var/atom/target, var/blocked = 0)
	if(isturf(target))
		target.ex_act(2)
	..()

/obj/item/projectile/beam/emitter
	name = "emitter beam"
	icon_state = "emitter"
	fire_sound = 'sound/weapons/emitter.ogg'
	damage = 0 // The actual damage is computed in /code/modules/power/singularity/emitter.dm

	muzzle_type = /obj/effect/projectile/emitter/muzzle
	tracer_type = /obj/effect/projectile/emitter/tracer
	impact_type = /obj/effect/projectile/emitter/impact

/obj/item/projectile/beam/lastertag/blue
	name = "lasertag beam"
	icon_state = "bluelaser"
	pass_flags = PASS_FLAG_TABLE | PASS_FLAG_GLASS | PASS_FLAG_GRILLE
	damage = 0
	no_attack_log = 1
	damage_type = BURN
	check_armour = "laser"

	muzzle_type = /obj/effect/projectile/laser_blue/muzzle
	tracer_type = /obj/effect/projectile/laser_blue/tracer
	impact_type = /obj/effect/projectile/laser_blue/impact

/obj/item/projectile/beam/lastertag/blue/on_hit(var/atom/target, var/blocked = 0)
	if(istype(target, /mob/living/carbon/human))
		var/mob/living/carbon/human/M = target
		if(istype(M.wear_suit, /obj/item/clothing/suit/redtag))
			M.Weaken(5)
	return 1

/obj/item/projectile/beam/lastertag/red
	name = "lasertag beam"
	icon_state = "laser"
	pass_flags = PASS_FLAG_TABLE | PASS_FLAG_GLASS | PASS_FLAG_GRILLE
	damage = 0
	no_attack_log = 1
	damage_type = BURN
	check_armour = "laser"

/obj/item/projectile/beam/lastertag/red/on_hit(var/atom/target, var/blocked = 0)
	if(istype(target, /mob/living/carbon/human))
		var/mob/living/carbon/human/M = target
		if(istype(M.wear_suit, /obj/item/clothing/suit/bluetag))
			M.Weaken(5)
	return 1

/obj/item/projectile/beam/lastertag/omni//A laser tag bolt that stuns EVERYONE
	name = "lasertag beam"
	icon_state = "omnilaser"
	pass_flags = PASS_FLAG_TABLE | PASS_FLAG_GLASS | PASS_FLAG_GRILLE
	damage = 0
	damage_type = BURN
	check_armour = "laser"

	muzzle_type = /obj/effect/projectile/laser_omni/muzzle
	tracer_type = /obj/effect/projectile/laser_omni/tracer
	impact_type = /obj/effect/projectile/laser_omni/impact

/obj/item/projectile/beam/lastertag/omni/on_hit(var/atom/target, var/blocked = 0)
	if(istype(target, /mob/living/carbon/human))
		var/mob/living/carbon/human/M = target
		if((istype(M.wear_suit, /obj/item/clothing/suit/bluetag))||(istype(M.wear_suit, /obj/item/clothing/suit/redtag)))
			M.Weaken(5)
	return 1

/obj/item/projectile/beam/sniper
	name = "sniper beam"
	icon_state = "xray"
	fire_sound = 'sound/weapons/marauder.ogg'
	damage = 50
	armor_penetration = 10
	stun = 3
	weaken = 3
	stutter = 3

	muzzle_type = /obj/effect/projectile/xray/muzzle
	tracer_type = /obj/effect/projectile/xray/tracer
	impact_type = /obj/effect/projectile/xray/impact

/obj/item/projectile/beam/stun
	name = "stun beam"
	icon_state = "stun"
	fire_sound = 'sound/weapons/Taser.ogg'
	check_armour = "energy"
	sharp = 0 //not a laser
	taser_effect = 1
	agony = 40
	damage_type = STUN

	muzzle_type = /obj/effect/projectile/stun/muzzle
	tracer_type = /obj/effect/projectile/stun/tracer
	impact_type = /obj/effect/projectile/stun/impact

/obj/item/projectile/beam/stun/heavy
	name = "heavy stun beam"
	agony = 60

/obj/item/projectile/beam/stun/shock
	name = "shock beam"
	damage_type = ELECTROCUTE
	damage = 10
	agony  = 5
	fire_sound='sound/weapons/pulse.ogg'

/obj/item/projectile/beam/stun/shock/heavy
	name = "heavy shock beam"
	damage = 20
	agony  = 10

/obj/item/projectile/beam/confuseray
	name = "disorientator ray"
	icon_state = "beam_grass"
	fire_sound='sound/effects/bang.ogg'
	damage = 2
	agony = 7
	sharp = FALSE
	damage_type = STUN
	penetration_modifier = 0
	var/potency_min = 4
	var/potency_max = 6

	muzzle_type = /obj/effect/projectile/stun/muzzle
	tracer_type = /obj/effect/projectile/stun/tracer
	impact_type = /obj/effect/projectile/stun/impact

/obj/item/projectile/beam/confuseray/on_hit(var/atom/target, var/blocked = 0)
	if(istype(target, /mob/living))
		var/mob/living/L = target
		var/potency = rand(potency_min, potency_max)
		L.confused += potency
		L.eye_blurry += potency
		if(L.confused >= 10)
			L.Stun(1)
			L.drop_l_hand()
			L.drop_r_hand()

	return 1

/obj/item/projectile/beam/incendiary_laser
	name = "scattered laser blast"
	icon_state = "beam_incen"
	fire_sound = 'sound/weapons/Taser.ogg'
	damage = 12
	agony = 8
	eyeblur = 8
	sharp = FALSE
	penetration_modifier = 0.1

	muzzle_type = /obj/effect/projectile/stun/muzzle
	tracer_type = /obj/effect/projectile/stun/tracer
	impact_type = /obj/effect/projectile/stun/impact

/obj/item/projectile/beam/incendiary_laser/on_hit(var/atom/target, var/blocked = 0)
	..()
	if(isliving(target))
		var/mob/living/L = target
		L.adjust_fire_stacks(rand(2,4))
		if(L.fire_stacks >= 3)
			L.IgniteMob()