	object_const_def
	const RUINSOFALPHRESEARCHCENTER_SCIENTIST1
	const RUINSOFALPHRESEARCHCENTER_SCIENTIST2
	const RUINSOFALPHRESEARCHCENTER_SCIENTIST3

RuinsOfAlphResearchCenter_MapScripts:
	def_scene_scripts
	scene_script RuinsOfAlphResearchCenterNoopScene,        SCENE_RUINSOFALPHRESEARCHCENTER_NOOP
	scene_script RuinsOfAlphResearchCenterGetUnownDexScene, SCENE_RUINSOFALPHRESEARCHCENTER_GET_UNOWN_DEX

	def_callbacks
	callback MAPCALLBACK_OBJECTS, RuinsOfAlphResearchCenterScientistCallback

RuinsOfAlphResearchCenterNoopScene:
	end

RuinsOfAlphResearchCenterGetUnownDexScene:
	sdefer RuinsOfAlphResearchCenterGetUnownDexScript
	end

RuinsOfAlphResearchCenterScientistCallback:
	checkscene
	ifequal SCENE_RUINSOFALPHRESEARCHCENTER_GET_UNOWN_DEX, .ShowScientist
	endcallback

.ShowScientist:
	moveobject RUINSOFALPHRESEARCHCENTER_SCIENTIST3, 3, 7
	appear RUINSOFALPHRESEARCHCENTER_SCIENTIST3
	endcallback

RuinsOfAlphResearchCenterGetUnownDexScript:
	applymovement RUINSOFALPHRESEARCHCENTER_SCIENTIST3, RuinsOfAlphResearchCenterApproachesComputerMovement
	playsound SFX_BOOT_PC
	pause 60
	playsound SFX_SWITCH_POKEMON
	pause 30
	playsound SFX_TALLY
	pause 30
	playsound SFX_TRANSACTION
	pause 30
	turnobject RUINSOFALPHRESEARCHCENTER_SCIENTIST3, DOWN
	opentext
	writetext RuinsOfAlphResearchCenterModifiedDexText
	waitbutton
	closetext
	applymovement RUINSOFALPHRESEARCHCENTER_SCIENTIST3, RuinsOfAlphResearchCenterApproachesPlayerMovement
	opentext
	writetext RuinsOfAlphResearchCenterDexUpgradedText
	playsound SFX_ITEM
	waitsfx
	setflag ENGINE_UNOWN_DEX
	writetext RuinsOfAlphResearchCenterScientist3Text
	waitbutton
	closetext
	applymovement RUINSOFALPHRESEARCHCENTER_SCIENTIST3, RuinsOfAlphResearchCenterLeavesPlayerMovement
	setscene SCENE_RUINSOFALPHRESEARCHCENTER_NOOP
	special RestartMapMusic
	end

RuinsOfAlphResearchCenterScientist3Script:
	faceplayer
	opentext
	readvar VAR_UNOWNCOUNT
	ifequal NUM_UNOWN, .PrinterAvailable
	writetext RuinsOfAlphResearchCenterScientist3Text
	waitbutton
	closetext
	end

.PrinterAvailable:
	writetext RuinsOfAlphResearchCenterScientist3_PrinterAvailable
	waitbutton
	closetext
	end

RuinsOfAlphResearchCenterScientist1Script:
	faceplayer
	opentext
	readvar VAR_UNOWNCOUNT
	ifequal NUM_UNOWN, .GotAllUnown
	checkflag ENGINE_UNOWN_DEX
	iftrue .GotUnownDex
	checkevent EVENT_MADE_UNOWN_APPEAR_IN_RUINS
	iftrue .UnownAppeared
	writetext RuinsOfAlphResearchCenterScientist1Text
	waitbutton
	closetext
	end

.UnownAppeared:
	writetext RuinsOfAlphResearchCenterScientist1Text_UnownAppeared
	waitbutton
	closetext
	end

.GotUnownDex:
	writetext RuinsOfAlphResearchCenterScientist1Text_GotUnownDex
	waitbutton
	closetext
	end

.GotAllUnown:
	writetext RuinsOfAlphResearchCenterScientist1Text_GotAllUnown
	waitbutton
	closetext
	clearevent EVENT_RUINS_OF_ALPH_OUTSIDE_TOURIST_YOUNGSTERS
	end

