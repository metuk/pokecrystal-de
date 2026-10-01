PokedexTypeSearchStrings:
; entries correspond with PokedexTypeSearchConversionTable (see data/types/search_types.asm)
	table_width POKEDEX_TYPE_STRING_LENGTH
	db "  ----  @"
	db " NORMAL @"
	db " FEUER  @"
	db " WASSER @"
	db "PFLANZE @"
	db "ELEKTRO @"
	db "  EIS   @"
	db " KAMPF  @"
	db "  GIFT  @"
	db " BODEN  @"
	db "  FLUG  @"
	db " PSYCHO @"
	db " KÄFER  @"
	db "GESTEIN @"
	db " GEIST  @"
	db "DRACHEN @"
	db "UNLICHT @"
	db " STAHL  @"
	assert_table_length NUM_TYPES + 1
