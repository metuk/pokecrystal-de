	object_const_def
	const SLOWPOKEWELLB2F_GYM_GUIDE
	const SLOWPOKEWELLB2F_POKE_BALL

SlowpokeWellB2F_MapScripts:
	def_scene_scripts

	def_callbacks

SlowpokeWellB2FGymGuideScript:
	faceplayer
	opentext
	checkevent EVENT_GOT_KINGS_ROCK_IN_SLOWPOKE_WELL
	iftrue .GotKingsRock
	writetext SlowpokeWellB2FGymGuideText
	promptbutton
	verbosegiveitem KINGS_ROCK
	iffalse .NoRoom
	setevent EVENT_GOT_KINGS_ROCK_IN_SLOWPOKE_WELL
.NoRoom:
	closetext
	end

.GotKingsRock:
	writetext SlowpokeWellB2FGymGuideText_GotKingsRock
	waitbutton
	closetext
	end

SlowpokeWellB2FTMRainDance:
	itemball TM_RAIN_DANCE

SlowpokeWellB2FGymGuideText:
	text "Ich warte darauf,"
	line "dass sich FLEGMON"
	cont "entwickelt."

	para "Aufgrund meiner"
	line "Beobachtungen"
	cont "habe ich eine"
	cont "neue Entdeckung"
	cont "gemacht."

	para "Trägt FLEGMON"
	line "einen KING-STEIN"

	para "wird es oft von"
	line "einem MUSCHAS"
	cont "gebissen."

	para "Hier, ich gebe"
	line "dir einen von"
	cont "meinen."
	done

SlowpokeWellB2FGymGuideText_GotKingsRock:
	text "Ich werde mich wie"
	line "FLEGMON verhalten."

	para "Ich werde geduldig"
	line "abwarten, bis es"
	cont "sich entwickelt."
	done

SlowpokeWellB2F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  9, 11, SLOWPOKE_WELL_B1F, 2

	def_coord_events

	def_bg_events

	def_object_events
	object_event  5,  4, SPRITE_GYM_GUIDE, SPRITEMOVEDATA_WANDER, 1, 2, -1, -1, 0, OBJECTTYPE_SCRIPT, 1, SlowpokeWellB2FGymGuideScript, -1
	object_event 15,  5, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, SlowpokeWellB2FTMRainDance, EVENT_SLOWPOKE_WELL_B2F_TM_RAIN_DANCE
