#!/usr/bin/env python

import psutil, sys, getopt

# yue: use psutil to fetch process mem info
def fetch_rss(proc_name):
	for proc in psutil.process_iter():
		#pinfo = proc.as_dict(attrs=['pid', 'name'])
		#print proc.name()
		if proc.name() == proc_name:
			print proc.memory_info()

if __name__ == "__main__":
	binary = ''
	try:
		opts, args = getopt.getopt(sys.argv[1:], "hb:")
	except getopt.GetoptError:
		print 'test.py -b <binary_name>'
		sys.exit(2)
	for opt, arg in opts:
		if opt == '-h':
			print 'test.py -b <binary_name>'
		elif opt == '-b':
			binary = arg
	
	fetch_rss(binary)
