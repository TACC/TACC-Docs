HORIZON_OBJS	=	\
	notices.md \
	system.md \
	access.md \
	admin.md \
	files.md \
	running.md \
	launching.md \
	jobmanagement.md \
	mps.md \
	building.md \
	nvidia.md \
	../../include/horizon-help.md 

#	mkl.md \
#	scripts.md \
#	programming.md \
#	python.md \
#	vis.md \
#	access.md \
#	admin.md \
#	refs.md
#	ml.md \

all:	horizon

horizon:	$(HORIZON_OBJS)
	cat $(HORIZON_OBJS) > horizon.md
	cat ../../aliases.md >> horizon.md
	/bin/mv horizon.md ..


