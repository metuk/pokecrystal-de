	object_const_def
	const CELADONCITY_FISHER
	const CELADONCITY_POLIWAG
	const CELADONCITY_TEACHER1
	const CELADONCITY_GRAMPS1
	const CELADONCITY_GRAMPS2
	const CELADONCITY_YOUNGSTER1
	const CELADONCITY_YOUNGSTER2
	const CELADONCITY_TEACHER2
	const CELADONCITY_LASS

CeladonCity_MapScripts:
	def_scene_scripts

	def_callbacks
	callback MAPCALLBACK_NEWMAP, CeladonCityFlypointCallback

CeladonCityFlypointCallback:
	setflag ENGINE_FLYPOINT_CELADON
	endcallback

CeladonCityFisherScript:
	jumptextfaceplayer CeladonCityFisherText

CeladonCityPoliwrath:
	opentext
	writetext CeladonCityPoliwrathText
	cry POLIWRATH
	waitbutton
	closetext
	end

CeladonCityTeacher1Script:
	jumptextfaceplayer CeladonCityTeacher1Text

CeladonCityGramps1Script:
	jumptextfaceplayer CeladonCityGramps1Text

CeladonCityGramps2Script:
	jumptextfaceplayer CeladonCityGramps2Text

CeladonCityYoungster1Script:
	jumptextfaceplayer CeladonCityYoungster1Text

CeladonCityYoungster2Script:
	jumptextfaceplayer CeladonCityYoungster2Text

CeladonCityTeacher2Script:
	jumptextfaceplayer CeladonCityTeacher2Text

CeladonCityLassScript:
	jumptextfaceplayer CeladonCityLassText

CeladonCitySign:
	jumptext CeladonCitySignText

CeladonGymSign:
	jumptext CeladonGymSignText

CeladonCityDeptStoreSign:
	jumptext CeladonCityDeptStoreSignText

CeladonCityMansionSign:
	jumptext CeladonCityMansionSignText

CeladonCityGameCornerSign:
	jumptext CeladonCityGameCornerSignText

CeladonCityTrainerTips:
	jumptext CeladonCityTrainerTipsText

CeladonCityPokecenterSign:
	jumpstd PokecenterSignScript

CeladonCityHiddenPpUp:
	hiddenitem PP_UP, EVENT_CELADON_CITY_HIDDEN_PP_UP

CeladonCityFisherText:
	text "Dieses QUAPPO ist"
	line "mein Partner."

	para "Ich frage mich, ob"
	line "es sich wohl je in"
	cont "ein Frosch-#MON"
	cont "weiterentwickelt."
	done

CeladonCityPoliwrathText:
	text "QUAPPO: Quaak!"
	done

CeladonCityTeacher1Text:
if DEF(_CRYSTAL_AU)
	text "I lost at the"
	line "machines."
	done
else
	text "I lost at the slot"
	line "machines again…"

	para "We girls also play"
	line "the slots now."

	para "You should check"
	line "them out too."
	done
endc

CeladonCityGramps1Text:
	text "Hier sind vor"
	line "kurzem SLEIMA"
	cont "aufgetaucht."

	para "Siehst du den"
	line "Teich da vor dem"

	para "Haus? Dort leben"
	line "jetzt SLEIMA."

	para "Wo kommen sie her?"
	line "Das ist ein"
	cont "echtes Problem…"
	done

CeladonCityGramps2Text:
	text "Hihihi! Diese"
	line "PKMN-ARENA ist"

	para "toll! Sie ist nur"
	line "für Mädchen!"
	done

CeladonCityYoungster1Text:
	text "Soll ich dir ein"
	line "Geheimnis"
	cont "erzählen?"

	para "PRISMANIA-VILLA"
	line "hat eine geheime"
	cont "Hintertür."
	done

CeladonCityYoungster2Text:
	text "Im Restaurant wird"
	line "ein Wettessen ab-"
	cont "gehalten."

	para "Ihnen beim Essen"
	line "nur zuzusehen,"
	cont "bringt mich schon"
	cont "zum Platzen…"
	done

CeladonCityTeacher2Text:
	text "Das EINKAUFS-"
	line "ZENTRUM in"

	para "PRISMANIA CITY"
	line "bietet die gröせte"

	para "und beste Auswahl"
	line "an Artikeln."

	para "Was du da nicht"
	line "findest, wirst"

	para "du nirgends"
	line "finden."

	para "Herrje… Ich klinge"
	line "wie ein Vertreter."
	done

