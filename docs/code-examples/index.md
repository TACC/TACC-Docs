# Code Examples

[TOC]

<style>:is(h1, h2, h4, h4, h5, h6) > b { text-decoration: underline; font-weight: inherit; }</style>

## Different Ways to Style & Author Code

### Inline Code

⚠️ Not documented yet.

### Code Block

#### Syntax

!!! hint "Correct"

            ```syntax
            ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBN+Mh3U/3We4VYtV1QmWUFIzFLTUeegl1Ao5/QGtCRGAZn8bxX9KlCrrWISIjSYAwCajIEGSPEZwPNMBoK8XD8Q= ylo@klar
            ```

    ```syntax
    ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBN+Mh3U/3We4VYtV1QmWUFIzFLTUeegl1Ao5/QGtCRGAZn8bxX9KlCrrWISIjSYAwCajIEGSPEZwPNMBoK8XD8Q= ylo@klar
    ```

#### Command Line

!!! hint "Preferred"

            ```cmd-line
            module load kitten
            ```

    ```cmd-line
    module load kitten
    ```

    {% include 'code-examples/_preferred-way-pro-con.md' %}

!!! caution "Avoided"

            <pre class="cmd-line"><code>module <strong>load <em>kitten</em></strong></code></pre>

    <pre class="cmd-line"><code>module <strong>load <em>kitten</em></strong></code></pre>

    {% include 'code-examples/_avoided-way-pro-con.md' %}

!!! danger "Deprecated"

            <pre class="cmd-line">module <strong>load <em>kitten</em></strong></pre>

    <pre class="cmd-line">module <strong>load <em>kitten</em></strong></pre>

    {% include 'code-examples/_deprecated-way-pro-con.md' %}

#### Job Script

!!! hint "Preferred"

            ```job-script
            #!/bin/bash
            #SBATCH -J myjob              # job name
            #SBATCH -e myjob.%j.err       # error file name
            #SBATCH -o myjob.%j.out       # output file name
            #SBATCH -N 2                  # request 2 nodes
            #SBATCH -n 96                 # request 2x48=96 MPI tasks
            #SBATCH -p skx-normal         # designate queue
            #SBATCH -t 24:00:00           # designate max run time
            #SBATCH -A myproject          # charge job to myproject
            module load gromacs/2022.1

            ibrun gmx_mpi mdrun -s topol.tpr -o traj.trr -c confout.gro -e ener.edr -g md.log
            ```

    ```job-script
    #!/bin/bash
    #SBATCH -J myjob              # job name
    #SBATCH -e myjob.%j.err       # error file name
    #SBATCH -o myjob.%j.out       # output file name
    #SBATCH -N 2                  # request 2 nodes
    #SBATCH -n 96                 # request 2x48=96 MPI tasks
    #SBATCH -p skx-normal         # designate queue
    #SBATCH -t 24:00:00           # designate max run time
    #SBATCH -A myproject          # charge job to myproject
    module load gromacs/2022.1
    
    ibrun gmx_mpi mdrun -s topol.tpr -o traj.trr -c confout.gro -e ener.edr -g md.log
    ```

    {% include 'code-examples/_preferred-way-pro-con.md' %}

!!! caution "Avoided"

            <pre class="job-script">
            <code>#!/bin/bash
            #SBATCH -J myjob              # job name
            #SBATCH -e myjob.%j.err       # error file name
            #SBATCH -o myjob.%j.out       # output file name
            #SBATCH -N 2                  # request 2 nodes
            #SBATCH -n 96                 # request 2x48=96 MPI tasks
            #SBATCH -p skx-normal         # designate queue
            #SBATCH -t 24:00:00           # designate max run time
            #SBATCH -A myproject          # charge job to myproject
            module <strong>load <em>gromacs/2022.1</em></strong>

            ibrun gmx_mpi mdrun -s topol.tpr -o traj.trr -c confout.gro -e ener.edr -g md.log</code></pre>

    <pre class="job-script">
    <code>#!/bin/bash
    #SBATCH -J myjob              # job name
    #SBATCH -e myjob.%j.err       # error file name
    #SBATCH -o myjob.%j.out       # output file name
    #SBATCH -N 2                  # request 2 nodes
    #SBATCH -n 96                 # request 2x48=96 MPI tasks
    #SBATCH -p skx-normal         # designate queue
    #SBATCH -t 24:00:00           # designate max run time
    #SBATCH -A myproject          # charge job to myproject
    module <strong>load <em>gromacs/2022.1</em></strong>
    &nbsp;
    ibrun gmx_mpi mdrun -s topol.tpr -o traj.trr -c confout.gro -e ener.edr -g md.log</code></pre>

    {% include 'code-examples/_avoided-way-pro-con.md' %}

