#!/bin/bash

# tweet the data
BODY=$(./castillayleon.sh)
../tweet.sh/tweet.sh post "${BODY}"
BODY=$(./galicia.sh)
../tweet.sh/tweet.sh post "${BODY}"
BODY=$(./madrid.sh)
../tweet.sh/tweet.sh post "${BODY}"
