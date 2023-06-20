# SNAKEMAKE - LDSC

This little snakemake script will execute [LDSC](https://github.com/bulik/ldsc) runs

## Install LDSC

```
git clone https://github.com/bulik/ldsc.git
cd ldsc
conda env create --file environment.yml
```

## How To run with SLURM

```
    snakemake --cores all --jobs 20 --cluster 'sbatch -t 1:00:00 --mem=12000'
```
