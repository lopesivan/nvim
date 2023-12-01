CC      = gcc
CFLAGS  = -g -O2
LD      = gcc
LDFLAGS = -o $@
LIBS    = -lbla
OBJS    = a.o b.o c.o
BIN     = abc

.c.o:
	$(CC) -c $(CFLAGS) -o $@ $<

all: $(BIN)

$(BIN): $(OBJS)
	$(LD) $(LDFLAGS) $+ $(LIBS)

clean:
	rm -f $(OBJS) core

