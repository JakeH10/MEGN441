% explore: generate a list of moves when following the left or right hand
% rule
%
%   [moveList] = explore(maze, handRule) Given the maze structure and a
%   hand rule, implement the programming logic to run the maze
%
%   Parameters
%   maze - a struct that holds the true/false values of where walls exist
%   horizontally and vertically, as well as the start and finish positions
%   handRule - a char ('L'/'R') that specifies which hand rule to follow
%
%   Returns
%   movesList - a char array ('L', 'F', or 'R') that lists the decisions
%   taken
%
%   Author: Jacob Hoffer
%   Date:

function moveList = explore(maze, handRule)
    %Create/initialize variables

    curPos = maze.start;
    curDir = maze.startDir;

    robotMatrix =  [cos(curDir),    -sin(curDir),   curPos(1);
                    sin(curDir),    -cos(curDir),   curPos(2);
                    0,              0,              1];

    if handRule == 'R'
        checkOrder = ['R', 'F', 'L'];
    else
        checkOrder = ['L', 'F', 'R'];
    end

    moveList = ''; %create empty char array
    % i = 1; %counting variable
    while(robotMatrix(1:2,3) ~= maze.finish)
        % Write code to explore maze according to the given hand rule
        for i = 1:3
            wall = getWall(maze, curPos, curDir, checkOrder(i));
            if ~wall
                break;
            end
        end
        [robotMatrix, moveList] = move(robotMatrix, moveList, checkOrder(i));
        disp(robotMatrix);
        w = waitforbuttonpress;
    end
end

function [robotMatrix, moveList] = move(robotMatrix, moveList, side)
    if side == 'R'
        dir = -pi / 2;
        T = [cos(dir), -sin(dir),  1;
             sin(dir), -cos(dir),  0;
             0,         0,         1];
        moveList = [moveList, 'RF'];
    elseif side == 'L'
        dir = pi / 2;
        T = [cos(dir), -sin(dir), -1;
             sin(dir), -cos(dir),  0;
             0,         0,         1];
        moveList = [moveList, 'LF'];
    else
        dir = 0;
        T = [cos(dir), -sin(dir), -1;
             sin(dir), -cos(dir),  0;
             0,         0,         1];
        moveList = [moveList, 'F'];
    end
    
    robotMatrix = T * robotMatrix;
    
end
