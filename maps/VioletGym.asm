	object_const_def
	const VIOLETGYM_FALKNER
	const VIOLETGYM_YOUNGSTER1
	const VIOLETGYM_YOUNGSTER2
	const VIOLETGYM_GYM_GUIDE

VioletGym_MapScripts:
	def_scene_scripts

	def_callbacks

VioletGymFalknerScript:
	faceplayer
	opentext
	checkevent EVENT_BEAT_FALKNER
	iftrue .FightDone
	writetext FalknerIntroText
	waitbutton
	closetext
	winlosstext FalknerWinLossText, 0
	loadtrainer FALKNER, FALKNER1
	startbattle
	reloadmapafterbattle
	setevent EVENT_BEAT_FALKNER
	opentext
	writetext ReceivedZephyrBadgeText
	playsound SFX_GET_BADGE
	waitsfx
	setflag ENGINE_ZEPHYRBADGE
	readvar VAR_BADGES
	scall VioletGymActivateRockets
.FightDone:
	checkevent EVENT_GOT_TM31_MUD_SLAP
	iftrue .SpeechAfterTM
	setevent EVENT_BEAT_BIRD_KEEPER_ROD
	setevent EVENT_BEAT_BIRD_KEEPER_ABE
	setmapscene ELMS_LAB, SCENE_ELMSLAB_NOOP
	specialphonecall SPECIALCALL_ASSISTANT
	writetext FalknerZephyrBadgeText
	promptbutton
	verbosegiveitem TM_MUD_SLAP
	iffalse .NoRoomForMudSlap
	setevent EVENT_GOT_TM31_MUD_SLAP
	writetext FalknerTMMudSlapText
	waitbutton
	closetext
	end

.SpeechAfterTM:
	writetext FalknerFightDoneText
	waitbutton
.NoRoomForMudSlap:
	closetext
	end

VioletGymActivateRockets:
	ifequal 7, .RadioTowerRockets
	ifequal 6, .GoldenrodRockets
	end

.GoldenrodRockets:
	jumpstd GoldenrodRocketsScript

.RadioTowerRockets:
	jumpstd RadioTowerRocketsScript

TrainerBirdKeeperRod:
	trainer BIRD_KEEPER, ROD, EVENT_BEAT_BIRD_KEEPER_ROD, BirdKeeperRodSeenText, BirdKeeperRodBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext BirdKeeperRodAfterBattleText
	waitbutton
	closetext
	end

TrainerBirdKeeperAbe:
	trainer BIRD_KEEPER, ABE, EVENT_BEAT_BIRD_KEEPER_ABE, BirdKeeperAbeSeenText, BirdKeeperAbeBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext BirdKeeperAbeAfterBattleText
	waitbutton
	closetext
	end

VioletGymGuideScript:
	faceplayer
	opentext
	checkevent EVENT_BEAT_FALKNER
	iftrue .VioletGymGuideWinScript
	writetext VioletGymGuideText
	waitbutton
	closetext
	end

.VioletGymGuideWinScript:
	writetext VioletGymGuideWinText
	waitbutton
	closetext
	end

VioletGymStatue:
	checkflag ENGINE_ZEPHYRBADGE
	iftrue .Beaten
	jumpstd GymStatue1Script
.Beaten:
	gettrainername STRING_BUFFER_4, FALKNER, FALKNER1
	jumpstd GymStatue2Script

FalknerIntroText:
	text "Ich bin FALK, der"
	line "ARENALEITER von"
	cont "VIOLA CITY!"

	para "Man sagt, dass man"
	line "die Flügel von"

	para "Flug-#MON mit"
	line "einem elektrischen"

	para "Blitz stutzen"
	line "kann…"

	para "So etwas werde ich"
	line "niemals zulassen!"

	para "Ich werde dich die"
	line "wahre Kraft der"

	para "Flug-#MON"
	line "spüren lassen!"
	done

FalknerWinLossText:
	text "…Verflixt! Mein"
	line "Vater hat Flug-"
	cont "#MON geliebt…"

	para "Also gut."
	line "Nimm dies!"

	para "Es ist der offi-"
	line "zielle FLÜGELORDEN"
	cont "der #MON"
	cont "LIGA."
	done

ReceivedZephyrBadgeText:
	text "<PLAYER> erhält den"
	line "FLÜGELORDEN."
	done