!!! danger "Deprecated"

            <pre class="job-script">#!/bin/bash
            #SBATCH -J myjob              # job name
            #SBATCH -e myjob.%j.err       # error file name
            #SBATCH -o myjob.%j.out       # output file name
            #SBATCH -N 2                  # request 2 nodes
            #SBATCH -n 96                 # request 2x48=96 MPI tasks
            #SBATCH -p skx-normal         # designate queue
            #SBATCH -t 24:00:00           # designate max run time
            #SBATCH -A myproject          # charge job to myproject
            module <strong>load <em>gromacs/2022.1</em></strong>

            ibrun gmx_mpi mdrun -s topol.tpr -o traj.trr -c confout.gro -e ener.edr -g md.log</pre>

    <pre class="job-script">#!/bin/bash
    #SBATCH -J myjob              # job name
    #SBATCH -e myjob.%j.err       # error file name
    #SBATCH -o myjob.%j.out       # output file name
    #SBATCH -N 2                  # request 2 nodes
    #SBATCH -n 96                 # request 2x48=96 MPI tasks
    #SBATCH -p skx-normal         # designate queue
    #SBATCH -t 24:00:00           # designate max run time
    #SBATCH -A myproject          # charge job to myproject
    module <strong>load <em>gromacs/2022.1</em></strong>
    &nbsp;
    ibrun gmx_mpi mdrun -s topol.tpr -o traj.trr -c confout.gro -e ener.edr -g md.log</pre>

    {% include 'code-examples/_deprecated-way-pro-con.md' %}

## Syntax Highlighting Reference

Syntax
:  [Python-Markdown `fenced_code_blocks`](https://python-markdown.github.io/extensions/fenced_code_blocks)
:  [Python-Markdown `code_hilite`](https://python-markdown.github.io/extensions/code_hilite) or [PyMdown Extensions: Highlight](https://facelessuser.github.io/pymdown-extensions/extensions/highlight/) <small>(which extension is used is unclear)</small>

Languages
:  [Highlight.js: Supported Languages](https://github.com/highlightjs/highlight.js/blob/main/SUPPORTED_LANGUAGES.md#supported-languages)

Themes
:  [Highlight.js: Demo](https://highlightjs.org/demo)

### Examples

`plaintext`
```plaintext
    #!/bin/bash
    #SBATCH -J myjob              # job name
    #SBATCH -e myjob.%j.err       # error file name
    #SBATCH -o myjob.%j.out       # output file name
    #SBATCH -N 2                  # request 2 nodes
    #SBATCH -n 96                 # request 2x48=96 MPI tasks
    #SBATCH -p skx-normal         # designate queue
    #SBATCH -t 24:00:00           # designate max run time
    #SBATCH -A myproject          # charge job to myproject
    module load gromacs/2022.1
    
    ibrun gmx_mpi mdrun -s topol.tpr -o traj.trr -c confout.gro -e ener.edr -g md.log
```

`bash`
```bash
    #!/bin/bash
    #SBATCH -J myjob              # job name
    #SBATCH -e myjob.%j.err       # error file name
    #SBATCH -o myjob.%j.out       # output file name
    #SBATCH -N 2                  # request 2 nodes
    #SBATCH -n 96                 # request 2x48=96 MPI tasks
    #SBATCH -p skx-normal         # designate queue
    #SBATCH -t 24:00:00           # designate max run time
    #SBATCH -A myproject          # charge job to myproject
    module load gromacs/2022.1
    
    ibrun gmx_mpi mdrun -s topol.tpr -o traj.trr -c confout.gro -e ener.edr -g md.log
```

`json`
```json
{
    "email": "user@gmail.com",
    "pw": "pass12345"
}
```

`python`
```python
import sys
!{sys.executable} -m pip install click

import click
```
