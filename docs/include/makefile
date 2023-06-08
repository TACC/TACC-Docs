HAML=	/usr/local/bin/md

SRC	=	scratchpolicy.md mklsrc.md taccinfosrc.md helpsrc.md jobaccountingsrc.md

all:	includes 

.SUFFIXES:	.md .html

includes:	$(SRC)
	./configurestrings.sh frontera
	./configurestrings.sh lonestar6
	./configurestrings.sh stampede2
#	./configurestrings.sh maverick2
	./configurestrings.sh ranch
	./configurestrings.sh defaults


clean:
	/bin/rm -f $(OBJ) *.html &2> /dev/null

