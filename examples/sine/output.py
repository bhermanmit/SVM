with open('output','r') as fh:
	lines = fh.read().splitlines()

with open('sine_data','r') as fh:
	linesx = fh.read().splitlines()

outstr = ""

i = 0

while i < 300:
	sline = lines[i].split()
	slinec = linesx[i].split(':')
 	slinex = slinec[0].split()
	slinec1 = linesx[i+300].split(':')
	slinex1 = slinec1[0].split()
	outstr += slinec[1] + " "  + slinec1[1] + " " + slinex[0] + " " + sline[1] + " " + sline[2] + "\n"
	i += 1

with open('data.dat', 'w') as fh:
	fh.write(outstr)
