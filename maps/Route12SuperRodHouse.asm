	object_const_def
	const ROUTE12SUPERRODHOUSE_FISHING_GURU

Route12SuperRodHouse_MapScripts:
	def_scene_scripts

	def_callbacks

Route12SuperRodHouseFishingGuruScript:
	faceplayer
	opentext
	checkevent EVENT_GOT_SUPER_ROD
	iftrue .GotSuperRod
	writetext OfferSuperRodText
	yesorno
	iffalse .Refused
	writetext GiveSuperRodText
	promptbutton
	verbosegiveitem SUPER_ROD
	iffalse .NoRoom
	setevent EVENT_GOT_SUPER_ROD
.GotSuperRod:
	writetext GaveSuperRodText
	waitbutton
	closetext
	end

.Refused:
	writetext DontWantSuperRodText
	waitbutton
.NoRoom:
	closetext
	end

SuperRodHouseBookshelf: ; unreferenced
	jumpstd PictureBookshelfScript

OfferSuperRodText:
	text "Ich bin der"
	line "jüngere Bruder des"
	cont "PROFI-ANGLERs."

	para "Wie ich sehe,"
	line "macht dir Angeln"

	para "Spaß. Darüber gibt"
	line "es keinen Zweifel!"

	para "Na? Das stimmt"
	line "doch, oder?"
	done

GiveSuperRodText:
	text "Jawohl! Genau, wie"
	line "ich dachte!"

	para "Hier, Angelfreak!"
	line "Nimm dies - die"
	cont "SUPERANGEL."
	done

GaveSuperRodText:
	text "Wirf sie aus und"
	line "angle, wo immer"
	cont "es Wasser gibt."

	para "Denk daran - du"
	line "kannst mit ver-"
	cont "schiedenen Angeln"

	para "auch verschiedene"
	line "#MON fangen."
	done

DontWantSuperRodText:
	text "Hä? Meine Augen"
	line "haben mich"
	cont "getäuscht."
	done

Route12SuperRodHouse_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, ROUTE_12, 1
	warp_event  3,  7, ROUTE_12, 1

	def_coord_events

	def_bg_events

	def_object_events
	object_event  5,  3, SPRITE_FISHING_GURU, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, Route12SuperRodHouseFishingGuruScript, -1
