"""
--------e--------
------e-d-e------
----e-d-c-d-e----
--e-d-c-b-c-d-e--
e-d-c-b-a-b-c-d-e
--e-d-c-b-c-d-e--
----e-d-c-d-e----
------e-d-e------
--------e--------
"""

n = 5

for i in range(1, n + 1):
    char_i = n + 1 - i
    cntr = 0
    for j in range(1, n + 1):
        if j > char_i - 1 and j != n:
            print(chr(96 + n - cntr) + '-', end='')
            cntr += 1
        elif j == n:
            print(chr(96 + char_i), end='')
        else:
            print('--', end='')
    cntr = i - 1
    for j in range(0, n - 1):
        if cntr:
            print('-' + chr(96 + n + 1 - cntr), end='')
            cntr -= 1
        else:
            print('--', end='')

    print()

# print()
"""
--e-d-c-b-c-d-e--
----e-d-c-d-e----
------e-d-e------
--------e--------
"""
for i in range(0, n - 1):
    for j in range(0, n):
        if j == n - 1:
            print(chr(ord('a') + 5 - j + i), end='')
        elif j < i + 1:
            print(('--'), end='')
        else:
            print(chr(ord('a') + 5 - j + i) + '-', end='')

    for j in range(1, n):
        if j < n - i - 1:
            print('-' + chr(ord('a') + i + 1 + j), end='')
        else:
            print(('--'), end='')

    print()
