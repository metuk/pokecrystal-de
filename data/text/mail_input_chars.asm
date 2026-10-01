; see engine/menus/naming_screen.asm

MailEntry_Uppercase:
	db "A B C D E F G H I J"
	db "K L M N O P Q R S T"
	db "U V W X Y Z   , ? !"
	db "1 2 3 4 5 6 7 8 9 0"
	db "<PK> <MN> <PO> <KE> é ♂ ♀ ¥ … ×"
	db "lower  DEL   END   "

MailEntry_Lowercase:
	db   "a b c d e f g h i jk l m n o p q r s tu v w x y z   . - /Ä Ö Ü ä に ぬ ö ü せ  ( ) “ ” [ ] ' : ; &GROせ  LÖSCH ENDE   どヅ<NULL>ゲさ<BOLD_C><WATASHI>"
	para "<NULL>ダ", $17, "<NULL>Rゾ", $04, "?<BOLD_C>ゲ'l<BOLD_C>ぃ8ぺ<SCROLL>わ<BOLD_C>F", $01, "<NULL>Lぶぴ<MOM>Rぺ<SCROLL>わ<BOLD_C>#<SCROLL><PK><BOLD_C>#<MOM>R<CR>ぬ<_CONT><PO>@"
