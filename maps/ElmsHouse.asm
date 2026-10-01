	object_const_def
	const ELMSHOUSE_ELMS_WIFE
	const ELMSHOUSE_ELMS_SON

ElmsHouse_MapScripts:
	def_scene_scripts

	def_callbacks

ElmsWife:
	jumptextfaceplayer ElmsWifeText

ElmsSon:
	jumptextfaceplayer ElmsSonText

ElmsHousePC:
	jumptext ElmsHousePCText

ElmsHouseBookshelf:
	jumpstd DifficultBookshelfScript

ElmsWifeText:
	text "Hi, <PLAY_G>! Mein"
	line "Mann ist immer so"

	para "beschäftigt. Ich"
	line "hoffe, es geht ihm"
	cont "gut."

	para "Wenn er sich in"
	line "seine #MON-"
	cont "Forschungen ver-"
	cont "tieft, vergisst er"
	cont "sogar zu essen."
	done

ElmsSonText:
	text "Wenn ich groß bin,"
	line "helfe ich meinem"
	cont "Papa!"

	para "Ich werde ein"
	line "großartiger #-"
	cont "MON-Professor!"
	done

ElmsHouseLabFoodText: ; unreferenced
	text "Hier ist etwas zu"
	line "essen. Es muss für"
	cont "das LABOR sein."
	done

ElmsHousePokemonFoodText: ; unreferenced
	text "Hier ist etwas zu"
	line "essen. Es muss für"
	cont "die #MON sein."
	done

ElmsHousePCText:
	text "#MON. Woher"
	line "kommen sie?"

	para "Wohin gehen sie?"

	para "Warum war noch nie"
	line "jemand Zeuge der"
	cont "Geburt eines"
	cont "#MON?"

	para "Ich will es wis-"
	line "sen. Ich werde"

	para "mein Leben in den"
	line "Dienst der #-"
	cont "MON-Forschung"
	cont "stellen!"

	para "…"

	para "Dies ist ein Teil"
	line "von PROF. LINDs"
	cont "Aufzeichnungen."
	done

ElmsHouse_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, NEW_BARK_TOWN, 4
	warp_event  3,  7, NEW_BARK_TOWN, 4

	def_coord_events

	def_bg_events
	bg_event  0,  1, BGEVENT_READ, ElmsHousePC
	bg_event  6,  1, BGEVENT_READ, ElmsHouseBookshelf
	bg_event  7,  1, BGEVENT_READ, ElmsHouseBookshelf

	def_object_events
	object_event  1,  5, SPRITE_TEACHER, SPRITEMOVEDATA_WALK_UP_DOWN, 0, 1, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, ElmsWife, -1
	object_event  5,  4, SPRITE_BUG_CATCHER, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, ElmsSon, -1
