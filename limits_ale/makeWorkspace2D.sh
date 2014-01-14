#!/bin/bash

if [ ${#} -eq 1  ]; then

#    massPoints=(090 100 110 120 125 130 140 150 170 200 250 300 350 400)
    massPoints=(090 100 110 120 125 130 140 150 170 200 250 300)

    tanBetaPoints=(05 08 10 13 16 20 23 26 30 35 40 45 50 55 60)

    filePrefix=${1}

    echo "filePrefix = ${filePrefix}"

    for i in ${massPoints[@]}

      do
  
      echo "mass = " $i

      for j in ${tanBetaPoints[@]}

      do 
	echo "  tanBeta = " $j

	echo "hist2workspace ${filePrefix}${i}_ggA.xml"
	hist2workspace ${filePrefix}${i}tb${j}.xml

      done

    done

else

    echo "Not enough inputs, so not running"

fi