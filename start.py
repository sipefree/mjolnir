#!/usr/bin/env python
import os
from sys import argv

mnesiadir = os.path.abspath("./db")
cmd = "erl -K true -pa ./ebin -boot start_sasl -config elog -setcookie hurrbotnet "

def myrun(it):
	print it
	os.system(it)

myrun(cmd + " ".join(argv[1:]))
