% COE 347 OF 3 Plotting Script
% Niusha Saadat 5/1/19
clear; clc; close all;

set(groot,'defaulttextinterpreter','latex');  
set(groot, 'defaultAxesTickLabelInterpreter','latex');  
set(groot, 'defaultLegendInterpreter','latex');

% Path to folder with all sims
folder_path = 'C:\Users\Niusha\Desktop\School\UT Year 3\Spring 2019\CFD\OpenFoam Group Assignment\OF 3\';
% Path of specific simulation to folder with all postProcessing data
sims = {'sonicFoam_20x20\postProcessing\graph\4\','sonicFoam_50x50\postProcessing\graph\4\','sonicFoam_02\postProcessing\graph\4\',...
    'sonicFoam_50x50_0005t\postProcessing\graph\4\','sonicFoam_024\postProcessing\graph\4\'};
% Desired postProcessing file
files = {'horizontal_step_p_T.xy','horizontal_wall_p_t.xy','top_wall_p_t.xy','vertical_wall_p_t.xy'};
titles = {'Horizontal Step', 'Horizontal Wall','Top Wall','Vertical Step Wall'};
fig_titles = {'sonicFoam on 20x20 Mesh','sonicFoam on 50x50 Mesh','sonicFoam on h = 0.2 Spaced Mesh','sonicFoam on 50x50 with 0.0005t',...
    'sonicFoam on h = 0.24 Spaced Mesh'};


% Loop through and plot
for ii = 1:length(sims)
    figure
    sgtitle(fig_titles{ii})
    for jj = 1:length(files)
        loc = strcat(folder_path,sims{ii},files{jj});
        data = importdata(loc);
        x = data(:,1);
        y = data(:,2);
        z = data(:,3);
        p = data(:,4);
        T = data(:,5);
        if(jj == 4)
            subplot(2,2,jj)
            plot(y,p)
            xlabel('y','FontSize',12);ylabel('p','FontSize',12);
            title(sprintf( 'Pressure Along %s',titles{jj}),'FontSize',16 );
            grid on; grid minor;

        else
            subplot(2,2,jj)
            plot(x,p)
            xlabel('x','FontSize',12);ylabel('p','FontSize',12);
            title(sprintf( 'Pressure Along %s',titles{jj}),'FontSize',16 );
            grid on; grid minor;
        end
    end
end




