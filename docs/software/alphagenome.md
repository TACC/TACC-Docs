# AlphaGenome at TACC
*Last update: August 11, 2026*

<img src="../imgs/alphagenome-logo.png" width="250" alt="AlphaGenome logo" class="align-right">  

AlphaGenome is Google DeepMind's unified DNA sequence model for regulatory variant-effect prediction and studying genome function. It analyzes DNA sequences of up to 1 million base pairs and produces predictions at single base-pair resolution across many modalities, including gene expression, splicing, chromatin accessibility, and contact maps. The model is described in the [Nature paper](https://www.nature.com/articles/s41586-025-10014-0) and the source code is available on [GitHub](https://github.com/google-deepmind/alphagenome_research); see also the official [AlphaGenome documentation](https://www.alphagenomedocs.com/).

At TACC, AlphaGenome is provided as a containerized environment module on **Vista** and **Stampede3**. The container bundles Python, JAX with GPU support, and the AlphaGenome code; you provide your own model weights and run predictions with a short Python script through the `run_alphagenome` command.

!!! note
    AlphaGenome runs on **GPU nodes** (Vista Grace-Hopper, Stampede3 H100). You use its Python API, either interactively or from a script. The module wraps this in a `run_alphagenome` command.

## Installations at TACC { #installations }

!!! important
    To run AlphaGenome at TACC you **must obtain the model weights yourself** by accepting DeepMind's non-commercial [AlphaGenome Model Terms of Use](https://deepmind.google.com/science/alphagenome/model-terms).  TACC cannot distribute the model weights. See [Access](#access) below.

### Table 1. Installations at TACC { #table 1 }

HPC Resource | Latest Version
-- | --
Vista | AlphaGenome: v0.3.0<br>**Reference**: `/scratch/tacc/apps/bio/alphagenome/0.3.0/reference`<br>**Examples**: `/scratch/tacc/apps/bio/alphagenome/0.3.0/examples`<br>**Module**: `/scratch/tacc/apps/bio/alphagenome/modulefiles` |
Stampede3 | AlphaGenome: v0.3.0<br>**Reference**: `/scratch/tacc/apps/bio/alphagenome/0.3.0/reference`<br>**Examples**: `/scratch/tacc/apps/bio/alphagenome/0.3.0/examples`<br>**Module**: `/scratch/tacc/apps/bio/alphagenome/modulefiles` |
Horizon | *Coming soon*

## Access

Because of AlphaGenome's licensing restrictions, users must obtain the model weights **directly from Google DeepMind**. To obtain and stage the weights:

