% drawMaze: draw the MEGN441 maze
%
%   [] = drawMaze(maze) Uses provided maze object to draw the walls
%   and spaces of the class maze
%
%   Parameters
%   maze - an object with members x and y
%   x is a binary array that shows where the horizontal walls are located
%   y is a binary array that shows where the vertical walls are located
%   
%   Returns
%   None
%
%   Author: Megan Shapiro
%   Date: 3/16/20

function drawMaze(maze)
% close all;
% figure();
clf;
hold on;
maze_x = maze.x;
maze_y = maze.y;
[size1, size2] = size(maze.y);
size3 = size2 + 1;
for i = 1:size1
    for j = 1:size1
        if (maze_y(j,i))
            plot([i,i],[size2-j,size3-j],'Color','#0072BD','LineWidth',1);
        else
            plot([i,i],[size2-j,size3-j],':k');
        end
        if (maze_x(j,i))
            plot([i,i+1],[size3-j,size3-j],'Color','#0072BD','LineWidth',1);
        else
            plot([i,i+1],[size3-j,size3-j],':k');
        end
        if (i == size1)
            if (maze_y(j,i+1))
                plot([i+1,i+1],[size2-j,size3-j],'Color','#0072BD','LineWidth',1);
            end
        end
        if (j == size1)
            if (maze_x(j+1,i))
                plot([i,i+1],[size2-j,size2-j],'Color','#0072BD','LineWidth',1);
            end
        end 
    end
end
% start = maze.start + [.5 .25];
% finish = maze.finish + [.5 .75];
% s = plot(start(1), start(2),'LineStyle','none','Marker','p','MarkerEdgeColor','k','MarkerFaceColor','g','MarkerSize',10);
% f = plot(finish(1), finish(2),'LineStyle','none','Marker','p','MarkerEdgeColor','k','MarkerFaceColor','r','MarkerSize',10);
axis([0 size3 0 size3]);
% legend([s f],{'Start', 'Finish'});
axis 'square';
axis off;
end
     
            