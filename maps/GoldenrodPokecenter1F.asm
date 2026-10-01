	object_const_def
	const GOLDENRODPOKECENTER1F_NURSE
	const GOLDENRODPOKECENTER1F_PCC_TRADE_CORNER_RECEPTIONIST
	const GOLDENRODPOKECENTER1F_GAMEBOY_KID
	const GOLDENRODPOKECENTER1F_LASS
	const GOLDENRODPOKECENTER1F_POKEFAN_F

GoldenrodPokecenter1F_MapScripts:
	def_scene_scripts
	scene_const SCENE_GOLDENRODPOKECENTER1F_GS_BALL

	def_callbacks

GoldenrodPokecenter1FNurseScript:
	jumpstd PokecenterNurseScript

GoldenrodPokecenter1F_GSBallSceneLeft:
	setval BATTLETOWERACTION_GSBALL
	special BattleTowerAction
	ifequal GS_BALL_AVAILABLE, .gsball
	end

.gsball
	checkevent EVENT_GOT_GS_BALL_FROM_GOLDENROD_POKEMON_CENTER
	iftrue .cancel
	playsound SFX_EXIT_BUILDING
	moveobject GOLDENRODPOKECENTER1F_PCC_TRADE_CORNER_RECEPTIONIST, 0, 7
	disappear GOLDENRODPOKECENTER1F_PCC_TRADE_CORNER_RECEPTIONIST
	appear GOLDENRODPOKECENTER1F_PCC_TRADE_CORNER_RECEPTIONIST
	playmusic MUSIC_SHOW_ME_AROUND
	applymovement GOLDENRODPOKECENTER1F_PCC_TRADE_CORNER_RECEPTIONIST, GoldenrodPokeCenter1FLinkReceptionistApproachPlayerAtLeftDoorwayTileMovement
	turnobject PLAYER, UP
	opentext
	writetext GoldenrodPokeCenter1FLinkReceptionistPleaseAcceptGSBallText
	waitbutton
	verbosegiveitem GS_BALL
	setevent EVENT_GOT_GS_BALL_FROM_GOLDENROD_POKEMON_CENTER
	setevent EVENT_CAN_GIVE_GS_BALL_TO_KURT
	writetext GoldenrodPokeCenter1FLinkReceptionistPleaseDoComeAgainText
	waitbutton
	closetext
	applymovement GOLDENRODPOKECENTER1F_PCC_TRADE_CORNER_RECEPTIONIST, GoldenrodPokeCenter1FLinkReceptionistWalkToStairsFromLeftDoorwayTileMovement
	special RestartMapMusic
	disappear GOLDENRODPOKECENTER1F_PCC_TRADE_CORNER_RECEPTIONIST
	playsound SFX_EXIT_BUILDING
.cancel
	end

GoldenrodPokecenter1F_GSBallSceneRight:
	setval BATTLETOWERACTION_GSBALL
	special BattleTowerAction
	ifequal GS_BALL_AVAILABLE, .gsball
	end

.gsball
	checkevent EVENT_GOT_GS_BALL_FROM_GOLDENROD_POKEMON_CENTER
	iftrue .cancel
	playsound SFX_EXIT_BUILDING
	moveobject GOLDENRODPOKECENTER1F_PCC_TRADE_CORNER_RECEPTIONIST, 0, 7
	disappear GOLDENRODPOKECENTER1F_PCC_TRADE_CORNER_RECEPTIONIST
	appear GOLDENRODPOKECENTER1F_PCC_TRADE_CORNER_RECEPTIONIST
	playmusic MUSIC_SHOW_ME_AROUND
	applymovement GOLDENRODPOKECENTER1F_PCC_TRADE_CORNER_RECEPTIONIST, GoldenrodPokeCenter1FLinkReceptionistApproachPlayerAtRightDoorwayTileMovement
	turnobject PLAYER, UP
	opentext
	writetext GoldenrodPokeCenter1FLinkReceptionistPleaseAcceptGSBallText
	waitbutton
	verbosegiveitem GS_BALL
	setevent EVENT_GOT_GS_BALL_FROM_GOLDENROD_POKEMON_CENTER
	setevent EVENT_CAN_GIVE_GS_BALL_TO_KURT
	writetext GoldenrodPokeCenter1FLinkReceptionistPleaseDoComeAgainText
	waitbutton
	closetext
	applymovement GOLDENRODPOKECENTER1F_PCC_TRADE_CORNER_RECEPTIONIST, GoldenrodPokeCenter1FLinkReceptionistWalkToStairsFromRightDoorwayTileMovement
	special RestartMapMusic
	disappear GOLDENRODPOKECENTER1F_PCC_TRADE_CORNER_RECEPTIONIST
	playsound SFX_EXIT_BUILDING
