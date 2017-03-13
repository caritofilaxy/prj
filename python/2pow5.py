#!/usr/bin/env python

L = [1, 2, 4, 8, 16, 32, 64]
x = 5

#for i in L:
#    if (2**x) == i:
#            print((2**x), 'found at', L.index(i))
#            break
#else:
#    print(x, 'not found')

if (2**x) in L:
    print(L.index(2**x))
else:
    print(x, 'not found')
