	object_const_def
	const CERULEANGYM_ROCKET
	const CERULEANGYM_MISTY
	const CERULEANGYM_SWIMMER_GIRL1
	const CERULEANGYM_SWIMMER_GIRL2
	const CERULEANGYM_SWIMMER_GUY
	const CERULEANGYM_GYM_GUIDE

CeruleanGym_MapScripts:
	def_scene_scripts
	scene_script CeruleanGymNoopScene,         SCENE_CERULEANGYM_NOOP
	scene_script CeruleanGymGruntRunsOutScene, SCENE_CERULEANGYM_GRUNT_RUNS_OUT

	def_callbacks

CeruleanGymNoopScene:
	end

CeruleanGymGruntRunsOutScene:
	sdefer CeruleanGymGruntRunsOutScript
	end

CeruleanGymGruntRunsOutScript:
	applymovement CERULEANGYM_ROCKET, CeruleanGymGruntRunsDownMovement
	playsound SFX_TACKLE
	applymovement CERULEANGYM_ROCKET, CeruleanGymGruntRunsIntoYouMovement
	playmusic MUSIC_ROCKET_ENCOUNTER
	opentext
	writetext CeruleanGymGruntIntroText
	waitbutton
	closetext
	showemote EMOTE_SHOCK, CERULEANGYM_ROCKET, 15
	applymovement CERULEANGYM_ROCKET, CeruleanGymGruntBacksAwayMovement
	opentext
	writetext CeruleanGymGruntBigMistakeText
	waitbutton
	closetext
	applymovement CERULEANGYM_ROCKET, CeruleanGymGruntMovesCloseMovement
	opentext
	writetext CeruleanGymGruntByeText
	waitbutton
	closetext
	applymovement CERULEANGYM_ROCKET, CeruleanGymGruntRunsOutMovement
	playsound SFX_EXIT_BUILDING
	disappear CERULEANGYM_ROCKET
	setevent EVENT_MET_ROCKET_GRUNT_AT_CERULEAN_GYM
	clearevent EVENT_ROUTE_24_ROCKET
	clearevent EVENT_ROUTE_25_MISTY_BOYFRIEND
	setscene SCENE_CERULEANGYM_NOOP
	setmapscene ROUTE_25, SCENE_ROUTE25_MISTYS_DATE
	setmapscene POWER_PLANT, SCENE_POWERPLANT_NOOP
	waitsfx
	special RestartMapMusic
	pause 15
	turnobject PLAYER, DOWN
	pause 15
	end

CeruleanGymMistyScript:
	faceplayer
	opentext
	checkflag ENGINE_CASCADEBADGE
	iftrue .FightDone
	writetext MistyIntroText
	waitbutton
	closetext
	winlosstext MistyWinLossText, 0
	loadtrainer MISTY, MISTY1
	startbattle
	reloadmapafterbattle
	setevent EVENT_BEAT_MISTY
	setevent EVENT_BEAT_SWIMMERF_DIANA
	setevent EVENT_BEAT_SWIMMERF_BRIANA
	setevent EVENT_BEAT_SWIMMERM_PARKER
	opentext
	writetext ReceivedCascadeBadgeText
	playsound SFX_GET_BADGE
	waitsfx
	setflag ENGINE_CASCADEBADGE
.FightDone:
	writetext MistyFightDoneText
	waitbutton
	closetext
	end

TrainerSwimmerfDiana:
	trainer SWIMMERF, DIANA, EVENT_BEAT_SWIMMERF_DIANA, SwimmerfDianaSeenText, SwimmerfDianaBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SwimmerfDianaAfterBattleText
	waitbutton
	closetext
	end

TrainerSwimmerfBriana:
	trainer SWIMMERF, BRIANA, EVENT_BEAT_SWIMMERF_BRIANA, SwimmerfBrianaSeenText, SwimmerfBrianaBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SwimmerfBrianaAfterBattleText
	waitbutton
	closetext
	end

