#!/usr/bin/env python

import numpy as np

# x_time = np.array([-0.625-0.875j,-0.9375-1j,0.75+0.625j,0.78125+0.75j])
# x_time = np.array([0+0j,-1-1j,0.5+0.5j,0.75+0.75j])

x_time = np.array([-0.625-0.875j,-0.9375-1j,0.75+0.625j,0.78125+0.75j,-0.625-0.875j,-0.5-0.75j,-0.25-0.375j,0.75-0.25j])
x = np.fft.fft(x_time)
for i in range(len(x)) :
    ## Depending on the number of the array 
    # if 4 = 2^2 (inputs) => 2^2 = 4 (divisor)
    print(x[i]/8)
    # print(x[i]/4)
