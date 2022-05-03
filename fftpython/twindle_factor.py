#!/usr/bin/env python

import math 

## Calcualte the twindle factors

def find_twindle_factors(S):
    for i in range(0,S//2):
        print("Twindle_factor:",i)
        print("Cos:",round(math.cos(-2*math.pi*i/S),0),end=" ")
        print("\t\tCos without rounding:",math.cos(-2*math.pi*i/S))
        
        print("Sin:",round(math.sin(-2*math.pi*i/S),0),end=" ")
        print("\t\tSin without rounding:",math.sin(-2*math.pi*i/S))

if __name__ == '__main__':
    find_twindle_factors(4)

