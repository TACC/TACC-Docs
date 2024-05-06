LONESTAR6_OBJS	=	\
	notices.md \
	system.md \
	files.md \
	admin.md \
	building.md \
	launching.md \
	running.md \
	scripts.md \
	jobmanagement.md \
	ml.md \
	vis.md \
	../../include/lonestar6-help.md 

all:	lonestar6

lonestar6:	$(LONESTAR6_OBJS)
	cat $(LONESTAR6_OBJS) > lonestar6.md
	cat ../../aliases.md >> lonestar6.md
	/bin/mv lonestar6.md ..


