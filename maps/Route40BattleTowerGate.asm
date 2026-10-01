	object_const_def
	const ROUTE40BATTLETOWERGATE_ROCKER
	const ROUTE40BATTLETOWERGATE_TWIN

Route40BattleTowerGate_MapScripts:
	def_scene_scripts

	def_callbacks
	callback MAPCALLBACK_OBJECTS, RouteBattleTowerGateShowSailorCallback

RouteBattleTowerGateShowSailorCallback:
	clearevent EVENT_BATTLE_TOWER_OPEN_CIVILIANS
	endcallback

Route40BattleTowerGateRockerScript:
	jumptextfaceplayer Route40BattleTowerGateRockerText

Route40BattleTowerGateTwinScript:
	jumptextfaceplayer Route40BattleTowerGateTwinText

Route40BattleTowerGateUnusedText1: ; unreferenced
	text "Bist du auch ge-"
	line "kommen, um den"
	cont "DUELLTURM zu"
	cont "sehen?"

	para "Aber du kannst"
	line "noch nicht hinein."
	done

Route40BattleTowerGateUnusedText2: ; unreferenced
	text "Der DUELLTURM ist"
	line "geöffnet."

	para "Ich möchte hinein,"
	line "aber ich habe mir"

	para "noch keinen guten"
	line "Spruch ausgedacht,"
	cont "wenn ich gewinne."
	done

Route40BattleTowerGateRockerText:
	text "Gehst du zum"
	line "DUELLTURM?"

	para "Das ist ein Ge-"
	line "heimnis, aber du"

	para "erhältst spezielle"
	line "Preise, wenn du"
	cont "oft gewinnst."
	done

Route40BattleTowerGateUnusedText3: ; unreferenced
	text "Ich trainiere"
	line "meine #MON,"

	para "damit ich bereit"
	line "für den DUELLTURM"
	cont "bin."
	done

Route40BattleTowerGateTwinText:
	text "Die Level der"
	line "#MON, die ich"

	para "einsetzen möchte,"
	line "sind unter-"
	cont "schiedlich."

	para "Ich muss sie jetzt"
	line "trainieren!"
	done

Route40BattleTowerGate_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  4,  7, ROUTE_40, 1
	warp_event  5,  7, ROUTE_40, 1
	warp_event  4,  0, BATTLE_TOWER_OUTSIDE, 1
	warp_event  5,  0, BATTLE_TOWER_OUTSIDE, 2

	def_coord_events

	def_bg_events

	def_object_events
	object_event  3,  3, SPRITE_ROCKER, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, Route40BattleTowerGateRockerScript, EVENT_BATTLE_TOWER_OPEN_CIVILIANS
	object_event  7,  5, SPRITE_TWIN, SPRITEMOVEDATA_WALK_UP_DOWN, 0, 1, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, Route40BattleTowerGateTwinScript, -1
