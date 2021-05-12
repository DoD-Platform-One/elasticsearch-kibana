#!/bin/bash
set -ex

echo "Hitting Elasticsearch API endpoint..."
curl -skISu "elastic:${ELASTIC_PASSWORD}" "${elasticsearch_host}/" &>/dev/null || export ES_DOWN="true"
if [[ ${ES_DOWN} == "true" ]]; then
  echo "Test 1 Failure: Cannot hit Elasticsearch endpoint."
  echo "Debug information (curl response):"
  echo $(curl -ku "elastic:${ELASTIC_PASSWORD}" "${elasticsearch_host}")
  exit 1
fi
echo "Test 1 Success: Elasticsearch is up."

echo "Checking Elasticsearch Version..."
elasticsearch_response=$(curl -sS -ku "elastic:${ELASTIC_PASSWORD}" "${elasticsearch_host}/")
elasticsearch_version=$(echo ${elasticsearch_response} | jq '.version.number' | xargs)
curl -sS -ku "elastic:${ELASTIC_PASSWORD}" "${elasticsearch_host}_cluster/health?pretty" &>/dev/null || export ES_UNHEALTHYc="true"
if [ ! ${desired_version} ==  ${elasticsearch_version} ]; then
  echo "Test 2 Failure: Elasticsearch version does not match."
  echo "Debug information (deployed build info):"
  echo "${elasticsearch_response}"
  exit 1
fi
echo "Test 2 Success: Elasticsearch version matches."

echo "Checking Elasticsearch Indexes..."
indices_response=$(curl -sSku "elastic:${ELASTIC_PASSWORD}" "${elasticsearch_host}/_cluster/stats" 2>/dev/null)
indices_present=$(echo ${records_response} | jq '.indices.count')
if [ ! ${indices_present} -gt 0 ]; then
  echo "Test 3 Failure: Elasticsearch does not have any indices."
  echo "Debug information (metrics response):"
  echo "${indices_response}" | jq
  exit 1
fi
echo "Test 3 Success: Elasticsearch has ${indices_present} indices."

echo "Checking Elasticsearch Documents..."
docs_response=$(curl -sSku "elastic:${ELASTIC_PASSWORD}" "${elasticsearch_host}/_cluster/stats" 2>/dev/null)
docs_present=$(echo ${records_response} | jq '.indices.docs.count')
if [ ! ${docs_present} -gt 0 ]; then
  echo "Test 3 Failure: Elasticsearch does not have any documents."
  echo "Debug information (metrics response):"
  echo "${docs_response}" | jq
  exit 1
fi
echo "Test 4 Success: Elasticsearch has ${docs_present} documents."
