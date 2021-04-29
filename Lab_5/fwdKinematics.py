# fwdKinematics: Return the locations of the tool end and the second arm origin based on the joint angles and lengths of
# the 2-link arm
#
#    p_world_tool[0:2], p_2[0:2] = fwdKinematics(length_1, length_2, theta_1, theta_2) Uses rot2D and trans2D to
#    calculate the position of the join and end of tool. Each arm rotates
#
#    Parameters
#    length_1 = length of first arm
#    length_2 = length of second arm
#    theta_1 = rotation of first arm
#    theta_2 = rotation at the joint b/t arms 1 and 2
#
#    Returns
#    p_world_tool[0:2] = x, y coordinates of the tool's end position
#    p_2[0:2] = x, y coordinates of the second arm origin
#
#    Author: Jacob Hoffer
#    Date: 04/29/2021

import numpy as np

from trans2D import *
from rot2D import *


def fwdKinematics(length_1, length_2, theta_1, theta_2):

    p_tool_tool = np.array([0, 0, 1]).T

    t_1_tool = trans2D(0, length_1, 0)

    t_2_tool = trans2D(0, length_2, 0)
    t_1_2 = trans2D(theta_2, length_1, 0)
    t_w_1 = trans2D(theta_1, 0, 0)

    p_2 = t_w_1 @ t_1_tool @ p_tool_tool
    p_world_tool = t_w_1 @ t_1_2 @ t_2_tool @ p_tool_tool

    return p_world_tool[0:2], p_2[0:2]
