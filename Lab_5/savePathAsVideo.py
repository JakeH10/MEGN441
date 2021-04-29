# savePathAsVideo: plots a 2-link-arm over time, saves as video file
#
#   savePathAsVideo(video_name, P_tool,P_2): takes in a name for your video, the (x,y) positions
#   of the tooltip and link 2 over time, plots them as a robot arm
#   and saves the video file to your current directory
#
#   Parameters
#   video_name = String of your desired video name, including '.mp4'
#   P_tool = a 2xn matrix of tool positions
#   P_2 = a 2xn matrix of link arm #2 positions
#
#   Returns
#   None
#
#   Author: Megan Shapiro
#   Date: 7 Nov 2020
import numpy as np
import matplotlib
import matplotlib.pyplot as plt
import matplotlib.animation as animation
from matplotlib.legend_handler import HandlerLine2D
matplotlib.use("Agg")


def update_line(i, P_tool,P_2,arm1,arm2,path):
    # Draw 1st link arm
    arm1.set_data(np.array([0, P_2[0, i]]), np.array([0, P_2[1, i]]))
    # Draw the 2nd link arm
    arm2.set_data(np.array([P_2[0, i], P_tool[0, i]]), np.array([P_2[1, i], P_tool[1, i]]))
    # Draw the path
    path.set_data(P_tool[0, 0:i+1], P_tool[1, 0:i+1])
    return arm1,arm2,path

def savePathAsVideo(video_name, P_tool, P_2):
    plot_size = np.amax(np.abs([P_tool,P_2]))+1
    path_size = P_tool.shape[1]
    # Set up formatting for the movie files
    Writer = animation.writers['ffmpeg']
    writer = Writer(fps=2, metadata=dict(artist='Me'), bitrate=1800)

    # create a new figure window
    fig = plt.figure(3)
    # Draw 1st link arm
    arm1, = plt.plot([],[], 'c-',label='Link 1')
    # Draw the 2nd link arm
    arm2, = plt.plot([],[], 'k-',label='Link 2')
    # Draw the path
    path, = plt.plot([],[], 'r--',label='path')
    # Turn plot grid on
    plt.grid(True)
    # set the axis size
    plt.axis([-plot_size, plot_size, -plot_size, plot_size])
    # Add a legend
    plt.legend()
    # Add a title and axis labels
    plt.title('x vs y')
    plt.xlabel('X')
    plt.ylabel('y')

    line_ani = animation.FuncAnimation(fig, update_line, path_size, fargs=(P_tool,P_2,arm1,arm2,path),
                                       interval=50, blit=True)
    line_ani.save(video_name, writer=writer)

if __name__ == '__main__':
    savePathAsVideo("myPath.mp4",np.array([[-2,-1,0,1,2],[4,1,0,1,4]]),np.array([[.7889,1.566,0.0,2.5616,2.7889],[2.8944,2.5616,-3.0,-1.5616,1.1056]]))
