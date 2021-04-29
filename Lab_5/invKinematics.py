# invKinematics: Return the joint angles
#
#    theta_1, theta_2, reachable = invKinematics(L_1, L_2, x, y) Return the joint angles based on the provided arm
#    lengths and tool coordinates, and a Boolean representing if the point is reachable. (Non-reachable points have
#    imaginary numbers in their solutions for theta_1 and/or theta_2)
#
#    Parameters
#    L_1 = length of first arm
#    L_2 = length of second arm
#    x = tool x coordinate
#    y = tool y coordinate
#
#    Returns
#    theta_1 = rotation of first arm
#    theta_2 = rotation at the joint b/t arms 1 and 2
#    reachable = boolean to indicate if point is reachable given the parameters
#
#    Author: Jacob Hoffer
#    Date: 04/29/2021

import numpy as np


def invKinematics(L_1, L_2, x, y):

    num = 2 * L_1 * L_2 + L_1**2 + L_2**2 - x**2 - y**2
    den = 2 * L_1 * L_2 - L_1**2 - L_2**2 + x**2 + y**2

    value = round(num / den, 6)
    if value < 0:
        return 0, 0, 0
    value = np.sqrt(value)
    theta_2 = 2 * np.arctan(value * np.array([1, -1]))
    theta_2 = theta_2[np.isreal(theta_2)]

    if theta_2.size == 0:
        reachable = False
    else:
        reachable = True
        theta_2 = theta_2[0]

    theta_1 = np.arctan2(y, x) - np.arctan2(L_2 * np.sin(theta_2), L_1 + L_2 * np.cos(theta_2))

    while theta_1 < 0:
        theta_1 += 2 * np.pi

    theta_1 = theta_1[np.isreal(theta_1)]
    if theta_1.size == 0:
        reachable = False
    else:
        reachable = True

    return theta_1, theta_2, reachable
