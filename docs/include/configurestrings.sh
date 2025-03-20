#!/bin/sh
# include files for all TUP documentation, mostly HPC guidees
# this workflow is a remnant from way back when, slowly changing functionality

# Frontera
if [ "$1" = "frontera" ] 
then
	echo "building includes for Frontera user guide"
	machinename="Frontera"
	lcmachinename="frontera"
	helpoutputfile="frontera-help.md"
	jobaccountingoutputfile="frontera-jobaccounting.md"
	crontaboutputfile="frontera-crontab.md"
	hwthreads="56 on CLX"
	mkloutputfile="frontera-mkl.md"
	helpmsg="Be sure to include \"$machinename\" in the Resource field."

	sed	-e "s/MACHINENAME/$machinename/g" < jobaccountingsrc.md > $jobaccountingoutputfile
	sed	-e "s/MACHINENAME/$lcmachinename/g" < crontabsrc.md > $crontaboutputfile

	sed	-e "s/HWTHREADS/$hwthreads/g" < mklsrc.md > $mkloutputfile

	sed	-e "s/MACHINENAME/$machinename/g" \
		-e "s/HELPMSG/$helpmsg/g" < helpsrc.md > $helpoutputfile

### Vista
elif [ "$1" = "vista" ] 
then
	echo "building includes for Vista user guide"
	machinename="Vista"
	lcmachinename="vista"
	helpoutputfile="vista-help.md"
	jobaccountingoutputfile="vista-jobaccounting.md"
	crontaboutputfile="vista-crontab.md"
	helpmsg="Be sure to include \"$machinename\" in the Resource field."

	sed	-e "s/MACHINENAME/$machinename/g" < jobaccountingsrc.md > $jobaccountingoutputfile

	sed	-e "s/MACHINENAME/$lcmachinename/g" < crontabsrc.md > $crontaboutputfile

	sed	-e "s/MACHINENAME/$machinename/g" \
		-e "s/HELPMSG/$helpmsg/g" < helpsrc.md > $helpoutputfile

### Lonestar6
elif [ "$1" = "lonestar6" ] 
then
	echo "building includes for Lonestar6 user guide"
	machinename="Lonestar6"
	lcmachinename="lonestar6"
	helpoutputfile="lonestar6-help.md"
	jobaccountingoutputfile="lonestar6-jobaccounting.md"
	crontaboutputfile="lonestar6-crontab.md"
	hwthreads="128 on AMD Milan"
	mkloutputfile="lonestar6-mkl.md"
	helpmsg="Be sure to include \"$machinename\" in the Resource field."

	sed	-e "s/MACHINENAME/$machinename/g" < jobaccountingsrc.md > $jobaccountingoutputfile

	sed	-e "s/MACHINENAME/$lcmachinename/g" < crontabsrc.md > $crontaboutputfile

	sed	-e "s/HWTHREADS/$hwthreads/g" < mklsrc.md > $mkloutputfile

	sed	-e "s/MACHINENAME/$machinename/g" \
		-e "s/HELPMSG/$helpmsg/g" < helpsrc.md > $helpoutputfile

### Stampede3
elif [ "$1" = "stampede3" ] 
then
	echo "building includes for Stampede3 user guide"
	machinename="Stampede3"
	lcmachinename="stampede3"
	helpoutputfile="stampede3-help.md"
	jobaccountingoutputfile="stampede3-jobaccounting.md"
	crontaboutputfile="stampede3-crontab.md"
	helpmsg="Be sure to include \"$machinename\" in the Resource field."

	sed	-e "s/MACHINENAME/$machinename/g" < jobaccountingsrc.md > $jobaccountingoutputfile

	sed	-e "s/MACHINENAME/$lcmachinename/g" < crontabsrc.md > $crontaboutputfile

	sed	-e "s/MACHINENAME/$machinename/g" \
		-e "s/HELPMSG/$helpmsg/g" < helpsrc.md > $helpoutputfile

### Ranch
elif [ "$1" = "ranch" ] 
then
	echo "building includes for Ranch user guide"
	machinename="Ranch"
	helpoutputfile="ranch-help.md"
	helpmsg="Be sure to include \"$machinename\" in the Resource field."

	sed	-e "s/MACHINENAME/$machinename/g" \
		-e "s/HELPMSG/$helpmsg/g" < helpsrc.md > $helpoutputfile


### basics
elif [ "$1" = "basics" ] 
then
	echo "building includes for basics"
	machinename=""
	helpoutputfile="../basics/help.md"

	sed	-e "s/MACHINENAME/$machinename/g" \
		-e "s/HELPMSG/$helpmsg/g" < helpsrc.md > $helpoutputfile

# catch all... used for taccinfo, managingio
elif [ "$1" = "defaults" ] 
then
	echo "building defaults" # 02/10/2025 no defaults - removed taccinfo
	# sed -e "s/TACCINFOPATH/$taccinfopath/g" < taccinfosrc.md > tinfo.md
	
else
	echo "configurestrings: no such machine"
	exit 1
fi

