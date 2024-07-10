VISTA_OBJS	=	\
	notices.md \
	system.md \
#	access.md \
#	admin.md \
#	files.md \
#	running.md \
#	launching.md \
#	building.md \
#	mkl.md \
#	scripts.md \
#	jobmanagement.md \
#	programming.md \
#	ml.md \
#	python.md \
#	../../include/vista-help.md 
#	vis.md \
#	refs.md

all:	vista

vista:	$(VISTA_OBJS)
	cat $(VISTA_OBJS) > vista.md
	cat ../../aliases.md >> vista.md
	/bin/mv vista.md ..


