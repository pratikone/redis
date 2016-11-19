#!/usr/bin/awk -f

BEGIN {
	num_records = 0
	total_key_sz = 0
	print "val_sz=", val_sz
}
{
	if ($4 == "\"SET\"") {
		total_key_sz = total_key_sz + length($5) - 2
		#key = substr($3, 5, 10)
		#idx = match($0, /\[ field0=.+\]/)
		#value = substr($0, idx+9, 32)
		#print "put", value, "into", key
		#print "key_sz=", length($5)-2
		num_records++
	} else if ($1 == "\"GET\"") {
		total_key_sz = total_key_sz + length($5)
		#key = substr($3, 5, 10)
		#print "get from", key
		num_records++
	} else if ($1 == "UPDATE") {
		total_key_sz = total_key_sz + length($5)
		#key = substr($3, 5, 10)
		#idx = match($0, /\[ field0=.+\]/)
		#value = substr($0, idx+9, 32)
		#print "put", value, "into", key
		num_records++
	}
}
END{
	print "total_num_records=", num_records
	#print "total_raw_data_sz=", total_key_sz+num_records*ARGV[1]
	print "total_raw_data_sz=", total_key_sz+num_records*val_sz
}
