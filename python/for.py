#!/usr/bin/env python

l= ['e', 'pi', 2.7, 'euler', 3.14, 1.41, 1.618, 42, 21]

for x in l:
    print(x)
    if x == 'euler':
        print('euler found')
        break
else:
        print('euler not found')
        
