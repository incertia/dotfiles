CC = gcc
CFLAGS = -O3 -Wall -std=c99
ODIR = obj/
BINDIR = bin/

INSTALL_DEST = /usr/local/bin/

all: $(BINDIR)ida_patcher

install: $(BINDIR)ida_patcher
	install --strip $(BINDIR)ida_patcher $(INSTALL_DEST)
	install cutf.sh $(INSTALL_DEST)cutf

$(BINDIR)ida_patcher: $(ODIR)ida_patcher.o
	$(CC) $(CFLAGS) -o $(BINDIR)ida_patcher $(ODIR)ida_patcher.o

$(ODIR)%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

.PHONY: clean

clean:
	rm -rf $(ODIR)*.o *~ $(BINDIR)*
