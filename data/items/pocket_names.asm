ItemPocketNames:
; entries correspond to item type constants
	table_width 2
	dw .Item
	dw .Key
	dw .Ball
	dw .TM
	assert_table_length NUM_ITEM_TYPES

.Item: db "ITEM-TASCHE@"
.Key:  db "BASIS-ITEMS@"
.Ball: db "BALL-TASCHE@"
.TM:   db "TM-TASCHE@"
