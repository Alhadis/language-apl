all: toggle


toggle: grammars/apl.cson
	@grep 'ALPHA | BRAVO' $< >/dev/null && { \
		sed -ri -e 's/(ALPHA \| BRAVO)/\ALPHA/' $<; \
		echo 'Crash disabled'; \
	} || { \
		sed -ri -e 's/\( ALPHA \)/\( ALPHA | BRAVO \)/' $<; \
		echo 'Crash enabled'; \
	}

.PHONY: toggle
