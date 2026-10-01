	object_const_def
	const ROUTE20_SWIMMER_GIRL1
	const ROUTE20_SWIMMER_GIRL2
	const ROUTE20_SWIMMER_GUY

Route20_MapScripts:
	def_scene_scripts

	def_callbacks
	callback MAPCALLBACK_NEWMAP, Route20ClearRocksCallback

Route20ClearRocksCallback:
	setevent EVENT_CINNABAR_ROCKS_CLEARED
	endcallback

TrainerSwimmerfNicole:
	trainer SWIMMERF, NICOLE, EVENT_BEAT_SWIMMERF_NICOLE, SwimmerfNicoleSeenText, SwimmerfNicoleBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SwimmerfNicoleAfterBattleText
	waitbutton
	closetext
	end

TrainerSwimmerfLori:
	trainer SWIMMERF, LORI, EVENT_BEAT_SWIMMERF_LORI, SwimmerfLoriSeenText, SwimmerfLoriBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SwimmerfLoriAfterBattleText
	waitbutton
	closetext
	end

TrainerSwimmermCameron:
	trainer SWIMMERM, CAMERON, EVENT_BEAT_SWIMMERM_CAMERON, SwimmermCameronSeenText, SwimmermCameronBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext SwimmermCameronAfterBattleText
	waitbutton
	closetext
	end

CinnabarGymSign:
	jumptext CinnabarGymSignText

SwimmerfNicoleSeenText:
	text "Im Wasser fühle"
	line "ich mich so"
	cont "leicht."
	done

SwimmerfNicoleBeatenText:
	text "Oh, nein!"
	done

SwimmerfNicoleAfterBattleText:
	text "Beim Schwimmen"
	line "wird der gesamte"

	para "Körper trainiert."
	line "Schwimmen ist"
	cont "gesund."
	done

SwimmerfLoriSeenText:
	text "Du besitzt eine"
	line "umwerfende Anzahl"

	para "ARENA-ORDEN. Lass"
	line "uns kämpfen!"
	done

SwimmerfLoriBeatenText:
	text "Nein!"
	done

SwimmerfLoriAfterBattleText:
	text "SURFER ist nicht"
	line "mehr die einzige"
	cont "VM, die du im"
	cont "Wasser einsetzen"
	cont "kannst."
	done

SwimmermCameronSeenText:
	text "Ich denke es ist"
	line "unmöglich, den"

	para "ganzen Weg nach"
	line "JOHTO zu"
	cont "schwimmen."
	done

SwimmermCameronBeatenText:
	text "Yippie!"
	done

SwimmermCameronAfterBattleText:
	text "Ich schwimme auch"
	line "in Teichen und"
	cont "Flüssen."
	done

CinnabarGymSignText:
	text "Was steht auf"
	line "diesem Schild?"

	para "PKMN-ARENA der"
	line "ZINNOBERINSEL"

	para "LEITUNG: PYRO"
	done

Route20_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 38,  7, SEAFOAM_GYM, 1

	def_coord_events

	def_bg_events
	bg_event 37, 11, BGEVENT_READ, CinnabarGymSign

	def_object_events
	object_event 52,  8, SPRITE_SWIMMER_GIRL, SPRITEMOVEDATA_SPINRANDOM_FAST, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_TRAINER, 3, TrainerSwimmerfNicole, -1
	object_event 45, 13, SPRITE_SWIMMER_GIRL, SPRITEMOVEDATA_SPINRANDOM_FAST, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_TRAINER, 3, TrainerSwimmerfLori, -1
	object_event 12, 13, SPRITE_SWIMMER_GUY, SPRITEMOVEDATA_SPINRANDOM_FAST, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 3, TrainerSwimmermCameron, -1
