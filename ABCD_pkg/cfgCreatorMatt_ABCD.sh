#!/bin/bash

#XSFile="noformat_8TeV.txt"
XSFile="noformat_8TeV_leplep.txt"

#XSFile="noformat_7TeV_v2_no456mult.txt"
TEMPLATE="./Templates/"
TEMPLATE_SIG="./Templates/sig/"
TEMPLATE_BKG="./Templates/bkg/"
THEOPTION_="1"
# options 0: default errors
# options 1: no cross section errors
# options 2: errors up
# options 3: errors do

# filename errorupbbb errordobb crosssecbb  errorupgg errordogg crosssecgg mA OPTION
# OPTION = 0 normal; 1 NO ERR
function sedAndCat() {
    if [ "${9}" == "0"  ]; then
	sed -e "s/OverallSys Name=\"XS_bbA\".*$/OverallSys Name=\"XS_bbA\" High=\"${2}\" Low=\"${3}\" \/>/" -e "s/OverallSys Name=\"XS_ggA\".*$/OverallSys Name=\"XS_ggA\" High=\"${5}\" Low=\"${6}\" \/>/" -e "s/NormFactor Name=\"mbbAll${8}\".*$/NormFactor Name=\"mbbAll${8}\"  Val=\"${4}\" Low=\"${4}\" High=\"${4}\" \/>/" -e "s/NormFactor Name=\"mggAll${8}\".*$/NormFactor Name=\"mggAll${8}\"  Val=\"${7}\" Low=\"${7}\" High=\"${7}\" \/>/" ${1}
    else
	sed -e "/OverallSys Name=\"XS_bbA/d" -e "/OverallSys Name=\"XS_ggA/d" -e "s/NormFactor Name=\"mbbAll${8}\".*$/NormFactor Name=\"mbbAll${8}\"  Val=\"${4}\" Low=\"${4}\" High=\"${4}\" \/>/" -e "s/NormFactor Name=\"mggAll${8}\".*$/NormFactor Name=\"mggAll${8}\"  Val=\"${7}\" Low=\"${7}\" High=\"${7}\" \/>/" ${1}
    fi
    #echo "s/NormFactor Name=\"mggAll${8}\".*$/NormFactor Name=\"mggAll${8}\"  Val=\"${7}\" Low=\"${7}\" High=\"${7}\" \/>/"
}


