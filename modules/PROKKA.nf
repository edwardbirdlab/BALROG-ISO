process PROKKA {
    label 'lowmem'
    container 'staphb/prokka:latest'

    input:
        tuple val(sample), file(fasta)
    output:
        path("./${sample}"), emit: prokka_results
        path("versions.yml"), emit: versions

    script:

    """
    prokka --outdir ${sample} --prefix ${sample} ${fasta} --cpus ${task.cpus} --centre X --compliant

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        prokka: \$(prokka -v 2>&1 | sed -e "s/prokka //g")
    END_VERSIONS 
    """
}