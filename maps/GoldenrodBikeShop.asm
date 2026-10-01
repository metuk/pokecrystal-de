	object_const_def
	const GOLDENRODBIKESHOP_CLERK

GoldenrodBikeShop_MapScripts:
	def_scene_scripts

	def_callbacks

GoldenrodBikeShopNoopScene: ; unreferenced
	end

GoldenrodBikeShopClerkScript:
	faceplayer
	opentext
	checkevent EVENT_GOT_BICYCLE
	iftrue .GotBicycle
	writetext GoldenrodBikeShopClerkIntroText
	yesorno
	iffalse .Refused
	writetext GoldenrodBikeShopClerkAgreedText
	promptbutton
	waitsfx
	giveitem BICYCLE
	writetext BorrowedABicycleText
	playsound SFX_KEY_ITEM
	waitsfx
	itemnotify
	setflag ENGINE_BIKE_SHOP_CALL_ENABLED
	setevent EVENT_GOT_BICYCLE
.GotBicycle:
	writetext GoldenrodBikeShopClerkFirstRateBikesText
	waitbutton
	closetext
	end

.Refused:
	writetext GoldenrodBikeShopClerkRefusedText
	waitbutton
	closetext
	end

GoldenrodBikeShopJustReleasedCompactBike: ; unreferenced
	jumptext GoldenrodBikeShopJustReleasedCompactBikeText

GoldenrodBikeShopBicycle:
	jumptext GoldenrodBikeShopBicycleText

GoldenrodBikeShopClerkIntroText:
	text "…Seufz… Ich bin"
	line "hierher gezogen,"

	para "aber ich kann mei-"
	line "ne FAHRRÄDER nicht"

	para "verkaufen. Warum"
	line "nur?"

	para "Würdest du ein"
	line "FAHRRAD fahren und"
	cont "so Werbung machen?"
	done

GoldenrodBikeShopClerkAgreedText:
	text "Ja? Großartig!"

	para "Gib mir bitte"
	line "Namen und Nummer."

	para "Dann leihe ich dir"
	line "ein FAHRRAD."
	done

BorrowedABicycleText:
	text "<PLAYER> leiht sich"
	line "ein FAHRRAD aus."
	done

GoldenrodBikeShopClerkFirstRateBikesText:
	text "Meine FAHRRÄDER"
	line "sind erste Klasse!"

	para "Du kannst sie"
	line "überall fahren."
	done

GoldenrodBikeShopClerkRefusedText:
	text "…Seufz… Oh, für"
	line "die Güte der"
	cont "Menschen…"
	done

GoldenrodBikeShopJustReleasedCompactBikeText:
	text "Brandneu!"

	para "Erste Klasse Kom-"
	line "pakt-FAHRRÄDER!"
	done

GoldenrodBikeShopBicycleText:
	text "Ein nagelneues"
	line "FAHRRAD!"
	done

GoldenrodBikeShop_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, GOLDENROD_CITY, 2
	warp_event  3,  7, GOLDENROD_CITY, 2

	def_coord_events

	def_bg_events
	bg_event  1,  2, BGEVENT_READ, GoldenrodBikeShopBicycle
	bg_event  0,  3, BGEVENT_READ, GoldenrodBikeShopBicycle
	bg_event  1,  3, BGEVENT_READ, GoldenrodBikeShopBicycle
	bg_event  0,  5, BGEVENT_READ, GoldenrodBikeShopBicycle
	bg_event  1,  5, BGEVENT_READ, GoldenrodBikeShopBicycle
	bg_event  0,  6, BGEVENT_READ, GoldenrodBikeShopBicycle
	bg_event  1,  6, BGEVENT_READ, GoldenrodBikeShopBicycle
	bg_event  6,  6, BGEVENT_READ, GoldenrodBikeShopBicycle
	bg_event  7,  6, BGEVENT_READ, GoldenrodBikeShopBicycle

	def_object_events
	object_event  7,  2, SPRITE_CLERK, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, GoldenrodBikeShopClerkScript, -1