## input mA tb bb/gg OPTION
## OPTION: 0 default; 1 no err; 2 xs up; 3 xs down
function makeMSSMPoint() {
    theline=`grep "^${2} ${1}" ${XSFile}`
    #echo "$theline"

    mass1="$1"
    mass2=`echo $theline | awk '{print $9}'`
    mass3=`echo $theline | awk '{print $17}'`


    bbxs1=`echo $theline | awk '{print $3}'`
    bber1up=`echo $theline | awk '{print $4}'`
    bber1do=`echo $theline | awk '{print $5}'`
    
    bbxs2=`echo $theline | awk '{print $11}'`
    bber2up=`echo $theline | awk '{print $12}'`
    bber2do=`echo $theline | awk '{print $13}'`
    
    bbxs3=`echo $theline | awk '{print $19}'`
    bber3up=`echo $theline | awk '{print $20}'`
    bber3do=`echo $theline | awk '{print $21}'`

    ggxs1=`echo $theline | awk '{print $6}'`
    gger1up=`echo $theline | awk '{print $7}'`
    gger1do=`echo $theline | awk '{print $8}'`
    
    ggxs2=`echo $theline | awk '{print $14}'`
    gger2up=`echo $theline | awk '{print $15}'`
    gger2do=`echo $theline | awk '{print $16}'`
    
    ggxs3=`echo $theline | awk '{print $22}'`
    gger3up=`echo $theline | awk '{print $23}'`
    gger3do=`echo $theline | awk '{print $24}'`

    ## recalculate the central value if needed
    if [ "$5" == "2"  ]; then # up scaled cross sections
	bbxs1=`echo "scale=9; ${bbxs1}*${bber1up}" | bc`
	bbxs2=`echo "scale=9; ${bbxs2}*${bber2up}" | bc`
	bbxs3=`echo "scale=9; ${bbxs3}*${bber3up}" | bc`
	ggxs1=`echo "scale=9; ${ggxs1}*${gger1up}" | bc`
	ggxs2=`echo "scale=9; ${ggxs2}*${gger2up}" | bc`
	ggxs3=`echo "scale=9; ${ggxs3}*${gger3up}" | bc`
    elif [ "$5" == "3"  ]; then # down scaled cross sections
	bbxs1=`echo "scale=9; ${bbxs1}*${bber1do}" | bc`
	bbxs2=`echo "scale=9; ${bbxs2}*${bber2do}" | bc`
	bbxs3=`echo "scale=9; ${bbxs3}*${bber3do}" | bc`
	ggxs1=`echo "scale=9; ${ggxs1}*${gger1do}" | bc`
	ggxs2=`echo "scale=9; ${ggxs2}*${gger2do}" | bc`
	ggxs3=`echo "scale=9; ${ggxs3}*${gger3do}" | bc`
    fi
    # check whether you need to merge 2 masses
    MERGE="no"
    if [ "$mass1" == "$mass2"  ] && [ "$mass1" == "$mass3"  ]; then
	MERGE="yes123"

	bbxs1=`echo "scale=12;   ${bbxs1}+${bbxs2}+${bbxs3}" | bc`
	bber1up=`echo "scale=12;(${bbxs1}*${bber1up}+${bbxs2}*${bber2up}+${bbxs3}*${bber3up})/(${bbxs1}+${bbxs2}+${bbxs3})" | bc`
	bber1do=`echo "scale=12;(${bbxs1}*${bber1do}+${bbxs2}*${bber2do}+${bbxs3}*${bber3do})/(${bbxs1}+${bbxs2}+${bbxs3})" | bc`

	ggxs1=`echo "scale=12;   ${ggxs1}+${ggxs2}+${ggxs3}" | bc`
	gger1up=`echo "scale=12;(${ggxs1}*${gger1up}+${ggxs2}*${gger2up}+${ggxs3}*${gger3up})/(${ggxs1}+${ggxs2}+${ggxs3})" | bc`
	gger1do=`echo "scale=12;(${ggxs1}*${gger1do}+${ggxs2}*${gger2do}+${ggxs3}*${gger3do})/(${ggxs1}+${ggxs2}+${ggxs3})" | bc`


    elif [ "$mass1" == "$mass2"  ]; then
	MERGE="yes12"

	bbxs1=`echo "scale=12;${bbxs1}+${bbxs2}" | bc`
	bber1up=`echo "scale=12;(${bbxs1}*${bber1up}+${bbxs2}*${bber2up})/(${bbxs1}+${bbxs2})" | bc`
	bber1do=`echo "scale=12;(${bbxs1}*${bber1do}+${bbxs2}*${bber2do})/(${bbxs1}+${bbxs2})" | bc`

	ggxs1=`echo "scale=12;${ggxs1}+${ggxs2}" | bc`
	gger1up=`echo "scale=12;(${ggxs1}*${gger1up}+${ggxs2}*${gger2up})/(${ggxs1}+${ggxs2})" | bc`
	gger1do=`echo "scale=12;(${ggxs1}*${gger1do}+${ggxs2}*${gger2do})/(${ggxs1}+${ggxs2})" | bc`

    elif [ "$mass1" == "$mass3"  ]; then
	MERGE="yes13"

	bbxs1=`echo "scale=12;${bbxs1}+${bbxs3}" | bc`
	bber1up=`echo "scale=12;(${bbxs1}*${bber1up}+${bbxs3}*${bber3up})/(${bbxs1}+${bbxs3})" | bc`
	bber1do=`echo "scale=12;(${bbxs1}*${bber1do}+${bbxs3}*${bber3do})/(${bbxs1}+${bbxs3})" | bc`

	ggxs1=`echo "scale=12;${ggxs1}+${ggxs3}" | bc`
	gger1up=`echo "scale=12;(${ggxs1}*${gger1up}+${ggxs3}*${gger3up})/(${ggxs1}+${ggxs3})" | bc`
	gger1do=`echo "scale=12;(${ggxs1}*${gger1do}+${ggxs3}*${gger3do})/(${ggxs1}+${ggxs3})" | bc`

    elif [ "$mass2" == "$mass3"  ]; then
	MERGE="yes23"

	bbxs2=`echo "scale=12;${bbxs2}+${bbxs3}" | bc`
	bber2up=`echo "scale=12;(${bbxs2}*${bber2up}+${bbxs3}*${bber3up})/(${bbxs1}+${bbxs3})" | bc`
	bber2do=`echo "scale=12;(${bbxs2}*${bber2do}+${bbxs3}*${bber3do})/(${bbxs1}+${bbxs3})" | bc`

	ggxs2=`echo "scale=12;${ggxs2}+${ggxs3}" | bc`
	gger2up=`echo "scale=12;(${ggxs2}*${gger2up}+${ggxs3}*${gger3up})/(${ggxs1}+${ggxs3})" | bc`
	gger2do=`echo "scale=12;(${ggxs2}*${gger2do}+${ggxs3}*${gger3do})/(${ggxs1}+${ggxs3})" | bc`

    fi

    filename1="${TEMPLATE_SIG}/sig${3}_mA${mass1}_${4}_xml.txt"
    filename2="${TEMPLATE_SIG}/sig${3}_mA${mass2}_${4}_xml.txt"
    filename3="${TEMPLATE_SIG}/sig${3}_mA${mass3}_${4}_xml.txt"
    #echo $filename1
    #echo $mass1 " --- " $3 "  ----  " $4
    if [ "${MERGE}" == "yes123" ]; then
	sedAndCat $filename1 $bber1up $bber1do $bbxs1 $gger1up $gger1do $ggxs1  $mass1 $5
	
    elif [ "${MERGE}" == "yes12" ]; then
	sedAndCat $filename1 $bber1up $bber1do $bbxs1 $gger1up $gger1do $ggxs1  $mass1 $5
	sedAndCat $filename3 $bber3up $bber3do $bbxs3 $gger3up $gger3do $ggxs3  $mass3 $5
	
    elif [ "${MERGE}" == "yes13" ]; then
	sedAndCat $filename1 $bber1up $bber1do $bbxs1 $gger1up $gger1do $ggxs1  $mass1 $5
	sedAndCat $filename2 $bber2up $bber2do $bbxs2 $gger2up $gger2do $ggxs2  $mass2 $5
	
    elif [ "${MERGE}" == "yes23" ]; then
	sedAndCat $filename1 $bber1up $bber1do $bbxs1 $gger1up $gger1do $ggxs1  $mass1 $5
	sedAndCat $filename2 $bber2up $bber2do $bbxs2 $gger2up $gger2do $ggxs2  $mass2 $5
    else
	#echo "TEST the inputs: $filename1 $bber1up $bber1do $bbxs1 $gger1up $gger1do $ggxs1  $mass1"
	sedAndCat $filename1 $bber1up $bber1do $bbxs1 $gger1up $gger1do $ggxs1  $mass1 $5
	sedAndCat $filename2 $bber2up $bber2do $bbxs2 $gger2up $gger2do $ggxs2  $mass2 $5
	sedAndCat $filename3 $bber3up $bber3do $bbxs3 $gger3up $gger3do $ggxs3  $mass3 $5
    fi
    
    
}

