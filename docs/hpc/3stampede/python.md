## Python { #python }

Python on Stampede3 has been made into a module to mirror the environments of TACC others machines. Load python like so:

```cmd-line
$ module load python
```


### Jupyter Notebooks { #python-jupyter }

Unlike TACC's other HPC resources, Jupyter is not installed with the Python module on Stampede3.  In order to use Jupyter notebooks, you must install notebooks locally with the following one-time setup:  

1. Log into Stampede3, then edit your `.bashrc` file.  Add the following line to the "SECTION 1" portion of the file to update your `$PATH` environment variable.  

	```
	export PATH=$PATH:$HOME/.local/bin
	```	

2. Then install notebooks locally:

	```cmd-line
	pip install --user notebook==6.0.3
	```

This setup enables the [TACC Analysis Portal](http://tap.tacc.utexas.edu) to find the non-standard-location Jupyter-lab or Jupyter-notebook commands. 

If you prefer the old Jupyter notebook style then move the Jupyter lab executable to something else. Note that the TAP portal software is expecting a particular version of Jupyter. This version is consistent across TACC systems. 
