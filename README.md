# run_juicer_3ddna
Usage: run_juicer_3ddna.sh <-i genome.fa> <-c hic path> [-p juicer path] [-m restriction enzyme] [-d 3ddna path] [-j thread] \n
                            -i          genome \n
                          	-p          juicer path \n
                          	-c          hic path \n
                          	-d          3ddna path \n
                          	-m          Restriction enzyme cleavage types：HindIII | DpnII | MboI | NcoI     [ Default: MboI ] \n
                          	-j          Threads                                      [ Default: 40 ] \n
                          	 Note: The HIC files must have the suffix "*_R*.fastq*" \n
# piplines with genome assembly by juicer and 3ddna.
# You need to install Juicer and 3D-DNA for this bioinformatics workflow. If you have any questions or need assistance with the installation process, please let me know.
# Juicer and 3D-DNA can be installed in the directory `/opt/biosoft` or Please use the following command:  \n
"sed -i '/$path_Juicer/\/opt\/biosoft\/juicer-1.6/;/$path_3ddna/\/opt\/biosoft\/3d-dna-201008/'  run_juicer_3ddna" \n
#Note that you need to use \ to escape the slashes in the command.
# Juicer：https://github.com/aidenlab/juicer
# 3D-DNA: https://github.com/aidenlab/3d-dna
