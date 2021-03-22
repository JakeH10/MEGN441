% optimize: optimize and correct a mazeList to its shortest form (no dead
% ends)
%
%   [newList] = optimize(moveList, handRule) Locates commands that indicate the
%   presence of a dead end in the navigated path and replaces them with a
%   corrected move
%
%   Parameters
%   moveList - An array of characters ('L','F','R') that list the movements
%   taken by the robot in the maze (Left turn, drive Forward, Right turn)
%   handRule - A char ('R' or 'L') that indicates if the path was following
%   the Left- or Right-Hand rule of maze solving.
%
%   Returns
%   newList - The optimized list of robot commands
%
%   Author: Megan Shapiro
%   Date: 3/16/20

function newList = optimize(moveList, handRule)
if (handRule == 'R') % helper variables
    notHand = 'L'; % opposite turn of hand rule
    deadEnd = 'LL'; % deadend indicator
else
    notHand = 'R';% opposite turn of hand rule
    deadEnd = 'RR';% deadend indicator
end

deadendIndcices = strfind(moveList, deadEnd); %Find initial dead ends

i=1; %initialize counter
while(~isempty(deadendIndcices)) %while any deadends exist
    % replace deadend patterns
    deadendIndcices = strfind(moveList, deadEnd); % count deadEnds
end
newList = moveList; % return updated list
end
