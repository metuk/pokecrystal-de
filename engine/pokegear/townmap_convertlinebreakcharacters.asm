TownMap_ConvertLineBreakCharacters:
	ld hl, wStringBuffer1
.loop
	ld a, [hl]
	cp '@'
	jr z, .end
	cp '<WBR>'
	jr z, .line_feed
	cp '<BSP>'
	jr z, .line_feed
	cp '<SHY>'
	jr z, .hyphen
	inc hl
	jr .loop

.hyphen
	ld [hl], '<-LF>'
	jr .end

.line_feed
	ld [hl], '<LF>'

.end
	ld de, wStringBuffer1
	hlcoord 9, 0
	call PlaceString
	ret