FalknerZephyrBadgeText:
	text "Der FLÜGELORDEN"
	line "stärkt den ANGR-"
	cont "Wert deiner #-"
	cont "MON."

	para "Außerdem können"
	line "deine #MON"

	para "jederzeit BLITZ"
	line "einsetzen."

	para "Hier - ich habe"
	line "noch etwas für"
	cont "dich."
	done

FalknerTMMudSlapText:
	text "Benutzt ein #-"
	line "MON eine TM, er-"
	cont "lernt es sofort"
	cont "eine neue Attacke."

	para "Überlege dir den"
	line "Einsatz gut - eine"
	cont "TM kann nur einmal"
	cont "eingesetzt werden."

	para "TM31 enthält"
	line "LEHMSCHELLE."

	para "Sie fügt dem Geg-"
	line "ner Schaden zu und"

	para "reduziert gleich-"
	line "zeitig seine Ge-"
	cont "nauigkeit."

	para "Mit anderen Wor-"
	line "ten: Sie ist"
	cont "sowohl defensiv"
	cont "als auch offensiv."
	done

FalknerFightDoneText:
	text "In so mancher"
	line "Stadt warten noch"
	cont "ARENEN auf dich."

	para "Du solltest dein"
	line "Können in diesen"
	cont "ARENEN beweisen."

	para "Ich werde noch"
	line "härter trainieren,"

	para "um der größte Vo-"
	line "gel-Experte aller"
	cont "Zeiten zu werden!"
	done

BirdKeeperRodSeenText:
	text "Das Motto lautet:"
	line "Courage!"

	para "Sie alle hier üben"
	line "Tag und Nacht,"

	para "um Vogel-Meister-"
	line "Trainer zu werden."

	para "Komm schon!"
	done

BirdKeeperRodBeatenText:
	text "Gaaah!"
	done

BirdKeeperRodAfterBattleText:
	text "FALKs Fähigkeiten"
	line "sind unübertreff-"
	cont "lich!"

	para "Du solltest dich"
	line "nicht überschät-"
	cont "zen, nur weil du"
	cont "mich geschlagen"
	cont "hast!"
	done

BirdKeeperAbeSeenText:
	text "Lass mich heraus-"
	line "finden, ob du gut"
	cont "genug bist, um ge-"
	cont "gen FALK anzutre-"
	cont "ten!"
	done

BirdKeeperAbeBeatenText:
	text "Das kann nicht"
	line "wahr sein!"
	done

BirdKeeperAbeAfterBattleText:
	text "Das ist peinlich!"
	line "Von einem Anfänger"
	cont "besiegt…"
	done

VioletGymGuideText:
	text "Hey! Zwar bin ich"
	line "kein Trainer, aber"
	cont "ich kann dir gute"
	cont "Tipps geben!"

	para "Glaube mir!"
	line "Wenn du es tust,"

	para "kann dein Traum"
	line "von der Meister-"
	cont "schaft in Erfül-"
	cont "lung gehen."

	para "Du glaubst mir?"
	line "Dann pass auf!"

	para "Typ Pflanze ist"
	line "schwach gegen Typ"

	para "Flug. Das solltest"
	line "du dir merken."
	done

VioletGymGuideWinText:
	text "Netter Kampf! Mach"
	line "weiter so und bald"

	para "schon wirst du der"
	line "CHAMP sein!"
	done

VioletGym_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  4, 15, VIOLET_CITY, 2
	warp_event  5, 15, VIOLET_CITY, 2

	def_coord_events

	def_bg_events
	bg_event  3, 13, BGEVENT_READ, VioletGymStatue
	bg_event  6, 13, BGEVENT_READ, VioletGymStatue

	def_object_events
	object_event  5,  1, SPRITE_FALKNER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, VioletGymFalknerScript, -1
	object_event  7,  6, SPRITE_YOUNGSTER, SPRITEMOVEDATA_STANDING_LEFT, 2, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 3, TrainerBirdKeeperRod, -1
	object_event  2, 10, SPRITE_YOUNGSTER, SPRITEMOVEDATA_STANDING_RIGHT, 2, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 3, TrainerBirdKeeperAbe, -1
	object_event  7, 13, SPRITE_GYM_GUIDE, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, VioletGymGuideScript, -1
