# AlphaFold2 at TACC
*Last update: February 26, 2025*


<table cellpadding="5" cellspacing="5"><tr>
<td> <img alt="AlphaFold logo" src="../imgs/alphafold-logo.png"></td><td>
AlphaFold2 is a protein structure prediction tool developed by DeepMind (Google). AlphaFold2 uses a novel machine learning approach to predict 3D protein structures from primary sequences alone. In July 2021, the developers made the <a href="https://github.com/deepmind/alphafold">source code available on Github</a> and published a <a href="https://www.nature.com/articles/s41586-021-03819-2">Nature paper</a> (<a href="https://static-content.springer.com/esm/art%3A10.1038%2Fs41586-021-03819-2/MediaObjects/41586_2021_3819_MOESM1_ESM.pdf">supplementary information</a>) describing the method. In addition to the software, AlphaFold2 depends on ~2.9 TB of databases and model parameters. Researchers interested in making protein structure predictions with AlphaFold2 are encouraged to follow the guide below, and use the databases and model parameters that have been prepared.</td></tr></table>

## Installations at TACC { #installations } 

!!! important
    AlphaFold3 will be installed soon on TACC resources.   
	See Google's [AlphaFold 3 Model Parameters Terms of Use](https://github.com/google-deepmind/alphafold3/blob/main/WEIGHTS_TERMS_OF_USE.md)
    
### Table 1. Installations at TACC { #table1 }

System | What's Available
-- | --
Frontera | AlphaFold2: v2.3.2<br> Data: `/scratch2/projects/bio/alphafold/2.3.2/data`<br>Examples: `/scratch2/projects/bio/alphafold/2.3.2/examples`<br> Module: `/scratch2/projects/bio/alphafold/modulefiles`
Lonestar6 | AlphaFold2: v2.3.2<br> Data: `/scratch/tacc/apps/bio/alphafold/2.3.2/data`<br>Examples: `/scratch/tacc/apps/bio/alphafold/2.3.2/examples`<br> Module: `/scratch/tacc/apps/bio/alphafold/modulefiles`
Stampede3 | AlphaFold2: v2.3.2<br> Data: `/scratch/tacc/apps/bio/alphafold/2.3.2/data`<br>Examples: `/scratch/tacc/apps/bio/alphafold/2.3.2/examples`<br> Module: `/scratch/tacc/apps/bio/alphafold/modulefiles`


## Running AlphaFold2  { #running }

!!! important
	AlphaFold2 is being tested for performance and I/O efficiency - the instructions below are subject to change.

### Structure Prediction from Single Sequence { #running-singlesequence } 

To perform 3-D protein structure prediction with AlphaFold2, first upload a fasta-formatted protein primary sequence to your `$WORK` or `$SCRATCH` (recommended) space. Sample fasta sequences are provided in the machine-specific "Examples" paths listed in the table above. A valid fasta sequence might look like:

```syntax
>sample sequence consisting of 350 residues
MTANHLESPNCDWKNNRMAIVHMVNVTPLRMMEEPRAAVEAAFEGIMEPAVVGDMVEYWN
KMISTCCNYYQMGSSRSHLEEKAQMVDRFWFCPCIYYASGKWRNMFLNILHVWGHHHYPR
NDLKPCSYLSCKLPDLRIFFNHMQTCCHFVTLLFLTEWPTYMIYNSVDLCPMTIPRRNTC
RTMTEVSSWCEPAIPEWWQATVKGGWMSTHTKFCWYPVLDPHHEYAESKMDTYGQCKKGG
MVRCYKHKQQVWGNNHNESKAPCDDQPTYLCPPGEVYKGDHISKREAENMTNAWLGEDTH
NFMEIMHCTAKMASTHFGSTTIYWAWGGHVRPAATWRVYPMIQEGSHCQC
```

