#!/bin/bash

#PB
module load gmap

#Build gmap index files
gmap_build -d /bigdata/messaoudilab/arivera/GEN220/groupproject/2.Alignment/GSNAP/4.gsnap_buildtest2/S.cerevisiae/ -k 15 \ genome.fasta

echo "gmap_build done"

#GNSAP code for Snt2 mutant treated vs untreated files

gsnap -D /bigdata/messaoudilab/arivera/GEN220/groupproject/2.Alignment/GSNAP/4.gsnap_buildtest2/S.cerevisiae/ -d S.cerevisiae --force-single-end --pairmax-rna=2000 --format=sam 2nt2D_0hrs_rep1_1.fastq 2nt2D_0hrs_rep2_2.fastq 2nt2D_0hrs_rep3_3.fastq 2nt2D_0hrs_rep3_3.fastq 2nt2D_0.5hrs_rep1_1.fastq 2nt2D_0.5hrs_rep2_1.fastq 2nt2D_0.5hrs_rep3_1.fastq

echo "GSNAP done"

#use samtools to convert sam to bam files
module load samtools

samtools view -b -S 2nt2D_0hrs_rep1_1.sam > 2nt2D_0hrs_rep1_1.bam
samtools view -b -S 2nt2D_0hrs_rep2_1.sam > 2nt2D_0hrs_rep2_1.bam
samtools view -b -S 2nt2D_0hrs_rep3_1.sam > 2nt2D_0hrs_rep3_1.bam

samtools view -b -S 2nt2D_0.5hrs_rep1_1.sam > 2nt2D_0.5hrs_rep1_1.bam
samtools view -b -S 2nt2D_0.5hrs_rep2_1.sam > 2nt2D_0.5hrs_rep2_1.bam
samtools view -b -S 2nt2D_0.5hrs_rep3_1.sam > 2nt2D_0.5hrs_rep3_1.bam

#sort bam file 
samtools sort snt2D_0hrs_rep1_1_copy.bam snt2D_0hrs_rep1_1_sorted
samtools sort snt2D_0hrs_rep2_1_copy.bam snt2D_0hrs_rep2_1_sorted
samtools sort snt2D_0hrs_rep3_1_copy.bam snt2D_0hrs_rep3_1_sorted

samtools sort snt2D_0.5hrs_rep1_1_copy.bam snt2D_0.5hrs_rep1_1_sorted
samtools sort snt2D_0.5hrs_rep2_1_copy.bam snt2D_0.5hrs_rep2_1_sorted
samtools sort snt2D_0.5hrs_rep3_1_copy.bam snt2D_0.5hrs_rep3_1_sorted

#cuffdiff expression
module load cufflinks

cuffdiff -o diff_out_mut_2 -p 8 -L q1,q2 features.gff snt2D_0hrs_rep1_1_sorted.bam,snt2D_0hrs_rep2_1_sorted.bam,snt2D_0hrs_rep3_1_sorted.bam snt2D_0.5hrs_rep1_1_sorted.bam,snt2D_0.5hrs_rep2_1_sorted.bam,snt2D_0.5hrs_rep3_1_sorted.bam


#determine mapping % 
samtools flagstat snt2D*.sam 
samtools flagstat WT*.sam

echo "Done,done"

