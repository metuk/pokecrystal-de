Route7_MapScripts:
	def_scene_scripts

	def_callbacks

Route7UndergroundPathSign:
	jumptext Route7UndergroundPathSignText

Route7LockedDoor:
	jumptext Route7LockedDoorText

Route7UndergroundPathSignText:
	text "Was steht auf dem"
	line "Flugblatt?"

	para "…Ruppige Trainer"
	line "tragen auf dem"

	para "TUNNELPFAD Kämpfe"
	line "aus."

	para "Da sich die"
	line "Beschwerden der"
	cont "Anwohner häuften,"
	cont "wurde der"
	cont "TUNNELPFAD auf"
	cont "unbestimmte Zeit"
	cont "geschlossen."

	para "ORDNUNGSAMT VON"
	line "PRISMANIA CITY"
	done

Route7LockedDoorText:
	text "Es ist verriegelt…"
	done

Route7_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 15,  6, ROUTE_7_SAFFRON_GATE, 1
	warp_event 15,  7, ROUTE_7_SAFFRON_GATE, 2

	def_coord_events

	def_bg_events
	bg_event  5, 11, BGEVENT_READ, Route7UndergroundPathSign
	bg_event  6,  9, BGEVENT_READ, Route7LockedDoor

	def_object_events
