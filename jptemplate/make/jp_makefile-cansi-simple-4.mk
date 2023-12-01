# Makefile: A standard Makefile for main.c
program        = main
source         = $(wildcard	*.c)
objects        = $(source:.c=.o)

d              =\
$$PWD

cscope_init    =\
	find $d -name '*.c' -o -name '*.h' > cscope.files;\
	cscope -b;\
	echo "CSCOPE_DB=$$PWD/cscope.out; export CSCOPE_DB"

ctags_init     =\
	ctags -R --c-kinds=+p --fields=+iaS --extra=+q \
	`find $d -name '*.c' -o -name '*.h'`

LDFLAGS        =

all       :$(program)

$(program):$(objects)

asssist   :
	@make CC='gccrec gcc-code-assist'

tags      :ctags cscope

ctags     :
	$(shell $(ctags_init) )

cscope    :
	$(shell $(cscope_init))

cproto    :
	$(shell $(cproto_cmd))

clean     :
	/bin/rm -rf $(program) $(objects)
	@/bin/rm -rf tags *.orig cscope.* *~
# END OF FILE

