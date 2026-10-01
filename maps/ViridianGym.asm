	object_const_def
	const VIRIDIANGYM_BLUE
	const VIRIDIANGYM_GYM_GUIDE

ViridianGym_MapScripts:
	def_scene_scripts

	def_callbacks

ViridianGymBlueScript:
	faceplayer
	opentext
	checkflag ENGINE_EARTHBADGE
	iftrue .FightDone
	writetext LeaderBlueBeforeText
	waitbutton
	closetext
	winlosstext LeaderBlueWinText, 0
	loadtrainer BLUE, BLUE1
	startbattle
	reloadmapafterbattle
	setevent EVENT_BEAT_BLUE
	opentext
	writetext Text_ReceivedEarthBadge
	playsound SFX_GET_BADGE
	waitsfx
	setflag ENGINE_EARTHBADGE
	writetext LeaderBlueAfterText
	waitbutton
	closetext
	end

.FightDone:
	writetext LeaderBlueEpilogueText
	waitbutton
	closetext
	end

ViridianGymGuideScript:
	faceplayer
	opentext
	checkevent EVENT_BEAT_BLUE
	iftrue .ViridianGymGuideWinScript
	writetext ViridianGymGuideText
	waitbutton
	closetext
	end

.ViridianGymGuideWinScript:
	writetext ViridianGymGuideWinText
	waitbutton
	closetext
	end

ViridianGymStatue:
	checkflag ENGINE_EARTHBADGE
	iftrue .Beaten
	jumpstd GymStatue1Script

.Beaten:
	gettrainername STRING_BUFFER_4, BLUE, BLUE1
	jumpstd GymStatue2Script

LeaderBlueBeforeText:
	text "BLAU: He! Hast du"
	line "es endlich hierher"
	cont "geschafft?"

	para "Auf den ZINNOBER-"
	line "INSELN war mir"

	para "nicht danach, aber"
	line "jetzt können wir"
	cont "kämpfen."

	para "…"

	para "Willst du etwa"
	line "behaupten, du"

	para "hättest alle"
	line "ARENALEITER in"
	cont "JOHTO besiegt?"

	para "He! Dann müssen"
	line "die ARENALEITER in"
	cont "JOHTO ziemliche"
	cont "Jammerlappen sein."

	para "Aber - nur"
	line "keine Bange."

	para "Ich werde dir"
	line "sofort sagen, ob"

	para "du ein guter"
	line "Kämpfer bist."

	para "Fertig, JOHTO-"
	line "CHAMP?"
	done

LeaderBlueWinText:
	text "BLAU: Was?"

	para "Wie zum Teufel"
	line "konnte ich gegen"
	cont "dich verlieren?"

	para "…"

	para "Also gut…"
	line "Hier, nimm das -"
	cont "es ist der"
	cont "ERDORDEN."
	done

Text_ReceivedEarthBadge:
	text "<PLAYER> erhält"
	line "ERDORDEN."
	done

LeaderBlueAfterText:
	text "BLAU: …"

	para "In Ordnung. Ich"
	line "hatte Unrecht. Du"

	para "bist nicht aus"
	line "Watte, sondern ein"
	cont "guter Trainer."

	para "Aber eines Tages"
	line "werde ich dich"

	para "besiegen. Ich"
	line "vergesse dich"
	cont "nicht!"
	done

LeaderBlueEpilogueText:
	text "BLAU: Hör gut zu."

	para "Es bekommt dir"
	line "besser, nicht zu"
	cont "verlieren, bis ich"
	cont "dich besiegt habe!"
	cont "Klar?"
	done

ViridianGymGuideText:
	text "He! Ein CHAMP"
	line "in spe!"

	para "Wie läuft es so?"
	line "Du hast wohl"
	cont "gerade eine"
	cont "Glückssträhne."

	para "Der ARENALEITER"
	line "hat den CHAMP"

	para "vor drei Jahren"
	line "besiegt."

	para "Das wird kein"
	line "Kinderspiel!"

	para "Gib alles, was"
	line "du hast!"
	done

ViridianGymGuideWinText:
	text "Junge, Junge! Du"
	line "bist sehr stark…"

	para "Das war vielleicht"
	line "ein erfrischender"

	para "Kampf. Er hat mir"
	line "Tränen in die"
	cont "Augen getrieben."
	done

ViridianGym_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  4, 17, VIRIDIAN_CITY, 1
	warp_event  5, 17, VIRIDIAN_CITY, 1

	def_coord_events

	def_bg_events
	bg_event  3, 13, BGEVENT_READ, ViridianGymStatue
	bg_event  6, 13, BGEVENT_READ, ViridianGymStatue

	def_object_events
	object_event  5,  3, SPRITE_BLUE, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, ViridianGymBlueScript, EVENT_VIRIDIAN_GYM_BLUE
	object_event  7, 13, SPRITE_GYM_GUIDE, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, ViridianGymGuideScript, EVENT_VIRIDIAN_GYM_BLUE
