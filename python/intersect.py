#!/usr/bin/env python

s1 = "linux"
s2 = "unix"
l = []

for x in s1:
    if x in s2:
        l.append(x)

print(l)
