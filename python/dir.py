#!/usr/bin/env python

def dir1(x):
    print(x)
    return [a for a in dir(x) if not a.startswith('__')]

print(dir1(tuple))
print(dir1(list))
print(dir1(str))
print(dir1(set))
print(dir1(dict))

