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
%   Date: 4/8/21

function moveList = explore(maze, handRule)
    %Create/initialize variables

    curPos = maze.start; % Get starting position
    curDir = maze.startDir; % Get finish position

    % Create wall check order
    if handRule == 'R'
        checkOrder = ['R', 'F', 'L'];
    else
        checkOrder = ['L', 'F', 'R'];
    end

    moveList = ''; %create empty char array
    
    while(~isequal(curPos, maze.finish)) % Contine until finish positon is reached
        for i = 1:3 % Check for wall
            wall = getWall(maze, curPos, curDir, checkOrder(i));
            if ~wall % If no wall, then move
                [curPos, curDir, moveList] = move(curPos, curDir, ...
                    moveList, checkOrder(i), handRule);
                break; % 
            end
        end
        if wall % If walls exist on all three sides, turn arround
            [curPos, curDir, moveList] = move(curPos, curDir, ...
            moveList, 'B', handRule);
        end
    end
    
end

% function to turn and move
function [curPos, curDir, moveList] = move(curPos, curDir, moveList, ...
    side, handRule)
    if side == 'R'
         curDir = curDir - pi / 2; % Change direction
         moveList = [moveList, 'RF']; % Record moves
    elseif side == 'L'
        curDir = curDir + pi / 2;
        moveList = [moveList, 'LF'];
    elseif side == 'F'
        moveList = [moveList, 'F'];
    else % reached if robot found deadend and turns around
        curDir = curDir - pi;
        if handRule == 'R'
            moveList = [moveList, 'LLF'];  
        else
            moveList = [moveList, 'RRF'];
        end
              
    end
    
    % Taken from getWall.m
    curDir = wrapAngle(curDir); %limit absolute direction to 0-2*pi

    % Move 1 unit forward in the direction found above
    switch(curDir)
        case 0 
            curPos = curPos + [1 0];
        case pi/2 
            curPos = curPos + [0 1];
        case pi 
            curPos = curPos + [-1 0];
        case 3*pi/2 
            curPos = curPos + [0 -1];
    end
    
end
