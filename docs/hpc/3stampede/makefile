S3_OBJS	=	\
	notices.md \
	system.md \
	access.md \
	admin.md \
	files.md \
	running.md \
	launching.md \
	building.md \
	scripts.md \
	jobmanagement.md \
	ml.md \
	../../include/stampede3-help.md 
#	mkl.md \
#	programming.md \
#	vis.md \
#	refs.md

all:	stampede3

stampede3:	$(S3_OBJS)
	cat $(S3_OBJS) > stampede3.md
	cat ../../aliases.md >> stampede3.md
	/bin/mv stampede3.md ..


