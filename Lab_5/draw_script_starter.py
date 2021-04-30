import os
import numpy as np
import matplotlib.pyplot as plt

from rot2D import *
from trans2D import *
from fwdKinematics import *
from invKinematics import *
from savePathAsVideo import *


def draw_path():

    # Build your path as a list of x and y coordinates

    laterals = np.array([[0, -2.5], [-2.5, -2.5], [-2.5, -1.5], [-1.5, -1.5], [-1.5, -4.5], [-4.5, -4.5], [-4.5, -3.9],
                         [-3.9, -3.9], [-3.9, -4.5], [-4.5, -4.5], [-4.5, -2.2], [-2.2, 0]])
    verticals = np.array([[-1.8, 1.4], [1.4, -2.1], [-2.1, -2.1], [-2.1, -3.4], [-3.4, -3.4], [-3.4, -2], [-2, -2],
                          [-2, 2.6], [2.6, 2.6], [2.6, 3.9], [3.9, 3.9], [3.9, 0.9]])

    laterals = np.concatenate([laterals, -np.flip(laterals, (0, 1))], axis=0)
    verticals = np.concatenate([verticals, np.flip(verticals)], axis=0)

    x = np.concatenate([np.linspace(lateral[0], lateral[1], 5) for lateral in laterals])
    y = np.concatenate([np.linspace(vertical[0], vertical[1], 5) for vertical in verticals])

    x = np.concatenate([x, np.ones([1, 10])[0] * x[-1]])
    y = np.concatenate([y, np.ones([1, 10])[0] * y[-1]])

    # Choose the lengths of the arm links
    L_1 = 3
    L_2 = 3
    plot_size = L_1 + L_2 + 1

    # Preallocate arrays for theta_1, theta_2, P_tool, and P_2
    # theta_1 and theta_2 will be 1xn arrays, where n is the number of coordinate pairs
    # you made
    # P_tool and P_2 are 2xn arrays

    # for every coordinate
        # Call invKinematics to find the thetas to make the tooltip reach that point
        # Call fwdKinematics with your link lengths and found thetas to
        # find the P_tool and P_2 positions at each point

    coordinates = np.array([x, y]).T
    thetas = np.array([invKinematics(L_1, L_2, coord[0], coord[1]) for coord in coordinates])
    if not any(thetas[:, 2]):
        print('No angles exist to meet conditions')
        return

    positions = np.array([fwdKinematics(L_1, L_2, pair[0], pair[1]) for pair in thetas[:, :-1]])

    P_tool = positions[:, 0].T
    P_2 = positions[:, 1].T

    # Call savePathAs Video with inputs:
    # String of video name, including .mp4
    # The complete list of P_tool points as a 2xn array
    # The complete list of P_2 points as a 2xn array
    savePathAsVideo('Mines_M.mp4', P_tool, P_2)

    # Create an array of 0:n values to use as time
    t = np.arange(len(x))

    # Create a first plot window
    f1 = plt.figure(1)
    # Plot P_tool x vs time
    x_plot, = plt.plot(t, P_tool[0], 'b', label='x')
    # Plot P_tool y vs time
    y_plot, = plt.plot(t, P_tool[1], 'g', label='y')
    # Set axis size
    plt.axis([0, t[-1], -plot_size,  plot_size])
    # Add a legend
    plt.legend([x_plot, y_plot], ['x', 'y'])
    # Add a plot title and axis labels
    plt.title('X, Y, vs time')
    plt.xlabel('Time Steps')
    plt.ylabel('cm')
    # Turn on plot grid
    plt.grid(True)
    # Save this plot
    plt.savefig("x_y_time.png")

    # Using the syntax given for the 1st plots,
    # Repeat for theta_1 and theta_2 vs time
    # Create a second plot window
    f2 = plt.figure(2)
    # Plot theta_1 vs time
    theta_1_plot, = plt.plot(t, thetas[:, 0], 'b', label=r'$\theta_1$')
    # Plot theta_2 vs time
    theta_2_plot, = plt.plot(t, thetas[:, 1], 'g', label=r'$\theta_2$')
    # Set axis size
    plt.axis([0, t[-1], 0, 7])
    # Add a legend
    plt.legend([theta_1_plot, theta_2_plot], [r'$\theta_1$', r'$\theta_2$'])
    # Add a plot title and axis labels
    plt.title(r'$\theta_1$, $\theta_2$, vs time')
    plt.xlabel('Time Steps')
    plt.ylabel('radians')
    # Turn on plot grid
    plt.grid(True)
    # Save this plot
    plt.savefig("theta_time.png")


if __name__ == '__main__':
    draw_path()
