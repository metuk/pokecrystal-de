	object_const_def
	const ROUTE2GATE_SCIENTIST

Route2Gate_MapScripts:
	def_scene_scripts

	def_callbacks

Route2GateScientistScript:
	jumptextfaceplayer Route2GateScientistText

Route2GateScientistText:
	text "Bist du <PLAY_G>?"

	para "Ich bin der"
	line "ASSISTENT von"
	cont "PROF. EICH."

	para "Ich wusste nicht,"
	line "dass du hier"
	cont "bist."

	para "PROF. EICHs LABOR"
	line "ist gleich hier"
	cont "in ALABASTIA."
	done

Route2Gate_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  4,  0, ROUTE_2, 3
	warp_event  5,  0, ROUTE_2, 4
	warp_event  4,  7, ROUTE_2, 2
	warp_event  5,  7, ROUTE_2, 2

	def_coord_events

	def_bg_events

	def_object_events
	object_event  6,  4, SPRITE_SCIENTIST, SPRITEMOVEDATA_WALK_UP_DOWN, 0, 2, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, Route2GateScientistScript, -1
