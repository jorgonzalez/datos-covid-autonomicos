#!/bin/bash

if [[ "${CONTROL}" != "NO DATA" ]]; then
	echo "📍 ${REGION}\n"
	echo "\n"
	echo "🔵 ${NEW_CASES_YESTERDAY} CASOS NUEVOS\n"
	echo "-$(LC_TIME=${LOCALE} date +"%a" --date '2 days ago'): ${NEW_CASES_2DAYSAGO}\n"
	echo "-$(LC_TIME=${LOCALE} date +"%a" --date '3 days ago'): ${NEW_CASES_3DAYSAGO}\n"
	echo "-$(LC_TIME=${LOCALE} date +"%a" --date '4 days ago'): ${NEW_CASES_4DAYSAGO}\n"
	echo "-$(LC_TIME=${LOCALE} date +"%a" --date '5 days ago'): ${NEW_CASES_5DAYSAGO}\n"
	echo "-$(LC_TIME=${LOCALE} date +"%a" --date '6 days ago'): ${NEW_CASES_6DAYSAGO}\n"
	echo "-$(LC_TIME=${LOCALE} date +"%a" --date '7 days ago'): ${NEW_CASES_7DAYSAGO}\n"
	echo "-$(LC_TIME=${LOCALE} date +"%a" --date '8 days ago'): ${NEW_CASES_8DAYSAGO}\n"
	echo "-$(LC_TIME=${LOCALE} date +"%a" --date '9 days ago'): ${NEW_CASES_9DAYSAGO}\n"
	echo "\n"

	echo "${DEAD_DIFF} FALLECIDOS\n"
	echo "${RECOVERED_DIFF} CURADOS\n"
	echo "🏥 ${HOSPITAL_ADMITTED_YESTERDAY} PLANTA [${HOSPITAL_ADDMITTED_DIFF}]\n"
	echo "🚑 ${HOSPITAL_ICU_YESTERDAY} UCI [${HOSPITAL_ICU_DIFF}]\n"
else
	echo "📍 ${REGION}\n"
	echo "\n"
	echo "${REGION} no actualiza datos hoy."
fi

