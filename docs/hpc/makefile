
all:	include frontera lonestar6 stampede3 vista


include:
	echo "====== Building includes ======"
	cd ../include; make;

frontera: FORCE
	echo "====== Building Frontera ======"
	cd frontera; make;

lonestar6: FORCE
	echo "====== Building Lonestar6  ======"
	cd 6lonestar; make; 

stampede3: FORCE
	echo "====== Building Stampede3 ======"
	cd 3stampede; make;

vista: FORCE
	echo "====== Building Vista ======"
	cd vista; make;

FORCE:	
