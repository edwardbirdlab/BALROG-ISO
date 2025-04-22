/*
~~~~~~~~~~~~~~~~~~~~~~
Importing subworkflows
~~~~~~~~~~~~~~~~~~~~~~
*/

include { READ_QC_SR as READ_QC_SR } from '../subworkflows/READ_QC_SR.nf'
include { SHORT_READ_ISOLATE_ASSEMBLY as SHORT_READ_ISOLATE_ASSEMBLY } from '../subworkflows/SHORT_READ_ISOLATE_ASSEMBLY.nf'
include { PLASMID_PREDICTION as PLASMID_PREDICTION } from '../subworkflows/PLASMID_PREDICTION.nf'
//include { FUNCTIONAL_ANNOTATION as FUNCTIONAL_ANNOTATION } from '../subworkflows/FUNCTIONAL_ANNOTATION.nf'
//include { ASSEMBLY_QC as ASSEMBLY_QC } from '../subworkflows/ASSEMBLY_QC.nf'
include { IDENTIFICATION as IDENTIFICATION } from '../subworkflows/IDENTIFICATION.nf'
//include { ARG_GET_DBS as ARG_GET_DBS } from '../subworkflows/ARG_GET_DBS.nf'
//include { CUSTOM_ARG_DB as CUSTOM_ARG_DB } from '../subworkflows/CUSTOM_ARG_DB.nf'
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