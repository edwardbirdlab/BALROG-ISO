process BUSCO_DB {
    label 'lowmem'
    container 'ebird013/busco:5.7.1'
        
    output:
        path("./busco_downloads"), emit: busco_db
        path("versions.yml"), emit: versions

    script:

    """
    busco --download ${params.busco_lineage}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        busco: \$(busco -v 2>&1 | sed -e "s/BUSCO //g")
    END_VERSIONS 
    """
}