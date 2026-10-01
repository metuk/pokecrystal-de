	object_const_def
	const CERULEANPOKECENTER1F_NURSE
	const CERULEANPOKECENTER1F_SUPER_NERD
	const CERULEANPOKECENTER1F_GYM_GUIDE

CeruleanPokecenter1F_MapScripts:
	def_scene_scripts

	def_callbacks

CeruleanPokecenter1FNurseScript:
	jumpstd PokecenterNurseScript

CeruleanPokecenter1FSuperNerdScript:
	special CheckMobileAdapterStatusSpecial
	iftrue .mobile
	jumptextfaceplayer CeruleanPokecenter1FSuperNerdText

.mobile
	jumptextfaceplayer CeruleanPokecenter1FSuperNerdText_Mobile

CeruleanPokecenter1FGymGuideScript:
	jumptextfaceplayer CeruleanPokecenter1FGymGuideText

CeruleanPokecenter1FSuperNerdText:
	text "Ich kämpfe lieber"
	line "mit #MON, die"

	para "ich trainiert"
	line "habe, auch wenn"

	para "sie schwach sind,"
	line "als mit #MON,"

	para "die ich neu"
	line "gefangen habe."
	done

CeruleanPokecenter1FSuperNerdText_Mobile:
	text "Kämpfst du via"
	line "Handy?"

	para "Beendet das Zeit-"
	line "limit den Kampf,"

	para "ist es nervenzer-"
	line "reißend den Ge-"
	cont "winner abzuwarten."
	done

CeruleanPokecenter1FGymGuideText:
	text "Mit einer Ge-"
	line "schwindigkeit von"

	para "über 550km/h reist"
	line "der MAGNETZUG in"

	para "null Komma nichts"
	line "zwischen KANTO und"
	cont "JOHTO hin und her."

	para "Dadurch ist JOHTO"
	line "ganz nah."
	done

CeruleanPokecenter1F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  3,  7, CERULEAN_CITY, 4
	warp_event  4,  7, CERULEAN_CITY, 4
	warp_event  0,  7, POKECENTER_2F, 1

	def_coord_events

	def_bg_events

	def_object_events
	object_event  3,  1, SPRITE_NURSE, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, CeruleanPokecenter1FNurseScript, -1
	object_event  8,  4, SPRITE_SUPER_NERD, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, CeruleanPokecenter1FSuperNerdScript, -1
	object_event  1,  5, SPRITE_GYM_GUIDE, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, CeruleanPokecenter1FGymGuideScript, -1
