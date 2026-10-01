	object_const_def
	const GUIDEGENTSHOUSE_GRAMPS

GuideGentsHouse_MapScripts:
	def_scene_scripts

	def_callbacks

GuideGentsHouseGuideGent:
	jumptextfaceplayer GuideGentsHouseGuideGentText

GuideGentsHouseBookshelf:
	jumpstd MagazineBookshelfScript

GuideGentsHouseGuideGentText:
	text "Als ich noch ein"
	line "Junge war, war ich"
	cont "ein richtiger"
	cont "Heißsporn!"

	para "Ich gebe dir einen"
	line "Rat: Fange viele"
	cont "#MON!"

	para "Behandle sie alle"
	line "mit Freundlich-"
	cont "keit!"
	done

GuideGentsHouse_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, CHERRYGROVE_CITY, 4
	warp_event  3,  7, CHERRYGROVE_CITY, 4

	def_coord_events

	def_bg_events
	bg_event  0,  1, BGEVENT_READ, GuideGentsHouseBookshelf
	bg_event  1,  1, BGEVENT_READ, GuideGentsHouseBookshelf

	def_object_events
	object_event  2,  3, SPRITE_GRAMPS, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, GuideGentsHouseGuideGent, EVENT_GUIDE_GENT_VISIBLE_IN_CHERRYGROVE
