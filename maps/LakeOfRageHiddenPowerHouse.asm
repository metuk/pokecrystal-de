	object_const_def
	const LAKEOFRAGEHIDDENPOWERHOUSE_FISHER

LakeOfRageHiddenPowerHouse_MapScripts:
	def_scene_scripts

	def_callbacks

HiddenPowerGuy:
	faceplayer
	opentext
	checkevent EVENT_GOT_TM10_HIDDEN_POWER
	iftrue .AlreadyGotItem
	writetext HiddenPowerGuyText1
	promptbutton
	verbosegiveitem TM_HIDDEN_POWER
	iffalse .Done
	setevent EVENT_GOT_TM10_HIDDEN_POWER
	writetext HiddenPowerGuyText2
	waitbutton
	closetext
	end
.AlreadyGotItem:
	writetext HiddenPowerGuyText3
	waitbutton
.Done:
	closetext
	end

HiddenPowerHouseBookshelf:
	jumpstd DifficultBookshelfScript

HiddenPowerGuyText1:
	text "…Du bist viel he-"
	line "rumgekommen…"

	para "Ich habe hier me-"
	line "ditiert. In mir"

	para "ist eine neue"
	line "Kraft zum Leben"
	cont "erwacht."

	para "Lass mich meine"
	line "Kraft mit deinen"

	para "#MON teilen."
	line "Nimm dies, Kind."
	done

HiddenPowerGuyText2:
	text "Siehst du? Das"
	line "ist KRAFTRESERVE!"

	para "Sie bringt die"
	line "wahre Kraft der"
	cont "#MON zum"
	cont "Vorschein."

	para "Vergiss nicht: Typ"
	line "und Stärke der At-"
	cont "tacke hängen vom"
	cont "jeweiligen #MON"
	cont "ab."
	done

HiddenPowerGuyText3:
	text "Ich meditiere…"
	done

LakeOfRageHiddenPowerHouse_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, LAKE_OF_RAGE, 1
	warp_event  3,  7, LAKE_OF_RAGE, 1

	def_coord_events

	def_bg_events
	bg_event  0,  1, BGEVENT_READ, HiddenPowerHouseBookshelf
	bg_event  1,  1, BGEVENT_READ, HiddenPowerHouseBookshelf

	def_object_events
	object_event  2,  3, SPRITE_FISHER, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, HiddenPowerGuy, -1
