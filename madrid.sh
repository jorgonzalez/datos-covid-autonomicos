#!/bin/bash

REGION="MADRID"

DATE_TODAY=$(date +"%Y-%-m-%-d")
DATE_YESTERDAY=$(date +"%d/%m/%Y" --date="yesterday")
DATE_2DAYSAGO=$(date +"%d/%m/%Y" --date="2 days ago")
DATE_3DAYSAGO=$(date +"%d/%m/%Y" --date="3 days ago")
DATE_4DAYSAGO=$(date +"%d/%m/%Y" --date="4 days ago")
DATE_5DAYSAGO=$(date +"%d/%m/%Y" --date="5 days ago")
DATE_6DAYSAGO=$(date +"%d/%m/%Y" --date="6 days ago")
DATE_7DAYSAGO=$(date +"%d/%m/%Y" --date="7 days ago")
DATE_8DAYSAGO=$(date +"%d/%m/%Y" --date="8 days ago")
DATE_9DAYSAGO=$(date +"%d/%m/%Y" --date="9 days ago")

FILE1="SituacionEpidemiologica${REGION}_today.pdf"
FILE1TXT="SituacionEpidemiologica${REGION}_today.txt"
FILE2="SituacionEpidemiologica${REGION}_yesterday.pdf"
FILE2TXT="SituacionEpidemiologica${REGION}_yesterday.txt"

FILE_DATE=$(date +"%Y%m%d" --date="yesterday")
FILE="https://www.comunidad.madrid/sites/default/files/doc/sanidad/${FILE_DATE}_cam_covid19.pdf"
wget -qc "${FILE}" -O ${FILE2}
RESULT=$(echo $?)
if [[ "${RESULT}" -ne 0 ]]; then
	FILE_DATE=$(date +"%y%m%d" -date="yesterday")
	FILE="https://www.comunidad.madrid/sites/default/files/doc/sanidad/${FILE_DATE}_cam_covid19.pdf"
	wget -qc "${FILE}" -O ${FILE2}
fi
pdftotext -layout ${FILE2} ${FILE2TXT}

FILE_DATE=$(date +"%Y%m%d")
FILE="https://www.comunidad.madrid/sites/default/files/doc/sanidad/${FILE_DATE}_cam_covid19.pdf"
wget -qc "${FILE}" -O ${FILE1}
RESULT=$(echo $?)
if [[ "${RESULT}" -ne 0 ]]; then
	FILE_DATE=$(date +"%y%m%d")
	FILE="https://www.comunidad.madrid/sites/default/files/doc/sanidad/${FILE_DATE}_cam_covid19.pdf"
	wget -qc "${FILE}" -O ${FILE1}
fi
pdftotext -layout ${FILE1} ${FILE1TXT}

TEMPORARY_YESTERDAY=$(cat ${FILE1TXT})
TEMPORARY_2DAYSAGO=$(cat ${FILE2TXT})

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

