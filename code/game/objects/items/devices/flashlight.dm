/obj/item/device/flashlight
	name = "flashlight"
	desc = "A hand-held emergency light."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "flashlight"
	item_state = "flashlight"
	w_class = ITEM_SIZE_SMALL
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT

	matter = list(MATERIAL_STEEL = 50,MATERIAL_GLASS = 20)

	action_button_name = "Toggle Flashlight"
	var/on = 0
	var/brightness_on = 6	//range of light when on
	var/activation_sound = 'sound/effects/flashlight.ogg'
	var/flashlight_power	//luminosity of light when on, can be negative
	var/obj/item/weapon/cell/device/flashlight_cell = null	//device cell slot, empty by default
	var/power_usage = 22.5	//450 = 1% per second on 25Wh device cells

/obj/item/device/flashlight/Initialize()
	. = ..()
	update_icon()

/obj/item/device/flashlight/update_icon()
	if(on)
		icon_state = "[initial(icon_state)]-on"
		if(flashlight_power)
			set_light(l_range = brightness_on, l_power = flashlight_power)
		else
			set_light(brightness_on)
	else
		icon_state = "[initial(icon_state)]"
		set_light(0)

/obj/item/device/flashlight/examine(mob/user)
	if(..(user, 0))
		if (!power_usage)
			return
		if(flashlight_cell)
			to_chat(user,"<span class='notice'>There is about [round(src.flashlight_cell.percent(), 1)]% charge remaining.</span>")
		else
			to_chat(user,"<span class='warning'>\The [src] is missing a battery!</span>")

/obj/item/device/flashlight/proc/Deactivate()
	playsound(src.loc, activation_sound, 75, 1)
	on = 0
	STOP_PROCESSING(SSobj, src)
	update_icon()

/obj/item/device/flashlight/Process(mob/user)
	if(!flashlight_cell)
		Deactivate()
		return
	if(!flashlight_cell.checked_use(power_usage * CELLRATE))	//if this passes, there's not enough power in the battery
		Deactivate()
		to_chat(user,"<span class='warning'>\The [src] flickers briefly as the last of its charge is depleted.</span>")
		return

/obj/item/device/flashlight/attackby(var/obj/item/I, var/mob/user as mob)
	if(istype(I, /obj/item/weapon/screwdriver))
		if(power_usage && flashlight_cell)	//if contains powercell & uses power
			flashlight_cell.update_icon()
			flashlight_cell.dropInto(loc)
			flashlight_cell = null
			to_chat(user, "<span class='notice'>You remove \the [flashlight_cell] from \the [src].</span>")
		else if (power_usage && !flashlight_cell)	//does not contains cell, but still uses power
			to_chat(user, "<span class='notice'>There's no battery in \the [src].</span>")
		else	//no chat message for lights that don't use power
			return
	if(power_usage && !flashlight_cell && istype(I, /obj/item/weapon/cell/device) && user.unEquip(I, target = src))
		if (flashlight_cell)
			to_chat(user, "<span class='notice'>\The [src] already has a battery installed.</span>")
		if(power_usage && !flashlight_cell && user.unEquip(I))
			I.forceMove(src)
			flashlight_cell = I
			to_chat(user, "<span class='notice'>You install [I] into \the [src].</span>")
			update_icon()
		else	//no message for trying to put batteries in glowsticks
			return

/obj/item/device/flashlight/attack_self(mob/user)
	if(!isturf(user.loc))
		to_chat(user, "You cannot turn the light on while in this [user.loc].")	//To prevent some lighting anomalities.
		return 0
	if(on)
		Deactivate()
	else
		if(flashlight_cell)
			if(!flashlight_cell.check_charge(power_usage * CELLRATE))
				to_chat(user, "<span class='warning'>\The [src] refuses to operate.</span> ")
				return
			playsound(src.loc, activation_sound, 75, 1)
			on=1
			START_PROCESSING(SSobj, src)
			update_icon()
			user.update_action_buttons()
		else
			to_chat(user, "<span class='warning'>\The [src] does not have a battery installed.</span>")

