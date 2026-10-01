	object_const_def
	const HALLOFFAME_LANCE

HallOfFame_MapScripts:
	def_scene_scripts
	scene_script HallOfFameEnterScene, SCENE_HALLOFFAME_ENTER
	scene_script HallOfFameNoopScene,  SCENE_HALLOFFAME_NOOP

	def_callbacks

HallOfFameEnterScene:
	sdefer HallOfFameEnterScript
	end

HallOfFameNoopScene:
	end

HallOfFameEnterScript:
	follow HALLOFFAME_LANCE, PLAYER
	applymovement HALLOFFAME_LANCE, HallOfFame_WalkUpWithLance
	stopfollow
	turnobject PLAYER, RIGHT
	opentext
	writetext HallOfFame_LanceText
	waitbutton
	closetext
	turnobject HALLOFFAME_LANCE, UP
	applymovement PLAYER, HallOfFame_SlowlyApproachMachine
	setscene SCENE_HALLOFFAME_NOOP
	pause 15
	setval HEALMACHINE_HALL_OF_FAME
	special HealMachineAnim
	setevent EVENT_BEAT_ELITE_FOUR
	setevent EVENT_TELEPORT_GUY
	setevent EVENT_RIVAL_SPROUT_TOWER
	clearevent EVENT_RED_IN_MT_SILVER
	setevent EVENT_OLIVINE_PORT_SPRITES_BEFORE_HALL_OF_FAME
	clearevent EVENT_OLIVINE_PORT_SPRITES_AFTER_HALL_OF_FAME
	setmapscene SPROUT_TOWER_3F, SCENE_SPROUTTOWER3F_NOOP
	special HealParty
	checkevent EVENT_GOT_SS_TICKET_FROM_ELM
	iftrue .SkipPhoneCall
	specialphonecall SPECIALCALL_SSTICKET
.SkipPhoneCall:
	halloffame
	end

HallOfFame_WalkUpWithLance:
	step UP
	step UP
	step UP
	step UP
	step UP
	step UP
	step UP
	step UP
	step RIGHT
	turn_head LEFT
	step_end

HallOfFame_SlowlyApproachMachine:
	slow_step UP
	step_end

HallOfFame_LanceText:
	text "SIEGFRIED: Ich war"
	line "schon lange nicht"
	cont "mehr hier."

	para "Hier werden die"
	line "LIGA-CHAMPS"

	para "für alle Ewigkeit"
	line "gewürdigt."

	para "Ihre mutigen #-"
	line "MON sind auch"
	cont "aufgeführt."

	para "Hier und heute"
	line "wurden wir Zeuge"

	para "des Aufstiegs ei-"
	line "nes neuen LIGA-"
	cont "CHAMPS -- eines"
	cont "Trainers, der"

	para "Leidenschaft für"
	line "und Vertrauen in"
	cont "seine #MON hat."

	para "Ein Trainer,"
	line "dessen Erfolg auf"

	para "Ausdauer und"
	line "Entschlossenheit"
	cont "basiert."

	para "Der neue LIGA-"
	line "CHAMP, der"

	para "alle Zeichen von"
	line "Größe in sich"
	cont "vereint!"

	para "<PLAY_G>, darf ich"
	line "dich und deine"

	para "Partner als"
	line "CHAMPS"
	cont "eintragen?"
	done

HallOfFame_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  4, 13, LANCES_ROOM, 3
	warp_event  5, 13, LANCES_ROOM, 4

	def_coord_events

	def_bg_events

	def_object_events
	object_event  4, 12, SPRITE_LANCE, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, ObjectEvent, -1
