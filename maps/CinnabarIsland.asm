	object_const_def
	const CINNABARISLAND_BLUE

CinnabarIsland_MapScripts:
	def_scene_scripts

	def_callbacks
	callback MAPCALLBACK_NEWMAP, CinnabarIslandFlypointCallback

CinnabarIslandFlypointCallback:
	setflag ENGINE_FLYPOINT_CINNABAR
	endcallback

CinnabarIslandBlue:
	faceplayer
	opentext
	writetext CinnabarIslandBlueText
	waitbutton
	closetext
	playsound SFX_WARP_TO
	applymovement CINNABARISLAND_BLUE, CinnabarIslandBlueTeleport
	disappear CINNABARISLAND_BLUE
	clearevent EVENT_VIRIDIAN_GYM_BLUE
	end

CinnabarIslandGymSign:
	jumptext CinnabarIslandGymSignText

CinnabarIslandSign:
	jumptext CinnabarIslandSignText

CinnabarIslandPokecenterSign:
	jumpstd PokecenterSignScript

CinnabarIslandHiddenRareCandy:
	hiddenitem RARE_CANDY, EVENT_CINNABAR_ISLAND_HIDDEN_RARE_CANDY

CinnabarIslandBlueTeleport:
	teleport_from
	step_end

CinnabarIslandBlueText:
	text "Wer bist du?"

	para "Na, du bist"
	line "augenscheinlich"
	cont "ein Trainer…"

	para "Ich heiße BLAU."

	para "Ich war einmal ein"
	line "CHAMP, wenn auch"

	para "nur für kurze"
	line "Zeit…"

	para "Dieser nervige ROT"
	line "hat mich ganz"

	para "schön fertig-"
	line "gemacht…"

	para "Wie dem auch sei,"
	line "was willst du?"

	para "Willst du gegen"
	line "mich kämpfen?"

	para "…Ich sage es nur"
	line "ungern, aber ich"

	para "habe gar keine"
	line "Lust zu kämpfen."

	para "Sieh dich gut"
	line "um…"

	para "Ein Vulkan bricht"
	line "aus und vernichtet"

	para "auf einen Schlag"
	line "eine ganze Stadt."

	para "Wir werden weiter-"
	line "hin mit unseren"

	para "#MON siegen"
	line "oder verlieren."

	para "Aber wenn sich die"
	line "Natur erhebt, ist"
	cont "alles im Nu dahin."

	para "…"

	para "So ist das"
	line "eben…"

	para "Trotz allem bin"
	line "ich immer noch ein"
	cont "Trainer."

	para "Wenn ich einen"
	line "starken Gegner"
	cont "treffe, möchte ich"
	cont "gegen ihn kämpfen."

	para "Wenn du gegen mich"
	line "kämpfen möchtest,"

	para "dann besuche die"
	line "PKMN-ARENA in"
	cont "VERTANIA CITY."

	para "Dort werde ich"
	line "mich deiner"
	cont "annehmen."
	done

CinnabarIslandGymSignText:
	text "Hier ist eine"
	line "Nachricht…"

	para "Die PKMN-ARENA der"
	line "ZINNOBERINSEL"

	para "wurde auf die"
	line "SEESCHAUMINSELN"
	cont "verlegt."

	para "PYRO"
	done

CinnabarIslandSignText:
	text "ZINNOBERINSEL"

	para "Die Feurige Stadt"
	line "Brennender"
	cont "Begierde"
	done

CinnabarIsland_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 11, 11, CINNABAR_POKECENTER_1F, 1

	def_coord_events

	def_bg_events
	bg_event 12, 11, BGEVENT_READ, CinnabarIslandPokecenterSign
	bg_event  9, 11, BGEVENT_READ, CinnabarIslandGymSign
	bg_event  7,  7, BGEVENT_READ, CinnabarIslandSign
	bg_event  9,  1, BGEVENT_ITEM, CinnabarIslandHiddenRareCandy

	def_object_events
	object_event  9,  6, SPRITE_BLUE, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, CinnabarIslandBlue, EVENT_BLUE_IN_CINNABAR
