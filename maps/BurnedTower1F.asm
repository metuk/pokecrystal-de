	object_const_def
	const BURNEDTOWER1F_ROCK
	const BURNEDTOWER1F_EUSINE
	const BURNEDTOWER1F_RIVAL
	const BURNEDTOWER1F_MORTY
	const BURNEDTOWER1F_POKE_BALL

BurnedTower1F_MapScripts:
	def_scene_scripts
	scene_script BurnedTower1FMeetEusineScene, SCENE_BURNEDTOWER1F_MEET_EUSINE
	scene_script BurnedTower1FNoop1Scene,      SCENE_BURNEDTOWER1F_RIVAL_BATTLE
	scene_script BurnedTower1FNoop2Scene,      SCENE_BURNEDTOWER1F_NOOP

	def_callbacks
	callback MAPCALLBACK_TILES, BurnedTower1FHoleAndLadderCallback

BurnedTower1FMeetEusineScene:
	sdefer BurnedTower1FMeetEusineScript
	end

BurnedTower1FNoop1Scene:
	end

BurnedTower1FNoop2Scene:
	end

BurnedTower1FHoleAndLadderCallback:
	checkevent EVENT_HOLE_IN_BURNED_TOWER
	iftrue .KeepHoleOpen
	changeblock 10, 8, $32 ; floor
.KeepHoleOpen:
	checkevent EVENT_RELEASED_THE_BEASTS
	iftrue .HideBasement
	changeblock 6, 14, $09 ; ladder
.HideBasement:
	endcallback

BurnedTower1FMeetEusineScript:
	turnobject BURNEDTOWER1F_EUSINE, DOWN
	showemote EMOTE_SHOCK, BURNEDTOWER1F_EUSINE, 15
	applymovement BURNEDTOWER1F_EUSINE, BurnedTower1FEusineMovement
	opentext
	writetext BurnedTower1FEusineIntroText
	waitbutton
	closetext
	moveobject BURNEDTOWER1F_EUSINE, 9, 14
	setscene SCENE_BURNEDTOWER1F_RIVAL_BATTLE
	end

BurnedTowerRivalBattleScript:
	showemote EMOTE_SHOCK, BURNEDTOWER1F_RIVAL, 15
	special FadeOutMusic
	pause 15
	turnobject BURNEDTOWER1F_RIVAL, RIGHT
	pause 15
	applymovement PLAYER, BurnedTowerMovement_PlayerWalksToRival
	applymovement BURNEDTOWER1F_RIVAL, BurnedTowerMovement_RivalWalksToPlayer
	playmusic MUSIC_RIVAL_ENCOUNTER
	opentext
	writetext BurnedTowerRival_BeforeText
	waitbutton
	closetext
	checkevent EVENT_GOT_TOTODILE_FROM_ELM
	iftrue .totodile
	checkevent EVENT_GOT_CHIKORITA_FROM_ELM
	iftrue .chikorita
	winlosstext BurnedTowerRival_WinText, BurnedTowerRival_LossText
	setlasttalked BURNEDTOWER1F_RIVAL
	loadtrainer RIVAL1, RIVAL1_3_TOTODILE
	startbattle
	dontrestartmapmusic
	reloadmapafterbattle
	sjump .returnfrombattle

.totodile
	winlosstext BurnedTowerRival_WinText, BurnedTowerRival_LossText
	setlasttalked BURNEDTOWER1F_RIVAL
	loadtrainer RIVAL1, RIVAL1_3_CHIKORITA
	startbattle
	dontrestartmapmusic
	reloadmapafterbattle
	sjump .returnfrombattle

.chikorita
	winlosstext BurnedTowerRival_WinText, BurnedTowerRival_LossText
	setlasttalked BURNEDTOWER1F_RIVAL
	loadtrainer RIVAL1, RIVAL1_3_CYNDAQUIL
	startbattle
	dontrestartmapmusic
	reloadmapafterbattle
	sjump .returnfrombattle

.returnfrombattle
	playmusic MUSIC_RIVAL_AFTER
	opentext
	writetext BurnedTowerRival_AfterText1
	waitbutton
	closetext
	setscene SCENE_BURNEDTOWER1F_NOOP
	setevent EVENT_RIVAL_BURNED_TOWER
	special FadeOutMusic
	pause 15
	earthquake 50
	showemote EMOTE_SHOCK, PLAYER, 15
	playsound SFX_ENTER_DOOR
	waitsfx
	changeblock 10, 8, $25 ; hole
	refreshmap
	pause 15
	applymovement PLAYER, BurnedTower1FMovement_PlayerStartsToFall
	playsound SFX_KINESIS
	showemote EMOTE_SHOCK, BURNEDTOWER1F_RIVAL, 20
	opentext
	writetext BurnedTowerRival_AfterText2
	waitbutton
	closetext
	setevent EVENT_HOLE_IN_BURNED_TOWER
	pause 15
	warpcheck
	end

BurnedTower1FEusineScript:
	jumptextfaceplayer BurnedTower1FEusineText

BurnedTower1FMortyScript:
	jumptextfaceplayer BurnedTower1FMortyText

BurnedTower1FRock:
	jumpstd SmashRockScript

BurnedTower1FHiddenEther:
	hiddenitem ETHER, EVENT_BURNED_TOWER_1F_HIDDEN_ETHER

BurnedTower1FHiddenUltraBall:
	hiddenitem ULTRA_BALL, EVENT_BURNED_TOWER_1F_HIDDEN_ULTRA_BALL

BurnedTower1FHPUp:
	itemball HP_UP

BurnedTowerMovement_PlayerWalksToRival:
	step LEFT
	step_end

