# Lonestar6 User Guide
# ├── Getting Started
# ├── System Overview
# ├── Storage and Data Management
# ├── Running Jobs
# ├── Software and Development
# ├── AI, GPUs, and Machine Learning
# ├── Interactive Computing and Visualization
# ├── Monitoring and Performance
# ├── Troubleshooting
# ├── Reference
# └── Support and Community

all:	ug

UG_OBJS = \
	homepage.md \
	gettingstarted.md \
	system.md \
	storage.md \
	running.md \
	softwaredev.md \
	ml.md \
	interactive.md \
	monitoring.md \
	troubleshooting.md \
	refs.md \
	support.md


ug:	$(UG_OBJS)
	cat $(UG_OBJS) > ug.md
	cat ../../aliases.md >> ug.md
	/bin/mv ug.md ..



