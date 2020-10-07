#!/usr/bin/python3
# -*- coding: utf-8 -*-

import Sofa.Core
import subprocess
import os

# type_string: short asset description string
type_string = 'Tetrahedral volumetric mesh'

# icon_path: url of the asset icon
icon_path = 'qrc:/icon/ICON_MESH.png'

# Used for Python scripts, determines whether it is sofa content or not
is_sofa_content = False

# Method called to instantiate the asset in the scene graph.
def create(node, assetName, assetPath):
    node.addObject('MeshVTKLoader', name=assetName, filename=assetPath)

def primitiveType(assetPath):
    return "Tethrahedron"
