# AlphaFold at TACC
*Last update: May 31, 2022* xx


<table cellpadding="5" cellspacing="5"><tr>
<td> <img alt="AlphaFold logo" src="../imgs/alphafold-logo.png"></td><td>
AlphaFold is a protein structure prediction tool developed by DeepMind (Google). It uses a novel machine learning approach to predict 3D protein structures from primary sequences alone. In July 2021, the developers made the <a href="https://github.com/deepmind/alphafold">source code available on Github</a> and published a <a href="https://www.nature.com/articles/s41586-021-03819-2">Nature paper</a> (<a href="https://static-content.springer.com/esm/art%3A10.1038%2Fs41586-021-03819-2/MediaObjects/41586_2021_3819_MOESM1_ESM.pdf">supplementary information</a>) describing the method. In addition to the software, AlphaFold depends on ~2.5 TB of databases and model parameters. Researchers interested in making protein structure predictions with AlphaFold are encouraged to follow the guide below, and use the databases and model parameters that have been prepared.</td></tr></table>

## [Installations at TACC](#installations) { #installations }

System | What's Available
--- | ---
Frontera | AlphaFold: v2.2.0<br> Data: <code>/scratch2/projects/bio/alphafold/data</code><br> Module: <code>/scratch2/projects/bio/alphafold/modulefiles</code><br> Examples: <code>/scratch2/projects/bio/alphafold/test</code>
Stampede2 | AlphaFold: v2.2.0<br> Data: <code>/scratch/projects/tacc/bio/alphafold/data</code><br> Module: <code>/scratch/projects/tacc/bio/alphafold/modulefiles</code><br> Examples: <code>/scratch/projects/tacc/bio/alphafold/test</code>
Maverick2 | AlphaFold: v2.2.0<br> Data: <code>/work/projects/tacc/bio/alphafold/data</code><br> Module: <code>/work/projects/tacc/bio/alphafold/modulefiles</code><br> Examples: <code>/work/projects/tacc/bio/alphafold/test</code>
Lonestar6 | AlphaFold: v2.2.0<br> Data: <code>/scratch/tacc/apps/bio/alphafold/data</code><br> Module: <code>/scratch/tacc/apps/bio/alphafold/modulefiles</code><br> Examples: <code>/scratch/tacc/apps/bio/alphafold/test</code>



## [Running AlphaFold](#running) { #running }

!!! note
	AlphaFold is still being tested for performance and I/O efficiency. These instructions are subject to change.


### [Single Sequence Prediction](#running-singlesequence) { #running-singlesequence }

To perform 3-D protein structure prediction with AlphaFold, first upload a fasta-formatted protein primary sequence to your `$WORK` or `$SCRATCH` (recommended) space. Sample fasta sequences are provided in the machine-specific "**Examples**" paths listed in the table above. A valid fasta sequence might look like:

``` syntax
>sample sequence consisting of 350 residues
MTANHLESPNCDWKNNRMAIVHMVNVTPLRMMEEPRAAVEAAFEGIMEPAVVGDMVEYWN
KMISTCCNYYQMGSSRSHLEEKAQMVDRFWFCPCIYYASGKWRNMFLNILHVWGHHHYPR
NDLKPCSYLSCKLPDLRIFFNHMQTCCHFVTLLFLTEWPTYMIYNSVDLCPMTIPRRNTC
RTMTEVSSWCEPAIPEWWQATVKGGWMSTHTKFCWYPVLDPHHEYAESKMDTYGQCKKGG
MVRCYKHKQQVWGNNHNESKAPCDDQPTYLCPPGEVYKGDHISKREAENMTNAWLGEDTH
NFMEIMHCTAKMASTHFGSTTIYWAWGGHVRPAATWRVYPMIQEGSHCQC
```

Next, prepare a batch job submission script for running AlphaFold. Two different templates for different levels of precision are provided within the "**Examples**" paths listed in the table above:

* `reduced_dbs.slurm`: higher speed
* `full_dbs.slurm`: higher precision (default)

See the AlphaFold documentation for more information on the speed / quality tradeoff of each preset. The example templates each need to be customized before they can be used. Copy the desired template to your `$WORK` or `$SCRATCH` space along with the input fasta file. After necessary customizations, a batch script for running the full databases on Frontera may contain:

``` job-script
#!/bin/bash
# -----------------------------------------------------------------
#SBATCH -J my_af2_job                 # Job name
#SBATCH -o my_af2_job.%j.out          # Name of stdout output file
#SBATCH -e my_af2_job.%j.err          # Name of stderr output file
#SBATCH -p rtx                        # Queue (partition) name
#SBATCH -N 1                          # Total # of nodes
#SBATCH -n 1                          # Total # of mpi tasks
#SBATCH -t 12:00:00                   # Run time (hh:mm:ss)
#SBATCH -A myproject                  # Project/Allocation name
# -----------------------------------------------------------------

# Load modules (example path on Frontera)
module unload xalt
module use /scratch2/projects/bio/alphafold/modulefiles
module load alphafold/2.2.0-ctr

# Run AlphaFold
run_alphafold.sh --flagfile=$AF2_HOME/test/flags/full_dbs.ff \
                 --fasta_paths=$SCRATCH/sample.fasta \
                 --output_dir=$SCRATCH/output \
                 --model_preset=monomer \
                 --use_gpu_relax=True
```

In the batch script, make sure to use a batch queue (`#SBATCH -p`), node / wallclock limits, and allocation name (`#SBATCH -A`) appropriate to the machine you are running on. Also, make sure the path shown in the module use line matches the machine-specific "Module" path listed in the table above.