CeladonCityLassText_Mobile: ; unreferenced
	text "Ich liebe es, von"
	line "hohen Gebäuden"
	cont "umgeben zu sein!"

	para "Stimmt es, dass"
	line "man das #MON-"
	cont "CENTER in DUKATIA"
	cont "vergröせert hat?"

	para "Das ist toll! Ich"
	line "wünschte, wir"

	para "hätten solch einen"
	line "Ort in KANTO…"
	done

CeladonCityLassText:
	text "Mir wird ganz"
	line "schwindelig, wenn"

	para "ich beim Laufen"
	line "auf den Boden"
	cont "gucke."
	done

CeladonCitySignText:
	text "PRISMANIA CITY"

	para "Die Stadt der"
	line "Regenbogen-Träume"
	done

CeladonGymSignText:
	text "PKMN-ARENA von"
	line "PRISMANIA CITY"

	para "LEITUNG: ERIKA"
	line "Die Prinzessin mit"

	para "Herz für die Natur"
	done

CeladonCityDeptStoreSignText:
	text "Im EINKAUFSZENTRUM"
	line "von PRISMANIA CITY"
	cont "Findest Du Alles,"
	cont "was Dein Herz"
	cont "Begehrt!"
	done

CeladonCityMansionSignText:
	text "PRISMANIA-VILLA"
	done

CeladonCityGameCornerSignText:
if DEF(_CRYSTAL_AU)
	text "The Game Area for"
	line "Grown-ups--CELADON"
	cont "GAME CORNER"
	done
else
	text "The Playground for"
	line "Everybody--CELADON"
	cont "GAME CORNER"
	done
endc

CeladonCityTrainerTipsText:
	text "TIPPS für TRAINER"

	para "Der MEGABLOCK"
	line "schützt #MON"

	para "vor SPEZIAL-"
	line "Attacken wie z.B."
	cont "Feuer und Wasser."

	para "Hol dir deine"
	line "Items im EINKAUFS-"
	cont "ZENTRUM von"
	cont "PRISMANIA CITY!"
	done

CeladonCity_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  4,  9, CELADON_DEPT_STORE_1F, 1
	warp_event 16,  9, CELADON_MANSION_1F, 1
	warp_event 16,  3, CELADON_MANSION_1F, 3
	warp_event 17,  3, CELADON_MANSION_1F, 3
	warp_event 29,  9, CELADON_POKECENTER_1F, 1
	warp_event 18, 19, CELADON_GAME_CORNER, 1
	warp_event 23, 19, CELADON_GAME_CORNER_PRIZE_ROOM, 1
	warp_event 10, 29, CELADON_GYM, 1
	warp_event 25, 29, CELADON_CAFE, 1

	def_coord_events

	def_bg_events
	bg_event 23, 21, BGEVENT_READ, CeladonCitySign
	bg_event 11, 31, BGEVENT_READ, CeladonGymSign
	bg_event  6,  9, BGEVENT_READ, CeladonCityDeptStoreSign
	bg_event 13,  9, BGEVENT_READ, CeladonCityMansionSign
	bg_event 19, 21, BGEVENT_READ, CeladonCityGameCornerSign
	bg_event 29, 21, BGEVENT_READ, CeladonCityTrainerTips
	bg_event 30,  9, BGEVENT_READ, CeladonCityPokecenterSign
	bg_event 37, 21, BGEVENT_ITEM, CeladonCityHiddenPpUp

	def_object_events
	object_event 26, 11, SPRITE_FISHER, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, CeladonCityFisherScript, -1
	object_event 27, 11, SPRITE_POLIWAG, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, CeladonCityPoliwrath, -1
	object_event 20, 24, SPRITE_TEACHER, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 2, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, CeladonCityTeacher1Script, -1
	object_event 14, 16, SPRITE_GRAMPS, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, CeladonCityGramps1Script, -1
	object_event  8, 31, SPRITE_GRAMPS, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, CeladonCityGramps2Script, -1
	object_event 18, 13, SPRITE_YOUNGSTER, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 2, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, CeladonCityYoungster1Script, -1
	object_event 24, 33, SPRITE_YOUNGSTER, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, CeladonCityYoungster2Script, -1
	object_event  6, 14, SPRITE_TEACHER, SPRITEMOVEDATA_WANDER, 2, 2, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, CeladonCityTeacher2Script, -1
	object_event  7, 22, SPRITE_LASS, SPRITEMOVEDATA_WALK_UP_DOWN, 0, 2, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, CeladonCityLassScript, -1