function makeCrossSectionFile() {

    if [ "${3}" == "lephad" ]; then
	FSTATE_LABEL="LH"
    elif [ "${3}" == "leplep" ]; then
	FSTATE_LABEL="LL"
    fi
    
    echo "<!DOCTYPE Channel  SYSTEM 'HistFactorySchema.dtd'>" > ${5}
    echo "<Channel Name=\"${3}_${2}\" InputFile=\"./data/${4}\" >" >> ${5}
    echo ' '  >> ${5}
    echo '  <Data HistoName="'"${8}"'" HistoPath="" />' >> ${5}
    echo '  <StatErrorConfig RelErrorThreshold="0.05" ConstraintType="Poisson" />' >> ${5}
    echo '<!-- background list -->'  >> ${5}
    cat ${1} >> ${5}
    echo '<!-- signal list using mA '" $6  "' -->'  >> ${5}
    if [ "${7}" == "bbA"  ]; then
	# keep bbA files
	sed -n  "/<Sample Name=\"ATLAS_Sig_${FSTATE_LABEL}_bbA/,/<\/Sample>/p"  "${TEMPLATE_SIG}/sig_mA${6}_${2}_xml.txt" >> ${5}
    else
	# keep ggA files
	sed -n  "/<Sample Name=\"ATLAS_Sig_${FSTATE_LABEL}_ggA/,/<\/Sample>/p"  "${TEMPLATE_SIG}/sig_mA${6}_${2}_xml.txt" >> ${5}
    fi
    echo '</Channel>'  >> ${5}
    # remove the cross section normalization
    if [ "${3}" == "lephad" ]; then
	sed -i '/NormFactor Name="mbbAlh/d' ${5}
	sed -i '/NormFactor Name="mggAlh/d' ${5}
    elif [ "${3}" == "leplep" ]; then
	sed -i '/NormFactor Name="mbbAll/d' ${5}
	sed -i '/NormFactor Name="mggAll/d' ${5}
    fi
    # remove the cross section error
    sed -i '/\"XS_ggA\"/d' ${5}
    sed -i '/\"XS_bbA\"/d' ${5}
    # change the names of the signal histos - i.e. not to be weighted by the cross section
    sed -i 's/ATLAS_Sig_${FSTATE_LABEL}_ggA/ATLAS_Sig_{FSTATE_LABEL}_XSec_ggA/g' ${5}
    sed -i 's/ATLAS_Sig_${FSTATE_LABEL}_bbA/ATLAS_Sig_{FSTATE_LABEL}_XSec_bbA/g' ${5}
}