BurnedTowerMovement_RivalWalksToPlayer:
	step RIGHT
	step_end

BurnedTower1FMovement_PlayerStartsToFall:
	skyfall_top
	step_end

BurnedTower1FEusineMovement:
	step DOWN
	step LEFT
	step LEFT
	step LEFT
	step DOWN
	step_end

BurnedTowerRival_BeforeText:
	text "<……> <……> <……>"

	para "…Oh, du bist es."

	para "Ich suchte nach"
	line "legendären #-"
	cont "MON, die angeblich"
	cont "hier leben."

	para "Aber hier ist"
	line "nichts!"

	para "Nichts, das den"
	line "Aufwand hierher zu"

	para "kommen, recht-"
	line "fertigt! Absolut"
	cont "nichts."

	para "Das ist alles"
	line "deine Schuld!"
	done

BurnedTowerRival_WinText:
	text "…Humpf!"

	para "Darum hasse ich"
	line "es, gegen Schwäch-"
	cont "linge anzutreten."

	para "Es ist keine"
	line "Herausforderung."
	done

BurnedTowerRival_AfterText1:
	text "…Ach, egal!"

	para "Du wärst sowieso"
	line "nicht fähig, ein"

	para "legendäres #MON"
	line "zu fangen."
	done

BurnedTowerRival_LossText:
	text "…Humpf!"

	para "Ich hasse es, ge-"
	line "gen Schwächlinge"

	para "anzutreten. Es ist"
	line "Zeitverschwendung."
	done

BurnedTowerRival_AfterText2:
	text "Humpf!"

	para "Was hast du dir"
	line "dabei gedacht,"

	para "einfach in ein"
	line "Loch zu fallen?"
	cont "Du Genie!"

	para "Das geschieht dir"
	line "recht!"
	done

BurnedTower1FEusineIntroText:
	text "EUSIN: Ich heiße"
	line "EUSIN."

	para "Ich bin auf der"
	line "Suche nach einem"
	cont "#MON namens"
	cont "SUICUNE."

	para "Und wer bist du…?"

	para "<PLAYER>? Schön,"
	line "dich kennen"
	cont "zu lernen!"

	para "Ich hörte, dass"
	line "SUICUNE hier in"

	para "der TURMRUINE ist,"
	line "also wollte ich es"
	cont "sehen."

	para "Aber wo genau ist"
	line "es?"
	done

BurnedTower1FEusineText:
	text "Ich hörte, dass"
	line "SUICUNE hier in"

	para "der TURMRUINE ist,"
	line "also wollte ich es"
	cont "sehen."

	para "Aber wo genau ist"
	line "es?"
	done

BurnedTower1FMortyText:
	text "JENS: Der ARENA-"
	line "LEITER von TEAK"

	para "CITY, muss die"
	line "sogenannten"

	para "legendären #MON"
	line "- SUICUNE, ENTEI"
	cont "und RAIKOU -"
	cont "studieren."

	para "EUSIN ist ge-"
	line "kommen, also habe"

	para "ich beschlossen,"
	line "den TURM mit ihm"
	cont "zu untersuchen."
	done

BurnedTower1F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  9, 15, ECRUTEAK_CITY, 13
	warp_event 10, 15, ECRUTEAK_CITY, 13
	warp_event 10,  9, BURNED_TOWER_B1F, 1
	warp_event  5,  5, BURNED_TOWER_B1F, 1 ; inaccessible, left over from G/S
	warp_event  5,  6, BURNED_TOWER_B1F, 1 ; inaccessible, left over from G/S
	warp_event  4,  6, BURNED_TOWER_B1F, 1 ; inaccessible, left over from G/S
	warp_event 15,  4, BURNED_TOWER_B1F, 2 ; inaccessible, left over from G/S
	warp_event 15,  5, BURNED_TOWER_B1F, 2 ; inaccessible, left over from G/S
	warp_event 10,  7, BURNED_TOWER_B1F, 3 ; inaccessible, left over from G/S
	warp_event  5, 14, BURNED_TOWER_B1F, 4 ; inaccessible, left over from G/S
	warp_event  4, 14, BURNED_TOWER_B1F, 4 ; inaccessible, left over from G/S
	warp_event 14, 14, BURNED_TOWER_B1F, 5 ; inaccessible, left over from G/S
	warp_event 15, 14, BURNED_TOWER_B1F, 5 ; inaccessible, left over from G/S
	warp_event  7, 15, BURNED_TOWER_B1F, 6 ; inaccessible, left over from G/S

	def_coord_events
	coord_event 11,  9, SCENE_BURNEDTOWER1F_RIVAL_BATTLE, BurnedTowerRivalBattleScript

	def_bg_events
	bg_event  8,  7, BGEVENT_ITEM, BurnedTower1FHiddenEther
	bg_event 13, 11, BGEVENT_ITEM, BurnedTower1FHiddenUltraBall

	def_object_events
	object_event 15,  4, SPRITE_ROCK, SPRITEMOVEDATA_SMASHABLE_ROCK, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, BurnedTower1FRock, -1
	object_event 12, 12, SPRITE_SUPER_NERD, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, BurnedTower1FEusineScript, EVENT_BURNED_TOWER_1F_EUSINE
	object_event  8,  9, SPRITE_RIVAL, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, 0, OBJECTTYPE_TRAINER, 3, ObjectEvent, EVENT_RIVAL_BURNED_TOWER
	object_event 14, 14, SPRITE_MORTY, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, BurnedTower1FMortyScript, EVENT_BURNED_TOWER_MORTY
	object_event 14,  2, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, BurnedTower1FHPUp, EVENT_BURNED_TOWER_1F_HP_UP
