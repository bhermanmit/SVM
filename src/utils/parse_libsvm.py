#!/usr/bin/env python

import sys

# template definitions
traindata_t = """ <traindata yvalue="{yval}" id="{id}">
{xinputs} </traindata>\n"""
testdata_t = """ <testdata yvalue="{yval}" id="{id}">
{xinputs} </testdata>\n"""
xinput_t = """   <xinput index="{idx}" value="{val}" />\n"""

# get the input argument for the file name
filename = sys.argv[1]
n_train = int(sys.argv[2])

# open the file
with open(filename, 'r') as fh:
  lines = fh.read().splitlines()

# loop around lines
traindataList = []
testdataList = []
dataList = traindataList
n_pts = 0
for line in lines:
  if n_pts == n_train:
    n_pts = 0
    dataList = testdataList
  sline = line.split()
  dataList.append({'yval':float(sline[0]),'id':n_pts+1})
  dataList[n_pts].update({'xinputs':[]})
  del sline[0]
  for inputset in sline:
    aset = inputset.split(':')
    dataList[n_pts]['xinputs'].append({'idx':aset[0],'val':aset[1]})
  n_pts += 1

outStr = """<?xml version="1.0" encoding="UTF-8"?>\n"""
outStr += "<data>\n"
outStr += "\n"

for data in traindataList:
  xinputs = ""
  for xinput in data['xinputs']:
    xinputs += xinput_t.format(**xinput)
  data['xinputs'] = xinputs
  outStr += traindata_t.format(**data)
  outStr += "\n"
for data in testdataList:
  xinputs = ""
  for xinput in data['xinputs']:
    xinputs += xinput_t.format(**xinput)
  data['xinputs'] = xinputs
  outStr += testdata_t.format(**data)
  outStr += "\n"
outStr += "</data>"

# write file
with open('data.xml','w') as fh:
  fh.write(outStr)
