/*
Subworkflow for Identification bactarial genomes
Requries set params:

*/

include { GTDBTK_DB as GTDBTK_DB } from '../modules/GTDBTK_DB.nf'
include { GTDB_TK as GTDB_TK } from '../modules/GTDB_TK.nf'


workflow IDENTIFICATION {
    take:
        chromosomal      //    channel: [ val(sample), path("${sample}_chromosome.fasta")]

    main:
    
        // GTDBtk Database

        if (params.db_gtdbtk) {

            GTDBTK_DB()

            ch_gtdbtk_db       = GTDBTK_DB.out.DB

            } else {

                ch_gtdbtk_db   =  Channel.fromPath("${params.database_dir}/GTDBtk/*.tar.gz")

            }

        ch_for_gtdbtk = chromosomal.combine(ch_gtdbtk_db)


        GTDB_TK(ch_for_gtdbtk)


}