	object_const_def
	const VERMILIONFISHINGSPEECHHOUSE_FISHING_GURU

VermilionFishingSpeechHouse_MapScripts:
	def_scene_scripts

	def_callbacks

FishingDude:
	jumptextfaceplayer FishingDudeText

FishingDudesHousePhoto:
	jumptext FishingDudesHousePhotoText

FishingDudesHouseBookshelf: ; unreferenced
	jumpstd PictureBookshelfScript

FishingDudeText:
	text "Ich bin der ANG-"
	line "LER, der Ältere"
	cont "der ANGLERBRÜDER."

	para "Hast du den PROFI-"
	line "ANGLER am SEE DES"
	cont "ZORNS getroffen?"

	para "Er träumt davon,"
	line "das größte"

	para "KARPADOR der Welt"
	line "zu sehen."

	para "Falls es dir"
	line "nichts ausmacht,"

	para "könntest du ihm"
	line "jedes KARPADOR"

	para "zeigen, das du"
	line "fängst?"

	para "Wer weiß, viel-"
	line "leicht fängst du"

	para "das KARPADOR"
	line "seiner Träume."
	done

FishingDudesHousePhotoText:
	text "Das ist ein Foto,"
	line "auf dem Angler zu"
	cont "sehen sind…"

	para "Sie haben viel"
	line "Spaß beim Angeln…"
	done

VermilionFishingSpeechHouse_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, VERMILION_CITY, 1
	warp_event  3,  7, VERMILION_CITY, 1

	def_coord_events

	def_bg_events
	bg_event  3,  0, BGEVENT_READ, FishingDudesHousePhoto

	def_object_events
	object_event  2,  4, SPRITE_FISHING_GURU, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, FishingDude, -1