function makeCfgFile() {
    echo "<!DOCTYPE Channel  SYSTEM 'HistFactorySchema.dtd'>" > ${5}
    echo "<Channel Name=\"${3}\" InputFile=\"./data/${4}\" >" >> ${5}
    echo ' '  >> ${5}
    echo '  <Data HistoName="'"${8}"'" HistoPath="" />' >> ${5}
    echo '  <StatErrorConfig RelErrorThreshold="0.05" ConstraintType="Poisson" />' >> ${5}
    echo '<!-- background list -->'  >> ${5}
    cat ${1} >> ${5}
    echo '<!-- signal list using mA/tanB '" $6 / $7 "' -->'  >> ${5}
#    echo " $2 --- $3 --- $4 --- $5 --- $6 ---  $7  ---  $9 ---  $10  --- $11" 
    makeMSSMPoint "$6" "$7" "$9" "$2" ${THEOPTION_}  >> ${5}
    echo '</Channel>'  >> ${5}
}

function makeTopCfgFile() {
    matbTag=$1
    topFileName=$2
    theHead=$3
    shift
    shift
    shift
    echo "<!DOCTYPE Combination  SYSTEM 'HistFactorySchema.dtd'>"             > $topFileName
    echo "<Combination OutputFilePrefix=\"./results/${theHead}_${matbTag}_comb\" >" >> $topFileName

    #---- add ABCD CR ---
    echo "  <Input>region_b_${theHead}.xml</Input>" >> $topFileName
    echo "  <Input>region_c_${theHead}.xml</Input>" >> $topFileName
    echo "  <Input>region_d_${theHead}.xml</Input>" >> $topFileName
    #-------------------

    # add the files now
    for i in ${@}; do
	echo "  <Input>${i}</Input>"          >> $topFileName
    done

    cat ${TEMPLATE}/top_template_xml.txt      >> $topFileName

}
#
#
#

