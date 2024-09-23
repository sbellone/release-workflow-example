#!/bin/bash

set -e

OWNER=sbellone
REPO=release-workflow-example
PRIVATE_KEY_FILE=/tmp/gh_deploy_key_${REPO}

echo "Fetching public key of repo ${OWNER}/${REPO}..."
PUBLIC_KEY_RESPONSE=$(gh api /repos/${OWNER}/${REPO}/actions/secrets/public-key)
PUBLIC_KEY_ID=$(echo ${PUBLIC_KEY_RESPONSE} | jq -r .key_id)
PUBLIC_KEY=$(echo ${PUBLIC_KEY_RESPONSE} | jq -r .key)

echo "Generating SSH Key..."
ssh-keygen -t ed25519 -C "github-actions@github.com" -f ${PRIVATE_KEY_FILE} -N ""

echo "Encrypting private key using public key (id=${PUBLIC_KEY_ID})..."
npm install --silent
ENCRYPTED_KEY=$(node encrypt-deploy-key.js ${PUBLIC_KEY} ${PRIVATE_KEY_FILE})

echo "Creating \"generated-deploy-key\" deploy key..."
gh api \
  --method POST \
  /repos/${OWNER}/${REPO}/keys \
  -f "title=generated-deploy-key" -f "key=$(cat ${PRIVATE_KEY_FILE}.pub)"

echo "Updating DEPLOY_KEY secret..."
gh api \
  --method PUT \
  /repos/${OWNER}/${REPO}/actions/secrets/DEPLOY_KEY \
  -f "encrypted_value=${ENCRYPTED_KEY}" -f "key_id=${PUBLIC_KEY_ID}"

echo "Done."
echo "You can remove the old deploy key and the generated SSH key (${PRIVATE_KEY_FILE})."
