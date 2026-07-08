#!/usr/bin/env sagemath
# -*- coding: utf-8 -*-
# Respect the shebang and mark file as executable

import os


def main():
    L = [3, [5, 1, 4, 2, 3], 17, 17, 3, 51]

    print(f"Hello {os.environ['SOCAT_PEERADDR']}:{os.environ['SOCAT_PEERPORT']}")

    print(f"Let me give you some integers coming directly sagemath: {L}")

    number = input("Give me input: ")
    print(f"Your input was {number}")

    # Check if sagemath-operators work as expected
    assert 3 ^ 2 == 9, "Sagemath-operators don't seem to work correctly!!"

    with open('/flag.txt', 'r') as flag:
        print(f"Here is your flag: {flag.read()}")

    exit(0)


if __name__ == '__main__':
    main()

# vim: filetype=python
