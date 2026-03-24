HORIZON_OBJS	=	\
	notices.md \
	system.md \
	running.md \
	mps.md \
	nvidia.md 

#	files.md \
#	mkl.md \
#	scripts.md \
#	programming.md \
#	python.md \
#	vis.md \
#	access.md \
#	admin.md \
#	launching.md \
#	jobmanagement.md \
#	building.md \
#	../../include/horizon-help.md \
#	refs.md
#	ml.md \

all:	horizon

horizon:	$(HORIZON_OBJS)
	cat $(HORIZON_OBJS) > horizon.md
	cat ../../aliases.md >> horizon.md
	/bin/mv horizon.md ..


