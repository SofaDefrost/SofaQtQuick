#!/usr/bin/python3

import Sofa.Core


def convert(src):
    return [[i for i in src.value[0]] + [j for j in src.value[1]]]