.cancel
	end

GoldenrodPokecenter1FGameboyKidScript:
	jumptextfaceplayer GoldenrodPokecenter1FGameboyKidText

GoldenrodPokecenter1FLassScript:
	jumptextfaceplayer GoldenrodPokecenter1FLassText

GoldenrodPokecenter1FPokefanF:
	faceplayer
	opentext
	writetext GoldenrodPokecenter1FPokefanFDoYouHaveEonMailText
	waitbutton
	writetext GoldenrodPokecenter1FAskGiveAwayAnEonMailText
	yesorno
	iffalse .NoEonMail
	takeitem EON_MAIL
	iffalse .NoEonMail
	writetext GoldenrodPokecenter1FPlayerGaveAwayTheEonMailText
	waitbutton
	writetext GoldenrodPokecenter1FPokefanFThisIsForYouText
	waitbutton
	verbosegiveitem REVIVE
	iffalse .NoRoom
	writetext GoldenrodPokecenter1FPokefanFDaughterWillBeDelightedText
	waitbutton
	closetext
	end

.NoEonMail:
	writetext GoldenrodPokecenter1FPokefanFTooBadText
	waitbutton
	closetext
	end

.NoRoom:
	giveitem EON_MAIL
	writetext GoldenrodPokecenter1FPokefanFAnotherTimeThenText
	waitbutton
	closetext
	end

GoldenrodPokeCenter1FLinkReceptionistApproachPlayerAtLeftDoorwayTileMovement:
	step UP
	step RIGHT
	step RIGHT
	step RIGHT
	turn_head DOWN
	step_end

GoldenrodPokeCenter1FLinkReceptionistWalkToStairsFromLeftDoorwayTileMovement:
	step LEFT
	step LEFT
	step LEFT
	step DOWN
	step_end

GoldenrodPokeCenter1FLinkReceptionistApproachPlayerAtRightDoorwayTileMovement:
	step UP
	step RIGHT
	step RIGHT
	step RIGHT
	step RIGHT
	turn_head DOWN
	step_end

GoldenrodPokeCenter1FLinkReceptionistWalkToStairsFromRightDoorwayTileMovement:
	step LEFT
	step LEFT
	step LEFT
	step LEFT
	step DOWN
	step_end

GoldenrodPokecomCenterWelcomeToTradeCornerText: ; unreferenced
	text_start
	done

GoldenrodPokecomCenterWeMustHoldYourMonText: ; unreferenced
	text_start
	done

GoldenrodPokecomCenterWhatMonDoYouWantText: ; unreferenced
	text_start
	done

GoldenrodPokecomCenterWeWillTradeYourMonForMonText: ; unreferenced
	text_start
	done

GoldenrodPokecomCenterWeWillTradeYourMonForNewText: ; unreferenced
	text_start
	done

GoldenrodPokecomCenterYourMonHasBeenReceivedText: ; unreferenced
	text_start
	done

GoldenrodPokecomCenterYouHaveOnlyOneMonText: ; unreferenced
	text_start
	done

