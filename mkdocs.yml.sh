#!/bin/bash

# To merge Client config into TACC config as New config
yq eval '. *d load("mkdocs-tacc-client.yml")' mkdocs-tacc.yml > mkdocs.yml

# To replace `nav` array of New config with that from Client config
yq eval-all 'select(fileIndex==0).nav = select(fileIndex==1).nav | select(fileIndex==0)' mkdocs.yml mkdocs-tacc-client.yml > temp.yml && mv temp.yml mkdocs.yml