The flagfile is a configuration file passed to AlphaFold containing parameters including the level of precision, the location of the databases for multiple sequence alignment, and more. Flag files for all three presets can be found in the "Examples" directory, and typically they should not be edited. The other three parameters passed to AlphaFold should be customized to your input path / filename, desired output path, and the selection of models. The parameters are summarized in the following table:

Parameter | Setting
--- | ---
<code>--fasta_paths</code> | # full path including filename to your test data<br> <code>=$SCRATCH/sample.fasta</code>
<code>--output_dir</code> | # full path to desired output dir (/scratch filesystem recommended)<br> <code>=$SCRATCH/output</code>
<code>--model_preset</code> | # control which AlphaFold model to run, options are:<br><code>=monomer | =monomer_casp14 | =monomer_ptm | =multimer</code>
<code>--use_gpu_relax</code> | # whether to relax on GPUs (recommended if GPU available)<br><code> =True | =False</code>




Once the input fasta sequence and customized batch job script are prepared, submit to the queue with:

``` syntax
sbatch name_of_job_script
```

``` bash
login1$ sbatch full_dbs.slurm
```

Using the scheme above with `full_dbs` precision, we expect each job to take between 2 to 12 hours depending on the length of the input fasta sequence, the speed of the compute node, and the relative load on the file system at the time of run. Using `reduced_dbs` should cut the job time in half, while slightly sacrificing precision. Refer to the AlphaFold Documentation for a description of the expected output files.

### [Multiple Sequence Predictions](#running-multiplesequence) { #running-multiplesequence }

!!! tip
	The multiple sequence alignment step of the AlphaFold workflow is exceedingly I/O intensive.  
	**Limit your concurrent AlphaFold processes per node to a maximum of four.**

To perform 3-D protein structure prediction with AlphaFold for many protein sequences, we recommend using TACC's `launcher` or `launcher-gpu` utility. First review the instructions for submitting single sequence predictions above, then make the following adjustments:

Fasta formatted sequences should be uniquely identifiable either by giving each a unique name or by putting each sequence in its own uniquely-named directory. The simplest way to achieve this is to have one sub directory (e.g. `$SCRATCH/inputs/`) with all uniquely named fasta sequences in it:

``` cmd-line
login1$ ls $SCRATCH/inputs/
seq1.fasta
seq2.fasta
seq3.fasta
...
```

Next, prepare a launcher `jobfile` that contains each command that needs to be run. There should be one line in the `jobfile` for each input fasta sequence. Each line should refer to a unique input sequence and a unique output path:

``` syntax
singularity exec --nv $AF2_HOME/images/alphafold_2.2.0.sif /app/run_alphafold.sh --flagfile=$AF2_HOME/test/flags/full_dbs.ff --fasta_paths=$SCRATCH/input/BLUEseq1.fasta --output_dir=$SCRATCH/BLUEoutput1 --model_preset=monomer --use_gpu_relax=True
singularity exec --nv $AF2_HOME/images/alphafold_2.2.0.sif /app/run_alphafold.sh --flagfile=$AF2_HOME/test/flags/full_dbs.ff --fasta_paths=$SCRATCH/input/BLUEseq2.fasta --output_dir=$SCRATCH/BLUEoutput2 --model_preset=monomer --use_gpu_relax=True
singularity exec --nv $AF2_HOME/images/alphafold_2.2.0.sif /app/run_alphafold.sh --flagfile=$AF2_HOME/test/flags/full_dbs.ff --fasta_paths=$SCRATCH/input/BLUEseq3.fasta --output_dir=$SCRATCH/BLUEoutput3 --model_preset=monomer --use_gpu_relax=True
...
```

!!! Important
	Due to the way `launcher_gpu` distributes tasks to individual GPUs, the full `singularity` command must be used in the `jobfile` as shown above. 


Prepare a batch job submission script by merging the AlphaFold template with a launcher template. Adjust the number of nodes, number of tasks, and the wall clock time appropriately for the number of jobs in the `jobfile`:

``` job-script
#!/bin/bash
# -----------------------------------------------------------------
#SBATCH -J my_af2_launcher_job          # Job name
#SBATCH -o my_af2_launcher_job.%j.out   # Name of stdout output file
#SBATCH -e my_af2_launcher_job.%j.err   # Name of stderr output file
#SBATCH -p rtx                          # Queue (partition) name
#SBATCH -N 1                            # Total # of nodes
#SBATCH -n 4                            # Total # of mpi tasks
#SBATCH -t 12:00:00                     # Run time (hh:mm:ss)
#SBATCH -A myproject                    # Project/Allocation name
# -----------------------------------------------------------------

# Load modules (example path on Frontera)
module unload xalt
module use /scratch2/projects/bio/alphafold/modulefiles
module load alphafold/2.2.0-ctr

# Launcher specifics (use launcher_gpu for GPUs)
module load launcher_gpu
export LAUNCHER_WORKDIR=$SCRATCH
export LAUNCHER_JOB_FILE=jobfile

# Run AlphaFold with Launcher
${LAUNCHER_DIR}/paramrun
```

Once the input sequences, the `jobfile`, and the batch job submission script are all prepared, submit the job to the queue with:

``` syntax
sbatch name_of_job_script
```

``` bash
login1$ sbatch full_dbs_launcher.slurm
```

## [References](#refs) { #refs }

* [AlphaFold Github](https://github.com/deepmind/alphafold)
* [AlphaFold Nature Paper](https://www.nature.com/articles/s41586-021-03819-2)
	

