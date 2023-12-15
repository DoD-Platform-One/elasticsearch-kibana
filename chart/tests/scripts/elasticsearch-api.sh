#!/bin/bash
set -ex

# Give it some time for networking to be ready
sleep 15

echo "Hitting Elasticsearch API endpoint..."
curl --retry-delay 5 --retry-max-time 600 --retry 60 --retry-connrefused -skISu "elastic:${ELASTIC_PASSWORD}" "${elasticsearch_host}/" &>/dev/null || export ES_DOWN="true"
if [[ ${ES_DOWN} == "true" ]]; then
  echo "Test 1 Failure: Cannot hit Elasticsearch endpoint."
  echo "Debug information (curl response):"
  echo $(curl -ku "elastic:${ELASTIC_PASSWORD}" "${elasticsearch_host}")
  exit 1
fi
echo "Test 1 Success: Elasticsearch is up."

echo "Hitting Elasticsearch API endpoint..."
health_response=$(curl -sSku "elastic:${ELASTIC_PASSWORD}" "${elasticsearch_host}/_cluster/health" 2>/dev/null)
elasticsearch_health=$(jq -r .status <<< "${health_response}")
if [[ ${elasticsearch_health} != "green" ]]; then
  echo "Test 2 Failure: Elasticsearch is not Healthy."
  echo "Debug information (curl response):"
  echo $(curl -ku "elastic:${ELASTIC_PASSWORD}" "${elasticsearch_host}/_cluster/health?pretty")
  exit 1
fi
echo "Test 2 Success: Elasticsearch is Healthy."

echo "Checking Elasticsearch Version..."
elasticsearch_response=$(curl -sS -ku "elastic:${ELASTIC_PASSWORD}" "${elasticsearch_host}/")
elasticsearch_version=$(jq -r .version.number <<< "${elasticsearch_response}")
if [ ! ${desired_version} ==  ${elasticsearch_version} ]; then
  echo "Test 2 Failure: Elasticsearch version does not match."
  echo "Debug information (deployed build info):"
  echo "${elasticsearch_response}"
  exit 1
fi
echo "Test 3 Success: Elasticsearch version matches."
