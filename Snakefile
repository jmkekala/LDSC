# Snakemake file: Snakefile

# Define the input and output file patterns
bfile_pattern = "1000G_EUR_Phase3_plink1/1000G.EUR.QC.{chrom}.bed"
annotation_pattern = "for_testing/ASPC_random_set{set}.txt.{chrom}.annot.gz"
output_pattern = "results/ASPC_random_set{set}.txt.{chrom}"

CHROMOSOMES = glob_wildcards("1000G_EUR_Phase3_plink1/1000G.EUR.QC.{condition}.bed").condition
SET_LIST = glob_wildcards("for_testing/ASPC_random_set{condition}.txt.{chrom}.annot.gz").condition

# Make sure lists contain unique values and sort them in numerical order
CHROMOSOMES = list(set(CHROMOSOMES))
SET_LIST = list(set(SET_LIST))
CHROMOSOMES = sorted(CHROMOSOMES, key=lambda x: int(x))
SET_LIST = sorted(SET_LIST, key=lambda x: int(x))

print("Chromosomes are: ", CHROMOSOMES)
print("Annotation sets are: ", SET_LIST)

# Rule to collect all final results
rule all:
    input:
        expand(output_pattern+".l2.ldscore.gz", set=SET_LIST,chrom=CHROMOSOMES)

# Rule: Generate LD scores for each chromosome and annotation set
rule run_ldsc:
    # Track input and annotation
    input:
        bfile=bfile_pattern,
        annotation=annotation_pattern
    output:
        expand(output_pattern+".l2.ldscore.gz", set="{set}",chrom="{chrom}")
    # Define input and output variables. LDSC requires input _without_ extension. Same applies to output.
    params:
        bfile=bfile_pattern.rsplit(".", 1)[0],
        output=output_pattern.format(set="{set}", chrom="{chrom}")
    # Use pre-installed "ldsc" conda environment
    conda:
        "ldsc"
    # Actual LDSC run
    shell:
        """ 
        ldsc/ldsc.py \
            --l2 \
            --bfile {params.bfile} \
            --annot {input.annotation} \
            --ld-wind-cm 1 \
            --thin-annot \
            --out {params.output} \
        """

