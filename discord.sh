#!/bin/sh

source /.envvars
SERVICE_URL="https://localhost:8443/"

# color codes examples: https://gist.github.com/deflax/e4fe4cced12103819c2663e2369911a5

while read LINE ; do
    PRIO=`echo ${LINE} | cut -d ' ' -f 1`
    if [ "${PRIO}" = "27" ] ; then
        #test client notice - dark green
        COLOR=2067276
    elif [ "${PRIO}" = "134" ] ; then
        #hpilo notice - grey
        COLOR=9807270
    else
        #fallback to dark orange
        COLOR=11027200
    fi
    SUBJECT=`echo ${LINE} | cut -d ' ' -f 2`
    MESSAGE=`echo ${LINE} | cut -d ' ' -f 3-`

    PAYLOAD=`printf "{ \"embeds\": [{\"title\": \"%s\", \"url\": \"%s\", \"description\": \"%s\", \"type\": \"link\", \"color\": %s }] }" "${SUBJECT}" "${SERVICE_URL}" "${MESSAGE}" "${COLOR}"`
    echo ${PAYLOAD} > /var/log/discord.payload
    HTTP_RESPONSE=`curl --write-out %{http_code} --silent --output /dev/null -X POST -H "Content-Type: application/json" -d @/var/log/discord.payload ${DISCORD_WEBHOOK}`

    if [[ "${HTTP_RESPONSE}" != "204" ]] ; then
        echo "Received HTTP-Code: ${HTTP_RESPONSE}" >> /var/log/discord.log
    fi
done