#!/bin/sh

licenseDebug=$1

function logOutput {
    if [ "$licenseDebug" == "1" ]; then 
        echo "$1"
    fi
}

function getVersion {
    unset LICENSE_SOFTWARE_VERSION
    LICENSE_SOFTWARE_VERSION=$(cat /var/www/solodev/version.txt)
    logOutput "Detected Version: $LICENSE_SOFTWARE_VERSION"
}

function getEnvVarData {
    echo -n '{"bash_license_script":"true"'
    printenv | while IFS='=' read n v; do
        if [ "$n" = "HOSTNAME" ]; then
             echo -n ",\"envHostname\":\"${v}\""
        fi
    done
    echo "}"
}

function getMachineInfo {
    metadata=$(getEnvVarData)
    metadata=$(echo "${metadata:1:-1}")

    ec2Metadata=$(TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"` && curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/dynamic/instance-identity/document 2>/dev/null | tr -d '\040\011\012\015')
    if [[ -z "$ec2Metadata" ]] || [ "$ec2Metadata" = "" ]; then
        logOutput "NOT ON AMAZON EC2"
    else
        ec2Metadata=$(echo "${ec2Metadata:1:-1}")
        metadata=$(echo "${metadata},${ec2Metadata}")
        logOutput "WE ARE ON AMAZON EC2"
    fi

    unset LICENSE_META_DATA
    LICENSE_META_DATA=$(echo "{$metadata}")
}

function callLicenseServer {
    getVersion
    getMachineInfo
    
    local encodedMetadata=$(echo $LICENSE_META_DATA | php -r 'echo urlencode(fgets(STDIN));')

    local licenseURL="https://license.solodev.org/authorize/?version=${LICENSE_SOFTWARE_VERSION}&signature=${LICENSE_SIGNATURE}&metadata=$encodedMetadata"
    
    logOutput "LICENSE URL"
    logOutput "$licenseURL"
    
    local licenseResponse=$(curl $licenseURL 2>/dev/null)

    logOutput "LICENSE RESPONSE"
    logOutput "$licenseResponse"
    license=$(echo "$licenseResponse" | grep -o '"license":"[^"]*' | grep -o '[^"]*$')

    local needle="LICENSE FILE DATA"

    if [ "${license}" != "${license/${needle}/}" ]; then
        logOutput  "Writing license to /var/www/solodev/license.txt"
        echo "$license" | sed 's/\\n/\n/g' > /var/www/solodev/license.txt
    else
        logOutput "License response did not contain valid license. Not writing to license file."
    fi
    #write license to file
}

logOutput "Check License - started: $(date +'%D %T')"

callLicenseServer