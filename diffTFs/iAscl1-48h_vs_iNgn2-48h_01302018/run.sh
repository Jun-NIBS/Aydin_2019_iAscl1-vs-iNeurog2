#PBS -W umask=0007
#PBS -W group_list=sam77_collab
#PBS -l walltime=30:00:00
#PBS -l nodes=1:ppn=1
#PBS -j oe
#PBS -A sam77_b_g_sc_default
#PBS -l mem=10gb

module load r/3.4
module load python/2.7.8


cd /gpfs/group/sam77/default/projects/es/iAscl1_iNgn2/diffTFs/iAscl1-48h_vs_iNgn2-48h_01302018

multi_out="/gpfs/group/sam77/default/projects/es/iAscl1_iNgn2/multigps_calls/Ascl1_Ngn2_12_and_48h_14112017/Ascl1_Ngn2_12_and_48_14112017"
outbase=$(echo "$multi_out" | sed 's/\/$//' | rev | cut -d "/" -f1 | rev)
condition_name_A="EB+48hr_iA_Ascl1"
condition_name_N="EB+48hr_iN_Ngn2"
# Name of the factors
facA="Ascl1-48hr"
facN="Ngn2-48hr"

# seq-code jar file                
seqcodejar="/gpfs/group/sam77/default/projects/es/iAscl1_iNgn2/diffTFs/seqcode.mahonylab.jar"

perl ~/group/projects/es/iAscl1_iNgn2/utils/extract_from_multiGPS.pl "$multi_out"/"$outbase".all.events.table "$multi_out"/"$outbase""_""$condition_name_A""_gt_""$condition_name_N"".diff.events" "$condition_name_A" "$condition_name_A"";""$condition_name_N" true | grep -v "#" | awk '$3<-6.64{print $1"\t"$2}' | grep "Infinity" > tmp

perl ~/group/projects/es/iAscl1_iNgn2/utils/extract_from_multiGPS.pl "$multi_out"/"$outbase".all.events.table "$multi_out"/"$outbase""_""$condition_name_A""_gt_""$condition_name_N"".diff.events" "$condition_name_A" "$condition_name_A"";""$condition_name_N" true | grep -v "#" | awk '$3<-6.64{print $1"\t"$2}' | grep -v "Infinity" | sort -k2 -n >> tmp

mv tmp "$facA""_gt_""$facN"".peaks"

perl ~/group/projects/es/iAscl1_iNgn2/utils/extract_from_multiGPS.pl "$multi_out"/"$outbase".all.events.table "$multi_out"/"$outbase""_""$condition_name_N""_gt_""$condition_name_A"".diff.events" "$condition_name_N" "$condition_name_N"";""$condition_name_A" true | grep -v "#" | awk '$3<-6.64{print $1"\t"$2}' | grep "Infinity" > tmp

perl ~/group/projects/es/iAscl1_iNgn2/utils/extract_from_multiGPS.pl "$multi_out"/"$outbase".all.events.table "$multi_out"/"$outbase""_""$condition_name_N""_gt_""$condition_name_A"".diff.events" "$condition_name_N" "$condition_name_N"";""$condition_name_A" true | grep -v "#" | awk '$3<-6.64{print $1"\t"$2}' | grep -v "Infinity" | sort -k2 -n >> tmp

mv tmp "$facN""_gt_""$facA"".peaks"


cat "$facA""_gt_""$facN"".peaks" "$facN""_gt_""$facA"".peaks" | cut -f1 > t

awk 'NR==FNR{$A[$1];next}!($1 in A){print $0}' t "$multi_out"/"$outbase""_""$condition_name_A".events > "$facN""_shared_""$facA"".peaks"

awk 'NR==FNR{$A[$1];next}!($1 in A){print $0}' t "$multi_out"/"$outbase""_""$condition_name_N".events >> "$facN""_shared_""$facA"".peaks"

grep -v "#" "$facN""_shared_""$facA"".peaks" | cut -f1 | sort | uniq -c | sed 's/^\s\s*//' | sed 's/\s\s*/\t/' | awk '$1==2{print $0}' | cut -f2 > t

mv t "$facN""_shared_""$facA"".peaks"

perl ~/group/projects/es/iAscl1_iNgn2/utils/extract_from_multiGPS.pl "$multi_out"/"$outbase".all.events.table "$facN""_shared_""$facA"".peaks"  "$condition_name_N" "$condition_name_N"";""$condition_name_A" true | grep -v "#" | cut -f1,2 | grep "Infinity" > tmp

perl ~/group/projects/es/iAscl1_iNgn2/utils/extract_from_multiGPS.pl "$multi_out"/"$outbase".all.events.table "$facN""_shared_""$facA"".peaks"  "$condition_name_N" "$condition_name_N"";""$condition_name_A" true | grep -v "#" | cut -f1,2 | grep -v "Infinity" | sort -k2 -n >> tmp

mv tmp "$facN""_shared_""$facA"".peaks"
