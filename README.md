#run_juicer_3ddna <br>
Usage: run_juicer_3ddna.sh <-i genome.fa> <-c hic path> [-p juicer path] [-m restriction enzyme] [-d 3ddna path] [-j thread] <br>
                          &#9; -i          genome <br>
                          &#9; -p          juicer path <br>
                          &#9; -c          hic path <br>
                          &#9; -d          3ddna path <br>
                          &#9; -m          Restriction enzyme cleavage types：HindIII | DpnII | MboI | NcoI     [ Default: MboI ] <br>
                          &#9; -j          Threads                                      [ Default: 40 ] <br>
                          &#9; Note: The HIC files must have the suffix "*_R*.fastq*" <br>
piplines with genome assembly by juicer and 3ddna. <br>
You need to install Juicer and 3D-DNA for this bioinformatics workflow. If you have any questions or need assistance with the installation process, please let me know. <br>

Juicer and 3D-DNA can be installed in the directory `/opt/biosoft` or Please use the following command:  <br>
&#9; "sed -i '/$path_Juicer/\/opt\/biosoft\/juicer-1.6/;/$path_3ddna/\/opt\/biosoft\/3d-dna-201008/'  run_juicer_3ddna" <br>

Note that you need to use \ to escape the slashes in the command. <br>
Juicer：https://github.com/aidenlab/juicer <br>
3D-DNA: https://github.com/aidenlab/3d-dna <br>
