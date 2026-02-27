# AlphaFold3 at TACC
*Last update: February 26, 2026*

<img src="../imgs/alphafold3-logo.png" width="250" alt="AlphaFold3 logo" class="align-right">

AlphaFold3 is Google Deepmind's latest deep learning model for predicting the structure and interactions of biological macromolecules, including proteins, nucleic acids, small molecules, ions, and post-translational modifications. AlphaFold3 significantly expands the capabilities of AlphaFold2, offering highly accurate complex structure predictions beyond protein folding alone. In November 2024, the developers made the [source code available on Github](https://github.com/deepmind/alphafold) and published a [Nature paper](https://www.nature.com/articles/s41586-024-07487-w) ([supplementary information](https://static-content.springer.com/esm/art%3A10.1038%2Fs41586-024-07487-w/MediaObjects/41586_2024_7487_MOESM1_ESM.pdf)) describing the method. In addition to the software, AlphaFold3 depends on ~630 GB of disk space to hold genetic databases. 

We encourage researchers interested in making protein structure predictions with AlphaFold3 to follow the guide below, and use the prepared databases.  

## Installations at TACC { #installations } 

!!! important
    To run AlphaFold3 on TACC Systems, you *must* obtain the model parameters directly from Google by completing [this form](https://docs.google.com/forms/d/e/1FAIpQLSfWZAgo1aYk0O4MuAXZj8xRQ8DafeFJnldNOnh_13qAx2ceZw/viewform).     

	See Google's [AlphaFold 3 Model Parameters Terms of Use](https://github.com/google-deepmind/alphafold3/blob/main/WEIGHTS_TERMS_OF_USE.md)
    
### Table 1. Installations at TACC { #table1 }

HPC Resource | Versions
-- | --
Lonestar6 | AlphaFold3: v3.0.1<br>**Data**: `/scratch/tacc/apps/bio/alphafold3/3.0.1/data`<br>**Examples**: `/scratch/tacc/apps/bio/alphafold3/3.0.1/examples`<br> Module: `/scratch/tacc/apps/bio/alphafold3/modulefiles`
Frontera | AlphaFold3: v3.0.1<br>**Data**: `/scratch2/projects/bio/alphafold3/3.0.1/data`<br>**Examples**: `/scratch2/projects/bio/alphafold3/3.0.1/examples`<br> Module: `/scratch2/projects/bio/alphafold3/modulefiles`
Stampede3 | AlphaFold3: v3.0.1<br> *Coming soon*
Vista | AlphaFold3: v3.0.1<br> *Coming soon*

## Access

Due to AlphaFold's licensing restrictions, users must obtain the model parameters **directly from Google DeepMind**. To obtain the model parameters:

1. Visit the following form: [AlphaFold3 Model Request Form](https://docs.google.com/forms/d/e/1FAIpQLSfWZAgo1aYk0O4MuAXZj8xRQ8DafeFJnldNOnh_13qAx2ceZw/viewform)
2. Submit the request using an institutional email address.
3. Once approved, you will receive instructions for downloading a folder containing the model paramters.

After downloading, you must **manually place the model parameters** in the appropriate directory in your work environment.

**Note:** TACC cannot distribute the AlphaFold3 model parameters.

## Running AlphaFold3  { #running }

!!! important
	AlphaFold3 is being tested for performance and I/O efficiency - the instructions below are subject to change.

### Directory Structure

We highly recommend running AlphaFold3 from your `$SCRATCH` directory A typical working directory may look like this:
```syntax
alphafold3_project/
├── input/
│   └── example_input.json
├── output/
└── slurm_jobs/
```

### Input Preparation

AlphaFold3 expects a single `.json` input file describing the molecular system to be predicted. The input format is detailed in the [official DeepMind documentation](https://github.com/google-deepmind/alphafold3/blob/main/docs/input.md). This input file should be uploaded to your `$WORK` or `$SCRATCH` (recommended) space. Sample `.json` input files are provided in the machine-specific "Examples" path listed in [Table 1.](#table1) above.

A valid protein chain may look like:
```json
{
  "name": "UQCR11_Hsapiens",
  "sequences": [
    {
      "protein": {
        "id": "A",
        "sequence": "MVTRFLGPRYRELVKNWVPTAYTWGAVGAVGLVWATDWRLILDWVPYINGKFKKDN"
      }
    }
  ],
  "modelSeeds": [1],
  "dialect": "alphafold3",
  "version": 1
}
```

### SLURM Job Script Preparation

Next, prepare a batch job submission script for running AlphaFold3. *Model inference must be run on a GPU*. See the [Running MSA and Inference Separately](#split-stages) section of this page and the [AlphaFold3 performance documentation](https://github.com/google-deepmind/alphafold3/blob/main/docs/performance.md) for more information on executing AlphaFold3 jobs in stages to optimize resource utilization. 

Templates for batch job submission scripts are provided within the "Examples" paths listed in [Table 1.](#table1) above. The example templates need to be customized before they can be used. Copy the desired tample to your `$WORK` or `$SCRATCH` space along with the input `.json` file. After necessary customizations, a batch script for running AlphaFold3 on Lonestar6 may look like the following :

```job-script
#!/bin/bash
#----------------------------------------------------------------------
#SBATCH -J AF3_protein             # Job name
#SBATCH -o AF3_protein.o%j         # Name of stdout output file
#SBATCH -e AF3_protein.e%j         # Name of stderr error file
#SBATCH -p gpu-a100-small          # Queue (partition) name
#SBATCH -N 1                       # Total # of nodes
#SBATCH -t 01:00:00                # Run time (hh:mm:ss)
#SBATCH -A my-project              # Allocation name
#----------------------------------------------------------------------

# Load required modules
module use /scratch/tacc/apps/bio/alphafold3/modulefiles
module load alphafold3/3.0.1-ctr.lua

# Set environment variable definitions to point to your input, output, and model parameters directories:
export AF3_INPUT_DIR=$SCRATCH/input/
export AF3_OUTPUT_DIR=$SCRATCH/output/
export AF3_MODEL_PARAMETERS_DIR=$WORK/af3_parameters

# Run AlphaFold3 
run_alphafold3 --json_path=$AF3_INPUT_DIR/input.json           # MODIFY name of input.json                                
```

In the batch script, make sure to specify the partition (queue) (`#SBATCH -p`), node / wallclock limits, and allocation name (`#SBATCH -A`) appropriate to the machine you are running on. Also, make sure the path shown in the `module use` line matches the machine-specific "Module" path listed in [Table 1.](#table1) above.

When preparing a batch job script to run AlphaFold3, users must set several environment variables to point to their input, output, and model directories. The table below describes each variable and the necessary edits. 

#### Table 2. Required Variables to Set in Job Script { #table2 }

Variable | What it does | User Action Required
-- | -- | --
`AF3_INPUT_DIR` | Directory containing the `input.json` file | Set this to the location of your input files (e.g., `$SCRATCH/input`)
`AF3_OUTPUT_DIR` | Directory where output will be written | Set this to your desired output path (e.g., `$SCRATCH/output`)
`AF3_MODEL_PARAMETERS_DIR` | Directory where you manually downloaded and extracted the AlphaFold3 model parameters | Set this to where you stored the models (e.g., `$WORK/af3_parameters`)

Once the input `.json` and customized batch script are prepared, submit to the job queue with:

`login1$ sbatch <job_script>`

e.g.:

`login1$ sbatch AF3_protein.slurm`

### Optimizing Your AlphaFold3 Run { #optimizing }

#### Enabling Unified Memory (GPU Spill to Host RAM)

Unified memory lets the GPU use host RAM when GPU memory is insufficient. Using unified memory will make the job run slower, but can help with large structures or when you hit out-of-memory errors. Add these exports to your job script before calling `run_alphafold3`:

```bash
export XLA_PYTHON_CLIENT_PREALLOCATE=false
export TF_FORCE_UNIFIED_MEMORY=true
export XLA_CLIENT_MEM_FRACTION=3.2
```

`XLA_CLIENT_MEM_FRACTION=3.2` allows the client to use up to 3.2× the GPU memory size (spilling into host RAM). Tune this value based on available host memory and job size.

#### Running MSA and Inference Separately { #split-stages }

AlphaFold3 can be run in two stages:

 1. MSA stage (CPU or GPU): generates multiple sequence alignments (MSAs) from your input sequence(s).
 2. Inference stage (GPU): uses the MSA and other preprocessed data to generate structure predictions. 

Running the stages separately allows you to run the MSA on a CPU node and run the inference step on a GPU node.

##### Step 1: Run MSA

A sample `protein_MSA.slurm` job script with the `--norun_inference` flag is included in the machine-specific "Examples" path listed in [Table 1.](#table1) above. After necessary customizations, a batch script for running the MSA step on Frontera may look like this:

```job-script
#!/bin/bash
#----------------------------------------------------------------------
#SBATCH -J protein_MSA             
#SBATCH -o protein_MSA.o%j         
#SBATCH -e protein_MSA.e%j        
#SBATCH -p normal                  # Normal (CPU) queue
#SBATCH -N 1                       
#SBATCH -t 01:00:00                
#SBATCH -A my-project              
#----------------------------------------------------------------------

# Load required modules
module use /scratch2/projects/bio/alphafold3/modulefiles
module load alphafold3/3.0.1-ctr.lua

# Set environment variable definitions to point to your input, output, and model parameters directories:
export AF3_INPUT_DIR=$SCRATCH/input/
export AF3_OUTPUT_DIR=$SCRATCH/output/
export AF3_MODEL_PARAMETERS_DIR=$WORK/af3_parameters

# Run AlphaFold3 (MSA only)
run_alphafold3 --json_path=$AF3_INPUT_DIR/input.json --norun_inference
```

In the batch script above:

 - The partition (queue) (`#SBATCH -p`) is set to the **normal (CPU)** queue.
 - The `--norun_inference` flag tells AlphaFold3 to stop after generating the MSA and other preprocessed data.
 - The specified `AF3_OUTPUT_DIR` will contain all files needed for inference, including a new directory (named after the "name" value in our `input.json` file (e.g., `uqcr11_hsapiens`)) containing a new file called `uqcr11_hsapiens_data.json`. This will be our input for the inference step. 

##### Step 2: Run Inference

A sample `protein_inference.slurm` job script with the `--norun_data_pipeline` flag is included in the machine-specific "Examples" path listed in [Table 1.](#table1) above. After necessary customizations, a batch script for running the inference step on Frontera may look like this:

```job-script
#!/bin/bash
#----------------------------------------------------------------------
#SBATCH -J protein_inf             
#SBATCH -o protein_inf.o%j         
#SBATCH -e protein_inf.e%j        
#SBATCH -p rtx                  # rtx queue
#SBATCH -N 1                       
#SBATCH -t 01:00:00                
#SBATCH -A my-project              
#----------------------------------------------------------------------

# Load required modules
module use /scratch2/projects/bio/alphafold3/modulefiles
module load alphafold3/3.0.1-ctr.lua

# Set environment variable definitions to point to your input, output, and model parameters directories:
export AF3_INPUT_DIR=$SCRATCH/output/uqcr11_hsapiens
export AF3_OUTPUT_DIR=$SCRATCH/output/uqcr11_hsapiens
export AF3_MODEL_PARAMETERS_DIR=$WORK/af3_parameters

# Run AlphaFold3 (inference only)
run_alphafold3 --json_path=$AF3_INPUT_DIR/uqcr11_hsapiens_data.json --norun_data_pipeline
```

In the batch script above:

 - The partition (queue) (`#SBATCH -p`) is set to the **rtx** queue.
 - The `--norun_data_pipeline` flag tells AlphaFold3 to skip the MSA stage and run only the model inference. 

!!! important
    - `AF3_INPUT_DIR` must point to the new directory generated in Step 1 (e.g., `$SCRATCH/output/uqcr11_hsapiens`)
    - `--json_path` must point to the new `_data.json` file generated by Step 1 (e.g., `uqcr11_hsapiens_data.json`)

We are currently benchmarking AlphaFold3 on TACC systems. Refer to the [AlphaFold3 performance documentation](https://github.com/google-deepmind/alphafold3/blob/main/docs/performance.md#running-the-pipeline-in-stages) for runtime estimates based on token size and available hardware. Refer to the [AlphaFold3 output Documentation](https://github.com/google-deepmind/alphafold3/blob/main/docs/output.md) for a description of the expected output files. 

## References { #refs } 

* [GitHub: AlphaFold3](https://github.com/google-deepmind/alphafold3)
* [AlphaFold3 Nature Paper](https://www.nature.com/articles/s41586-024-07487-w)


{% include 'aliases.md' %}
