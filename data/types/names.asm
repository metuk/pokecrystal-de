TypeNames:
; entries correspond to types (see constants/type_constants.asm)
	table_width 2

	dw Normal
	dw Fighting
	dw Flying
	dw Poison
	dw Ground
	dw Rock
	dw Bird
	dw Bug
	dw Ghost
	dw Steel
	assert_table_length UNUSED_TYPES

rept UNUSED_TYPES_END - UNUSED_TYPES - 1 ; discount CURSE_TYPE
	dw Normal
endr
	dw CurseType
	assert_table_length UNUSED_TYPES_END

	dw Fire
	dw Water
	dw Grass
	dw Electric
	dw Psychic
	dw Ice
	dw Dragon
	dw Dark
	assert_table_length TYPES_END

Normal:    db "NORMAL@"
Fighting:  db "KAMPF@"
Flying:    db "FLUG@"
Poison:    db "GIFT@"
CurseType: db "???@"
Fire:      db "FEUER@"
Water:     db "WASSER@"
Grass:     db "PFLANZE@"
Electric:  db "ELEKTRO@"
Psychic:   db "PSYCHO@"
Ice:       db "EIS@"
Ground:    db "BODEN@"
Rock:      db "GESTEIN@"
Bird:      db "@"
Bug:       db "KÄFER@"
Ghost:     db "GEIST@"
Steel:     db "STAHL@"
Dragon:    db "DRACHEN@"
Dark:      db "UNLICHT@"
