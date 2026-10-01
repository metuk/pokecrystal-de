AlanAnswerPhoneText:
	text "Ich, @"
	text_ram wStringBuffer3
	text "!"

	para "<PLAY_G>, oder?"
	line "Guten Morgen!"
	done

AlanAnswerPhoneDayText:
	text "Ich, @"
	text_ram wStringBuffer3
	text "!"

	para "<PLAY_G>, oder?"
	done

AlanAnswerPhoneNiteText:
	text "Ich, @"
	text_ram wStringBuffer3
	text "!"

	para "<PLAY_G>, oder?"
	line "Guten Abend!"
	done

AlanGreetText:
	text "Hallo! Ich biるs,"
	line "@"
	text_ram wStringBuffer3
	text "!"
	done

AlanGreetDayText:
	text "Hallo! Ich biるs,"
	line "@"
	text_ram wStringBuffer3
	text "!"
	done

AlanGreetNiteText:
	text "Hallo! Ich biるs,"
	line "@"
	text_ram wStringBuffer3
	text "!"
	done

AlanGenericText:
	text "<PLAY_G>, trai-"
	line "nierst du deine"
	cont "#MON richtig?"

	para "Ich habe gelesen,"
	line "dass man die #-"
	cont "MON, die man fängt"
	cont "mit Liebe und"

	para "Umsicht trainieren"
	line "soll."
	done