/obj/item/device/flashlight/emp_act(severity)
	if(flashlight_cell != null)	//only flashlights with cells installed are affected
		Deactivate()
		flashlight_cell.emp_act(severity)
	..()

/obj/item/device/flashlight/attack(mob/living/M as mob, mob/living/user as mob)
	add_fingerprint(user)
	if(on && user.zone_sel.selecting == BP_EYES)

		if((CLUMSY in user.mutations) && prob(50))	//too dumb to use flashlight properly
			return ..()	//just hit them in the head

		var/mob/living/carbon/human/H = M	//mob has protective eyewear
		if(istype(H))
			for(var/obj/item/clothing/C in list(H.head,H.wear_mask,H.glasses))
				if(istype(C) && (C.body_parts_covered & EYES))
					to_chat(user, "<span class='warning'>You're going to need to remove [C] first.</span>")
					return

			var/obj/item/organ/vision
			if(!H.species.vision_organ || !H.should_have_organ(H.species.vision_organ))
				to_chat(user, "<span class='warning'>You can't find anything on [H] to direct [src] into!</span>")
				return

			vision = H.internal_organs_by_name[H.species.vision_organ]
			if(!vision)
				vision = H.species.has_organ[H.species.vision_organ]
				to_chat(user, "<span class='warning'>\The [H] is missing \his [initial(vision.name)]!</span>")
				return

			user.visible_message("<span class='notice'>\The [user] directs [src] into [M]'s [vision.name].</span>", \
								 "<span class='notice'>You direct [src] into [M]'s [vision.name].</span>")

			inspect_vision(vision, user)

			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN) //can be used offensively
			M.flash_eyes()
	else
		return ..()

/obj/item/device/flashlight/proc/inspect_vision(obj/item/organ/vision, mob/living/user)
	var/mob/living/carbon/human/H = vision.owner

	if(H == user)	//can't look into your own eyes buster
		return

	if(vision.robotic < ORGAN_ROBOT )

		if(vision.owner.stat == DEAD || H.blinded)	//mob is dead or fully blind
			to_chat(user, "<span class='warning'>\The [H]'s pupils do not react to the light!</span>")
			return
		if(XRAY in H.mutations)
			to_chat(user, "<span class='notice'>\The [H]'s pupils give an eerie glow!</span>")
		if(vision.damage)
			to_chat(user, "<span class='warning'>There's visible damage to [H]'s [vision.name]!</span>")
		else if(H.eye_blurry)
			to_chat(user, "<span class='notice'>\The [H]'s pupils react slower than normally.</span>")
		if(H.getBrainLoss() > 15)
			to_chat(user, "<span class='notice'>There's visible lag between left and right pupils' reactions.</span>")

		var/list/pinpoint = list(/datum/reagent/tramadol/oxycodone=1,/datum/reagent/tramadol=5)
		var/list/dilating = list(/datum/reagent/space_drugs=5,/datum/reagent/mindbreaker=1,/datum/reagent/adrenaline=1)
		if(H.reagents.has_any_reagent(pinpoint) || H.ingested.has_any_reagent(pinpoint))
			to_chat(user, "<span class='notice'>\The [H]'s pupils are already pinpoint and cannot narrow any more.</span>")
		else if(H.shock_stage >= 30 || H.reagents.has_any_reagent(dilating) || H.ingested.has_any_reagent(dilating))
			to_chat(user, "<span class='notice'>\The [H]'s pupils narrow slightly, but are still very dilated.</span>")
		else
			to_chat(user, "<span class='notice'>\The [H]'s pupils narrow.</span>")

	//if someone wants to implement inspecting robot eyes here would be the place to do it.