RuinsOfAlphResearchCenterScientist2Script:
	faceplayer
	opentext
	readvar VAR_UNOWNCOUNT
	ifequal NUM_UNOWN, .GotAllUnown
	checkevent EVENT_MADE_UNOWN_APPEAR_IN_RUINS
	iftrue .UnownAppeared
	writetext RuinsOfAlphResearchCenterScientist2Text
	waitbutton
	closetext
	end

.UnownAppeared:
	writetext RuinsOfAlphResearchCenterScientist2Text_UnownAppeared
	waitbutton
	closetext
	end

.GotAllUnown:
	writetext RuinsOfAlphResearchCenterScientist2Text_GotAllUnown
	waitbutton
	closetext
	end

RuinsOfAlphResearchCenterComputer:
	opentext
	checkevent EVENT_RUINS_OF_ALPH_RESEARCH_CENTER_SCIENTIST
	iftrue .SkipChecking
	readvar VAR_UNOWNCOUNT
	ifequal NUM_UNOWN, .GotAllUnown
.SkipChecking:
	writetext RuinsOfAlphResearchCenterComputerText
	waitbutton
	closetext
	end

.GotAllUnown:
	writetext RuinsOfAlphResearchCenterComputerText_GotAllUnown
	waitbutton
	closetext
	end

RuinsOfAlphResearchCenterPrinter:
	opentext
	checkevent EVENT_RUINS_OF_ALPH_RESEARCH_CENTER_SCIENTIST
	iftrue .SkipChecking
	readvar VAR_UNOWNCOUNT
	ifequal NUM_UNOWN, .PrinterAvailable
.SkipChecking:
	writetext RuinsOfAlphResearchCenterPrinterText_DoesntWork
	waitbutton
	closetext
	end

.PrinterAvailable:
	writetext RuinsOfAlphResearchCenterUnownPrinterText
	waitbutton
	special UnownPrinter
	closetext
	end

RuinsOfAlphResearchCenterPhoto: ; unreferenced
	jumptext RuinsOfAlphResearchCenterProfSilktreePhotoText

RuinsOfAlphResearchCenterBookshelf:
	jumptext RuinsOfAlphResearchCenterAcademicBooksText

RuinsOfAlphResearchCenterApproachesComputerMovement:
	step UP
	step UP
	step LEFT
	turn_head UP
	step_end

RuinsOfAlphResearchCenterApproachesPlayerMovement:
	step DOWN
	step_end

RuinsOfAlphResearchCenterLeavesPlayerMovement:
	step UP
	step_end

RuinsOfAlphResearchCenterModifiedDexText:
	text "Geschafft!"

	para "Ich habe deinen"
	line "#DEX erweitert."

	para "Ich habe dir einen"
	line "optionalen #DEX"

	para "extra für ICOGNITO"
	line "eingebaut. Er"

	para "speichert sie in"
	line "der Reihenfolge,"
	cont "in der du sie"
	cont "fängst."
	done

RuinsOfAlphResearchCenterDexUpgradedText:
	text "<PLAYER>s #DEX"
	line "wurde erweitert."
	done

RuinsOfAlphResearchCenterScientist3Text:
	text "Jedes ICOGNITO,"
	line "das du fängst,"
	cont "wird darin einge-"
	cont "tragen."

	para "Schlage nach,"
	line "um zu erfahren,"
	cont "wie viele es gibt."
	done

RuinsOfAlphResearchCenterScientist3_PrinterAvailable:
	text "Hast du alle"
	line "verschiedenen"
	cont "ICOGNITO?"

	para "Das ist eine"
	line "Spitzenleistung!"

	para "Ich habe den"
	line "Drucker aufge-"
	cont "stellt, um"
	cont "ICOGNITOs Daten"
	cont "auszudrucken."

	para "Du kannst ihn"
	line "jederzeit gerne"
	cont "benutzen."
	done

RuinsOfAlphResearchCenterScientist1Text:
	text "Die RUINEN sind"
	line "zirka 1500"
	cont "Jahre alt."

	para "Aber niemand weiß,"
	line "warum sie erbaut"
	cont "wurden."
	done

RuinsOfAlphResearchCenterScientist1Text_GotUnownDex:
	text "Ich frage mich,"
	line "wie viele #MON"
	cont "wohl in den RUINEN"
	cont "leben?"
	done

RuinsOfAlphResearchCenterScientist1Text_UnownAppeared:
	text "Es gibt #MON"
	line "in den RUINEN?"

	para "Das sind unfass-"
	line "bare Neuigkeiten!"

	para "Das müssen wir"
	line "erforschen."
	done