#fstate="lephad"
fstate="leplep"

#tanb_list=("05" "08")
#mass_list=("090" "100")
#tanb_list=("05" "08"  "10" "13" "16" "20" "23" "26" "30" "35" "40" "45" "50" "55" "60")
#mass_list=("090" "100" "110" "120" "130" "140" "150" "170" "200" "250" "300" "350" "400" "450" "500")

tanb_list=("05" "08"  "10" "13" "16" "20" "23" "26" "30" "35" "40" "45" "50" "55" "60")
mass_list=("090" "100" "110" "120" "125" "130" "140" "150" "170" "200" "250" "300" "350" "400")

outFolder=

function runChannel() {

#    tanb_list=("05" "08"  "10" "13" "16" "20" "23" "26" "30" "35" "40" "45" "50" "55" "60")
#    mass_list=("090" "100" "110" "120" "130" "140" "150" "170" "200" "250" "300" "350" "400" "450" "500")

#    channel_list=("bveto_el" "bveto_mu" "btag_el" "bveto_mu")
    channel=$1
    ROOTFILE="${fstate}_${channel}.root"
#    ROOTFILE=`echo $ROOTFILE | sed -e 's/Numerator_//' -e 's/Denominator_//'`
    ROOTFILE=`echo $ROOTFILE | sed -e 's/_num_/_/' -e 's/_den_/_/'`
    DATAHISTO="$2"
    if [ "${DATAHISTO}" == ""   ]; then
	DATAHISTO="ATLAS_data_LL"	
    fi
    echo ">>> Running Channel: $channel"
#    outFolder="mAtb_Xmls_${THEOPTION_}"
    if [ ! -d $outFolder  ]; then 
	mkdir $outFolder
    fi

    INBKG="${TEMPLATE_BKG}/bkg_${channel}_xml.txt"
    for mass in ${mass_list[@]}; do
	echo "                     mass=$mass"
	INSIG="${TEMPLATE_SIG}/sig_mA${mass}_${channel}_xml.txt"
	OUTXSbb="${outFolder}/${fstate}_${channel}_mA${mass}_bbA.xml"
	OUTXSgg="${outFolder}/${fstate}_${channel}_mA${mass}_ggA.xml"
	if [ "${THEOPTION_}" == "1"  ]; then
	    makeCrossSectionFile "${INBKG}" "${channel}" "${fstate}" "${ROOTFILE}" "${OUTXSbb}" "$mass" "bbA" "${DATAHISTO}"
	    makeCrossSectionFile "${INBKG}" "${channel}" "${fstate}" "${ROOTFILE}" "${OUTXSgg}" "$mass" "ggA" "${DATAHISTO}"
	fi
	for tanb in ${tanb_list[@]}; do
	    echo "Creating tanb=$tanb"
	    OUT="${outFolder}/${fstate}_${channel}_mA${mass}tb${tanb}.xml"
	    makeCfgFile "${INBKG}" "${channel}" "${fstate}_${channel}" "${ROOTFILE}" "${OUT}" "$mass" "$tanb" "${DATAHISTO}"  ""  	    
	done
    done

}

function sumUpChannels() {
    theHead=$1
    shift
    for mass in ${mass_list[@]}; do
	for tanb in ${tanb_list[@]}; do
	    theTag="mA${mass}tb${tanb}"
	    theList=()
	    cd $outFolder/
	    for i in ${@}; do
		theList1=(`ls ${i}_${theTag}.xml`)
		theList+=(${theList1[@]})
	    done
	    cd ../
	    echo ${theList[@]}
	    makeTopCfgFile ${theTag} "$outFolder/top_${theHead}_${theTag}.xml" "${theHead}"  ${theList[@]}
	done
	if [ "${THEOPTION_}" == "1"  ]; then
	    theTag="mA${mass}_bbA"
	    theList=()
	    cd $outFolder/
	    for i in ${@}; do
		theList1=(`ls ${i}_${theTag}.xml`)
		theList+=(${theList1[@]})
	    done
	    cd ../
	    echo ${theList[@]}
	    theTag1="mA${mass}tb00_bbA"
	    makeTopCfgFile ${theTag1} "$outFolder/top_${theHead}_${theTag}.xml" "${theHead}"  ${theList[@]}
	    ######
	    theTag="mA${mass}_ggA"
	    theList=()
	    cd $outFolder/
	    for i in ${@}; do
		theList1=(`ls ${i}_${theTag}.xml`)
		theList+=(${theList1[@]})
	    done
	    cd ../
	    echo ${theList[@]}
	    theTag1="mA${mass}tb00_ggA"
	    makeTopCfgFile ${theTag1} "$outFolder/top_${theHead}_${theTag}.xml" "${theHead}"  ${theList[@]}
	fi
    done


}