GoldenrodPokecomCenterWeHopeToSeeYouAgainText: ; unreferenced
	text_start
	done

GoldenrodPokecomCenterCommunicationErrorText: ; unreferenced
	text_start
	done

GoldenrodPokecomCenterCantAcceptLastMonText: ; unreferenced
	text_start
	done

GoldenrodPokecomCenterCantAcceptEggText: ; unreferenced
	text_start
	done

GoldenrodPokecomCenterCantAcceptAbnormalMonText: ; unreferenced
	text_start
	done

GoldenrodPokecomCenterAlreadyHoldingMonText: ; unreferenced
	text_start
	done

GoldenrodPokecomCenterCheckingTheRoomsText: ; unreferenced
	text_start
	done

GoldenrodPokecomCenterTradePartnerHasBeenFoundText: ; unreferenced
	text_start
	done

GoldenrodPokecomCenterItsYourNewPartnerText: ; unreferenced
	text_start
	done

GoldenrodPokecomCenterYourPartyIsFullText: ; unreferenced
	text_start
	done

GoldenrodPokecomCenterNoTradePartnerFoundText: ; unreferenced
	text_start
	done

GoldenrodPokecomCenterReturnedYourMonText: ; unreferenced
	text_start
	done

GoldenrodPokecomCenterYourMonIsLonelyText: ; unreferenced
	text_start
	done

GoldenrodPokecenter1FWeHopeToSeeYouAgainText_2: ; unreferenced
	text_start
	done

GoldenrodPokecomCenterContinueToHoldYourMonText: ; unreferenced
	text_start
	done

GoldenrodPokecomCenterRecentlyLeftYourMonText: ; unreferenced
	text_start
	done

GoldenrodPokecomCenterSaveBeforeTradeCornerText: ; unreferenced
	text_start
	done

GoldenrodPokecomCenterWhichMonToTradeText: ; unreferenced
	text_start
	done

GoldenrodPokecomCenterTradeCanceledText: ; unreferenced
	text_start
	done

GoldenrodPokecomCenterEggTicketText: ; unreferenced
	text_start
	done

GoldenrodPokecomCenterOddEggBriefingText: ; unreferenced
	text_start
	done

GoldenrodPokecomCenterPleaseWaitAMomentText: ; unreferenced
	text_start
	done

GoldenrodPokecomCenterHereIsYourOddEggText: ; unreferenced
	text_start
	done

GoldenrodPokecomCenterNoEggTicketServiceText: ; unreferenced
	text_start
	done

GoldenrodPokecomCenterNewsMachineText: ; unreferenced
	text_start
	done

GoldenrodPokecomCenterWhatToDoText: ; unreferenced
	text_start
	done

GoldenrodPokecomCenterNewsMachineExplanationText: ; unreferenced
	text_start
	done

GoldenrodPokecomCenterWouldYouLikeTheNewsText: ; unreferenced
	text_start
	done

GoldenrodPokecomCenterReadingTheLatestNewsText: ; unreferenced
	text_start
	done

GoldenrodPokecomCenterNoOldNewsText: ; unreferenced
	text_start
	done

GoldenrodPokecomCenterCorruptedNewsDataText: ; unreferenced
	text_start
	done

GoldenrodPokecomCenterMakingPreparationsText: ; unreferenced
	text_start
	done

GoldenrodPokecomCenterSaveBeforeNewsMachineText: ; unreferenced
	text_start
	done

GoldenrodPokecomCenterPerson1Text: ; unreferenced
	text "Dieses #MON-"
	line "CENTER ist riesig."

	para "Es wurde soeben"
	line "fertig. Es gibt"

	para "auch viele neue"
	line "Maschinen."
	done

