VISTA_OBJS	=	\
	notices.md \
	admin.md \
	system.md \
	running.md \
	launching.md \
	mps.md \
	ml.md \
	building.md \
	nvidia.md \
	../../include/vista-help.md \
	refs.md
#	access.md \
#	files.md \
#	mkl.md \
#	scripts.md \
#	jobmanagement.md \
#	programming.md \
#	ml.md \
#	python.md \
#	vis.md \
#	refs.md

all:	vista

vista:	$(VISTA_OBJS)
	cat $(VISTA_OBJS) > vista.md
	cat ../../aliases.md >> vista.md
	/bin/mv vista.md ..


