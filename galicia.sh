#!/bin/bash

REGION=GALICIA

DATE_YESTERDAY=$(date +"%Y-%m-%d" --date="yesterday")
DATE_2DAYSAGO=$(date +"%Y-%m-%d" --date="2 days ago")
DATE_3DAYSAGO=$(date +"%Y-%m-%d" --date="3 days ago")
DATE_4DAYSAGO=$(date +"%Y-%m-%d" --date="4 days ago")
DATE_5DAYSAGO=$(date +"%Y-%m-%d" --date="5 days ago")
DATE_6DAYSAGO=$(date +"%Y-%m-%d" --date="6 days ago")
DATE_7DAYSAGO=$(date +"%Y-%m-%d" --date="7 days ago")
DATE_8DAYSAGO=$(date +"%Y-%m-%d" --date="8 days ago")
DATE_9DAYSAGO=$(date +"%Y-%m-%d" --date="9 days ago")
BASE_URL="https://coronavirus.sergas.gal/infodatos"
#Casos nuevos; fallecidos; curados
FILE1="COVID19_Web_ActivosCuradosFallecidos.csv"
#Activos
FILE2="COVID19_Web_CifrasTotais_PDIA.csv"
#PDIA
FILE3="COVID19_Web_InfectadosPorFecha_PDIA.csv"
#Planta; UCI
FILE4="COVID19_Web_OcupacionCamasHospital.csv"

URL="https://coronavirus.sergas.gal/datos/#/gl-ES/galicia"

function status(){
	unset DIFF
	CURR=$1
	PREV=$2
	INVERT=$3
	let CHANGE=$CURR-$PREV
	if [[ "${CHANGE}" -gt 0 ]] && [[ -z "${INVERT}" ]]; then
		DIFF="+${CHANGE} 🔴"
	elif [[ "${CHANGE}" -gt 0 ]] && [[ ! -z "${INVERT}" ]]; then
		DIFF="+${CHANGE} 🟢"
	elif [[ "${CHANGE}" -lt 0 ]] && [[ -z "${INVERT}" ]]; then
		DIFF="${CHANGE} 🟢"
	elif [[ "${CHANGE}" -lt 0 ]] && [[ ! -z "${INVERT}" ]]; then
		DIFF="${CHANGE} 🔴"
	else
		DIFF="= 🟡"
	fi
	echo ${DIFF}
	unset DIFF
}

