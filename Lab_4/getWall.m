% getWall: finds if a wall exists at a certain point in the maze
%
%   [wall] = getWall(maze, curPos, curDir, side) - Given the maze
%   structure, the robot's current position and direction, and the side of
%   interest, the function finds the absolute location of the desired wall
%   and examines the maze structure
%
%   Parameters
%   maze - a maze structure that contains the locations of horizontal and
%   vertical walls, the start position, the starting direction, and the
%   finish location
%   curPos - the current position of the robot in the maze as an [x, y]
%   coordinate pair
%   curDir - the direction the robot is currently facing, in radians
%   side - the char that represents the side of interest ('R', 'L', or 'F')
%   
%   Returns
%   wall - the binary value that represents the wall's presence in the maze
%   (1: wall exists, 0: wall does not exist)
%
%   Author: Megan Shapiro
%   Date: 3/19/20

function wall = getWall(maze, curPos, curDir, side)
[~, size2] = size(maze.y);
size3 = size2 + 1;
%The absolute direction of interest is relative to the curDir and side
switch(side) 
    case 'R'
        absDir = curDir - pi/2; %The right wall is -pi/2 of the curDir
    case 'L'
        absDir = curDir + pi/2; %The left wall is +pi/2 of the curDir
    case 'F'
        absDir = curDir; %The front wall is equal to the curDir
end

absDir = wrapAngle(absDir); %limit absolute direction to 0-2*pi

% Find wall of interest from absolute direction and position
switch(absDir)
    % East Wall of curPos
    case 0 
        wall = maze.y( size2-curPos(2), 1+curPos(1));
    % North Wall of curPos
    case pi/2 
        wall = maze.x( size2-curPos(2), curPos(1));
    %West Wall of curPos
    case pi 
        wall = maze.y( size2-curPos(2), curPos(1));
    %South Wall of curPos
    case 3*pi/2 
        wall = maze.x( size3-curPos(2), curPos(1));
    % if angle is invalid, assume wall is true
    otherwise 
        wall = true;
end
end