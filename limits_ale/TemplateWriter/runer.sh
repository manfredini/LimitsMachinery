#!/bin/bash

./templateWriter.sh  John_Dec11/systematics.txt Templates_Dec11_noCR all
./templateWriter.sh  John_Dec11/systematics.txt Templates_Dec11_CR allcr

exit
#./templateWriter.sh  John_Dec7/systematics_CRa.txt Templates_CR allcr
./templateWriter.sh  John_Dec7/systematics_CRa.txt Templates_Dec7 all

exit

./templateWriter.sh  dec9_opt/high/batch1/systematics.txt Templates_high_batch1 high
./templateWriter.sh  dec9_opt/high/batch2/systematics.txt Templates_high_batch2 high
./templateWriter.sh  dec9_opt/high/batch3/systematics.txt Templates_high_batch3 high

./templateWriter.sh  dec9_opt/veto/batch1/systematics.txt Templates_veto_batch1 veto
./templateWriter.sh  dec9_opt/veto/batch2/systematics.txt Templates_veto_batch2 veto
./templateWriter.sh  dec9_opt/veto/batch3/systematics.txt Templates_veto_batch3 veto



