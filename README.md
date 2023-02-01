# Github Action to Set Purview Permissions

This action allows you to assign purview permissions to a user or security group.

## Usage


### Sample Workflow
The action can be used in your github workflows like below:

```yaml
name: Test pipeline

on: [push]

permissions:
  id-token: write
  contents: read

jobs:   
  workflow-test:
    name: 'Set purview permissions with workflow'
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v3

      - name: 'Az login'
        uses: azure/login@v1
        with:
          creds: ${{ secrets.AZURE_CREDENTIALS }}

      - name: Set purview permissions
        uses: abeebu/purview-assign-permissions@v1
        with:
          purview_name: "Purview name"   # name of the purview account  
          object_id: "object-id"  # Object Id to assign permissions to
          user_type: "U" # 'U' for user and 'G' for security group
          roles: "data_reader,data_curator,data_share_contributor" # list of roles to assign separated by comma
```

## Supported Roles
The following roles are supported:
 - root_collection_admin
 - data_reader
 - data_curator
 - data_source_admin
 - data_share_contributor
 - workflow_admin