TrainerSwimmermParker:
	trainer SWIMMERM, PARKER, EVENT_BEAT_SWIMMERM_PARKER, SwimmermParkerSeenText, SwimmermParkerBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SwimmermParkerAfterBattleText
	waitbutton
	closetext
	end

CeruleanGymGuideScript:
	faceplayer
	opentext
	checkevent EVENT_BEAT_MISTY
	iftrue .CeruleanGymGuideWinScript
	writetext CeruleanGymGuideText
	waitbutton
	closetext
	end

.CeruleanGymGuideWinScript:
	writetext CeruleanGymGuideWinText
	waitbutton
	closetext
	end

CeruleanGymHiddenMachinePart:
	hiddenitem MACHINE_PART, EVENT_FOUND_MACHINE_PART_IN_CERULEAN_GYM

CeruleanGymStatue1:
	checkevent EVENT_TRAINERS_IN_CERULEAN_GYM
	iffalse CeruleanGymStatue
	opentext
	writetext CeruleanGymNote1Text
	waitbutton
	closetext
	end

CeruleanGymStatue2:
	checkevent EVENT_TRAINERS_IN_CERULEAN_GYM
	iffalse CeruleanGymStatue
	opentext
	writetext CeruleanGymNote2Text
	waitbutton
	closetext
	end

CeruleanGymStatue:
	checkflag ENGINE_CASCADEBADGE
	iftrue .Beaten
	jumpstd GymStatue1Script
.Beaten:
	gettrainername STRING_BUFFER_4, MISTY, MISTY1
	jumpstd GymStatue2Script

CeruleanGymGruntRunsDownMovement:
	big_step DOWN
	big_step DOWN
	big_step DOWN
	big_step DOWN
	step_end

CeruleanGymGruntRunsOutMovement:
	big_step RIGHT
	big_step DOWN
	step_end

CeruleanGymGruntRunsIntoYouMovement:
	fix_facing
	set_sliding
	jump_step UP
	remove_sliding
	remove_fixed_facing
	step_sleep 8
	step_sleep 8
	step DOWN
	step DOWN
	step_end

CeruleanGymGruntMovesCloseMovement:
	big_step DOWN
	step_end

CeruleanGymGruntBacksAwayMovement:
	fix_facing
	slow_step UP
	remove_fixed_facing
	step_end

CeruleanGymGruntIntroText:
	text "Ups! Tut ja so"
	line "Leid mir! Du nicht"
	cont "verletzt, du O.K.?"

	para "Ich schwer"
	line "beschäftigt. Nicht"
	cont "Zeit für Reden."
	cont "Nicht gut, wenn"
	cont "ich gesehen"
	cont "werden."
	done

CeruleanGymGruntBigMistakeText:
	text "Oh nein! Du mich"
	line "schon hast gese-"
	cont "hen! Ich großes"
	cont "Fehler gemacht!"
	done

CeruleanGymGruntByeText:
	text "He, du! Du ver-"
	line "gessen, dass du"

	para "mich gesehen, ja?"
	line "Du nichts sehen,"

	para "hören und wissen!"
	line "Tschüss!"

	para "Und Tschüss!"
	done

CeruleanGymNote1Text:
	text "Ich bin leider"
	line "eine Zeit lang"
	cont "unterwegs. ARENA-"
	cont "LEITERIN, MISTY."
	done

CeruleanGymNote2Text:
	text "Nachdem MISTY"
	line "nicht hier ist,"
	cont "sind wir TRAINER"
	cont "auch nicht da."
	done

MistyIntroText:
	text "MISTY: Ich habe"
	line "dich erwartet, du"
	cont "Nervensäge!"

	para "Du hast zwar"
	line "viele ORDEN von"

	para "JOHTO, aber unter-"
	line "schätze mich"
	cont "lieber nicht!"

	para "Meine Wasser-"
	line "#MON sind hart!"
	done

MistyWinLossText:
	text "MISTY: Du bist"
	line "wirklich gut…"

	para "Ich gebe zu, dass"
	line "du sehr geschickt"
	cont "bist…"

	para "Hier hast du den"
	line "QUELLORDEN."
	done