CHECK_LAST_DATA=$(wget -qO - ${BASE_URL}/${DATE_YESTERDAY}_${FILE2} | dos2unix | head -n 2 | tail -n 1 | awk '{print $1}')
if [[ "${CHECK_LAST_DATA}" == "${DATE_YESTERDAY}" ]]; then
	CONTROL="OK"

	## WEEKLY
	NEW_CASES_YESTERDAY=$(wget -qO - ${BASE_URL}/${DATE_YESTERDAY}_${FILE2} | dos2unix | tail -n 1 | tr -d "\"." | awk -F"," '{print $4}')
	NEW_CASES_2DAYSAGO=$(wget -qO - ${BASE_URL}/${DATE_2DAYSAGO}_${FILE2} | dos2unix | tail -n 1 | tr -d "\"." | awk -F"," '{print $4}')
	NEW_CASES_3DAYSAGO=$(wget -qO - ${BASE_URL}/${DATE_3DAYSAGO}_${FILE2} | dos2unix | tail -n 1 | tr -d "\"." | awk -F"," '{print $4}')
	NEW_CASES_4DAYSAGO=$(wget -qO - ${BASE_URL}/${DATE_4DAYSAGO}_${FILE2} | dos2unix | tail -n 1 | tr -d "\"." | awk -F"," '{print $4}')
	NEW_CASES_5DAYSAGO=$(wget -qO - ${BASE_URL}/${DATE_5DAYSAGO}_${FILE2} | dos2unix | tail -n 1 | tr -d "\"." | awk -F"," '{print $4}')
	NEW_CASES_6DAYSAGO=$(wget -qO - ${BASE_URL}/${DATE_6DAYSAGO}_${FILE2} | dos2unix | tail -n 1 | tr -d "\"." | awk -F"," '{print $4}')
	NEW_CASES_7DAYSAGO=$(wget -qO - ${BASE_URL}/${DATE_7DAYSAGO}_${FILE2} | dos2unix | tail -n 1 | tr -d "\"." | awk -F"," '{print $4}')
	NEW_CASES_8DAYSAGO=$(wget -qO - ${BASE_URL}/${DATE_8DAYSAGO}_${FILE2} | dos2unix | tail -n 1 | tr -d "\"." | awk -F"," '{print $4}')
	NEW_CASES_9DAYSAGO=$(wget -qO - ${BASE_URL}/${DATE_9DAYSAGO}_${FILE2} | dos2unix | tail -n 1 | tr -d "\"." | awk -F"," '{print $4}')

	## DEAD
	DEAD_CASES_YESTERDAY=$(wget -qO - ${BASE_URL}/${DATE_YESTERDAY}_${FILE2} | dos2unix | tail -n 1 | tr -d "\"." | awk -F"," '{print $11}')
	DEAD_CASES_2DAYSAGO=$(wget -qO - ${BASE_URL}/${DATE_2DAYSAGO}_${FILE2} | dos2unix | tail -n 1 | tr -d "\"." | awk -F"," '{print $11}')

	## RECOVERED
	RECOVERED_CASES_YESTERDAY=$(wget -qO - ${BASE_URL}/${DATE_YESTERDAY}_${FILE2} | dos2unix | tail -n 1 | tr -d "\"." | awk -F"," '{print $6}')
	RECOVERED_CASES_2DAYSAGO=$(wget -qO - ${BASE_URL}/${DATE_2DAYSAGO}_${FILE2} | dos2unix | tail -n 1 | tr -d "\"." | awk -F"," '{print $6}')

	## HOSPITALS
	### ADMITTED
	HOSPITAL_ADMITTED_YESTERDAY=$(wget -qO - ${BASE_URL}/${DATE_YESTERDAY}_${FILE4} | dos2unix | tail -n 1 | tr -d "\"." | awk -F"," '{print $5}')
	HOSPITAL_ADMITTED_2DAYSAGO=$(wget -qO - ${BASE_URL}/${DATE_2DAYSAGO}_${FILE4} | dos2unix | tail -n 1 | tr -d "\"." | awk -F"," '{print $5}')
	### ICU
	HOSPITAL_ICU_YESTERDAY=$(wget -qO - ${BASE_URL}/${DATE_YESTERDAY}_${FILE4} | dos2unix | tail -n 1 | tr -d "\"." | awk -F"," '{print $6}')
	HOSPITAL_ICU_2DAYSAGO=$(wget -qO - ${BASE_URL}/${DATE_2DAYSAGO}_${FILE4} | dos2unix | tail -n 1 | tr -d "\"." | awk -F"," '{print $6}')

	DEAD_DIFF=$(status ${DEAD_CASES_YESTERDAY} ${DEAD_CASES_2DAYSAGO})
	RECOVERED_DIFF=$(status ${RECOVERED_CASES_YESTERDAY} ${RECOVERED_CASES_2DAYSAGO} "INVERT")
	HOSPITAL_ADDMITTED_DIFF=$(status ${HOSPITAL_ADMITTED_YESTERDAY} ${HOSPITAL_ADMITTED_2DAYSAGO})
	HOSPITAL_ICU_DIFF=$(status ${HOSPITAL_ICU_YESTERDAY} ${HOSPITAL_ICU_2DAYSAGO})
else
	CONTROL="NO DATA"
fi

# Delete temorary files
rm ${FILE1} ${FILE2} 2>/dev/null

# Export all data
export CONTROL
export REGION
export NEW_CASES_YESTERDAY
export NEW_CASES_2DAYSAGO
export NEW_CASES_3DAYSAGO
export NEW_CASES_4DAYSAGO
export NEW_CASES_5DAYSAGO
export NEW_CASES_6DAYSAGO
export NEW_CASES_7DAYSAGO
export NEW_CASES_8DAYSAGO
export NEW_CASES_9DAYSAGO
export DEAD_DIFF
export RECOVERED_DIFF
export HOSPITAL_ADMITTED_YESTERDAY
export HOSPITAL_ADDMITTED_DIFF
export HOSPITAL_ICU_YESTERDAY
export HOSPITAL_ICU_DIFF
export URL

# Print all data
source ./printData.sh
