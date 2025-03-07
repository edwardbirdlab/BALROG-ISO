#!/usr/bin/env nextflow
/*
#######################################
                                               ...._
                                         ..-```      ``.._
                                    _--``             .-`````)
               .-````----.....___../`  /``                   ```)
            _.(-----._  -.,.   _._   <_)     ........      .-````)
           (__            (_> (_/\_)  `   .-``        `-._       -``)_
        .-(     .--`````    .-----------.       --.   -.   -._   .-`` )
       /`---   /`    /```` /.. /.vv.\...-.\         \    \    \     -```)
      /`--    /           |`)vV`    `Vv|  ).         \   |____/       ---)
     (__     /             \| /````````| /.\      \  __.-`  //// /`/````)
    (       /      /        v/  /``.....V\\        \/\ \ \ //// /    _.)  
   ( `-..  /      /__  |    .| /  /     \\\       /\     ///     _.-
  (_.-----/____  /`\___\     \ |  |     || |     /          _.-``
 (     _.r-\\  `//\    `\     \ \ \     // |     \      ,.-’`
(__.-\ \ \ \\  ////|      \_   \ ` \____/  /     \\   /
  `\.          /// |\       \   `\.  __   /      /\\  |
     `*-.________  | |       \     \  _  /   .^./  \\ |
                 ! / /        `-.   \___/ .-./ |    \\|
                 || /         ^._...,    (     )     \|
                 ||/          \.    |     \._./       v
                 (|)            `-..’     ./
                  V                 ``...`                                            
       ___             
|_|     |          __  
| |igh  |hroughput     
__            _                  __                __            ___
|_|          /_\            |    |_|              |  |          | __
|_|acterial /   \ntimicrobia|__  | \estistance ann|__|tation of |__|enomes 

#######################################                                      
*/                                      




/*
========================================================================================
                         edwardbirdlab/BALROG-MON
========================================================================================
 Bacterial Antimicroal Resistance Annoation Pipeline.
 #### Find information at:
 https://github.com/edwardbirdlab/BALROG-MON
----------------------------------------------------------------------------------------
*/
nextflow.enable.dsl=2

if (params.workflow_opt == 'shortread_isolate') {

    ch_fastq = Channel.fromPath(params.sample_sheet) \
        | splitCsv(header:true) \
        | map { row-> tuple(row.sample, file(row.r1), file(row.r2)) }

    }

if (params.workflow_opt == 'sr_qc_only') {

    ch_fastq = Channel.fromPath(params.sample_sheet) \
        | splitCsv(header:true) \
        | map { row-> tuple(row.sample, file(row.r1), file(row.r2)) }

    }

include { SHORT_READ_ISOLATE as SHORT_READ_ISOLATE } from './workflows/SHORT_READ_ISOLATE.nf'
include { SR_QC_ONLY as SR_QC_ONLY } from './workflows/SR_QC_ONLY.nf'
include { SR_MULTIQC as SR_MULTIQC } from './workflows/SR_MULTIQC.nf'

workflow {

    if (params.workflow_opt == 'shortread_isolate') {

        SHORT_READ_ISOLATE(ch_fastq)

        }

    if (params.workflow_opt == 'sr_qc_only') {

        SR_QC_ONLY(ch_fastq)

        }

    if (params.workflow_opt == 'multiqc') {

        SR_MULTIQC()

        }
}