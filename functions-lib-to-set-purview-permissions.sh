
#!/bin/bash

function set-permission() {
    # $1: purview account name
    # $2: identities string comma separated
    # $3: permission:
        # "0" root collection admin
        # "1" data reader
        # "2" data curator
        # "3" data source admin
        # "4" data share contributor
        # "5" workflow admin
    # $4: "override" if you want to re-write permission

    purview_access_token=$(az account get-access-token --resource https://purview.azure.net/ --query accessToken --output tsv)

    body=$(curl -s -H "Authorization: Bearer $purview_access_token" "https://$1.purview.azure.com/policystore/collections/$1/metadataPolicy?api-version=2021-07-01")
    metadata_policy_id=$(echo "$body" | jq -r '.id')   

    a=($(echo "$2" | tr ',' "\n"))
    identities=$(jq --compact-output --null-input '$ARGS.positional' --args -- "${a[@]}")

    if [ -z "$4" ]; then
        body=$(echo "$body" | jq --argjson perm "$3" --argjson identities "$identities" '.properties.attributeRules[$perm].dnfCondition[0][0].attributeValueIncludedIn += $identities ')
    else
        body=$(echo "$body" | jq --argjson perm "$3" --argjson identities "$identities" '.properties.attributeRules[$perm].dnfCondition[0][0].attributeValueIncludedIn = $identities ')
    fi

    # WARNING: Concurrent calls may lead to inconsistencies on the Purview permissions. Associated story: 5230
    curl -H "Authorization: Bearer $purview_access_token" -H "Content-Type: application/json" \
        -d "$body" -X PUT -i -s "https://$1.purview.azure.com/policystore/metadataPolicies/${metadata_policy_id}?api-version=2021-07-01" > /dev/null
}

function reset-permission() {
    # $1: purview account name
    # $2: permission:
        # "0" root collection admin
        # "1" data reader
        # "2" data curator
        # "3" data source admin
        # "4" data share contributor
        # "5" workflow admin

    purview_access_token=$(az account get-access-token --resource https://purview.azure.net/ --query accessToken --output tsv)

    body=$(curl -s -H "Authorization: Bearer $purview_access_token" "https://$1.purview.azure.com/policystore/collections/$1/metadataPolicy?api-version=2021-07-01")
    metadata_policy_id=$(echo "$body" | jq -r '.id')

    body=$(echo "$body" | jq --argjson perm "$2" '.properties.attributeRules[$perm].dnfCondition[0][0].attributeValueIncludedIn = [] ')

    curl -H "Authorization: Bearer $purview_access_token" -H "Content-Type: application/json" \
        -d "$body" -X PUT -i -s "https://$1.purview.azure.com/policystore/metadataPolicies/${metadata_policy_id}?api-version=2021-07-01" > /dev/null
}

function set-root-collection-admin() {
    # $1: purview account name
    # $2: identities string comma separated or empty string for reset
    # $3: "override" if you want to re-write permission

    echo "Setting root collection admin permissions"
    if [[ -z $2 ]]; then
        reset-permission "$1" "0"
    else
        set-permission "$1" "$2" "0" "$3"
    fi
}

function set-data-reader() {
    # $1: purview account name
    # $2: identities string comma separated or empty string for reset
    # $3: "override" if you want to re-write permission

    echo "Setting data reader permissions"
    if [[ -z $2 ]]; then
        reset-permission "$1" "1"
    else
        set-permission "$1" "$2" "1" "$3"
    fi
}

function set-data-curator() {
    # $1: purview account name
    # $2: identities string comma separated or empty string for reset
    # $3: "override" if you want to re-write permission

    echo "Setting data curator permissions"
    if [[ -z $2 ]]; then
        reset-permission "$1" "2"
    else
        set-permission "$1" "$2" "2" "$3"
    fi
}

function set-data-source-admin() {
    # $1: purview account name
    # $2: identities string comma separated or empty string for reset
    # $3: "override" if you want to re-write permission

    echo "Setting data source admin permissions"
    if [[ -z $2 ]]; then
        reset-permission "$1" "3"
    else
        set-permission "$1" "$2" "3" "$3"
    fi
}

function set-data-share-contributor() {
    # $1: purview account name
    # $2: identities string comma separated or empty string for reset
    # $3: "override" if you want to re-write permission

    echo "Setting data share contributor permissions"
    if [[ -z $2 ]]; then
        reset-permission "$1" "4"
    else
        set-permission "$1" "$2" "4" "$3"
    fi
}

function set-workflow-admin() {
    # $1: purview account name
    # $2: identities string comma separated or empty string for reset
    # $3: "override" if you want to re-write permission

    echo "Setting wokflow admin permissions"
    if [[ -z $2 ]]; then
        reset-permission "$1" "5"
    else
        set-permission "$1" "$2" "5" "$3"
    fi
}
