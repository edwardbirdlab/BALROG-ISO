process GTDB_TK {
    label 'plasmer'
    container 'quay.io/biocontainers/gtdbtk:2.4.0--pyhdfd78af_2'

    input:
        tuple val(sample), file(fasta), path(db)
    output:
        path("./${sample}"), emit: results


    script:
    """
    mkdir db
    tar -xf *.tar.gz -C db --strip-components=1
    GTDBTK_DATA_PATH="db"
    mkdir fasta_dir
    cp ${fasta} fasta_dir
    gtdbtk classify_wf --out_dir ${sample} --prefix ${sample} --genome_dir fasta_dir --cpus ${task.cpus} --extension fasta --skip_ani_screen

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        gtdbtk: \$(gtdbtk --version 2>&1 | sed -e 's/gtdbtk: version \\([0-9.]*\\).*/\\1/')
    END_VERSIONS 
    """
}