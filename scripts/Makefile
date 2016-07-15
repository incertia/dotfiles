CC = gcc
CFLAGS = -O3 -Wall -std=c99
ODIR = obj/
BINDIR = bin/

INSTALL_BINDIR = $(HOME)/bin/
INSTALL_SCRIPTDIR = $(HOME)/scripts/

all: $(BINDIR)ida_patcher $(BINDIR)forker

install: $(BINDIR)ida_patcher $(BINDIR)forker
	install --strip $(BINDIR)ida_patcher $(INSTALL_BINDIR)
	install --strip $(BINDIR)forker $(INSTALL_BINDIR)
	install cutf.sh $(INSTALL_SCRIPTDIR)cutf
	install swap.sh $(INSTALL_SCRIPTDIR)swap

$(BINDIR)ida_patcher: $(ODIR)ida_patcher.o
	$(CC) $(CFLAGS) -o $(BINDIR)ida_patcher $(ODIR)ida_patcher.o

$(BINDIR)forker: $(ODIR)forker.o
	$(CC) $(CFLAGS) -pthread -o $(BINDIR)ida_patcher $(ODIR)ida_patcher.o

$(ODIR)%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

.PHONY: clean

clean:
	rm -rf $(ODIR)*.o *~ $(BINDIR)*
