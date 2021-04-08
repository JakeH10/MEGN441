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
%
%   Author: Jacob Hoffer
%   Date: 4/8/21

function newList = optimize(moveList, handRule)
if (handRule == 'R') % helper variables
    notHand = 'L'; % opposite turn of hand rule
    deadEnd = 'LL'; % deadend indicator
else
    notHand = 'R';% opposite turn of hand rule
    deadEnd = 'RR';% deadend indicator
end

deadendIndcices = strfind(moveList, deadEnd); %Find initial dead ends

    while(~isempty(deadendIndcices)) %while any deadends exist

        deadendIndcices = deadendIndcices(1); % Solve one deadend at a time

        i = 1; %initialize counter

        if deadendIndcices - i - 1  > 0 % Catch out-of-bounds error
            isAtStart = false;
        else
            isAtStart = true;
        end

        if ~isAtStart
            % Find the number of Forward movements leading to the deadend
            while moveList(deadendIndcices - i - 1) == 'F' ...
                    && moveList(deadendIndcices + i + 2) == 'F'
                i = i + 1;
                if deadendIndcices - i - 1  < 1
                    break
                end
            end
        end

        if (handRule == 'R') % Flip turns as necessary
            if moveList(deadendIndcices+i+2) == 'R'
                moveList(deadendIndcices+i+2) = 'L';
            elseif ~isAtStart
                if moveList(deadendIndcices-i-1) == 'R'
                    moveList(deadendIndcices-i-1) = 'L';
                end
            else
                % Turn robot around at start if directly facing a dead end
                moveList = [moveList(1:deadendIndcices + 1 + i), 'RR' moveList(deadendIndcices + 2 + i:end)];
            end
        else
            if moveList(deadendIndcices+i+2) == 'L'
                moveList(deadendIndcices+i+2) = 'R';
            elseif ~isAtStart
                if moveList(deadendIndcices-i-1) == 'L'
                    moveList(deadendIndcices-i-1) = 'R';
                end
            else
                % Turn robot around at start if directly facing a dead end
                moveList = [moveList(1:deadendIndcices + 1 + i), 'LL' moveList(deadendIndcices + 2 + i:end)];
            end
        end

        % Remove deadend
        moveList = [...
            moveList(1:deadendIndcices - i - 1), ...
            moveList(deadendIndcices + 2 + i:end)];

        % Remove turns that "cancel" eachother
        moveList = replace(moveList, 'RL', '');
        moveList = replace(moveList, 'LR', '');

        % Find any existing deadends
        deadendIndcices = strfind(moveList, deadEnd); % count deadEnds

    end
newList = moveList; % return updated list
end
