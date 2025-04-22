/*
~~~~~~~~~~~~~~~~~~~~~~
Importing subworkflows
~~~~~~~~~~~~~~~~~~~~~~
*/

include { READ_QC_SR as READ_QC_SR } from '../subworkflows/READ_QC_SR.nf'
include { SHORT_READ_ISOLATE_ASSEMBLY as SHORT_READ_ISOLATE_ASSEMBLY } from '../subworkflows/SHORT_READ_ISOLATE_ASSEMBLY.nf'
include { PLASMID_PREDICTION as PLASMID_PREDICTION } from '../subworkflows/PLASMID_PREDICTION.nf'
include { IDENTIFICATION as IDENTIFICATION } from '../subworkflows/IDENTIFICATION.nf'
include { MULTI_AMR as MULTI_AMR } from '../subworkflows/MULTI_AMR.nf'

workflow SHORT_READ_ISOLATE {
    take:
        fastqs_short_raw      //    channel: [val(sample), [fastq_1, fastq_2]]

    main:
        READ_QC_SR(fastqs_short_raw)

        SHORT_READ_ISOLATE_ASSEMBLY(READ_QC_SR.out.trimmed_fastq)
        
        PLASMID_PREDICTION(SHORT_READ_ISOLATE_ASSEMBLY.out.unclassed_genome)

        IDENTIFICATION(SHORT_READ_ISOLATE_ASSEMBLY.out.unclassed_genome)

        MULTI_AMR(SHORT_READ_ISOLATE_ASSEMBLY.out.unclassed_genome)

}