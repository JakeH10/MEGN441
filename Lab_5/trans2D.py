# trans2D: Return the 3x3 matrix for the transformation of a rotation of theta and the translation of (x,y)
#
#    transformation_matrix = trans2D(theta,x,y) the rotation matrix is found via rot2D. the matrix is converted to a 3x3
#    to make room for the translation. The third row will always return [0, 0, 1].
#
#    Parameters
#    theta = radians to rate around z-axis
#    x = distance to translate in the x direction
#    y = distance to translate in the y direction
#
#    Returns
#    transformation_matrix = rotation and translation of a point
#
#    Author: Jacob Hoffer
#    Date: 04/29/2021

import numpy as np

from rot2D import *


def trans2D(theta, x, y):

    rotation_matrix = rot2D(theta)
    translation_matrix = np.array([x, y]).T

    transformation_matrix = np.zeros((3, 3))
    transformation_matrix[:-1, :-1] = rotation_matrix
    transformation_matrix[:-1, -1] = translation_matrix
    transformation_matrix[-1] = np.array([0, 0, 1])

    return transformation_matrix
