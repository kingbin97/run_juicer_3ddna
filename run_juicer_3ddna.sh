#!/bin/bash
####################################################################################################
### 使用说明                                                                                     ###
####################################################################################################
usage() {
	echo -e "\e[32mUsage: bash run_juicer_3ddna.sh <-i genome.fa> <-c hic path> [-p juicer path] [-m restriction enzyme] [-d 3ddna path] [-j thread]\e[0m"
	echo -e "\e[32m                -i          基因组\e[0m                      "
	echo -e "\e[32m                -p          juicer目录\e[0m                       "
	echo -e "\e[32m                -c          hic目录\e[0m               "
	echo -e "\e[32m                -d          3ddna 目录"
	echo -e "\e[32m                -m          酶切类型：HindIII | DpnII | MboI | NcoI     [ Default: MboI ]\e[0m"
	echo -e "\e[32m                -j          线程数                                      [ Default: 40 ]\e[0m"
	echo -e "\e[32m注意：hic文件后缀必须以  *_R*.fastq* 结尾 \e[0m"
}
if [ $# -eq 0 ] || [ "$1" = "-h" ]; then
	usage
	exit 0
elif [ $# -lt 4 ]; then
	echo "Error: Missing required arguments."
	usage
	exit 1
fi
####################################################################################################
### 传参                                                                                         ###
####################################################################################################
while getopts ":i:p:c:m:j:d:" opt; do
	case $opt in
		i) reference_in="$OPTARG";;
		p) scripts_path="$OPTARG";;
		c) hic="$OPTARG";;
		d) path_3ddna="$OPTARG";;
		m) enzyme_type="$OPTARG";;
		j) THREAD="$OPTARG";;
		\?) echo "Invalid option -$OPTARG" >&2;;
	esac
done
####################################################################################################
path=$(pwd)
reference=$(basename "$reference_in")
####################################################################################################
# 酶切
if [[ -z $enzyme_type ]]
then
	enzyme_type=MboI
fi
# 线程
if [[ -z $THREAD ]]
then
	THREAD=40
fi
if [[ -z $scripts_path ]]
then
	scripts_path=/opt/biosoft/juicer-1.6
fi
if [[ -z $path_3ddna ]]
then
	path_3ddna=/opt/biosoft/3d-dna-201008
fi
####################################################################################################
echo -e "####################################################################################################"
echo -e "##         \e[32m基因组: ${reference}\e[0m"
echo -e "##         \e[32m工作目录：${path}\e[0m"
echo -e "##         \e[32mjuicer目录: ${scripts_path}\e[0m"
echo -e "##         \e[32mhic文件所在目录: ${hic}\e[0m"
echo -e "##         \e[32m线程数: ${THREAD}\e[0m"
echo -e "##         \e[32m酶切类型: ${enzyme_type}\e[0m"
# runnning 1
echo -e "####################################################################################################"
echo -e "##  \e[32mRunnning 1：创建fastq目录\e[0m"
mkdir fastq
cd fastq
ln -s ${hic}/* .
echo -e "##  \e[32mFinished 1：创建fastq目录\e[0m"
cd ..
# runnning 2
echo -e "####################################################################################################"
echo -e "##  \e[32mRunnning 2: 创建酶切文件\e[0m"
mkdir restriction_sites
cd restriction_sites
${scripts_path}/misc/generate_site_positions.py ${enzyme_type} $reference $reference_in
echo -e "##  \e[32mFinished 2: 创建酶切文件\e[0m"
cd ..
# runnning 3
echo -e "####################################################################################################"
echo -e "##  \e[32mRunnning 3: 创建索引文件与染色体长度文件\e[0m"
mkdir references
cd references
ln -s ${reference_in}
samtools faidx ${reference}
cut -f1,2 ${reference}.fai >${reference}.size
bwa index ${reference}
echo -e "##  \e[32mFinished 3: 创建索引文件与染色体长度文件\e[0m"
cd ..
# runnning 4
echo -e "####################################################################################################"
echo -e "##  \e[32mRunnning 4：软连接脚本文件\e[0m"
ln -s ${scripts_path}/CPU scripts
echo -e "##  \e[32mFinished 4：软连接脚本文件\e[0m"
######################################################################
# Running 5
echo -e "####################################################################################################"
echo -e "##  \e[32mRunnning 5: 运行 juicer\e[0m"
bash ${path}/scripts/juicer.sh \
-D ${path} \
-d ${path} \
-s ${enzyme_type} \
-g $(basename "$reference") \
-z ${path}/references/${reference} \
-p ${path}/references/${reference}.size \
-y ${path}/restriction_sites/${reference}_${enzyme_type}.txt \
-t ${THREAD} >run_juicer.log
echo -e "##  \e[32mFinished 5: 运行 juicer\e[0m"
######################################################################
# Running 6: 3D-DNA run1
echo -e "####################################################################################################"
echo -e "##  \e[32mRunnning 6: 运行 第一轮3D-DNA\e[0m"
mkdir run1_3ddna
cd run1_3ddna
${path_3ddna}/run-asm-pipeline.sh -i 100000 -r 0 ${path}/references/${reference}  ${path}/aligned/merged_nodups.txt
echo -e "##  \e[32mFinished 6: 运行 第一轮3D-DNA\e[0m"
######################################################################