GoldenrodPokecomCenterPerson2Text: ; unreferenced
	text "Ich habe mir etwas"
	line "lustiges für die"
	cont "TAUSCHECKE aus-"
	cont "/LINE ADDEDgedacht"

	para "Ich gebe TAUBSI"
	line "einen BRIEF und"

	para "tausche es gegen"
	line "ein anderes!"

	para "Wenn das jeder"
	line "tut, könnte man"

	para "mit allen mög-"
	line "lichen Leuten"
	cont "BRIEFE tauschen!"

	para "Ich nenne das"
	line "TAUBSI-BRIEF!"

	para "Setzt es sich"
	line "durch, schließe"

	para "ich viele neue"
	line "Freundschaften!"
	done

GoldenrodPokecomCenterPerson3Text: ; unreferenced
	text "Sie sagen, dass"
	line "man dort sogar mit"

	para "Fremden tauschen"
	line "kann."

	para "Aber sie arbeiten"
	line "noch daran."
	done

GoldenrodPokecomCenterPerson4Text: ; unreferenced
	text "Ein mir fremdes"
	line "Mädchen schickte"

	para "mir ihr"
	line "HOPPSPROSS."

	para "Tausche #MON,"
	line "die du möchtest."
	done

GoldenrodPokecomCenterPerson5Text: ; unreferenced
	text "Ich erhielt ein"
	line "weibliches"
	cont "HOPPSPROSS, das"
	cont "SEAMUS heißt!"

	para "So heißt mein"
	line "Vater!"
	done

GoldenrodPokecomCenterPerson6Text: ; unreferenced
	text "Welches ist die"
	line "NACHRICHTEN-"
	cont "MASCHINE?"

	para "Bezieht sie die"
	line "Nachrichten"
	cont "nur vom Radio?"
	done

GoldenrodPokecomCenterPerson7Text: ; unreferenced
	text_start
	done

GoldenrodPokecomCenterPerson8Text: ; unreferenced
	text "Die Maschinen sind"
	line "noch nicht ein-"
	cont "satzbereit."

	para "Dennoch ist es"
	line "toll, solch einen"

	para "modernen Ort vor"
	line "allen anderen zu"
	cont "besuchen."
	done

GoldenrodPokecomCenterPerson9Text: ; unreferenced
	text "Mein Freund war"
	line "neulich in den"

	para "NACHRICHTEN. Das"
	line "hat mich"
	cont "überrascht!"
	done

GoldenrodPokecomCenterPerson10Text: ; unreferenced
	text "Ich werde unruhig,"
	line "wenn ich nicht"

	para "die neusten"
	line "NACHRICHTEN"

	para "bekomme!"
	done

GoldenrodPokecomCenterPerson11Text: ; unreferenced
	text "Wenn ich in die"
	line "NACHRICHTEN komme,"

	para "werde ich berühmt"
	line "und verehrt."

	para "Wie kann ich es"
	line "bloß in die NACH-"
	cont "RICHTEN schaffen?"
	done

GoldenrodPokecenter1FGameboyKidText:
	text "Im oberen Stock-"
	line "werk findest du"

	para "das KOLOSSEUM."
	line "Hier kannst du"

	para "gegen Freunde"
	line "antreten."

	para "Kampfergebnisse"
	line "werden an der Wand"

	para "ausgehängt. Ich"
	line "kann es mir nicht"

	para "erlauben, zu ver-"
	line "lieren."
	done

GoldenrodPokecomCenterPerson12Text: ; unreferenced
	text "Ich bin sofort"
	line "hierher gekommen,"

	para "als ich hörte,"
	line "dass das #MON-"
	cont "CENTER in DUKATIA"

	para "neue Maschinen"
	line "hat."

	para "Aber es scheint,"
	line "als seien sie noch"

	para "mitten in den"
	line "Vorbereitungen…"
	done

GoldenrodPokecomCenterPerson13Text: ; unreferenced
	text "Allein das Be-"
	line "trachten dieser"

	para "neuen Errungen-"
	line "schaften macht"
	cont "mich jünger!"
	done

