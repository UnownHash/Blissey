#!/bin/bash

folder="$(pwd)"
source $folder/config.ini

echo ""
echo 'Please select a job'
echo ""
n=0
for job in $(curl -s $host:$port/api/job/list | grep -oP '(?<=id":").*?(?=")')
do
    n=$((n+1))
    printf "[%s] %s\n" "$n" "$job"
    eval "job${n}=\$job"
done

if [ "$n" -eq 0 ]
then
    echo >&2 No jobs found
    exit
fi
echo ""
printf 'Enter job number (1 to %s): ' "$n"
read -r num
num=$(printf '%s\n' "$num" | tr -dc '[:digit:]')

if [ "$num" -le 0 ] || [ "$num" -gt "$n" ]
then
    echo >&2 Wrong selection.
    exit 1
else
    eval "JOB=\$job${num}"
    echo Selected job is "$JOB"
fi

echo ""
echo ""
echo 'Please select a origin'
echo ""
n=0
for origin in $(curl -s $host:$port/api/status | grep -oP '(?<=deviceId":").*?(?=")' | sort -u) All
do
    n=$((n+1))
    printf "[%s] %s\n" "$n" "$origin"
    eval "origin${n}=\$origin"
done

if [ "$n" -eq 0 ]
then
    echo >&2 No origins found
    exit
fi
echo ""
printf 'Enter origin number (1 to %s): ' "$n"
read -r num
num=$(printf '%s\n' "$num" | tr -dc '[:digit:]')

if [ "$num" -le 0 ] || [ "$num" -gt "$n" ]
then
    echo >&2 Wrong selection.
    exit 1
else
    eval "ORIGIN=\$origin${num}"
    echo Selected origin is "$ORIGIN"
fi

if [ $ORIGIN == "All" ]
then
  echo ""
  echo "Seconds between jobs"
  read -r jobwait
  echo ""
  for origin in $(curl -s $host:$port/api/status | grep -oP '(?<=deviceId":").*?(?=")' | sort -u)
  do
#    echo "executing: curl -X POST http://$host:$port/api/job/execute/$JOB/$origin"
    curl -s -X POST $host:$port/api/job/execute/$JOB/$origin
    echo ""
    echo "sleeping $jobwait seconds"
    sleep $jobwait\s
  done
else
  echo ""
  echo "executing: curl -X POST $host:$port:7072/api/job/execute/$JOB/$ORIGIN"
  echo ""
  curl -s -X POST $host:$port/api/job/execute/$JOB/$ORIGIN
fi
echo ""
echo "All done !!"
