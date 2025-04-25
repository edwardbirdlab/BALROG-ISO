process PLASMIDFINDER {
   label 'lowmemlong'
    container 'ebird013/plasmidfinder:latest'

    input:
        tuple val(sample), file(fasta)

    output:
        path("./${sample}_plasmidfinder"), emit: plasmidfinder_results


    script:

    """
    mkdir -p ${sample}_plasmidfinder
    /usr/src/plasmidfinder.py -i ${fasta} -o ${sample}_plasmidfinder
    """
}