ReceivedCascadeBadgeText:
	text "<PLAYER> erhält"
	line "QUELLORDEN."
	done

MistyFightDoneText:
	text "MISTY: Gibt es"
	line "viele starke"
	cont "Trainer wie dich"
	cont "in JOHTO?"

	para "Eines Tages werde"
	line "ich mich aufmachen"

	para "und gegen einige"
	line "ausgebildete"
	cont "Trainer kämpfen."
	done

SwimmerfDianaSeenText:
	text "Es tut mir Leid,"
	line "dass ich so lange"
	cont "weg war. Lass uns"
	cont "anfangen!"
	done

SwimmerfDianaBeatenText:
	text "Ich gebe auf! Du"
	line "hast gewonnen!"
	done

SwimmerfDianaAfterBattleText:
	text "Ich werde in Ruhe"
	line "vor mich hin-"
	cont "schwimmen."
	done

SwimmerfBrianaSeenText:
	text "Ich hoffe, meine"
	line "elegante Art zu"
	cont "schwimmen zermürbt"
	cont "dich nicht."
	done

SwimmerfBrianaBeatenText:
	text "Oh, du hast mich"
	line "ohne viel Auf-"
	cont "hebens erledigt…"
	done

SwimmerfBrianaAfterBattleText:
	text "Freue dich nicht"
	line "zu sehr über"
	cont "deinen Sieg."

	para "MISTY wird dich"
	line "fertig machen,"

	para "wenn du selbst-"
	line "gefällig wirst."
	done

SwimmermParkerSeenText:
	text "Glugger…"

	para "Erster! Fang"
	line "mich doch!"
	done

SwimmermParkerBeatenText:
	text "Das darf nicht"
	line "wahr sein…"
	done

SwimmermParkerAfterBattleText:
	text "MISTY ist in den"
	line "letzten Jahren"
	cont "immer besser"
	cont "geworden."

	para "Sei auf der Hut,"
	line "sonst wirst du"
	cont "platt gemacht!"
	done

CeruleanGymGuideText:
	text "He! Du CHAMP"
	line "in spe!"

	para "Nachdem MISTY weg"
	line "war, bin ich auch"

	para "los, um Spaß zu"
	line "haben. Hi-hi-hi."
	done

CeruleanGymGuideWinText:
	text "Oje, du bist"
	line "ganz schön hart."

	para "Das war wie immer"
	line "ein super Kampf!"
	done

CeruleanGym_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  4, 15, CERULEAN_CITY, 5
	warp_event  5, 15, CERULEAN_CITY, 5

	def_coord_events

	def_bg_events
	bg_event  3,  8, BGEVENT_ITEM, CeruleanGymHiddenMachinePart
	bg_event  2, 13, BGEVENT_READ, CeruleanGymStatue1
	bg_event  6, 13, BGEVENT_READ, CeruleanGymStatue2

	def_object_events
	object_event  4, 10, SPRITE_ROCKET, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, ObjectEvent, EVENT_CERULEAN_GYM_ROCKET
	object_event  5,  3, SPRITE_MISTY, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, CeruleanGymMistyScript, EVENT_TRAINERS_IN_CERULEAN_GYM
	object_event  4,  6, SPRITE_SWIMMER_GIRL, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_TRAINER, 3, TrainerSwimmerfDiana, EVENT_TRAINERS_IN_CERULEAN_GYM
	object_event  1,  9, SPRITE_SWIMMER_GIRL, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_TRAINER, 1, TrainerSwimmerfBriana, EVENT_TRAINERS_IN_CERULEAN_GYM
	object_event  8,  9, SPRITE_SWIMMER_GUY, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 3, TrainerSwimmermParker, EVENT_TRAINERS_IN_CERULEAN_GYM
	object_event  7, 13, SPRITE_GYM_GUIDE, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, CeruleanGymGuideScript, EVENT_TRAINERS_IN_CERULEAN_GYM
