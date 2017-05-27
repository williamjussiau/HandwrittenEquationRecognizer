%% Name: Johnson Loh, Student No.: 9836543

clear; clc; close all;

%% read data

img = imread('eq1.png');
gray = rgb2gray(img);
% otsu thresholding & 1 for black pixel
BW = 1 - imbinarize(gray);

%% data conversion parameters
x_scale = 1;
y_scale = 8;

%% convert binary image into data array

% data format x1 x2
data = zeros(1,2);
index = 0;
for ii = 1:size(BW,1)
    for jj = 1:size(BW,2)
        if BW(ii,jj) == 1
            index = index + 1;
            data(index,1) = (size(BW,1) - ii + 1)/y_scale;
            data(index,2) = jj/x_scale;
        end
    end
end

% visualize data
%plot(data(:,2),data(:,1),'bx');

%% agglomerative clustering

% TODO: autogenerate number of cluster centres

% create agglomerative hierarchical cluster tree
Z = linkage(data,'single','euclidean');
c = cluster(Z,'maxclust',16);

% %% EM Gaussian Mixture Model
% 
% obj = fitgmdist(data,16);
% c = cluster(obj,data);
% 
% %% k-means clustering
% 
% [c,C] = kmeans(data,16,'Distance','cityblock');

%% generate output

% find bounding box values & cluster centres
% TODO: remove corner array for efficiency in function
corner1 = zeros(size(unique(c),1),2);
corner2 = zeros(size(unique(c),1),2);
means = zeros(size(unique(c),1),2);
bb = zeros(size(unique(c),1),4);
for ii = unique(c)'
    corner1(ii,:) = min(data(c==ii,:)).*[y_scale x_scale];
    corner2(ii,:) = max(data(c==ii,:)).*[y_scale x_scale];
    means(ii,:) = mean(data(c==ii,:)).*[y_scale x_scale];
    bb(ii,:) = [corner1(ii,2),corner1(ii,1),corner2(ii,2)-corner1(ii,2),corner2(ii,1)-corner1(ii,1)];
end

%% visualize clusters
scatter(data(:,2),data(:,1),16,c)
for ii = unique(c)'
    figure
    hold on
    scatter(data(c==ii,2)*x_scale,data(c==ii,1)*y_scale);
    scatter(means(ii,2),means(ii,1),'LineWidth',1.5,'MarkerFaceColor',[0 .7 .7])
    rectangle('Position', bb(ii,:),'EdgeColor','r','LineWidth',2 )
    axis([0 size(BW,2) 0 size(BW,1)]);
end