function runChannelSet() {
    runChannel ${1}
    runChannel "Numerator_${1}"
    runChannel "Denominator_${1}"
    sumUpChannels  ${1}  ${1}  "Numerator_${1}"  "Denominator_${1}"
}

function runWithoutCR() {
    echo "Will run jobs without CR"
    # run the channels
    runChannel "veto_el" >& tt1 &
    runChannel "veto_mu" >& tt2 &
    runChannel "tag_el"  >& tt3 &
    runChannel "tag_mu"  >& tt4 &
    wait
    runChannel "high_el" >& tt5 &
    runChannel "high_mu" >& tt6 &
    wait
    sumUpChannels "${fstate}_high_el"  "${fstate}_high_el" >& tt1 &
    sumUpChannels "${fstate}_high_mu"  "${fstate}_high_mu" >& tt2 &
    sumUpChannels "${fstate}_veto_el"  "${fstate}_veto_el" >& tt3 &
    sumUpChannels "${fstate}_veto_mu"  "${fstate}_veto_mu" >& tt4 &
    wait
    sumUpChannels "${fstate}_tag_el"  "${fstate}_tag_el" >& tt1 &
    sumUpChannels "${fstate}_tag_mu"  "${fstate}_tag_mu" >& tt2 &
    sumUpChannels "${fstate}_low_el"  "${fstate}_tag_el"   "${fstate}_veto_el" >& tt3 &
    sumUpChannels "${fstate}_low_mu"  "${fstate}_tag_mu"   "${fstate}_veto_mu" >& tt4 &
    wait
    sumUpChannels "${fstate}_high"  "${fstate}_high_el" "${fstate}_high_mu"  >& tt1 &
    sumUpChannels "${fstate}_veto"  "${fstate}_veto_el" "${fstate}_veto_mu"  >& tt2 &
    sumUpChannels "${fstate}_tag"  "${fstate}_tag_el" "${fstate}_tag_mu"     >& tt3 &
    sumUpChannels "${fstate}_low"  "${fstate}_tag_el" "${fstate}_tag_mu"  "${fstate}_veto_el" "${fstate}_veto_mu" >& tt4 &
    wait
}

function runWithoutCR_LL() {
    echo "Will run jobs without CR (LL final state)"
    # run the channels
    runChannel "veto_emu" "ATLAS_data_LL" >& tt1 &
    runChannel "tag_emu"  "ATLAS_data_LL" >& tt2 &
    wait
    sumUpChannels "${fstate}_veto_emu"  "${fstate}_veto_emu" >& tt3 &
    wait
    sumUpChannels "${fstate}_tag_emu"  "${fstate}_tag_emu" >& tt4 &
    wait
    sumUpChannels "${fstate}_veto" "${fstate}_veto_emu"  >& tt5 &
    sumUpChannels "${fstate}_tag"  "${fstate}_tag_emu"     >& tt6 &
    wait
}

