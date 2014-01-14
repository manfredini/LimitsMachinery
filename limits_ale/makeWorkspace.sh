#!/bin/bash

if [ ${#} -eq 1  ]; then

#    massPoints=(090 100 110 120 125 130 140 150 170 200 250 300 350 400)
    massPoints=(090 100 110 120 125 130 140 150 170 200 250 300)

    filePrefix=${1}

    echo "filePrefix = ${filePrefix}"

    for i in ${massPoints[@]}

      do
  
      echo "mass = " $i

      echo "hist2workspace ${filePrefix}${i}_bbA.xml"
      hist2workspace ${filePrefix}${i}_bbA.xml

      echo "hist2workspace ${filePrefix}${i}_ggA.xml"
      hist2workspace ${filePrefix}${i}_ggA.xml


    done

else

    echo "Not enough inputs, so not running"

fi