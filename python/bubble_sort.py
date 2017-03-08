#!/usr/bin/env python

l = [34, 12, 5, 24, 19, 58, 11, 85, 4, 22, 99, 63, 20, 74, 42]

for i in range(len(l)):
    for j in range(i+1, len(l)):
        if l[j] < l[i]:
            l[j], l[i] = l[i], l[j]

print(l)
