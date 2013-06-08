#!/usr/bin/env python

import sys

# template definitions
datapt_t = """ <datapt y="{yval}" >
{xinputs} </datapt>\n"""
xinput_t = """   <xinput index="{idx}" value="{val}" />\n"""

# get the input argument for the file name
filename = sys.argv[1]

# open the file
with open(filename, 'r') as fh:
  lines = fh.read().splitlines()

# loop around lines
dataList = [] 
n_pts = 0
for line in lines:
  sline = line.split()
  dataList.append({'yval':float(sline[0])})
  dataList[n_pts].update({'xinputs':[]})
  del sline[0]
  for inputset in sline:
    aset = inputset.split(':')
    dataList[n_pts]['xinputs'].append({'idx':aset[0],'val':aset[1]})
  n_pts += 1

outStr = """<?xml version="1.0" encoding="UTF-8"?>\n"""
outStr += "<data>\n"
outStr += "\n"

for data in dataList:
  xinputs = ""
  for xinput in data['xinputs']:
    xinputs += xinput_t.format(**xinput)
  data['xinputs'] = xinputs
  outStr += datapt_t.format(**data)
  outStr += "\n"
outStr += "</data>"

# write file
with open(filename+'.xml','w') as fh:
  fh.write(outStr)