/obj/item/device/flashlight/flashdark
	name = "flashdark"
	desc = "A strange device manufactured with mysterious elements that somehow emits darkness. Or maybe it just sucks in light? Nobody knows for sure."
	icon_state = "flashdark"
	item_state = "flashdark"
	w_class = ITEM_SIZE_NORMAL
	brightness_on = 8
	flashlight_power = -6

/obj/item/device/flashlight/pen
	name = "penlight"
	desc = "A pen-sized light, used by medical staff."
	icon_state = "penlight"
	item_state = ""
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_EARS
	brightness_on = 2
	power_usage = 5
	w_class = ITEM_SIZE_TINY
	matter = list(MATERIAL_STEEL = 30,MATERIAL_GLASS = 10)

/obj/item/device/flashlight/maglight
	name = "maglight"
	desc = "A very, very heavy duty flashlight."
	icon_state = "maglight"
	item_state = "maglight"
	force = 10
	attack_verb = list ("smacked", "thwacked", "thunked")
	matter = list(MATERIAL_STEEL = 200,MATERIAL_GLASS = 50)
	hitsound = "swing_hit"

/obj/item/device/flashlight/drone
	name = "low-power flashlight"
	desc = "A miniature lamp, that might be used by small robots."
	icon_state = "penlight"
	item_state = ""
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	brightness_on = 2
	power_usage = 0
	w_class = ITEM_SIZE_TINY


// the desk lamps are a bit special
/obj/item/device/flashlight/lamp
	name = "desk lamp"
	desc = "A desk lamp with an adjustable mount."
	icon_state = "lamp"
	item_state = "lamp"
	brightness_on = 2		//smaller lit area than flashlights
	flashlight_power = 6	//but the small area is lit very well
	w_class = ITEM_SIZE_LARGE
	obj_flags = OBJ_FLAG_CONDUCTIBLE


// green-shaded desk lamp
/obj/item/device/flashlight/lamp/green
	desc = "A classic green-shaded desk lamp."
	icon_state = "lampgreen"
	item_state = "lampgreen"
	light_color = "#ffc58f"

/obj/item/device/flashlight/lamp/verb/toggle_light()
	set name = "Toggle light"
	set category = "Object"
	set src in oview(1)

	if(!usr.stat)
		attack_self(usr)

// FLARES

/obj/item/device/flashlight/flare
	name = "flare"
	desc = "A red standard-issue flare. There are instructions on the side reading 'pull cord, make light'."
	w_class = ITEM_SIZE_TINY
	brightness_on = 8
	light_power = 3
	light_color = "#e58775"
	icon_state = "flare"
	item_state = "flare"
	action_button_name = null
	var/fuel = 0
	var/on_damage = 7
	var/produce_heat = 1500
	power_usage = 0
	activation_sound = 'sound/effects/flare.ogg'

/obj/item/device/flashlight/flare/New()
	fuel = rand(900, 1800)	//lasts 15-30 minutes
	..()

/obj/item/device/flashlight/flare/Process()
	var/turf/pos = get_turf(src)
	if(pos)
		pos.hotspot_expose(produce_heat, 5)
	fuel = max(fuel - 1, 0)
	if(!fuel || !on)
		turn_off()
		if(!fuel)
			src.icon_state = "[initial(icon_state)]-empty"
		STOP_PROCESSING(SSobj, src)

/obj/item/device/flashlight/flare/proc/turn_off()
	on = 0
	src.force = initial(src.force)
	src.damtype = initial(src.damtype)
	update_icon()

/obj/item/device/flashlight/flare/attack_self(mob/user)
	if(turn_on(user))
		user.visible_message("<span class='notice'>\The [user] activates \the [src].</span>", "<span class='notice'>You pull the cord on the flare, activating it!</span>")

/obj/item/device/flashlight/flare/proc/turn_on(var/mob/user)
	if(on)
		return FALSE
	if(!fuel)
		if(user)
			to_chat(user, "<span class='notice'>It's burnt out.</span>")
		return FALSE
	on = TRUE
	force = on_damage
	damtype = "fire"
	hitsound = "sound/effects/woodhit.ogg"
	START_PROCESSING(SSobj, src)
	update_icon()
	return 1

