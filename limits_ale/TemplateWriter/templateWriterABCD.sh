#!/bin/bash

#INFILE="systFormat.txt"
INFILE=$3
FOLDER="./Templates/"

# inputs: mass, channel
function SignalTemplateCreation() {

    MASS="$1"
    CHANNEL="$2"
    FSTATE="LL"
#    FSTATE="LH"

    echo "SignalTemplateCreation : $MASS $CHANNEL $FSTATE"

    output="${FOLDER}/sig/sig_mA${MASS}_${CHANNEL}_xml.txt"
    theSigNameBB="ATLAS_Sig_${FSTATE}_bbA${MASS}"
    theSigNameGG="ATLAS_Sig_${FSTATE}_ggA${MASS}"
    list_bb_n_names=(`grep "${theSigNameBB} ${CHANNEL} n" $INFILE |  awk '{print $4}'`)
    list_bb_n_high=(`grep  "${theSigNameBB} ${CHANNEL} n" $INFILE |  awk '{print $5}'`)
    list_bb_n_low=(`grep   "${theSigNameBB} ${CHANNEL} n" $INFILE |  awk '{print $6}'`)

    list_bb_h_names=(`grep "${theSigNameBB} ${CHANNEL} h" $INFILE |  awk '{print $4}'`)
    list_bb_h_high=(`grep  "${theSigNameBB} ${CHANNEL} h" $INFILE |  awk '{print $5}'`)
    list_bb_h_low=(`grep   "${theSigNameBB} ${CHANNEL} h" $INFILE |  awk '{print $6}'`)

    list_gg_n_names=(`grep "${theSigNameGG} ${CHANNEL} n" $INFILE |  awk '{print $4}'`)
    list_gg_n_high=(`grep  "${theSigNameGG} ${CHANNEL} n" $INFILE |  awk '{print $5}'`)
    list_gg_n_low=(`grep   "${theSigNameGG} ${CHANNEL} n" $INFILE |  awk '{print $6}'`)

    list_gg_h_names=(`grep "${theSigNameGG} ${CHANNEL} h" $INFILE |  awk '{print $4}'`)
    list_gg_h_high=(`grep  "${theSigNameGG} ${CHANNEL} h" $INFILE |  awk '{print $5}'`)
    list_gg_h_low=(`grep   "${theSigNameGG} ${CHANNEL} h" $INFILE |  awk '{print $6}'`)

    # if all of them are empty, try for control regions
    if [ "${#list_bb_n_names}" -eq 0 ] && [ "${#list_bb_h_names}" -eq 0 ] && [ "${#list_gg_n_names}" -eq 0  ] && [  "${#list_gg_h_names}" -eq 0 ]; then
	# try the B region
	theSigNameBB="ATLAS_Sig_${FSTATE}_bbA${MASS}_cB"
	theSigNameGG="ATLAS_Sig_${FSTATE}_ggA${MASS}_cB" 
	list_bb_n_names=(`grep "${theSigNameBB} ${CHANNEL} n" $INFILE |  awk '{print $4}'`)
	list_bb_n_high=(`grep  "${theSigNameBB} ${CHANNEL} n" $INFILE |  awk '{print $5}'`)
	list_bb_n_low=(`grep   "${theSigNameBB} ${CHANNEL} n" $INFILE |  awk '{print $6}'`)
	
	list_bb_h_names=(`grep "${theSigNameBB} ${CHANNEL} h" $INFILE |  awk '{print $4}'`)
	list_bb_h_high=(`grep  "${theSigNameBB} ${CHANNEL} h" $INFILE |  awk '{print $5}'`)
	list_bb_h_low=(`grep   "${theSigNameBB} ${CHANNEL} h" $INFILE |  awk '{print $6}'`)
	
	list_gg_n_names=(`grep "${theSigNameGG} ${CHANNEL} n" $INFILE |  awk '{print $4}'`)
	list_gg_n_high=(`grep  "${theSigNameGG} ${CHANNEL} n" $INFILE |  awk '{print $5}'`)
	list_gg_n_low=(`grep   "${theSigNameGG} ${CHANNEL} n" $INFILE |  awk '{print $6}'`)
	
	list_gg_h_names=(`grep "${theSigNameGG} ${CHANNEL} h" $INFILE |  awk '{print $4}'`)
	list_gg_h_high=(`grep  "${theSigNameGG} ${CHANNEL} h" $INFILE |  awk '{print $5}'`)
	list_gg_h_low=(`grep   "${theSigNameGG} ${CHANNEL} h" $INFILE |  awk '{print $6}'`)
    fi
    if [ ${#list_bb_n_names} -eq 0 ] && [ ${#list_bb_h_names} -eq 0 ] && [ ${#list_gg_n_names} -eq 0  ] && [  ${#list_gg_h_names} -eq 0 ]; then
	# try the D region
	theSigNameBB="ATLAS_Sig_${FSTATE}_bbA${MASS}_cD"
	theSigNameGG="ATLAS_Sig_${FSTATE}_ggA${MASS}_cD"
	list_bb_n_names=(`grep "${theSigNameBB} ${CHANNEL} n" $INFILE |  awk '{print $4}'`)
	list_bb_n_high=(`grep  "${theSigNameBB} ${CHANNEL} n" $INFILE |  awk '{print $5}'`)
	list_bb_n_low=(`grep   "${theSigNameBB} ${CHANNEL} n" $INFILE |  awk '{print $6}'`)
	
	list_bb_h_names=(`grep "${theSigNameBB} ${CHANNEL} h" $INFILE |  awk '{print $4}'`)
	list_bb_h_high=(`grep  "${theSigNameBB} ${CHANNEL} h" $INFILE |  awk '{print $5}'`)
	list_bb_h_low=(`grep   "${theSigNameBB} ${CHANNEL} h" $INFILE |  awk '{print $6}'`)
	
	list_gg_n_names=(`grep "${theSigNameGG} ${CHANNEL} n" $INFILE |  awk '{print $4}'`)
	list_gg_n_high=(`grep  "${theSigNameGG} ${CHANNEL} n" $INFILE |  awk '{print $5}'`)
	list_gg_n_low=(`grep   "${theSigNameGG} ${CHANNEL} n" $INFILE |  awk '{print $6}'`)
	
	list_gg_h_names=(`grep "${theSigNameGG} ${CHANNEL} h" $INFILE |  awk '{print $4}'`)
	list_gg_h_high=(`grep  "${theSigNameGG} ${CHANNEL} h" $INFILE |  awk '{print $5}'`)
	list_gg_h_low=(`grep   "${theSigNameGG} ${CHANNEL} h" $INFILE |  awk '{print $6}'`)
    fi

    #
    #
    # start writing the file
    # bbA sample
    if [ ${#list_bb_n_names} -ge 1 ] || [ ${#list_bb_h_names} -ge 1 ]; then

	echo "<Sample Name=\"${theSigNameBB}\"  HistoPath=\"\"  NormalizeByTheory=\"True\"  HistoName=\"${theSigNameBB}\">" > $output
	echo '  <StatError Activate="False" />'                                                         >> $output
	echo '  <OverallSys Name="XS_bbA" High="x.xxxx" Low="y.yyyy" />'                                >> $output
	let counter=0
	for i in ${list_bb_n_names[@]}; do
	    high=${list_bb_n_high[${counter}]}
	    low=${list_bb_n_low[${counter}]}
	    echo "   <OverallSys Name=\"${i}\" High=\"${high}\" Low=\"${low}\" />"                      >> $output
	    ((++counter))
	done

	let counter=0
	for i in ${list_bb_h_names[@]}; do
	    high=${list_bb_h_high[${counter}]}
	    low=${list_bb_h_low[${counter}]}
	    echo "   <HistoSys Name=\"${i}\"  HistoNameHigh=\"${high}\"  HistoNameLow=\"${low}\" />"    >> $output
	    ((++counter))
	done

	if [ "$FSTATE" == "LH" ]; then
	    echo "  <NormFactor Name=\"mbbAlh${MASS}\" Val=\"a.aaaaa\" Low=\"a.aaaaa\" High=\"a.aaaaa\" />" >> $output
	elif [ "$FSTATE" == "LL" ]; then
	    echo "  <NormFactor Name=\"mbbAll${MASS}\" Val=\"a.aaaaa\" Low=\"a.aaaaa\" High=\"a.aaaaa\" />" >> $output
	fi
	echo "  <NormFactor Name=\"SigXsecOverSM\" Val=\"0\" Low=\"0.\" High=\"40.\"  />"               >> $output
	echo "</Sample>"                                                                                >> $output
    fi
                      
    # ggA sample
    if [ ${#list_gg_n_names} -ge 1 ] || [ ${#list_gg_h_names} -ge 1 ]; then

	echo "<Sample Name=\"${theSigNameGG}\"  HistoPath=\"\"  NormalizeByTheory=\"True\"  HistoName=\"${theSigNameGG}\">" >> $output
	echo '  <StatError Activate="False" />'                                                         >> $output
	echo '  <OverallSys Name="XS_ggA" High="z.zzzz" Low="m.mmmm" />'                                >> $output
	let counter=0
	for i in ${list_gg_n_names[@]}; do
	    high=${list_gg_n_high[${counter}]}
	    low=${list_gg_n_low[${counter}]}
	    echo "   <OverallSys Name=\"${i}\" High=\"${high}\" Low=\"${low}\" />"                      >> $output
	    ((++counter))
	done
	
	let counter=0
	for i in ${list_gg_h_names[@]}; do
	    high=${list_gg_h_high[${counter}]}
	    low=${list_gg_h_low[${counter}]}
	    echo "   <HistoSys Name=\"${i}\"  HistoNameHigh=\"${high}\"  HistoNameLow=\"${low}\" />"    >> $output
	    ((++counter))
	done
	
	if [ "$FSTATE" == "LH" ]; then
	    echo "  <NormFactor Name=\"mggAlh${MASS}\" Val=\"f.ffff\" Low=\"f.ffff\" High=\"f.ffff\" />" >> $output
	elif [ "$FSTATE" == "LL" ]; then
	    echo "  <NormFactor Name=\"mggAll${MASS}\" Val=\"f.ffff\" Low=\"f.ffff\" High=\"f.ffff\" />" >> $output
	fi
	echo "  <NormFactor Name=\"SigXsecOverSM\" Val=\"0\" Low=\"0.\" High=\"40.\"  />"               >> $output
	echo "</Sample>"                                                                                >> $output
    fi

}

#
# input: channel name, list of bkgs
function bkgCreator() {

    CHANNEL="$1"
    shift
    output="${FOLDER}/bkg/bkg_${CHANNEL}_xml.txt"
    echo "" > $output
    for i in ${@}; do

	echo "background: $i"

	# count how many you have
	how_many=`grep "${i} ${CHANNEL} " $INFILE | wc -l`
	echo "how_many = $how_many"
	if [ ${how_many} -lt 1 ]; then
	    continue
	fi	

	list_n_names=(`grep "${i} ${CHANNEL} n" $INFILE |  awk '{print $4}'`)
	list_n_high=(`grep "${i} ${CHANNEL} n" $INFILE |  awk '{print $5}'`)
	list_n_low=(`grep "${i} ${CHANNEL} n" $INFILE |  awk '{print $6}'`)

	list_h_names=(`grep "${i} ${CHANNEL} h" $INFILE |  awk '{print $4}'`)
	list_h_high=(`grep "${i} ${CHANNEL} h" $INFILE |  awk '{print $5}'`)
	list_h_low=(`grep "${i} ${CHANNEL} h" $INFILE |  awk '{print $6}'`)

##	normToTheory=`grep "${i} ${CHANNEL} n" $INFILE | egrep 'True|False' |  awk '{print $7}' | head --lines 1 `
##	if [ "${normToTheory}" == ""  ]; then
##	    normToTheory=`grep "${i} ${CHANNEL} x" $INFILE | egrep 'True|False' |  awk '{print $8}' | head --lines 1 `
##	fi
##	if [ "${normToTheory}" == ""  ]; then
##	    normToTheory=`grep "${i} ${CHANNEL} h" $INFILE | egrep 'True|False' |  awk '{print $7}' | head --lines 1 `
##	fi
##	if [ "${normToTheory}" == ""  ]; then
##	    echo "BUG in $INFILE: missing normToTheory for ${CHANNEL} and $i"
##	    exit 1
##	fi
##	statErrorActivate=`grep "${i} ${CHANNEL} n" $INFILE | egrep 'True|False' |  awk '{print $8}' | head --lines 1 `
##	if [ "${statErrorActivate}" == ""  ]; then
##	    statErrorActivate=`grep "${i} ${CHANNEL} x" $INFILE | egrep 'True|False' |  awk '{print $9}' | head --lines 1 `
##	fi
##	if [ "${statErrorActivate}" == ""  ]; then
##	    statErrorActivate=`grep "${i} ${CHANNEL} h" $INFILE | egrep 'True|False' |  awk '{print $8}' | head --lines 1 `
##	fi

	normToTheory=`grep "${i} ${CHANNEL} n" $INFILE | egrep 'True|False' |  awk '{print $7}' | head -n 1 `
	if [ "${normToTheory}" == ""  ]; then
	    normToTheory=`grep "${i} ${CHANNEL} x" $INFILE | egrep 'True|False' |  awk '{print $8}' | head -n 1 `
	fi
	if [ "${normToTheory}" == ""  ]; then
	    normToTheory=`grep "${i} ${CHANNEL} h" $INFILE | egrep 'True|False' |  awk '{print $7}' | head -n 1 `
	fi
	if [ "${normToTheory}" == ""  ]; then
	    echo "BUG in $INFILE: missing normToTheory for ${CHANNEL} and $i"
	    exit 1
	fi
	statErrorActivate=`grep "${i} ${CHANNEL} n" $INFILE | egrep 'True|False' |  awk '{print $8}' | head -n 1 `
	if [ "${statErrorActivate}" == ""  ]; then
	    statErrorActivate=`grep "${i} ${CHANNEL} x" $INFILE | egrep 'True|False' |  awk '{print $9}' | head -n 1 `
	fi
	if [ "${statErrorActivate}" == ""  ]; then
	    statErrorActivate=`grep "${i} ${CHANNEL} h" $INFILE | egrep 'True|False' |  awk '{print $8}' | head -n 1 `
	fi

	if [ "${statErrorActivate}" == ""  ]; then
	    echo "BUG in $INFILE: missing statErrorActivate for ${CHANNEL} and $i"
	    exit 1
	fi
	echo "<Sample Name=\"${i}\"  HistoPath=\"\"  NormalizeByTheory=\"${normToTheory}\"  HistoName=\"${i}\">" >> $output
	echo '  <StatError Activate="'"${statErrorActivate}"'" />'                                               >> $output

	let counter=0
	for j in ${list_n_names[@]}; do
	    high=${list_n_high[${counter}]}
	    low=${list_n_low[${counter}]}
	    echo "   <OverallSys Name=\"${j}\" High=\"${high}\" Low=\"${low}\" />"                    >> $output
	    ((++counter))
	done

	let counter=0
	for j in ${list_h_names[@]}; do
	    high=${list_h_high[${counter}]}
	    low=${list_h_low[${counter}]}
	    echo "   <HistoSys Name=\"${j}\"  HistoNameHigh=\"${high}\"  HistoNameLow=\"${low}\" />"    >> $output
	    ((++counter))
	done

	# now check for norm factors
	list_x_names=(`grep "${i} ${CHANNEL} x" $INFILE |  awk '{print $4}'`)
	list_x_nom=(`grep "${i} ${CHANNEL} x" $INFILE |  awk '{print $5}'`)
	list_x_high=(`grep "${i} ${CHANNEL} x" $INFILE |  awk '{print $6}'`)
	list_x_low=(`grep "${i} ${CHANNEL} x" $INFILE |  awk '{print $7}'`)
#	echo '<!-- norm factors:  '" ${i}  ${CHANNEL}, $INFILE:  ${list_x_names[@]}"' -->'
	let counter=0
	for j in ${list_x_names[@]}; do
	    nom=${list_x_nom[${counter}]}
	    high=${list_x_high[${counter}]}
	    low=${list_x_low[${counter}]}
	    echo "  <NormFactor Name=\"${j}\" Val=\"${nom}\" Low=\"${low}\" High=\"${high}\" />" >> $output
	    ((++counter))
	done
	echo "</Sample>"                                                                         >> $output
	

    done


}

massList=("090" "100" "110" "120" "130" "140" "150" "170" "200" "250" "300" "350" "400" "450" "500")
massListLepLep=("090" "100" "110" "120" "125" "130" "140" "150" "170" "200" "250" "300" "350" "400")
channelList=("high_el" "high_mu" "veto_el" "veto_mu" "tag_el" "tag_mu" "veto_emu" "tag_emu")
bkgList=("ATLAS_Bkg_LH_Other" "ATLAS_Bkg_LH_TT" "ATLAS_Bkg_LH_Wlnu" "ATLAS_Bkg_LH_Zjet" "ATLAS_Bkg_LH_Zlep" "ATLAS_Bkg_LH_Zleplep" "ATLAS_Bkg_LH_Ztautau" 
"ATLAS_Bkg_LH_qcd_cC" 
"ATLAS_Bkg_LH_Other_cD" "ATLAS_Bkg_LH_TT_cD" "ATLAS_Bkg_LH_Wlnu_cD" "ATLAS_Bkg_LH_Zjet_cD" "ATLAS_Bkg_LH_Zlep_cD" "ATLAS_Bkg_LH_Zleplep_cD" "ATLAS_Bkg_LH_Ztautau_cD" 
"ATLAS_Bkg_LH_Other_cB" "ATLAS_Bkg_LH_TT_cB" "ATLAS_Bkg_LH_Wlnu_cB" "ATLAS_Bkg_LH_Zjet_cB" "ATLAS_Bkg_LH_Zlep_cB" "ATLAS_Bkg_LH_Zleplep_cB" "ATLAS_Bkg_LH_Ztautau_cB" 
"FlatHist1" "ATLAS_Bkg_LL_TopFit")
bkgListLepLep=( "ATLAS_Bkg_LL_qcd" "ATLAS_Bkg_LL_qcd_data_cB" "ATLAS_Bkg_LL_qcd_data_cD" "ATLAS_Bkg_LL_Ztautau" "ATLAS_Bkg_LL_Ztautau_cB" "ATLAS_Bkg_LL_Other" "ATLAS_Bkg_LL_Other_cB" "ATLAS_Bkg_LL_TT" "ATLAS_Bkg_LL_TT_cB" "FlatHist1" "ATLAS_Bkg_LL_TopFit")

# if you find arguments do something different
if [ ${#} -ge 3  ]; then
    echo "will take parameters from command line"
    INFILE="$1"
    FOLDER="$2"
    if [ "$3" == "high" ]; then
	channelList=("high_el" "high_mu")
    elif [ "$3" == "veto" ]; then
	channelList=("veto_el" "veto_mu")
    elif [ "$3" == "tag" ]; then
	channelList=("tag_el" "tag_mu")
    elif [ "$3" == "all" ]; then
	channelList=("high_el" "high_mu" "veto_el" "veto_mu" "tag_el" "tag_mu")
    elif [ "$3" == "allcr" ]; then
	channelList=("high_el" "num_high_el" "den_high_el" "high_mu" "num_high_mu" "den_high_mu"  "veto_el" "num_veto_el" "den_veto_el"  "veto_mu" "num_veto_mu" "den_veto_mu"  "tag_el" "num_tag_el" "den_tag_el"  "tag_mu" "num_tag_mu"  "den_tag_mu")
    elif [ "$3" == "tag_leplep" ]; then
	channelList=("tag_emu")
	massList=("${massListLepLep[@]}")
	bkgList=("${bkgListLepLep[@]}")
    elif [ "$3" == "veto_leplep" ]; then
	channelList=("veto_emu")
	massList=("${massListLepLep[@]}")
	bkgList=("${bkgListLepLep[@]}")
    fi
    echo $INFILE
    echo $FOLDER
    echo "MASS LIST :  ${massList[@]}"
    echo "CHANNELS  :  ${channelList[@]}"
    echo "BKG LIST  :  ${bkgList[@]}"
fi

if [ -d ${FOLDER} ]; then
    rm -rf ${FOLDER}
    mkdir ${FOLDER}
    mkdir ${FOLDER}/{bkg,sig}
else
    mkdir ${FOLDER}
    mkdir ${FOLDER}/{bkg,sig}
fi

if [ "$3" == "tag_leplep" ]; then
    cp top_template_leplep_xml.txt ${FOLDER}/top_template_xml.txt
elif [ "$3" == "veto_leplep" ]; then
    cp top_template_leplep_xml.txt ${FOLDER}/top_template_xml.txt
else
    cp top_template_xml.txt ${FOLDER}
fi

for i_mass in ${massList[@]}; do
    for i_channel in ${channelList[@]}; do
	SignalTemplateCreation ${i_mass} ${i_channel}
    done
done


for i_channel in ${channelList[@]}; do
    bkgCreator ${i_channel}  ${bkgList[@]}
done

#----  Add ABCD to output bkg file --- ALE
if [ "$3" == "tag_leplep" ]; then
	echo "<Sample Name=\"ATLAS_Bkg_QCD\" HistoPath=\"abcd_FullBtag/\" NormalizeByTheory=\"False\" HistoName=\"ATLAS_Bkg_QCD_shape_FullBtag\">" >> ${FOLDER}/bkg/bkg_tag_emu_xml.txt
	echo "   <StatError Activate=\"False\" />" >> ${FOLDER}/bkg/bkg_tag_emu_xml.txt
	echo "   <NormFactor Name=\"N_qcd_B_tag\" Val=\"50.\" Low=\"0.\" High=\"1000.\" />  <!-- Number of events in region B to be fitted -->" >> ${FOLDER}/bkg/bkg_tag_emu_xml.txt
	echo "   <NormFactor Name=\"R_qcd_tag\" Val=\"2.\" Low=\"0.\" High=\"10.\"  />     <!-- R_qcd factor that converts # events in region B to SR A,-->" >> ${FOLDER}/bkg/bkg_tag_emu_xml.txt
	echo "   <OverallSys Name=\"R_qcd_tag\" Low=\"0.85\" High=\"1.15\"/>" >> ${FOLDER}/bkg/bkg_tag_emu_xml.txt
	echo "</Sample>" >> ${FOLDER}/bkg/bkg_tag_emu_xml.txt

elif [ "$3" == "veto_leplep" ]; then
	echo "<Sample Name=\"ATLAS_Bkg_QCD\" HistoPath=\"abcd_FullBveto/\" NormalizeByTheory=\"False\" HistoName=\"ATLAS_Bkg_QCD_shape_FullBveto\">" >> ${FOLDER}/bkg/bkg_veto_emu_xml.txt
	echo "   <StatError Activate=\"False\" />" >> ${FOLDER}/bkg/bkg_veto_emu_xml.txt
	echo "   <NormFactor Name=\"N_qcd_B_veto\" Val=\"3000.\" Low=\"0.\" High=\"10000.\" />  <!-- Number of events in region B to be fitted -->" >> ${FOLDER}/bkg/bkg_veto_emu_xml.txt
	echo "   <NormFactor Name=\"R_qcd_veto\" Val=\"2.\" Low=\"0.\" High=\"10.\"  />    <!-- R_qcd factor that converts # events in region B to SR A, -->" >> ${FOLDER}/bkg/bkg_veto_emu_xml.txt
	echo "   <OverallSys Name=\"R_qcd_veto\" Low=\"0.85\" High=\"1.15\"/>" >> ${FOLDER}/bkg/bkg_veto_emu_xml.txt
	echo "</Sample>" >> ${FOLDER}/bkg/bkg_veto_emu_xml.txt
else
	echo "channel $3 not recognised!! QCD region is not added"
fi