GoldenrodPokecenter1FLassText:
	text "Ein starkes #-"
	line "MON muss nicht"
	cont "zwingend gewinnen."

	para "Meist entscheidet"
	line "der Vor- oder"
	cont "Nachteil des Typs."

	para "Ich glaube nicht,"
	line "dass es ein #-"
	cont "MON gibt, das al-"
	cont "len anderen über-"
	cont "legen ist."
	done

GoldenrodPokeCenter1FLinkReceptionistPleaseAcceptGSBallText:
	text "<PLAYER>, oder?"

	para "Glückwunsch!"

	para "Nur für dich wurde"
	line "ein GS-BALL"
	cont "geschickt!"

	para "Nimm ihn bitte!"
	done

GoldenrodPokeCenter1FLinkReceptionistPleaseDoComeAgainText:
	text "Beehre uns bald"
	line "wieder!"
	done

GoldenrodPokecomCenterSignText: ; unreferenced
	text_start
	done

GoldenrodPokecomCenterNewsMachineNotYetText: ; unreferenced
	text "Das ist eine #-"
	line "MON NACHRICHTEN-"
	cont "MASCHINE!"

	para "Sie ist noch nicht"
	line "in Betrieb…"
	done

GoldenrodPokecenter1FPokefanFDoYouHaveEonMailText:
	text "Oh, dein Beutel"
	line "sieht schwer aus!"

	para "Oh! Hast du zufäl-"
	line "lig etwas, das man"
	cont "ANARA-BRIEF nennt?"

	para "Meine Tochter"
	line "sucht danach."

	para "Du gibst mir doch"
	line "einen, nicht wahr?"
	done

GoldenrodPokecenter1FAskGiveAwayAnEonMailText:
	text "ANARA-BRIEF"
	line "weggeben?"
	done

GoldenrodPokecenter1FPokefanFThisIsForYouText:
	text "Oh, großartig!"
	line "Danke, Schatz!"

	para "Hier, als Aus-"
	line "gleich sollst"
	cont "du das haben!"
	done

GoldenrodPokecenter1FPokefanFDaughterWillBeDelightedText:
	text "Meine Tochter wird"
	line "entzückt sein!"
	done

GoldenrodPokecenter1FPokefanFTooBadText:
	text "Oh? Du hast"
	line "keinen? Schade."
	done

GoldenrodPokecenter1FPokefanFAnotherTimeThenText:
	text "Oh… Ein anderes"
	line "Mal vielleicht."
	done

GoldenrodPokecenter1FPlayerGaveAwayTheEonMailText:
	text "<PLAYER> gibt den"
	line "ANARA-BRIEF weg."
	done

GoldenrodPokecenter1F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  3,  7, GOLDENROD_CITY, 15
	warp_event  4,  7, GOLDENROD_CITY, 15
	warp_event  0,  6, POKECOM_CENTER_ADMIN_OFFICE_MOBILE, 1
	warp_event  0,  7, POKECENTER_2F, 1

	def_coord_events
	coord_event  3,  7, SCENE_GOLDENRODPOKECENTER1F_GS_BALL, GoldenrodPokecenter1F_GSBallSceneLeft
	coord_event  4,  7, SCENE_GOLDENRODPOKECENTER1F_GS_BALL, GoldenrodPokecenter1F_GSBallSceneRight

	def_bg_events

	def_object_events
	object_event  3,  1, SPRITE_NURSE, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, GoldenrodPokecenter1FNurseScript, -1
	object_event 16,  8, SPRITE_LINK_RECEPTIONIST, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, ObjectEvent, -1
	object_event  6,  1, SPRITE_GAMEBOY_KID, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, GoldenrodPokecenter1FGameboyKidScript, -1
	object_event  1,  4, SPRITE_LASS, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, GoldenrodPokecenter1FLassScript, -1
	object_event  7,  5, SPRITE_POKEFAN_F, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, GoldenrodPokecenter1FPokefanF, -1