1. Accept the AlphaGenome Model Terms of use from [Kaggle](https://www.kaggle.com/models/google/alphagenome) or [Hugging Face](https://huggingface.co/collections/google/alphagenome).
2. Download all five AlphaGenome models. The per-fold tarball is the easiest format to download.
3. Extract them into a directory you own (your `$WORK` is recommended), with one subdirectory per fold:

    ```
    $WORK/alphagenome/models/
    ├── all_folds/
    ├── fold_0/
    ├── fold_1/
    ├── fold_2/
    └── fold_3/
    ```
!!! note
    TACC cannot distribute the AlphaGenome model weights. Each user must download their own after accepting the model terms.

## Running AlphaGenome { #running }

AlphaGenome has no dedicated command-line tool. Instead you use its Python API — either interactively or from a script — and run it with `run_alphagenome`, which executes Python inside a container on the GPU. `run_alphagenome my_script.py` runs a script; `run_alphagenome` with no argument opens an interactive Python session.

### Load the module

```bash
module use /scratch/tacc/apps/bio/alphagenome/modulefiles
module load alphagenome/0.3.0-ctr
export AG_MODELS_DIR=$WORK/alphagenome/models     # your own weights (see Access)
```

The module sets these variables for you:

| Variable | Meaning |
| --- | --- |
| `AG_REFERENCE_DIR` | Shared genome reference files (set by TACC) |
| `AG_EXAMPLES_DIR`  | Example scripts, including `variant_pred.py` |
| `AG_IMAGE`         | Path to the container image |
| `AG_MODELS_DIR`    | **You set this** — your downloaded weights |

Run `module help alphagenome` at any time for a summary.

### Directory Structure

We recommend working from `$SCRATCH`. A typical layout:

```
alphagenome_project/
├── my_analysis.py
└── slurm_jobs/
    └── alphagenome.slurm
```

### Writing an analysis script

A complete working example is provided at `$AG_EXAMPLES_DIR/variant_pred.py`. Copy it as a starting point:

```bash
cp $AG_EXAMPLES_DIR/variant_pred.py .
```

It reads `AG_MODELS_DIR` and `AG_REFERENCE_DIR` from the environment, builds the model, scores a variant, and writes a plot (`pv.png`). The essential structure:

```python
import os
import jax

# Initialize the GPU and fail loudly if we somehow landed on CPU (10-100x slower).
assert jax.devices()[0].platform == "gpu", f"Expected a GPU, got {jax.devices()}"

from alphagenome.data import genome
from alphagenome_research.model import dna_model

MODELS = os.environ["AG_MODELS_DIR"]
REF = os.environ["AG_REFERENCE_DIR"]

model = dna_model.create(
    checkpoint_path=os.path.join(MODELS, "all_folds") + "/",
    organism_settings={
        dna_model.Organism.HOMO_SAPIENS: dna_model.OrganismSettings(
            fasta_path=f"{REF}/gencode/hg38/GRCh38.p13.genome.fa",
            gtf_feather_path=f"{REF}/gencode/hg38/gencode.v46.annotation.gtf.gz.feather",
            # ... (see the full example for all reference paths) ...
        ),
    },
    device=jax.local_devices()[0],
)

# ... build a genome.Interval / genome.Variant and call model.predict_variant(...) ...
```

For the full API and more examples, see the official
[AlphaGenome documentation](https://www.alphagenomedocs.com/) and the
[quick-start notebook](https://colab.research.google.com/github/google-deepmind/alphagenome_research/blob/main/colabs/quick_start.ipynb).

### Interactive development (idev)

Grab a GPU node with `idev` (queue `gh` on Vista, `h100` on Stampede3), load the module, and set your weights:

```cmd-line
login1$ idev -p gh -N 1 -t 01:00:00  # request 1 Vista Grace-Hopper GPU node for 1 hour
...
c123-456$ module use /scratch/tacc/apps/bio/alphagenome/modulefiles
c123-456$ module load alphagenome/0.3.0-ctr
c123-456$ export AG_MODELS_DIR=$WORK/alphagenome/models
```

From there you can work interactively:

```bash
# Open an interactive Python session inside the container (no argument):
run_alphagenome
```

### Batch jobs (SLURM)

An example job script is provided in `$AG_EXAMPLES_DIR`. A minimal batch job:

#### Vista

Modify the following job script for use on Stampede3.

```job-script
#!/bin/bash
#SBATCH -J alphagenome
#SBATCH -o alphagenome.%j.out
#SBATCH -e alphagenome.%j.err
#SBATCH -p gh                 # Vista Grace-Hopper GPU queue
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -t 01:00:00
#SBATCH -A your-project       # your allocation

module use /scratch/tacc/apps/bio/alphagenome/modulefiles
module load alphagenome/0.3.0-ctr
export AG_MODELS_DIR=$WORK/alphagenome/models

cp $AG_EXAMPLES_DIR/variant_pred.py .
run_alphagenome variant_pred.py
```

##### Large sequences: unified memory (Vista)

On Vista's GH200, you can let the GPU spill to host RAM for very long sequences by setting and exporting the following environment variables prior to running `run_alphagenome`:

```bash
export XLA_PYTHON_CLIENT_PREALLOCATE=false
export TF_FORCE_UNIFIED_MEMORY=true
export XLA_CLIENT_MEM_FRACTION=3.2
```


#### Stampede3

Modify the following job script for use on Stampede3.

```job-script
#!/bin/bash
#SBATCH -J alphagenome
#SBATCH -o alphagenome.%j.out
#SBATCH -e alphagenome.%j.err
#SBATCH -p h100               # Stampede3 H100 GPU queue
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -t 01:00:00
#SBATCH -A your-project       # <-- your allocation

module use /scratch/tacc/apps/bio/alphagenome/modulefiles
module load alphagenome/0.3.0-ctr
export AG_MODELS_DIR=$WORK/alphagenome/models

cp $AG_EXAMPLES_DIR/variant_pred.py .
run_alphagenome variant_pred.py
```

Submit your job script on the command-line:

```cmd-line
$ sbatch alphagenome.slurm
```

Program outputs, such as `pv.png`, are written to the directory you submitted from.

## Citation { #citation }

If you use AlphaGenome at TACC in your research, please cite:

> Avsec, Ž., Latysheva, N., Cheng, J. et al. Advancing regulatory variant effect prediction with
> AlphaGenome. *Nature* 649, 1206–1218 (2026).
> [https://doi.org/10.1038/s41586-025-10014-0](https://doi.org/10.1038/s41586-025-10014-0)

and acknowledge:

> The authors acknowledge the Texas Advanced Computing Center (TACC) at The University of Texas at
> Austin for providing computational resources that have contributed to the research results reported 
> within this paper. URL: http://www.tacc.utexas.edu

## References { #refs }

* [AlphaGenome source code](https://github.com/google-deepmind/alphagenome_research)
* [AlphaGenome documentation](https://www.alphagenomedocs.com/)
* [Model weights (Kaggle)](https://www.kaggle.com/models/google/alphagenome)
* [Model weights (Hugging Face)](https://huggingface.co/collections/google/alphagenome)
* [Model Terms of Use](https://deepmind.google.com/science/alphagenome/model-terms)
* [AlphaGenome Community](https://www.alphagenomecommunity.com)

{% include 'aliases.md' %}
