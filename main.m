% A. Wolek, N. Kakavitsas, UNC Charlotte, Jan. 2024
% MATLAB Script to generate plots from dataset.csv used in paper below.
%
% Reference:
% "Comparison of size and performance of small vertical and short takeoff
% and landing uncrewed aircraft systems." N. Kakavitsas, A. Willis,
% J. Conrad, and A. Wolek. 2024 IEEE Aerospace Conference.
%
% Toolboxes Required: "Image Processing Toolbox" (dependency of
% distinguishable_colors package)

% prepare workspace
clear; close all; clc;

% load packages
addpath('distinguishable_colors/')
addpath('Violinplot-Matlab/')

% setup
color_dist = distinguishable_colors(6);
legendStr = {'Fixed-Wing','Helicopter','Multicopter','QP','Tailsitter','FPV'};
csvfile = 'dataset.csv';
printFlag = 0; % flag (1 is on, 0 is off) to print plots to pdf

% read data
data = readtable(csvfile);
% sort into types
tableTypes{1} = data(strcmp(data.Type,'Fixed-wing'),:);
tableTypes{2} = data(strcmp(data.Type,'Helicopter'),:);
tableTypes{3}= data(strcmp(data.Type,'Multirotor'),:);
tableTypes{4} = data(strcmp(data.Type,'Quadplane/Tiltrotor'),:);
tableTypes{5} = data(strcmp(data.Type,'Tailsitter'),:);
tableTypes{6} = data(strcmp(data.Type,'FPV Multirotor'),:);
% sort into groups
tableGroups{1} = data( data.UASGroup == 1, : );
tableGroups{2} = data( data.UASGroup == 2, : );
tableGroups{3}= data( data.UASGroup == 3, : );

%% Country of Origin Analysis
COG = data.COG;
[uni,~,idx] = unique(COG);
for i = 1:1:max(idx)
    bins(i) = sum(idx==i);
end
inds = (bins <= 2);
numOthers = sum(bins(inds));
fprintf('Percent Other: (%d/%d) = %3.3f\n',numOthers,sum(bins),numOthers/sum(bins)*100);
figure;
histogram('Categories',uni,'BinCounts',bins)
grid on;
set(gcf,'Color','w')
for i =1:1:length(bins)
    fprintf('%s : %d/%d (%3.3f ) \n',uni{i},bins(i),sum(bins),bins(i)/sum(bins)*100);
end

%% Speed Analysis
ms = 15;
scale = 1;
ytickvec = [0:20:300];
legendLoc = 'northeast';
figPosSize = [0.5 0.5 7 12];
figPaperSize = [7 11.5];
axPos1 = [0.75 8.25 6 3];
axPos2 = [0.75 4.75 6 3];
axPos3 = [0.75 0.5 6 3];
yval_label = 'Max. Speed (mph)';
yval = 'Speed_mph_';
makePlot;
if ( printFlag )
    print(gcf,'-dpdf','speed.pdf')
end

%% Size Analysis
yval_label = 'Size (ft)';
yval = 'Size_ft_';
ytickvec = [0:2:22];
makePlot;
if ( printFlag )
    print(gcf,'-dpdf','size.pdf')
end

%% Flight Time Analysis
yval_label = 'Flight Time (hrs)';
yval = 'FlightTime_min_';
scale = 1/60;
ytickvec = [0:2:26];
makePlot;
if ( printFlag )
    print(gcf,'-dpdf','endurance.pdf')
end

%% Payload Analysis
yval_label = 'Payload (lbs)';
yval = 'Payload_lbs_';
legendLoc = 'southeast';
scale = 1;
ytickvec = [0:20:120];
makePlot;
if ( printFlag )
    print(gcf,'-dpdf','payload.pdf')
end

%% Payload Fraction Analysis
yval_label = 'Payload Fraction';
yval = 'PayloadFraction';
scale = 1;
legendLoc = 'northeast';
ytickvec = [0:0.1:1];
makePlot;
if ( printFlag )
    print(gcf,'-dpdf','payload_frac.pdf')
end

%% Truncated data on weight / speed
data_trunc = data( data.MTOW_lbs_<=140, : );
data_trunc = data_trunc( data_trunc.Speed_mph_<=140, : );
fprintf('Percent of platforms less than 140 lbs and 140 mph (%d/%d) = %3.3f\n',size(data_trunc,1),size(data,1),size(data_trunc,1)/size(data,1)*100)

%% Truncated data on weight / endurance
data_trunc = data( data.FlightTime_min_/60<=4, : );
fprintf('Percent of platforms less than 4 hr endurance (%d/%d) = %3.3f\n',size(data_trunc,1),size(data,1),size(data_trunc,1)/size(data,1)*100)
data_trunc = data( data.FlightTime_min_/60<=1, : );
fprintf('Percent of platforms less than 1 hr endurance (%d/%d) = %3.3f\n',size(data_trunc,1),size(data,1),size(data_trunc,1)/size(data,1)*100)

%% Data on unique vendors
[unique_vendors] = unique(data.Vendor)
fprintf('Number of unique vendors: %d\n',length(unique_vendors));

