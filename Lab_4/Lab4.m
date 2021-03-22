clear; clc; close all;

%Maze metadata provided
load tests;
%pre allocate variables
moves = cell(10,2);
solution = cell(10,2);
correct = ones(10,2,2);

for i = 1:length(tests) %For all test casesd
    maze = tests(i).maze; %load maze structure
    fprintf('Maze %i\n',i); %Print i value
    for j = 1:2 %for both hand rules
             
        if j==1
            handRule = 'L'; %set char variable
            notHand = 'R';
            correctExplore = tests(i).Explore.L;
            correctSolve = tests(i).Optimize.L;
        else
            handRule = 'R'; %set char variable
            notHand = 'L';
            correctExplore = tests(i).Explore.R;
            correctSolve = tests(i).Optimize.R;
        end
        
        fprintf('\t%c Hand Rule\n',handRule); %print hand Rule
        
        clf; %clear figure window
        
        %drawMaze structre
        drawMaze(maze);
        
        %List of moves generate by YOUR explore function
        moves{i,j} = explore(maze, handRule);
        %draw your path
        [explored, a] = drawPath(maze, moves{i,j}, true,'k');
        
        %print results of test
        fprintf('\t\tExplore\n');
        if (length(moves{i,j}) == length(correctExplore))
            correct(i,j,1)= min(moves{i,j}==correctExplore);
        else
            correct(i,j,1) = false;
        end
        str1 = 'Explore phase of Maze %i for %c Hand Rule Incorrect\n';
        if ~correct(i,j,1)
            fprintf(str1,i,handRule);
        end
        
        %Do you want to erase the first path (y/n)
        c = 'n';
        if (c == 'Y' || c == 'y')
            delete(explored);
        end
        
        % erase previous directional arrow
        if exist('a','var')
            delete(a);
        end
        
        %find solution moveList based on YOUR solve function
        solution{i,j} = optimize(moves{i,j},handRule);
        %draw the optimized path
        [run,a] = drawPath(maze, solution{i,j}, true, 'b');
        %print results of test
        fprintf('\t\tOptimize\n');
        solution{i,j} = replace(solution{i,j},[notHand,notHand],[handRule,handRule]);
        solution{i,j} = replace(solution{i,j},[notHand,handRule],'');
        solution{i,j} = replace(solution{i,j},[handRule,notHand],'');
        if (length(solution{i,j}) == length(correctSolve))
            correct(i,j,2)= min(solution{i,j}==correctSolve);
        else
            correct(i,j,2) = false;
        end
        str2 = 'Run phase of Maze %i for %c Hand Rule Incorrect\n';
        if ~correct(i,j,2)
            fprintf(str2,i,handRule);
        end
        
        %delete extra plot items
        if exist('run','var')
            delete(run);
        end
        if exist('a','var')
            delete(a);
        end
        if exist('explore','var')
            delete(explore);
        end
        
    end
end

% if there are no zeros in the correct array
if min(correct)==1
    fprintf('All tests are correct!\n');
else
    disp(correct);
    fprintf("Explore: %.2f\n",mean(mean(correct(:,:,1))));
    fprintf("Optimize: %.2f\n",mean(mean(correct(:,:,2))));
end
