% drawPath: Given a list of robot commands/moves, it draws the created
% path on a plot window. Assumes maze has been drawn first
%
%   [p, a] = drawPath(moveList, stepByStep, Color)-Uses the commands in
%   moveList to detail the path taken by a robot. Options for step-by-step
%   path viewing and custom path color
%
%   Parameters
%   List parameters here
%   moveList - An array of characters ('L','F','R') that list the movements
%   taken by the robot in the maze (Left turn, drive Forward, Right turn)
%   stepByStep - A true/false input that, if true, pauses between commands
%   to show the next indended direction
%   Color - implements a custom path color if given in matlab standard
%   formats for the Color attribute of Line objects
%   
%   Returns
%   p - the plotted path object is returned. This is given so the maze can
%   be cleared of a path without deleting the structure entirely
%   a - the last direction arrow object. This is given so the maze can be
%   cleared of an arrow without deleting the structure entirely
%   Author: Megan Shapiro
%   Date: 3/16/20
function [p, a] = drawPath(maze, moveList, stepByStep, Color)

hold on;
path = ones(sum(moveList=='F'),2);
path(1, :) = maze.start;
dir = maze.startDir;
j = 1;
arrow_x = [-.25,.25]*cos(dir)+ path(j,1) + .5;
arrow_y = [-.25,.25]*sin(dir)+ path(j,2) + .5;
a = annotation('arrow');
a.Parent = gca;
a.X = arrow_x;
a.Y = arrow_y;
a.LineWidth = 2;
for i = 1:length(moveList)
    if (stepByStep)
        pause(.01);
    end
    if moveList(i) == 'R'
        dir = dir - pi/2;
    elseif moveList(i) == 'L'
        dir = dir + pi/2;
    elseif moveList(i) == 'F'
        next = path(j,:) + [cos(dir), sin(dir)];
        j = j + 1;
        path(j, :) = next;
        x = path(1:j,1) + .5;
        y = path(1:j,2) + .5;
        if exist('p','var')
            delete(p)
        end
        p = plot(x,y,'-','Color',Color,'HandleVisibility','off');
    end
    delete(a)
    arrow_x = [-.25,.25]*cos(dir)+ path(j,1) + .5;
    arrow_y = [-.25,.25]*sin(dir)+ path(j,2) + .5;
    a = annotation('arrow');
    a.Parent = gca;
    a.X = arrow_x;
    a.Y = arrow_y;
    a.LineWidth = 2;
end
end