CHECK_LAST_DATA=$(echo "${TEMPORARY_YESTERDAY}" | grep "Datos cierre día anterior" -m1 -B1 | head -n1 | tr -d "." | sed -e 's/^[ \t]*//' | awk -F"/" '{print $3"-"$2"-"$1}')
if [[ "${CHECK_LAST_DATA}" == "${DATE_TODAY}" ]]; then
	CONTROL="OK"

	## WEEKLY
	NEW_CASES_YESTERDAY=$(echo "${TEMPORARY_YESTERDAY}" | grep "${DATE_YESTERDAY}" -m1 | awk '{print $2}')
	NEW_CASES_2DAYSAGO=$(echo "${TEMPORARY_YESTERDAY}" | grep "${DATE_2DAYSAGO}" -m1 | awk '{print $2}')
	NEW_CASES_3DAYSAGO=$(echo "${TEMPORARY_YESTERDAY}" | grep "${DATE_3DAYSAGO}" -m1 | awk '{print $2}')
	NEW_CASES_4DAYSAGO=$(echo "${TEMPORARY_YESTERDAY}" | grep "${DATE_4DAYSAGO}" -m1 | awk '{print $2}')
	NEW_CASES_5DAYSAGO=$(echo "${TEMPORARY_YESTERDAY}" | grep "${DATE_5DAYSAGO}" -m1 | awk '{print $2}')
	NEW_CASES_6DAYSAGO=$(echo "${TEMPORARY_YESTERDAY}" | grep "${DATE_6DAYSAGO}" -m1 | awk '{print $2}')
	NEW_CASES_7DAYSAGO=$(echo "${TEMPORARY_YESTERDAY}" | grep "${DATE_7DAYSAGO}" -m1 | awk '{print $2}')
	NEW_CASES_8DAYSAGO=$(echo "${TEMPORARY_YESTERDAY}" | grep "${DATE_8DAYSAGO}" -m1 | awk '{print $2}')
	NEW_CASES_9DAYSAGO=$(echo "${TEMPORARY_YESTERDAY}" | grep "${DATE_9DAYSAGO}" -m1 | awk '{print $2}')

	## DEAD
	DEAD_CASES_YESTERDAY=$(echo "${TEMPORARY_YESTERDAY}" | grep "(en el día)" -m 1 -B1 | head -n 1 | awk '{print $1}' | tr -d "." | sed -e 's/^[ \t]*//')
	DEAD_CASES_2DAYSAGO=$(echo "${TEMPORARY_2DAYSAGO}" | grep "(en el día)" -m 1 -B1 | head -n 1 | awk '{print $1}' | tr -d "." | sed -e 's/^[ \t]*//')

	## RECOVERED
	RECOVERED_CASES_YESTERDAY=$(echo "${TEMPORARY_YESTERDAY}" | grep "Altas Hospitalarias" -A3 | tail -n 1 | awk '{print $6}' | tr -d "." | sed -e 's/^[ \t]*//')
	RECOVERED_CASES_2DAYSAGO=$(echo "${TEMPORARY_2DAYSAGO}" | grep "Altas Hospitalarias" -A3 | tail -n 1 | awk '{print $6}' | tr -d "." | sed -e 's/^[ \t]*//')

	## HOSPITALS
	### ADMITTED
	HOSPITAL_ADMITTED_YESTERDAY=$(echo "${TEMPORARY_YESTERDAY}" | grep "Altas Hospitalarias" -A3 | tail -n 1 | awk '{print $6}' | tr -d "." | sed -e 's/^[ \t]*//')
	HOSPITAL_ADMITTED_2DAYSAGO=$(echo "${TEMPORARY_2DAYSAGO}" | grep "Altas Hospitalarias" -A3 | tail -n 1 | awk '{print $6}' | tr -d "." | sed -e 's/^[ \t]*//')
	### ICU
	HOSPITAL_ICU_YESTERDAY=$(echo "${TEMPORARY_YESTERDAY}" | grep "Pacientes en UCI" -A4 | tail -n 1 | awk '{print $2}' | tr -d "." | sed -e 's/^[ \t]*//')
	HOSPITAL_ICU_2DAYSAGO=$(echo "${TEMPORARY_2DAYSAGO}" | grep "Pacientes en UCI" -A4 | tail -n 1 | awk '{print $2}' | tr -d "." | sed -e 's/^[ \t]*//')

	DEAD_DIFF=$(status ${DEAD_CASES_YESTERDAY} ${DEAD_CASES_2DAYSAGO})
	RECOVERED_DIFF=$(status ${RECOVERED_CASES_YESTERDAY} ${RECOVERED_CASES_2DAYSAGO} "INVERT")
	HOSPITAL_ADDMITTED_DIFF=$(status ${HOSPITAL_ADMITTED_YESTERDAY} ${HOSPITAL_ADMITTED_2DAYSAGO})
	HOSPITAL_ICU_DIFF=$(status ${HOSPITAL_ICU_YESTERDAY} ${HOSPITAL_ICU_2DAYSAGO})

	URL="${FILE}"
else
	CONTROL="NO DATA"
fi

# Delete temorary files
rm ${FILE1} ${FILE2} ${FILE1TXT} ${FILE2TXT} 2>/dev/null

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
