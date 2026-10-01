	object_const_def
	const ROUTE24_ROCKET

Route24_MapScripts:
	def_scene_scripts

	def_callbacks

Route24RocketScript:
	faceplayer
	playmusic MUSIC_ROCKET_ENCOUNTER
	opentext
	writetext Route24RocketSeenText
	waitbutton
	closetext
	winlosstext Route24RocketBeatenText, -1
	loadtrainer GRUNTM, GRUNTM_31
	startbattle
	dontrestartmapmusic
	reloadmapafterbattle
	playmusic MUSIC_ROCKET_ENCOUNTER
	opentext
	writetext Route24RocketAfterBattleText
	promptbutton
	special FadeOutMusic
	writetext Route24RocketDisappearsText
	waitbutton
	closetext
	special FadeOutToBlack
	special ReloadSpritesNoPalettes
	disappear ROUTE24_ROCKET
	pause 25
	special FadeInFromBlack
	playmapmusic
	end

Route24RocketSeenText:
	text "Hey, Minimensch!"
	line "Ich sein von TEAM"
	cont "ROCKET."

	para "Sein aus fremde"
	line "Land, Trainer eins"
	cont "ich sein!"

	para "Geglaubt, wenn"
	line "nix Energie mehr,"

	para "mache viel Panik"
	line "bei Leute!"

	para "Geheim mein"
	line "Auftrag sein, ich"
	cont "dir nix verraten!"

	para "Doch! Wenn mich"
	line "besiegen, ich sein"

	para "lieb und dir"
	line "verrate Geheimnis."

	para "Du, Kind! Kämpfen"
	line "lass uns!"
	done

Route24RocketBeatenText:
	text "Uff! Nein,"
	line "glauben nicht ich"
	cont "kann!"

	para "Stark sehr du"
	line "sein! Ich nix"
	cont "Gegner für dich!"
	done

Route24RocketAfterBattleText:
	text "O.K. Verraten dir"
	line "meine Geheimnis."

	para "SPULE, gestohlen"
	line "von mir, versteckt"

	para "in PKMN-ARENA der"
	line "AZURIA CITY."

	para "Wasser sein gute"
	line "Versteck. In"

	para "Mitte von PKMN-"
	line "ARENA Wasser sein."

	para "Kind, du mich"
	line "vergessen nicht!"

	para "Besiege dir wird"
	line "TEAM ROCKET tun."

	para "Werden kommen aus"
	line "JOHTO, mein"

	para "Freunde. Rächen"
	line "sie werden tun."
	done

Route24RocketDisappearsText:
	text "…"

	para "Was du sagen? TEAM"
	line "ROCKET nix mehr"

	para "gibt? Kaputt"
	line "gemacht, du sagen?"

	para "Oh, nein! Ich"
	line "tun was jetzt"
	cont "machen?"
	done

Route24_MapEvents:
	db 0, 0 ; filler

	def_warp_events

	def_coord_events

	def_bg_events

	def_object_events
	object_event  8,  7, SPRITE_ROCKET, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, Route24RocketScript, EVENT_ROUTE_24_ROCKET
