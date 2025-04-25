/*
Subworkflow for assembly of short read bactarial genomes and classificaion of plasmids
Requries set params:

params.plasmer_min_len = '300'     ==  Setting the minimum size to be classified in plasmer (defualt/recommended = 500)
params.plasmer_max_len = '500000'  ==  Setting the length at which all contigs greater than this size are automatically considered chromomosomal in orgin (defualt = 500000)

*/

include { PLASMER as PLASMER } from '../modules/PLASMER.nf'
include { PLASMER_SORT as PLASMER_SORT } from '../modules/PLASMER_SORT.nf'
include { QUAST as QUAST_PLASMID} from '../modules/QUAST.nf'
include { QUAST as QUAST_CHROMOSOMAL} from '../modules/QUAST.nf'
include { QUAST as QUAST_SHORT} from '../modules/QUAST.nf'
include { PLASMER_DB as PLASMER_DB } from '../modules/PLASMER_DB.nf'
include { PLASMIDFINDER as PLASMIDFINDER } from '../modules/PLASMIDFINDER.nf'


workflow PLASMID_PREDICTION {
    take:
        assembly      //    channel: [ val(sample), path("${sample}_scaffolds.fasta")]

    main:

        // Plasmer Database

        if (params.db_plasmer) {

            PLASMER_DB()

            ch_plasmer_db       = PLASMER_DB.out.plasmer_DB

            } else {

                ch_plasmer_db   =  Channel.fromPath("${params.database_dir}/Plasmer/*.Kraken2DB.tar.xz","${params.database_dir}/Plasmer/*.MainDB.tar.xz")

            }


        PLASMER(assembly, ch_plasmer_db)
        PLASMER_SORT(PLASMER.out.for_sort)
        QUAST_PLASMID(PLASMER_SORT.out.plasmid)
        QUAST_CHROMOSOMAL(PLASMER_SORT.out.chromosome)
        QUAST_SHORT(PLASMER_SORT.out.tooshort)

        PLASMIDFINDER(PLASMER_SORT.out.plasmid)

    emit:
        plasmids         =       PLASMER_SORT.out.plasmid        // tuple val(sample), path("*plasmid.fasta"), emit: plasmid
        chromosomal      =       PLASMER_SORT.out.chromosome     // tuple val(sample), path("*chromosome.fasta"), emit: chromosome
        too_short        =       PLASMER_SORT.out.tooshort       // tuple val(sample), path("*tooshort.fasta"), emit: tooshort
        all              =       PLASMER_SORT.out.all            // tuple val(sample), path("*allclass.fasta"), emit: all

}