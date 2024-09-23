#!/bin/sh
wait_project() {
   sleep 15
   timeElapsed=0
   while true; do
      elasticHealth=$(kubectl get elasticsearch -A -o jsonpath='{.items[0].status.health}' | xargs)
      kibanaHealth=$(kubectl get kibana -A -o jsonpath='{.items[0].status.health}' | xargs)
      if [[ $elasticHealth == "green" && $kibanaHealth == "green" ]]; then
         break
      fi
      sleep 5
      timeElapsed=$(($timeElapsed+5))
      if [[ $timeElapsed -ge 700 ]]; then
         exit 1
      fi
   done
   sleep 30 # Sleep an additional 30 seconds to give upgrade time to roll pods
}
