StatNames:
; entries correspond to stat ids
	list_start STRING_BUFFER_LENGTH - 1
	li "ANGR"
	li "VER"
	li "INIT"
	li "SPEZ.ANG"
	li "SPEZ.VER"
	li "GENAUIGKEIT"
	li "FLUCHTWERT"
	li "FÄHIGKEIT" ; used for BattleCommand_Curse
	assert_list_length NUM_LEVEL_STATS
