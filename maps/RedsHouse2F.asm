RedsHouse2F_MapScripts:
	def_scene_scripts

	def_callbacks

RedsHouse2FN64Script:
	jumptext RedsHouse2FN64Text

RedsHouse2FPCScript:
	jumptext RedsHouse2FPCText

RedsHouse2FN64Text:
	text "<PLAYER> spielt"
	line "N64."

	para "Mach besser"
	line "weiter - du hast"
	cont "keine Zeit zu"
	cont "verlieren!"
	done

RedsHouse2FPCText:
	text "Es sieht aus, als"
	line "wäre er seit"
	cont "langer Zeit nicht"
	cont "mehr benutzt"
	cont "worden…"
	done

RedsHouse2F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  7,  0, REDS_HOUSE_1F, 3

	def_coord_events

	def_bg_events
	bg_event  3,  5, BGEVENT_READ, RedsHouse2FN64Script
	bg_event  0,  1, BGEVENT_READ, RedsHouse2FPCScript

	def_object_events