Next, prepare a batch job submission script for running AlphaFold2. Two different templates for different levels of precision are provided within the "Examples" paths listed in [Table 1.](#table1) above:

* `full_dbs.slurm`: higher precision (default)
* `reduced_dbs.slurm`: higher speed

See the <a href="https://github.com/deepmind/alphafold">AlphaFold2 documentation</a> for more information on the speed vs. quality tradeoff of each preset. The example templates each need to be customized before they can be used. Copy the desired template to your `$WORK` or `$SCRATCH` space along with the input fasta file. After necessary customizations, a batch script for running the full databases on Lonestar6 may contain:

```job-script
#!/bin/bash
# full_dbs.slurm
# -----------------------------------------------------------------
#SBATCH -J af2_full                   # Job name
#SBATCH -o af2_full.%j.out            # Name of stdout output file
#SBATCH -e af2_full.%j.err            # Name of stderr error file
#SBATCH -p gpu-a100                   # Queue (partition) name
#SBATCH -N 1                          # Total # of nodes 
#SBATCH -n 1                          # Total # of mpi tasks 
#SBATCH -t 12:00:00                   # Run time (hh:mm:ss)
#SBATCH -A my-project                 # Project/Allocation name 
# -----------------------------------------------------------------

# Load modules
module unload xalt
module use /scratch/tacc/apps/bio/alphafold/modulefiles
module load alphafold/2.3.2-ctr

# Run AlphaFold2
run_alphafold.sh --flagfile=$AF2_HOME/examples/flags/full_dbs.ff \
                 --fasta_paths=$SCRATCH/input/sample.fasta \
                 --output_dir=$SCRATCH/output \
                 --model_preset=monomer \
                 --max_template_date=2050-01-01 \
                 --use_gpu_relax=True
```


In the batch script, make sure to specify the partition (queue) (`#SBATCH -p`), node / wallclock limits, and allocation name (`#SBATCH -A`) appropriate to the machine you are running on. Also, make sure the path shown in the `module use` line matches the machine-specific "Module" path listed in the [Table 1.](#table1) above.

The `flagfile` is a configuration file passed to AlphaFold2 containing parameters including the level of precision, the location of the databases for multiple sequence alignment, and more. Flag files for all presets can be found in the 'Examples' directory, and typically they should not be edited. The other three parameters passed to AlphaFold2 should be customized to your input path / filename, desired output path, and the selection of models. The parameters are summarized in the following table:


#### Table 2. AlphaFold2 Parameter Settings { #table2 }

Parameter | Setting
-- | --
`--fasta_paths` | # full path including filename to your test data<br>`=$SCRATCH/input/sample.fasta`
`--output_dir`  | # full path to desired output dir (/scratch filesystem recommended)<br>`=$SCRATCH/output`
`--model_preset`| # control which AlphaFold2 model to run, options are:<br>`=monomer | =monomer_casp14 | =monomer_ptm | =multimer`
`--max_template_date` | # control which structures from PDB are used<br>`=2050-01-01`
`--use_gpu_relax` | # whether to relax on GPUs (recommended if GPU available)<br>`=True | =False`

Once the input fasta sequence and customized batch job script are prepared, submit to the queue with:

```cmd-line
login1$ sbatch <job_script>
```

e.g.:

```cmd-line
login1$ sbatch full_dbs.slurm
```

Using the scheme above with `full_dbs` precision, we expect each job to take between 2 to 12 hours depending on the length of the input fasta sequence, the speed of the compute node, and the relative load on the file system at the time of run. Using `reduced_dbs` should cut the job time in half, while slightly sacrificing precision. Refer to the <a href="https://github.com/deepmind/alphafold%23alphafold-output">AlphaFold2 Documentation</a> for a description of the expected output files.

### Batch Structure Predictions from Independent Sequences { #running-independentsequences }

!!! caution
	**Limit your concurrent AlphaFold2 processes per node to a maximum of three**.<br>The multiple sequence alignment step of the AlphaFold workflow is exceedingly I/O intensive. 

To perform 3-D protein structure prediction with AlphaFold2 for many protein sequences, we recommend using TACC's <a href="https://docs.tacc.utexas.edu/software/pylauncher/">PyLauncher</a> utility. First review the instructions for submitting single sequence predictions above, then make the following adjustments:

Fasta formatted sequences should be uniquely identifiable either by giving each a unique name or by putting each sequence in its own uniquely-named directory. The simplest way to achieve this is to have one sub directory (e.g. `$SCRATCH/inputs/`) with all uniquely named fasta sequences in it:

```cmd-line
login1$ ls $SCRATCH/inputs/
seq1.fasta
seq2.fasta
seq3.fasta
...
```

Next, you will need three files to run AlphaFold2 with PyLauncher:

1. `commandlines` – Contains each AlphaFold2 command to be executed in parallel, each command on a different line. 
2. `pylauncher.py` – A Python script that uses the PyLauncher library to read the `commandlines` file and launch the jobs in parallel with the appropriate resources.
3. `af2_pylauncher_job.slurm` – A SLURM job script that loads the necessary modules and executes the `pylauncher.py` script.

#### 1. Prepare the `commandlines` file { #running-independentsequences-commandlines-file }

First, create a file named `commandlines` that contains each command that needs to be run. There should be one line in `commandlines` for each input fasta sequence. Each line should refer to a unique input sequence and a unique output path. 

Example:
```syntax
apptainer exec --nv $AF2_HOME/images/alphafold_2.3.2.sif /app/run_alphafold.sh --flagfile=$AF2_HOME/examples/flags/full_dbs.ff --fasta_paths=$SCRATCH/input/seq1.fasta --output_dir=$SCRATCH/output1 --model_preset=monomer --max_template_date=2050-01-01 --use_gpu_relax=True
apptainer exec --nv $AF2_HOME/images/alphafold_2.3.2.sif /app/run_alphafold.sh --flagfile=$AF2_HOME/examples/flags/full_dbs.ff --fasta_paths=$SCRATCH/input/seq2.fasta --output_dir=$SCRATCH/output2 --model_preset=monomer --max_template_date=2050-01-01 --use_gpu_relax=True
apptainer exec --nv $AF2_HOME/images/alphafold_2.3.2.sif /app/run_alphafold.sh --flagfile=$AF2_HOME/examples/flags/full_dbs.ff --fasta_paths=$SCRATCH/input/seq3.fasta --output_dir=$SCRATCH/output3 --model_preset=monomer --max_template_date=2050-01-01 --use_gpu_relax=True
...
```

!!! important 
	Due to the way `PyLauncher.GPULauncher` distributes tasks to individual GPUs, the full `apptainer` command must be used in the` commandlines` file as shown above. 


#### 2. Create the `pylauncher.py` script { #running-independentsequences-pylauncher-file }

Next, create a file called `pylauncher.py` that will launch the commands in `commandlines`. Be sure to check the TACC system documentation to ensure you are using the correct number of GPUs per node. For example, to utilize the three GPUs per node on Lonestar6 (`gpu-a100` queue), the `pylauncher.py` script would look like:

```python3
import pylauncher
pylauncher.GPULauncher("commandlines", debug="host+job+exec", gpuspernode=3)
```

#### 3. Set up the SLURM job script { #running-independentsequences-job-script }

Finally, prepare a batch job submission script. Adjust the number of nodes, number of tasks, and the wall clock time appropriately for the number of commands in `commandlines`. For example, to run AlphaFold2 on six independent input sequences across two nodes (three tasks per node) simultaneously, the job script would resemble:

```job-script
#!/bin/bash
# af2_pylauncher_job.slurm
# -----------------------------------------------------------------
#SBATCH -J af2_pylauncher               # Job name
#SBATCH -o af2_pylauncher.%j.out        # Name of stdout output file
#SBATCH -e af2_pylauncher.%j.err        # Name of stderr output file
#SBATCH -p gpu-a100                     # Queue (partition) name
#SBATCH -N 2                            # Total # of nodes
#SBATCH -n 6                            # Total # of mpi tasks
#SBATCH -t 03:00:00                     # Run time (hh:mm:ss)
#SBATCH -A my-project                   # Project/Allocation name
# -----------------------------------------------------------------

# Load modules (example path on Lonestar6)
module unload xalt
module load python3/3.9.7 pylauncher
module use /scratch/tacc/apps/bio/alphafold/modulefiles
module load alphafold/2.3.2-ctr

# Run AlphaFold2 with PyLauncher
python3 pylauncher.py
```

Once the input sequences, the `commandlines` file, the `pylauncher.py` file, and the batch job submission script are all prepared, submit the job to the queue with:

```cmd-line
login1$ sbatch <name_of_job_script>
```
e.g.:

```cmd-line
login1$ sbatch af2_pylauncher_job.slurm
```

### Structure Prediction from Multiple Sequences (Multimer) { #running-multiplesequences } 

!!! caution
	Alphafold2 supports multimer folding, but as mentioned in the <a href="https://github.com/google-deepmind/alphafold">AlphaFold2 Documentation</a>, it is a work in progress and is not expected to be as stable as monomer folding. 

Nevertheless, we provide example flag files, job scripts, and sequences in the "Examples" paths listed above to test multimer folding. In our experience, the success rates of multimer folding jobs decrease as input sequence length increases.


## References { #refs }

* [Github: AlphaFold](https://github.com/deepmind/alphafold)
* [AlphaFold Nature Paper](https://www.nature.com/articles/s41586-021-03819-2)


