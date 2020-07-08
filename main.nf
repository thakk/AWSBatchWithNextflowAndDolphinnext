$HOSTNAME = ""
params.outdir = 'results'  


if (!params.InputFile){params.InputFile = ""} 

g_0_txtFile_g_1 = file(params.InputFile, type: 'any') 


process Reverse_file {

publishDir params.outdir, overwrite: true, mode: 'copy',
	saveAs: {filename ->
	if (filename =~ /Output.txt$/) "Results/$filename"
}

input:
 file InputFile from g_0_txtFile_g_1

output:
 file "Output.txt"  into g_1_txtFile

"""
tac ${InputFile} > Output.txt
"""
}


workflow.onComplete {
println "##Pipeline execution summary##"
println "---------------------------"
println "##Completed at: $workflow.complete"
println "##Duration: ${workflow.duration}"
println "##Success: ${workflow.success ? 'OK' : 'failed' }"
println "##Exit status: ${workflow.exitStatus}"
}
