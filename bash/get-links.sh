#!/bin/bash

for beer in $(cat ./categories); do
  cat /dev/null > ./links/${beer}.txt
  for i in {1..36}; do
    curl -s "https://carttocar.com/bier-station/?product-page=${i}" | grep -A 2 instock | egrep -A 2 "product_cat.*${beer}" | grep href | cut -f2 -d \" | egrep "pack\/$|pk\/$" | egrep -v "non-alcoholic|nonalcoholic" | sort | uniq >> ./links/${beer}.txt
  done
done
