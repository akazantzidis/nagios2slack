#!/usr/bin/bash
# This script was created to take output from nagios and send alerts via slack.

#Modify these variables for your environment
MY_NAGIOS_HOSTNAME='nagios.local' # Your nagios host
SLACK_HOSTNAME='whatever.slack.com' # Your slack team
SLACK_TOKEN='slacktoken' # Your slack token
SLACK_CHANNEL='#whatever' # Your slack channel
SLACK_BOTNAME=',mybot'  # Your slack bot
SLACK_USERNAME='Nagios' # Whatever never you want to see in slack 
SLACK_WEBHOOKURL='https://hooks.slack.com/services/slacktoken' # Your slack webhookurl

TYPE="${1}" # This is not NAGIOS TYPE is used at the local script, if the alert is about service or host.

# Case about service   
if [[ "${1}" = '-s' ]]
    then
        HOST="${2}"
        STATE="${3}"
        TEXT="${4}"
        SERV="${5}"
        NOTIF="${6}"

        # Set the message icon based on Nagios service state
        if [[ "${STATE}" = "CRITICAL" ]]
            then
                ICON=':exclamation:'
        elif [[ "${STATE}" = "WARNING" ]]
            then
                ICON=':warning:'
        elif [[ "${STATE}" = "OK" ]]
            then
                ICON=':white_check_mark:'
        elif [[ "${STATE}" = "UNKNOWN" ]]
            then
                ICON=':question:'
        else
            ICON=':white_medium_square:'
       fi

       # Send message to Slack
       curl -X POST --data "payload={\"channel\": \"${SLACK_CHANNEL}\", \"username\": \"${SLACK_USERNAME}\", \"text\": \"${ICON} NOTIFICATION: ${NOTIF} HOST: ${HOST}   SERVICE: ${SERV}     MESSAGE: ${TEXT} <https://${MY_NAGIOS_HOSTNAME}/nagios/cgi-bin/status.cgi?host=${HOST}|See Nagios>\"}" "${SLACK_WEBHOOKURL}"

# Case about host
elif [[ "${1}" = '-h' ]]
    then
    	HOST="${2}"
    	STATE="${3}"
    	TEXT="${4}"
    	NOTIF="${5}"

        # Set the message icon based on Nagios host state
        if [[ "${STATE}" = "CRITICAL" ]]
            then
                ICON=':exclamation:'
        elif [[ "${STATE}" = "WARNING" ]]
            then
                ICON=':warning:'
        elif [[ "${STATE}" = "OK" ]]
            then
                ICON=':white_check_mark:'
        elif [[ "${STATE}" = "UNKNOWN" ]]
            then
                ICON=':question:'
        else
            ICON=':white_medium_square:'
       fi

       # Send message to Slack 
       curl -X POST --data "payload={\"channel\": \"${SLACK_CHANNEL}\", \"username\": \"${SLACK_USERNAME}\", \"text\": \"${ICON} ALERT: ${NOTIF} HOST: ${HOST}   STATE: ${STATE}     MESSAGE: ${TEXT} <https://${MY_NAGIOS_HOSTNAME}/nagios/cgi-bin/status.cgi?host=${HOST}|See Nagios>\"}" "${SLACK_WEBHOOKURL}"
       
else
    echo "${date} -- Something went wrong at execution.The ${#} arguments taken were ${@}" >> /tmp/nag2slack.log
fi