var/list/gyrotrons = list()

/obj/machinery/power/emitter/gyrotron
	name = "gyrotron"
	icon = 'icons/obj/machines/power/fusion.dmi'
	desc = "It is a heavy duty industrial gyrotron suited for powering fusion reactors."
	icon_state = "emitter-off"
	req_access = list(ACCESS_ENGINEERING_MAIN)
	use_power = USE_POWER_IDLE
	active_power_usage = 50000

	circuit = /obj/item/circuitboard/gyrotron

	var/id_tag
	var/rate = 3
	var/mega_energy = 1


/obj/machinery/power/emitter/gyrotron/anchored
	anchored = 1
	state = 2

/obj/machinery/power/emitter/gyrotron/Initialize(mapload)
	gyrotrons += src
	active_power_usage = mega_energy * 50000
	. = ..()

/obj/machinery/power/emitter/gyrotron/Destroy()
	gyrotrons -= src
	return ..()

/obj/machinery/power/emitter/gyrotron/process(delta_time)
	active_power_usage = mega_energy * 50000
	. = ..()

/obj/machinery/power/emitter/gyrotron/get_rand_burst_delay()
	return rate * 10

/obj/machinery/power/emitter/gyrotron/get_burst_delay()
	return rate * 10

/obj/machinery/power/emitter/gyrotron/get_emitter_beam()
	var/obj/item/projectile/beam/emitter/E = ..()
	E.damage = mega_energy * 50
	return E

/obj/machinery/power/emitter/gyrotron/update_icon()
	if (active && powernet && avail(active_power_usage * 0.001))
		icon_state = "emitter-on"
	else
		icon_state = "emitter-off"

/obj/machinery/power/emitter/gyrotron/attackby(var/obj/item/W, var/mob/user)
	if(istype(W, /obj/item/multitool))
		var/new_ident = input("Enter a new ident tag.", "Gyrotron", id_tag) as null|text
		if(new_ident && user.Adjacent(src))
			id_tag = new_ident
		return

	if(default_deconstruction_screwdriver(user, W))
		return
	if(default_deconstruction_crowbar(user, W))
		return
	if(default_part_replacement(user, W))
		return

	return ..()
