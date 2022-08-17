#!/bin/sh
wait_project() {
   timeElapsed=0
   while true; do
      sleep 50
      elasticHealth=$(kubectl get elasticsearch -A -o jsonpath='{.items[0].status.health}' | xargs)
      kibanaHealth=$(kubectl get kibana -A -o jsonpath='{.items[0].status.health}' | xargs)
      if [[ $elasticHealth == "green" && $kibanaHealth == "green" ]]; then
         break
      fi
      sleep 5
      timeElapsed=$(($timeElapsed+5))
      if [[ $timeElapsed -ge 600 ]]; then
         exit 1
      fi
   done
}
