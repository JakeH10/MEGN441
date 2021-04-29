# rot2D: Return the 2x2 matrix for the rotation about the z-axis by theta radians
#
#    rotation_matrix = rot2D(theta) the rotation matrix is found by substituting theta, in radians, into a numpy array.
#    The numpy array is a 2x2 matrix of sin and cos. The result is the rotation matrix.
#
#    Parameters
#    theta = radians to rate around z-axis
#
#    Returns
#    rotation_matrix = the rotation matrix
#
#    Author: Jacob Hoffer
#    Date: 04/29/2021

import numpy as np


def rot2D(theta):

    rotation_matrix = np.array([[np.cos(theta), -np.sin(theta)], [np.sin(theta), np.cos(theta)]])

    return rotation_matrix
