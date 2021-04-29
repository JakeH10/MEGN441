# This file's content should not be changed,
# but feel free to add print statements and breakpoints
# to debug your code and check your math

import os
import numpy as np

# Import your .py files for each function
# Comment out lines for files you haven't finished yet
from rot2D import *
from trans2D import *
from fwdKinematics import *
from invKinematics import *

pi = 3.14159
directory = "tests/"


def rot2DTests():
    input_file = "rot2D_inputs.csv"
    output_file = "rot2D_outputs.csv"
    input_path = directory + input_file
    output_path = directory + output_file
    if (os.path.exists(input_path)):
        test_inputs = np.loadtxt(input_path,delimiter=',')
        #print(test_inputs)
        if(os.path.exists(output_path)):
            test_outputs = np.loadtxt(output_path,delimiter=',')
            #print(test_outputs)
        else:
            print(f"Test file {output_file} not found in folder {directory}.")
            return
    else:
        print(f"Test file {input_file} not found in folder {directory}.")
        return
    correct = np.zeros(10)
    for i in range(10):
        R = np.eye(2)
        for j in range(2):
            R = R @ rot2D(test_inputs[i,j])
        R[abs(R)<1e-5] = 0
        #print(R)
        #print(test_outputs[2*i:2*i+2])
        #print(abs(test_outputs[2*i:2*i+2]-R))
        if((abs(test_outputs[2*i:2*i+2]-R)<1e-3).all()):
            correct[i] = 1
        else:
            print(f"rot2D test # {i} incorrect.")
    if(correct.all()):
        print("All rot2D tests passed!")
    #print(correct)


def trans2DTests():
    input_file = "trans2D_inputs.csv"
    output_file = "trans2D_outputs.csv"
    input_path = directory + input_file
    output_path = directory + output_file
    if (os.path.exists(input_path)):
        test_inputs = np.loadtxt(input_path,delimiter=',')
        #print(test_inputs)
        if(os.path.exists(output_path)):
            test_outputs = np.loadtxt(output_path,delimiter=',')
            #print(test_outputs)
        else:
            print(f"Test file {output_file} not found in folder {directory}.")
            return
    else:
        print(f"Test file {input_file} not found in folder {directory}.")
        return

    correct = np.zeros(10)
    for i in range(10):
        T = np.eye(3)
        for j in range(2):
            T = T @ trans2D(test_inputs[2*i+j,0],test_inputs[2*i+j,1],test_inputs[2*i+j,2])
        T[abs(T)<1e-5] = 0
        # print(T)
        # print(test_outputs[3*i:3*i+3,:])
        # print(abs(test_outputs[3*i:3*i+3,:]-T))
        if((abs(test_outputs[3*i:3*i+3]-T)<1e-3).all()):
            correct[i] = 1
        else:
            print(f"trans2D test # {i} incorrect.")
    if(correct.all()):
        print("All trans2D tests passed!")
    #print(correct)


def fwdKinematicsTests():
    input_file = "fwdKinematics_inputs.csv"
    output_file = "fwdKinematics_outputs.csv"
    input_path = directory + input_file
    output_path = directory + output_file
    if (os.path.exists(input_path)):
        test_inputs = np.loadtxt(input_path,delimiter=',')
        #print(test_inputs)
        if(os.path.exists(output_path)):
            test_outputs = np.loadtxt(output_path,delimiter=',')
            #print(test_outputs)
        else:
            print(f"Test file {output_file} not found in folder {directory}.")
            return
    else:
        print(f"Test file {input_file} not found in folder {directory}.")
        return
    correct = np.zeros(10)
    for i in range(10):
        P1, P2 = fwdKinematics(test_inputs[i,0],test_inputs[i,1],test_inputs[i,2],test_inputs[i,3])
        # print(P1)
        # print(P2)
        # print(test_outputs[i,:])
        # print((abs(test_outputs[i,0:2]-P1)<1e-3).all())
        # print((abs(test_outputs[i,2:]-P2)<1e-3).all())
        if((abs(test_outputs[i,0:2]-P1)<1e-3).all() and (abs(test_outputs[i,2:]-P2)<1e-3).all()):
            correct[i] = 1
        else:
            print(f"fwdKinematics test # {i} incorrect.")
    if(correct.all()):
        print("All fwdKinematics tests passed!")
    #print(correct)


def invKinematicsTests():
    input_file = "invKinematics_inputs.csv"
    output_file = "invKinematics_outputs.csv"
    input_path = directory + input_file
    output_path = directory + output_file
    if (os.path.exists(input_path)):
        test_inputs = np.loadtxt(input_path,delimiter=',')
        #print(test_inputs)
        if(os.path.exists(output_path)):
            test_outputs = np.loadtxt(output_path,delimiter=',')
            #print(test_outputs)
        else:
            print(f"Test file {output_file} not found in folder {directory}.")
            return
    else:
        print(f"Test file {input_file} not found in folder {directory}.")
        return
    correct = np.zeros(15)
    for i in range(15):
        t1, t2, r = invKinematics(test_inputs[i,0],test_inputs[i,1],test_inputs[i,2],test_inputs[i,3])
        # print(t1)
        # print(t2)
        # print(test_outputs[i,:])
        # print(abs(test_outputs[i,0]-t1)<1e-3)
        # print(abs(test_outputs[i,1]-t1)<1e-3)
        # print(test_outputs[i,2]==reachable)
        if((test_outputs[i,2] == 1) and ((test_outputs[i,0]-t1<1e-3) and (test_outputs[i,1]-t2<1e-3) and (test_outputs[i,2]==r))):
            correct[i] = 1
        elif ((test_outputs[i,2] == 0) and (test_outputs[i,2]==r)):
            correct[i] = 1
        else:
            print(f"invKinematics test # {i} incorrect.")
    if(correct.all()):
        print("All invKinematics tests passed!")
    #print(correct)

# Comment out any tests you want to skip for now
if __name__ == '__main__':
    rot2DTests()
    trans2DTests()
    fwdKinematicsTests()
    invKinematicsTests()
