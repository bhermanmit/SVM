set terminal png
set output 'data.png' 
plot 'data.dat' using 1:3 with points lc rgb "red" title "TRAINING", \
     'data.dat' using 2:4 with points lc rgb "black" title "LIBSVM"
