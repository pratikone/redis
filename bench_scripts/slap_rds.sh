#!/usr/bin/env bash

# Please change this according to your redis installation
RDS_HOME="/root/dss/memstores/redis-3.2.5/src"

# Specify test case using the 1st cmd line argument;
# by default it is set hashtable
TEST="set"
if [[ $# -gt 1 ]]; then
	TEST=$1
fi

#for setting in `ls ${workload_spec}`
for valSz in 16 32 64 128; do
	for objNum in 100000 1000000 10000000; do
		# kill redis first
		pkill redis-server
		sleep 0.3
		#pkill redis-cli
		#sleep 0.3
		# Relaunch redis
		echo "launch redis-server"
		${RDS_HOME}/redis-server ./redis.conf > /dev/null &
		sleep 1
		# Use redis-cli to record traces for accurate raw data sz profiling
		echo "launch redis-cli monitor"
		${RDS_HOME}/redis-cli monitor > /tmp/rds_raw.dat &
		sleep 1

		echo "valSz=$valSz, objNum=$objNum"
		${RDS_HOME}/redis-benchmark -t $TEST -n $objNum -r 100000000 > /dev/null
		sleep 0.3

		./get_rss.py -b redis-server
		sleep 0.3
		# I use this awk script to output stats but you can also use redis-cli
		# to fetch memory info
		./rds_trace_parser.awk -v val_sz=$valSz /tmp/rds_raw.dat
		sleep 0.3
		# Redis set test: element size is 20 bytes
		#total_raw=`echo "scale=4;20*$objNum"|bc -l`
		#echo "total_num_records= ${objNum}"
		#echo "total_raw_data_sz= ${total_raw}"

		${RDS_HOME}/redis-cli flushall > /dev/null
		sleep 1

		echo ""
	done
done

pkill redis-server
sleep 0.3
pkill redis-cli
