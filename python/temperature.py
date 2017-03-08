#!/usr/bin/env python

t = int(input("Degrees(C):"))

if t < 0:
    print('Ice')
elif 0 < t <= 10:
    print('Cold')
elif 10 < t <= 30:
    print('Warm')
elif 30 < t <= 50:
    print('Norm')
elif 50 < t <= 70:
    print('hot')
elif 70 < t <= 100:
    print('Danger!')
else:
    print('You are boiled. good bye')
