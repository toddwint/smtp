#!/usr/bin/env bash
SCRIPTDIR="$(dirname "$(realpath "$0")")"

# Check that files exist first
FILES=("config.txt" "templates/webadmin.html.template")
for FILE in "${FILES[@]}"; do
    if [ ! -f "${SCRIPTDIR}/${FILE}" ]; then
            echo "File not found: ${FILE}"
            echo "Cannot continue. Exiting script."
            exit 1
    fi
done

# Then start by importing environment file
source "${SCRIPTDIR}"/config.txt

# Copy config.txt to .env
echo "Creating container: ${HOSTNAME}"
cp "${SCRIPTDIR}/config.txt" "${SCRIPTDIR}/.env"
echo "Copied config.txt to .env"

# Create the docker network and management macvlan interface
echo '- - - - -'
echo "Creating docker network: ${INTERFACE}-macvlan"
docker network create -d macvlan --subnet=${SUBNET} --gateway=${GATEWAY} \
    --aux-address="mgmt_ip=${MGMTIP}" -o parent="${INTERFACE}" \
    --attachable "${INTERFACE}-macvlan"
echo "Creating management network: ${INTERFACE}-macvlan"
sudo ip link add "${INTERFACE}-macvlan" link "${INTERFACE}" type macvlan mode bridge
sudo ip link set "${INTERFACE}-macvlan" up
sudo ip addr add "${MGMTIP}/32" dev "${INTERFACE}-macvlan"
sudo ip route add "${SUBNET}" dev "${INTERFACE}-macvlan"
echo "Added routes from management network to docker network"

# Create the docker container
echo '- - - - -'
echo "Starting container: ${HOSTNAME}"
docker run -dit \
    --name "${HOSTNAME}" \
    --network "${INTERFACE}-macvlan" \
    --ip "${IPADDR}" \
    -h "${HOSTNAME}" \
    -p "${IPADDR}:25:25" \
    -p "${IPADDR}:${HTTPPORT1}:${HTTPPORT1}" \
    -p "${IPADDR}:${HTTPPORT2}:${HTTPPORT2}" \
    -p "${IPADDR}:${HTTPPORT3}:${HTTPPORT3}" \
    -p "${IPADDR}:${HTTPPORT4}:${HTTPPORT4}" \
    -e TZ="${TZ}" \
    -e DOMAINNAME="${DOMAINNAME}" \
    -e HTTPPORT1="${HTTPPORT1}" \
    -e HTTPPORT2="${HTTPPORT2}" \
    -e HTTPPORT3="${HTTPPORT3}" \
    -e HTTPPORT4="${HTTPPORT4}" \
    -e HOSTNAME="${HOSTNAME}" \
    -e APPNAME="${APPNAME}" \
    "toddwint/${APPNAME}"

# Create the webadmin html file from template
echo '- - - - -'
HTMLTEMPLATE="${SCRIPTDIR}"/templates/webadmin.html.template
HTMLFILE="${SCRIPTDIR}"/webadmin.html
cp "${HTMLTEMPLATE}" "${HTMLFILE}"
sed -Ei 's/hostname/'"${HOSTNAME}"'/gi' "${HTMLFILE}"
sed -Ei 's/\bIPADDR:HTTPPORT1\b/'"${IPADDR}"':'"${HTTPPORT1}"'/g' "${HTMLFILE}"
sed -Ei 's/\bIPADDR:HTTPPORT2\b/'"${IPADDR}"':'"${HTTPPORT2}"'/g' "${HTMLFILE}"
sed -Ei 's/\bIPADDR:HTTPPORT3\b/'"${IPADDR}"':'"${HTTPPORT3}"'/g' "${HTMLFILE}"
sed -Ei 's/\bIPADDR:HTTPPORT4\b/'"${IPADDR}"':'"${HTTPPORT4}"'/g' "${HTMLFILE}"
sed -Ei 's/\bIPADDR:80\b/'"${IPADDR}"':80/g' "${HTMLFILE}"
echo "Added file: webadmin.html"

## Give the user instructions and offer to launch webadmin page
echo '- - - - -'
echo -e "Open the following file to manage this project: webadmin.html"
read -rp 'Would you like to open that file now? [Y/n]: ' ANSWER
if [ -z ${ANSWER} ]; then ANSWER='y'; fi
if [[ ${ANSWER,,} =~ ^y ]]
then
    firefox "${SCRIPTDIR}/webadmin.html" > /dev/null 2>&1 &
fi
