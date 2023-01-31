#!/bin/bash

set -e
source ./functions-lib-to-set-purview-permissions.sh; 

declare -A rolesMap
rolesMap["data_reader"]='set-data-reader' 
rolesMap["root_collection_admin"]='set-root-collection-admin' 
rolesMap["data_curator"]='set-data-curator' 
rolesMap["data_source_admin"]='set-data-source-admin' 
rolesMap["data_share_contributor"]='set-data-share-contributor' 
rolesMap["workflow_admin"]='set-workflow-admin' 

roles="${INPUT_ROLES}"

#Assign each role passed in the argument
for role in $roles
echo $role
do
  ${rolesMap[${role}]} "$INPUT_PURVIEW_NAME" "$INPUT_OBJECT_ID" "$INPUT_USER_TYPE"
done
