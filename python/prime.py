#!/usr/bin/env python
y = int(input())
#for y in range(5000):

x = y // 2
while x > 1:
    if y % x == 0:
        break
    x -= 1
else:
    print(y, end=' ',flush=True)
 
print()
