#!/bin/sh
# include files for all TUP documentation, mostly HPC guidees

# some defaults
striping="<a\ href=\"\/user-guides\/stampede2#files-striping\">Striping\ Large\ Files\ in\ the\ Stampede2\ User\ Guide<\/a>"
taccinfopath="\/usr\/local\/etc\/taccinfo"

# managingio - taccinfo
# help 

if [ "$1" = "frontera" ] 
then
	echo "building includes for Frontera user guide"
	machinename="Frontera"
	helpoutputfile="frontera-help.md"
	# conductoutputfile="lonestar6-conduct.md"
	jobaccountingoutputfile="frontera-jobaccounting.md"
	hwthreads="56 on CLX"
	mkloutputfile="frontera-mkl.md"

	sed	-e "s/MACHINENAME/$machinename/g" \
		-e "s/TACCINFOPATH/$taccinfopath/g" < jobaccountingsrc.md > $jobaccountingoutputfile
	sed	-e "s/HWTHREADS/$hwthreads/g" < mklsrc.md > $mkloutputfile
	sed	-e "s/MACHINENAME/$machinename/g" < helpsrc.md > $helpoutputfile
	# sed	-e "s/MACHINENAME/$machinename/g" \
	# 	-e "s/STRIPING/$striping/g"  < conductsrc.md > $conductoutputfile

elif [ "$1" = "lonestar6" ] 
then
	echo "building includes for Lonestar6 user guide"
	machinename="Lonestar6"
	helpoutputfile="lonestar6-help.md"
	# conductoutputfile="lonestar6-conduct.md"
	jobaccountingoutputfile="lonestar6-jobaccounting.md"
	hwthreads="128 on AMD Milan"
	mkloutputfile="lonestar6-mkl.md"

	sed	-e "s/MACHINENAME/$machinename/g" \
		-e "s/TACCINFOPATH/$taccinfopath/g" < jobaccountingsrc.md > $jobaccountingoutputfile
	sed	-e "s/HWTHREADS/$hwthreads/g" < mklsrc.md > $mkloutputfile
	sed	-e "s/MACHINENAME/$machinename/g" < helpsrc.md > $helpoutputfile
	# sed	-e "s/MACHINENAME/$machinename/g" \
	# 	-e "s/STRIPING/$striping/g"  < conductsrc.md > $conductoutputfile


### Stampede3
elif [ "$1" = "stampede3" ] 
then
	echo "building includes for Stampede3 user guide"
	machinename="Stampede3"
	# hwthreads="272 on KNL, 96 on SKX, 160 on ICX"
	# striping="<a\ href=\"#files-striping\">Striping\ Large\ Files<\/a>"
	helpoutputfile="stampede3-help.md"
	jobaccountingoutputfile="stampede3-jobaccounting.md"

	sed	-e "s/MACHINENAME/$machinename/g" \
		-e "s/TACCINFOPATH/$taccinfopath/g" < jobaccountingsrc.md > $jobaccountingoutputfile
	#sed	-e "s/HWTHREADS/$hwthreads/g" < mklsrc.md > $mkloutputfile
	sed	-e "s/MACHINENAME/$machinename/g" < helpsrc.md > $helpoutputfile
	# sed	-e "s/MACHINENAME/$machinename/g" \
	# 	-e "s/STRIPING/$striping/g"  < conductsrc.md > $conductoutputfile

### Ranch
# no conduct section for Ranch
# no taccinfo for Ranch
# no striping for Ranch
elif [ "$1" = "ranch" ] 
then
	echo "building includes for Ranch user guide"
	machinename="Ranch"
	helpoutputfile="ranch-help.md"

	sed	-e "s/MACHINENAME/$machinename/g" < helpsrc.md > $helpoutputfile

# used for taccinfo, managingio
elif [ "$1" = "defaults" ] 
then
	echo "building defaults"
	sed -e "s/TACCINFOPATH/$taccinfopath/g" < taccinfosrc.md > tinfo.md
	
else
	echo "configurestrings: no such machine"
	exit 1
fi

