REGION="CASTILLA Y LEON"

DATE_TODAY=$(date +"%Y-%m-%d")
DATE_YESTERDAY=$(date +"%Y-%m-%d" --date="yesterday")
DATE_2DAYSAGO=$(date +"%Y-%m-%d" --date="2 days ago")
DATE_3DAYSAGO=$(date +"%Y-%m-%d" --date="3 days ago")
DATE_4DAYSAGO=$(date +"%Y-%m-%d" --date="4 days ago")
DATE_5DAYSAGO=$(date +"%Y-%m-%d" --date="5 days ago")
DATE_6DAYSAGO=$(date +"%Y-%m-%d" --date="6 days ago")
DATE_7DAYSAGO=$(date +"%Y-%m-%d" --date="7 days ago")
DATE_8DAYSAGO=$(date +"%Y-%m-%d" --date="8 days ago")
DATE_9DAYSAGO=$(date +"%Y-%m-%d" --date="9 days ago")

FILE1="SituacionEpidemiologicaCyL.csv"
wget -qc "https://analisis.datosabiertos.jcyl.es/explore/dataset/situacion-epidemiologica-coronavirus-en-castilla-y-leon/download/?format=csv&timezone=Europe/Madrid&lang=en&use_labels_for_header=true&csv_separator=%3B" -O ${FILE1}
FILE2="SituacionHospitalizadosCyL.csv"
wget -qc "https://analisis.datosabiertos.jcyl.es/explore/dataset/situacion-de-hospitalizados-por-coronavirus-en-castilla-y-leon/download/?format=csv&timezone=Europe/Madrid&lang=en&use_labels_for_header=true&csv_separator=%3B" -O ${FILE2}

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

CHECK_LAST_DATA=$(cat ${FILE1} | head -n 2 | tail -n 1 | awk -F";" '{print $1}')
if [[ "${CHECK_LAST_DATA}" == "${DATE_TODAY}" ]]; then
	CONTROL="OK"

	## WEEKLY
	for i in $(cat ${FILE1} | grep ${DATE_YESTERDAY} | awk -F";" '{print $4}'); do
		let NEW_CASES_YESTERDAY=${NEW_CASES_YESTERDAY}+$i
	done
	for i in $(cat ${FILE1} | grep ${DATE_2DAYSAGO} | awk -F";" '{print $4}'); do
		let NEW_CASES_2DAYSAGO=${NEW_CASES_2DAYSAGO}+$i
	done
	for i in $(cat ${FILE1} | grep ${DATE_3DAYSAGO} | awk -F";" '{print $4}'); do
		let NEW_CASES_3DAYSAGO=${NEW_CASES_3DAYSAGO}+$i
	done
	for i in $(cat ${FILE1} | grep ${DATE_4DAYSAGO} | awk -F";" '{print $4}'); do
		let NEW_CASES_4DAYSAGO=${NEW_CASES_4DAYSAGO}+$i
	done
	for i in $(cat ${FILE1} | grep ${DATE_5DAYSAGO} | awk -F";" '{print $4}'); do
		let NEW_CASES_5DAYSAGO=${NEW_CASES_5DAYSAGO}+$i
	done
	for i in $(cat ${FILE1} | grep ${DATE_6DAYSAGO} | awk -F";" '{print $4}'); do
		let NEW_CASES_6DAYSAGO=${NEW_CASES_6DAYSAGO}+$i
	done
	for i in $(cat ${FILE1} | grep ${DATE_7DAYSAGO} | awk -F";" '{print $4}'); do
		let NEW_CASES_7DAYSAGO=${NEW_CASES_7DAYSAGO}+$i
	done
	for i in $(cat ${FILE1} | grep ${DATE_8DAYSAGO} | awk -F";" '{print $4}'); do
		let NEW_CASES_8DAYSAGO=${NEW_CASES_8DAYSAGO}+$i
	done
	for i in $(cat ${FILE1} | grep ${DATE_9DAYSAGO} | awk -F";" '{print $4}'); do
		let NEW_CASES_9DAYSAGO=${NEW_CASES_9DAYSAGO}+$i
	done

	## ACTIVE
	for i in $(cat ${FILE1} | grep ${DATE_YESTERDAY} | awk -F";" '{print $4}'); do
		let ACTIVE_CASES_YESTERDAY=${ACTIVE_CASES_YESTERDAY}+$i
	done
	for i in $(cat ${FILE1} | grep ${DATE_2DAYSAGO} | awk -F";" '{print $4}'); do
		let ACTIVE_CASES_2DAYSAGO=${ACTIVE_CASES_2DAYSAGO}+$i
	done

	## DEAD
	for i in $(cat ${FILE1} | grep ${DATE_YESTERDAY} | awk -F";" '{print $6}'); do
		let DEAD_CASES_YESTERDAY=${DEAD_CASES_YESTERDAY}+$i
	done
	for i in $(cat ${FILE1} | grep ${DATE_2DAYSAGO} | awk -F";" '{print $6}'); do
		let DEAD_CASES_2DAYSAGO=${DEAD_CASES_2DAYSAGO}+$i
	done

	## RECOVERED
	for i in $(cat ${FILE1} | grep ${DATE_YESTERDAY} | awk -F";" '{print $5}'); do
		let RECOVERED_CASES_YESTERDAY=${RECOVERED_CASES_YESTERDAY}+$i
	done
	for i in $(cat ${FILE1} | grep ${DATE_2DAYSAGO} | awk -F";" '{print $5}'); do
		let RECOVERED_CASES_2DAYSAGO=${RECOVERED_CASES_2DAYSAGO}+$i
	done

	## HOSPITALS
	### ADMITTED
	for i in $(cat ${FILE2} | grep ${DATE_YESTERDAY} | awk -F";" '{print $6}'); do
		let HOSPITAL_ADMITTED_YESTERDAY=${HOSPITAL_ADMITTED_YESTERDAY}+$i
	done
	for i in $(cat ${FILE2} | grep ${DATE_2DAYSAGO} | awk -F";" '{print $6}'); do
		let HOSPITAL_ADMITTED_2DAYSAGO=${HOSPITAL_ADMITTED_2DAYSAGO}+$i
	done
	### ICU
	for i in $(cat ${FILE2} | grep ${DATE_YESTERDAY} | awk -F";" '{print $6}'); do
		let HOSPITAL_ICU_YESTERDAY=${HOSPITAL_ICU_YESTERDAY}+$i
	done
	for i in $(cat ${FILE2} | grep ${DATE_2DAYSAGO} | awk -F";" '{print $6}'); do
		let HOSPITAL_ICU_2DAYSAGO=${HOSPITAL_ICU_2DAYSAGO}+$i
	done

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

# Print all data
source ./printData.sh
