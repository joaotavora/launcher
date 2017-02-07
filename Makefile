CC ?= gcc
CFLAGS ?= -std=c99 -Wall
OUTPUT ?= build
IGNORE := $(shell mkdir -p $(OUTPUT))

.PHONY = all lin win mac
all:

lin: $(OUTPUT)/lin
$(OUTPUT)/lin: portacle_lin.c portacle.c fontreg_lin.c fontreg.c ld-wrap.c
	$(CC) -o "$(OUTPUT)/ld-wrap.so" $(CFLAGS) -D_GNU_SOURCE -fPIC -shared -Wl,-init,init "ld-wrap.c" -ldl
	$(CC) -o "$(OUTPUT)/fontreg" $(CFLAGS) -static "fontreg.c"
	$(CC) -o "$(OUTPUT)/portacle" $(CFLAGS) -static -D_GNU_SOURCE "portacle.c"
	touch "$(OUTPUT)/lin"

win: $(OUTPUT)/win
$(OUTPUT)/win: portacle_win.c portacle.c fontreg_win.c fontreg.c
	$(CC) -o "$(OUTPUT)/fontreg.exe" $(CFLAGS) "fontreg.c" -mwindows
	windres -o "$(OUTPUT)/portacle.res" "portacle.rc" -O coff
	$(CC) -o "$(OUTPUT)/portacle.exe" $(CFLAGS) "portacle.c" "$(OUTPUT)/portacle.res" -lshlwapi -mwindows -mconsole
	touch "$(OUTPUT)/win"

mac: $(OUTPUT)/mac
$(OUTPUT)/mac: portacle_mac.c portacle.c fontreg_lin.c fontreg.c
	$(CC) -o "$(OUTPUT)/fontreg" $(CFLAGS) -static "fontreg.c"
	$(CC) -o "$(OUTPUT)/portacle" $(CFLAGS) -static "portacle.c"
	touch "$(OUTPUT)/mac"
