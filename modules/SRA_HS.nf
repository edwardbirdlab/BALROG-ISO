process SRA_HS {
    label 'low'
	container 'ebird013/sra_human_scrubber:latest'

    input:
        tuple val(sample), file(R1), file(R2)
    output:
	    tuple val(sample), path("${sample}_decon_1.fastq.gz"), path("${sample}_decon_2.fastq.gz"), emit: decon_fastq
        tuple val(sample), path("${sample}_scrub.log")
        path("versions.yml"), emit: versions


    script:

    """
    gunzip -c ${R1} > ${sample}_raw_1.fq
    gunzip -c ${R2} > ${sample}_raw_2.fq

    scrub.sh -p ${task.cpus} -i ${sample}_raw_1.fq -o ${sample}_decon_1.fastq 2>&1 | tee ${sample}_scrub.log
    scrub.sh -p ${task.cpus} -i ${sample}_raw_2.fq -o ${sample}_decon_2.fastq 2>&1 | tee -a ${sample}_scrub.log

    gzip ${sample}_decon_1.fastq
    gzip ${sample}_decon_2.fastq

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        sra_human_scrubber: "2.2.1"
        sra_human_scrubber_db: \$(scrub.sh test 2>&1 | grep "DB version" | sed -e "s/DB version is //g")
    END_VERSIONS
    """
}