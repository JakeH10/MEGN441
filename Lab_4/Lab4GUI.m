function Lab4GUI
clear;
clc;
close all;

load('tests.mat','tests');

f = figure('Visible','off','Units','pixels','Position',[0 0 600 500],...
    'KeyReleaseFcn',{@key_release_callback});
movegui(f,'center');
ha = axes('Units','pixels','Position',[25,60,400,400]);
mazeNum = 1;
maze = tests(mazeNum).maze;
curDir = maze.startDir;
movesList = [];
drawMaze(tests(mazeNum).maze,f);
[p, a] = drawPath(maze,[]);
instructions = {'Lab 4 Manual Test Instructions','up arrow: forward','left arrow: turn left','right arrow: turn right','down arrow: undo'};
GUIInstructions = annotation('textbox',[.7,.5,.25,.3],'String',...
    instructions,'FontWeight','bold','FitBoxToText','on',...
    'HorizontalAlignment','center','LineStyle','none');
selectText = uicontrol('Style','text','String','Select Test Maze #','Position',[390,250,200,15]);
mazeSelect = uicontrol('Style','popupmenu','String',string(1:max(size(tests))),...
    'Position',[440,220,100,25],'Callback',{@maze_select_Callback},'Value',1);
movesListLabel = uicontrol('Style','text','String','Current Moves List:',...
    'HorizontalAlignment','left','Position',[10,50,150,15]);
movesListDisplay = uicontrol('Style','edit','Position',[10,10,510,30]);
movesListEnter = uicontrol('Style','pushbutton','String','Enter',...
    'Position',[530,10,65,30],'Callback',{@text_key_release_callback});
f.Visible = 'on';


    function maze_select_Callback(source, eventdata)
        str = source.String;
        val = source.Value;
        mazeNum = str2double(str{val});
        maze = tests(mazeNum).maze;
        curDir = maze.startDir;
        movesList = [];
        drawMaze(tests(mazeNum).maze,f);
        if exist('p','var')
            delete(p);
            delete(a);
        end
        [p, a] = drawPath(maze,[]);
        movesListDisplay.String = movesList;
        set(mazeSelect, 'Enable', 'off');
        drawnow update;
        set(mazeSelect, 'Enable', 'on');
        %         GUIInstructions = annotation('textbox',[.65,.5,.3,.3],'String',...
        %             instructions,'FontWeight','bold','FitBoxToText','on',...
        %             'HorizontalAlignment','center','LineStyle','none');
        %         selectText = uicontrol('Style','text','String','Select Test Maze #','Position',[400,250,200,15]);
        %         mazeSelect = uicontrol('Style','popupmenu','String',string(1:max(size(tests))),...
        %             'Position',[450,220,100,25],'Callback',{@maze_select_Callback},'Value',val);
        %         f.KeyReleaseFcn = @key_release_callback;
    end

    function key_release_callback(source2, eventdata2)
        switch(eventdata2.Key)
            case 'uparrow'
                %disp('up');
                movesList = [movesList, 'F'];
            case 'downarrow'
                %disp('down');
                movesList = movesList(1:end-1);
            case 'leftarrow'
                %disp('left');
                movesList = [movesList, 'L'];
            case 'rightarrow'
                %disp('right');
                movesList = [movesList, 'R'];
            otherwise
                %disp('Unknown');
        end
        if exist('p','var')
            delete(p)
            delete(a)
        end
        [p, a] = drawPath(maze,movesList);
        movesListDisplay.String = movesList;
    end

    function text_key_release_callback(source, eventdata)
        movesList = upper(movesListDisplay.String);
        if exist('p','var')
            delete(p)
            delete(a)
        end
        [p, a] = drawPath(maze,movesList);
        movesListDisplay.String = movesList;
        set(movesListEnter, 'Enable', 'off');
        drawnow update;
        set(movesListEnter, 'Enable', 'on');
    end

    function drawMaze(maze, f)
        % close all;
        figure(f);
        hold off;
        x = plot([0,0]);
        delete(x);
        axes(ha);
        %         ha = axes('Units','pixels','Position',[25,60,400,400]);
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
        start = maze.start + [.5 .25];
        finish = maze.finish + [.5 .75];
        s = plot(start(1), start(2),'LineStyle','none','Marker','p','MarkerEdgeColor','k','MarkerFaceColor','g','MarkerSize',10);
        f = plot(finish(1), finish(2),'LineStyle','none','Marker','p','MarkerEdgeColor','k','MarkerFaceColor','r','MarkerSize',10);
        axis([0 size3 0 size3]);
        legend([s f],{'Start', 'Finish'});
        axis 'square';
        axis off;
    end

    function [p, a] = drawPath(maze, moveList)
        hold on;
        path = ones(sum(moveList=='F')+1,2);
        path(1, :) = maze.start;
        dir = maze.startDir;
        j = 1;
        for k = 1:length(moveList)
            if moveList(k) == 'R'
                dir = dir - pi/2;
            elseif moveList(k) == 'L'
                dir = dir + pi/2;
            elseif moveList(k) == 'F'
                next = path(j,:) + [cos(dir), sin(dir)];
                j = j + 1;
                path(j, :) = next;
            end
        end
        x = path(1:j,1) + .5;
        y = path(1:j,2) + .5;
        p = plot(x,y,'k-','HandleVisibility','off');
        arrow_x = [-.25,.25]*cos(dir)+ path(j,1) + .5;
        arrow_y = [-.25,.25]*sin(dir)+ path(j,2) + .5;
        a = annotation('arrow');
        a.Parent = gca;
        a.X = arrow_x;
        a.Y = arrow_y;
        a.LineWidth = 2;
    end

end