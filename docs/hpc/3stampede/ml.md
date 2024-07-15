## Machine Learning { #ml }

Follow these instructions to begin using Intel's Conda environment with PyTorch and Tensorflow on Stampede3.

1.  First, do an initial one-time setup of the conda environment, then log out.

	```cmd-line
	login2.stampede3(1003)$ module load python
	login2.stampede3(1004)$ module save
	Saved current collection of modules to: "default"
	
	login2.stampede3(1005)$ conda init bash
	login2.stampede3(1006)$ logout
	logout
	Connection to login2.stampede3.tacc.utexas.edu closed.
	```

2. Log back into Stampede3, then activate either the PyTorch or Tensorflow environment.

	```cmd-line
	localhost$ ssh stampede3.tacc.utexas.edu
	...
	(base) login1.stampede3(1003)$ conda activate pytorch
	(pytorch) login1.stampede3(1004)$
	```