RuinsOfAlphResearchCenterScientist1Text_GotAllUnown:
	text "Unsere Forschung"
	line "und deine Hilfe"

	para "geben uns einen"
	line "tiefen Einblick in"
	cont "die RUINEN."

	para "Es scheint, als ob"
	line "die RUINEN als"

	para "Habitat für #-"
	line "MON gebaut wurden."
	done

RuinsOfAlphResearchCenterScientist2Text:
	text "An die Wände der"
	line "RUINEN sind selt-"
	cont "same Zeichen"

	para "gemalt."
	line "Sie sind der"

	para "Schlüssel zur"
	line "Lösung des Rätsels"
	cont "um die RUINEN."
	done

RuinsOfAlphResearchCenterScientist2Text_UnownAppeared:
	text "Die seltsamen"
	line "#MON, die du in"
	cont "den RUINEN gesehen"
	cont "hast?"

	para "Es scheint, sie"
	line "ähneln den"

	para "Zeichnungen an"
	line "den Wänden."

	para "Hmm…"

	para "Das bedeutet, es"
	line "gibt viele"
	cont "von ihnen…"
	done

RuinsOfAlphResearchCenterUnusedText1: ; unreferenced
	text "Wir denken, dass"
	line "irgendetwas für"

	para "die rätselhaften"
	line "Muster in den"

	para "RUINEN verantwort-"
	line "lich war."

	para "Darauf basiert"
	line "unsere Forschung."
	done

RuinsOfAlphResearchCenterUnusedText2: ; unreferenced
	text "Unsere Forschung"
	line "hat ergeben…,"

	para "diese selt-"
	line "samen Muster ent-"
	cont "standen, als das"

	para "#KOM-CENTER"
	line "errichtet wurde."

	para "Das bedeutet, dass"
	line "Radiowellen einen"

	para "gewissen Einfluß"
	line "haben…"
	done

RuinsOfAlphResearchCenterScientist2Text_GotAllUnown:
	text "Warum sind diese"
	line "antiken Muster"

	para "jetzt an den Wän-"
	line "den aufgetaucht?"

	para "Das wird immer"
	line "geheimnisvoller…"
	done

RuinsOfAlphResearchCenterComputerText:
	text "ALPH-RUINEN"
	line "10. Forschungsjahr"
	done

RuinsOfAlphResearchCenterComputerText_GotAllUnown:
	text "Geheimnisvolles"
	line "#MON"
	cont "Name: ICOGNITO"

	para "26 verschiedene"
	line "gefunden."
	done

RuinsOfAlphResearchCenterPrinterText_DoesntWork:
	text "Das scheint noch"
	line "nicht zu"
	cont "funktionieren."
	done

RuinsOfAlphResearchCenterUnownPrinterText:
	text "ICOGNITO kann"
	line "gedruckt werden."
	done

RuinsOfAlphResearchCenterProfSilktreePhotoText:
	text "Itわ a photo of"
	line "the RESEARCH"

	para "CENTER'S founder,"
	line "PROF.SILKTREE."
	done

RuinsOfAlphResearchCenterAcademicBooksText:
	text "Es gibt viele"
	line "wissenschaftliche"
	cont "Bücher dort."

	para "Antike Ruinen…"
	line "Geheimnisse der"
	cont "Antike…"
	done

RuinsOfAlphResearchCenter_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, RUINS_OF_ALPH_OUTSIDE, 6
	warp_event  3,  7, RUINS_OF_ALPH_OUTSIDE, 6

	def_coord_events

	def_bg_events
	bg_event  6,  5, BGEVENT_READ, RuinsOfAlphResearchCenterBookshelf
	bg_event  3,  4, BGEVENT_READ, RuinsOfAlphResearchCenterComputer
	bg_event  7,  1, BGEVENT_READ, RuinsOfAlphResearchCenterPrinter

	def_object_events
	object_event  4,  5, SPRITE_SCIENTIST, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, RuinsOfAlphResearchCenterScientist1Script, -1
	object_event  5,  2, SPRITE_SCIENTIST, SPRITEMOVEDATA_WANDER, 2, 1, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, RuinsOfAlphResearchCenterScientist2Script, -1
	object_event  2,  5, SPRITE_SCIENTIST, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, RuinsOfAlphResearchCenterScientist3Script, EVENT_RUINS_OF_ALPH_RESEARCH_CENTER_SCIENTIST