//Glowsticks
/obj/item/device/flashlight/glowstick
	name = "green glowstick"
	desc = "A military-grade glowstick."
	w_class = 2.0
	brightness_on = 5
	light_power = 2
	color = "#49f37c"
	icon_state = "glowstick"
	item_state = "glowstick"
	action_button_name = null
	randpixel = 12
	var/fuel = 0
	power_usage = 0
	activation_sound = null

/obj/item/device/flashlight/glowstick/New()
	fuel = rand(86000, 90000) //lasts between 24 - 25 hours, seems fair for persistence
	light_color = color
	..()

/obj/item/device/flashlight/glowstick/Destroy()
	. = ..()
	STOP_PROCESSING(SSobj, src)

/obj/item/device/flashlight/glowstick/Process()
	fuel = max(fuel - 1, 0)
	if(!fuel)
		turn_off()
		STOP_PROCESSING(SSobj, src)
		update_icon()

/obj/item/device/flashlight/glowstick/proc/turn_off()
	on = 0
	update_icon()

/obj/item/device/flashlight/glowstick/update_icon()
	item_state = "glowstick"
	overlays.Cut()
	if(!fuel)
		icon_state = "glowstick-empty"
		set_light(0)
	else if (on)
		var/image/I = overlay_image(icon,"glowstick-on",color)
		I.blend_mode = BLEND_ADD
		overlays += I
		item_state = "glowstick-on"
		set_light(brightness_on)
	else
		icon_state = "glowstick"
	var/mob/M = loc
	if(istype(M))
		if(M.l_hand == src)
			M.update_inv_l_hand()
		if(M.r_hand == src)
			M.update_inv_r_hand()

/obj/item/device/flashlight/glowstick/attack_self(mob/user)

	if(!fuel)
		to_chat(user,"<span class='notice'>\The [src] is spent.</span>")
		return
	if(on)
		to_chat(user,"<span class='notice'>\The [src] is already lit.</span>")
		return
	user.visible_message("<span class='notice'>[user] cracks and shakes the glowstick.</span>", "<span class='notice'>You crack and shake the glowstick, turning it on!</span>")
	on = TRUE
	START_PROCESSING(SSobj, src)
	update_icon()

/obj/item/device/flashlight/glowstick/red
	name = "red glowstick"
	color = "#fc0f29"

/obj/item/device/flashlight/glowstick/blue
	name = "blue glowstick"
	color = "#599dff"

/obj/item/device/flashlight/glowstick/orange
	name = "orange glowstick"
	color = "#fa7c0b"

/obj/item/device/flashlight/glowstick/yellow
	name = "yellow glowstick"
	color = "#fef923"

/obj/item/device/flashlight/glowstick/random
	name = "glowstick"
	desc = "A party-grade glowstick."
	color = "#ff00ff"

/obj/item/device/flashlight/glowstick/random/New()
	color = rgb(rand(50,255),rand(50,255),rand(50,255))
	..()

/obj/item/device/flashlight/slime
	gender = PLURAL
	name = "glowing slime extract"
	desc = "A glowing ball of what appears to be amber."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "floor1"	//not a slime extract sprite but... something close enough!
	item_state = "slime"
	action_button_name = null
	w_class = ITEM_SIZE_TINY
	flashlight_cell = null
	power_usage = 0
	brightness_on = 4
	color = "#ffc200"	//amber
	light_color = "#ffc200"
	on = 1	//Bio-luminesence has one setting, on.

/obj/item/device/flashlight/slime/New()
	..()
	set_light(brightness_on)

/obj/item/device/flashlight/slime/update_icon()
	return

/obj/item/device/flashlight/slime/attack_self(mob/user)
	return	//Bio-luminescence does not toggle.