function runWithCR() {
    echo "Will run jobs with CR"
    runChannel "veto_el" >& tt1 &
    runChannel "num_veto_el" "ATLAS_Bkg_LH_qcd_data_cB" >& tt1a &
    runChannel "den_veto_el" "ATLAS_Bkg_LH_qcd_data_cD" >& tt1b &
    runChannel "veto_mu" >& tt2 &
    runChannel "num_veto_mu" "ATLAS_Bkg_LH_qcd_data_cB" >& tt2a &
    runChannel "den_veto_mu" "ATLAS_Bkg_LH_qcd_data_cD" >& tt2b &
    wait
    runChannel "tag_el"  >& tt3 &
    runChannel "num_tag_el" "ATLAS_Bkg_LH_qcd_data_cB"  >& tt3a &
    runChannel "den_tag_el" "ATLAS_Bkg_LH_qcd_data_cD"  >& tt3b &
    runChannel "tag_mu"  >& tt4 &
    runChannel "num_tag_mu" "ATLAS_Bkg_LH_qcd_data_cB"  >& tt4a &
    runChannel "den_tag_mu" "ATLAS_Bkg_LH_qcd_data_cD"  >& tt4b &
    wait
    runChannel "high_el" >& tt5 &
    runChannel "num_high_el" "ATLAS_Bkg_LH_qcd_data_cB" >& tt5a &
    runChannel "den_high_el" "ATLAS_Bkg_LH_qcd_data_cD" >& tt5b &
    runChannel "high_mu" >& tt6 &
    runChannel "num_high_mu" "ATLAS_Bkg_LH_qcd_data_cB" >& tt6a &
    runChannel "den_high_mu" "ATLAS_Bkg_LH_qcd_data_cD" >& tt6b &
    wait
    list_high_el=("${fstate}_high_el" "${fstate}_num_high_el" "${fstate}_den_high_el")
    list_high_mu=("${fstate}_high_mu" "${fstate}_num_high_mu" "${fstate}_den_high_mu")
    list_veto_el=("${fstate}_veto_el" "${fstate}_num_veto_el" "${fstate}_den_veto_el")
    list_veto_mu=("${fstate}_veto_mu" "${fstate}_num_veto_mu" "${fstate}_den_veto_mu")
    list_tag_el=("${fstate}_tag_el" "${fstate}_num_tag_el" "${fstate}_den_tag_el")
    list_tag_mu=("${fstate}_tag_mu" "${fstate}_num_tag_mu" "${fstate}_den_tag_mu")

    sumUpChannels "${fstate}_high_el"  ${list_high_el[@]} >& tt1 &
    sumUpChannels "${fstate}_high_mu"  ${list_high_mu[@]} >& tt2 &
    sumUpChannels "${fstate}_veto_el"  ${list_veto_el[@]} >& tt3 &
    sumUpChannels "${fstate}_veto_mu"  ${list_veto_mu[@]} >& tt4 &
    wait
    sumUpChannels "${fstate}_tag_el"  ${list_tag_el[@]} >& tt1 &
    sumUpChannels "${fstate}_tag_mu"  ${list_tag_mu[@]} >& tt2 &
    sumUpChannels "${fstate}_low_el"  ${list_veto_el[@]} ${list_tag_el[@]} >& tt3 &
    sumUpChannels "${fstate}_low_mu"  ${list_veto_mu[@]} ${list_tag_mu[@]} >& tt4 &
    wait
    sumUpChannels "${fstate}_high" ${list_high_el[@]} ${list_high_mu[@]}   >& tt1 &
    sumUpChannels "${fstate}_veto" ${list_veto_el[@]} ${list_veto_mu[@]}   >& tt2 &
    sumUpChannels "${fstate}_tag"  ${list_tag_el[@]}  ${${fstate}_tag_mu[@]}  >& tt3 &
    sumUpChannels "${fstate}_low"  ${list_tag_el[@]}  ${list_tag_mu[@]}   ${list_veto_el[@]} ${list_veto_mu[@]} >& tt4 &
    wait
}

# options: 1: no errors
#          2: errors up
#          3: errors down

