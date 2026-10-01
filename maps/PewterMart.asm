	object_const_def
	const PEWTERMART_CLERK
	const PEWTERMART_YOUNGSTER
	const PEWTERMART_SUPER_NERD

PewterMart_MapScripts:
	def_scene_scripts

	def_callbacks

PewterMartClerkScript:
	opentext
	pokemart MARTTYPE_STANDARD, MART_PEWTER
	closetext
	end

PewterMartYoungsterScript:
	jumptextfaceplayer PewterMartYoungsterText

PewterMartSuperNerdScript:
	jumptextfaceplayer PewterMartSuperNerdText

PewterMartYoungsterText:
	text "Hi! Mach doch"
	line "Bekanntschaft mit"
	cont "meinem GARADOS!"

	para "Ich habe es als"
	line "KARPADOR auf-"
	cont "gezogen. Kaum zu"

	para "glauben, wie stark"
	line "es geworden ist."
	done

PewterMartSuperNerdText:
	text "Es gab mal einen"
	line "komischen, alten"
	cont "Mann, der KARPADOR"
	cont "verkaufte."

	para "Er sagte immer,"
	line "die KARPADOR im"

	para "SEE DES ZORNS"
	line "seien"
	cont "außergewöhnlich."
	done

PewterMart_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, PEWTER_CITY, 3
	warp_event  3,  7, PEWTER_CITY, 3

	def_coord_events

	def_bg_events

	def_object_events
	object_event  1,  3, SPRITE_CLERK, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, PewterMartClerkScript, -1
	object_event  9,  2, SPRITE_YOUNGSTER, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 2, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, PewterMartYoungsterScript, -1
	object_event  6,  6, SPRITE_SUPER_NERD, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, PewterMartSuperNerdScript, -1