#if [ ${#} -ge 3  ]; then
#    THEOPTION_="$2"
#    echo "Running with option ${THEOPTION_}"
#    runChannel $1
#else
THEOPTION_="$1"
echo "Running with option ${THEOPTION_}"
outFolder="mAtb_Xmls_${THEOPTION_}"
xsFolder="XSection"

if [ ${#} -eq 5  ]; then
    TEMPLATE="${2}/"
    TEMPLATE_SIG="${2}/sig/"
    TEMPLATE_BKG="${2}/bkg/"
    outFolder="mAtb_Xmls_${THEOPTION_}_${3}"
    xsFolder="XSection_${3}"

    echo "Will take arguments from command line: $TEMPLATE $outFolder"
    if [ "${4}" == "cr" ]; then
	if [ "${5}" == "LL" ]; then
	    runWithCR_LL
	elif [ "${5}" == "LH" ]; then
	    runWithCR
	fi
    else
	if [ "${5}" == "LL" ]; then
	    runWithoutCR_LL
	elif [ "${5}" == "LH" ]; then
	    runWithoutCR
	fi
    fi
else
    runWithoutCR
fi

    # check to see whether there is a XS folder
if [ "$THEOPTION_" == "1" ]; then
    if [ -d ${xsFolder} ]; then
	rm -rf ${xsFolder}
    fi
    mkdir ${xsFolder}
    cp ${outFolder}/${fstate}_*{bbA,ggA}.xml ${xsFolder}
    cp ${outFolder}/top_${fstate}_*{bbA,ggA}.xml ${xsFolder}
fi

exit

#    runChannel "bveto_el"
#    runChannel "Numerator_bveto_el"
#    runChannel "Denominator_bveto_el"
#    sumUpChannels "lephad_bveto_el"  "lephad_bveto_el" "lephad_Numerator_bveto_el" "lephad_Denominator_bveto_el"

    runChannelSet "bveto_el" >& tt1 &
    runChannelSet "bveto_mu" >& tt2 &
    runChannelSet "btag_el" >& tt3 &
    runChannelSet "btag_mu" >& tt4 &
    wait
#    runChannel "bveto_mu"
#    runChannel "Numerator_bveto_mu"
#    runChannel "Denominator_bveto_mu"
#    sumUpChannels  "lephad_bveto_mu"  "lephad_bveto_mu" "lephad_Numerator_bveto_mu" "lephad_Denominator_bveto_mu"

    sumUpChannels  "${fstate}_bveto"  "${fstate}_bveto_mu" "${fstate}_Numerator_bveto_mu" "${fstate}_Denominator_bveto_mu"   "${fstate}_bveto_el" "${fstate}_Numerator_bveto_el" "${fstate}_Denominator_bveto_el"

#    runChannel "btag_el"
#    runChannel "Numerator_btag_el"
#    runChannel "Denominator_btag_el"
#    sumUpChannels "lephad_btag_el"  "lephad_btag_el" "lephad_Numerator_btag_el" "lephad_Denominator_btag_el"

#    runChannel "btag_mu"
#    runChannel "Numerator_btag_mu"
#    runChannel "Denominator_btag_mu"
#    sumUpChannels "lephad_btag_mu"  "lephad_btag_mu" "lephad_Numerator_btag_mu" "lephad_Denominator_btag_mu"

    sumUpChannels  "${fstate}_btag"  "${fstate}_btag_mu" "${fstate}_Numerator_btag_mu" "${fstate}_Denominator_btag_mu"   "${fstate}_btag_el" "${fstate}_Numerator_btag_el" "${fstate}_Denominator_btag_el"

    sumUpChannels "${fstate}"  "${fstate}_btag_mu" "${fstate}_Numerator_btag_mu" "${fstate}_Denominator_btag_mu"   "${fstate}_btag_el" "${fstate}_Numerator_btag_el" "${fstate}_Denominator_btag_el" "${fstate}_bveto_mu" "${fstate}_Numerator_bveto_mu" "${fstate}_Denominator_bveto_mu"   "${fstate}_bveto_el" "${fstate}_Numerator_bveto_el" "${fstate}_Denominator_bveto_el"


fi


exit
