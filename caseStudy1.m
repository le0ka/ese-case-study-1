%Case Study 1 initial commit
load COVIDbyCounty.mat;

%plot(dates, CNTY_COVID);
%legend(CNTY_CENSUS.CTYNAME);

% Divisions: Pacific, Mountain, West South Central, West North Central, 
% West South Central, East North Central, East South Central,
% Middle Atlantic, South Atlantic, New England

idx_pacific = (CNTY_CENSUS.DIVNAME == "Pacific");
idx_mountain = (CNTY_CENSUS.DIVNAME == "Mountain");
idx_WSCentral = (CNTY_CENSUS.DIVNAME == "West South Central");
idx_WNCentral = (CNTY_CENSUS.DIVNAME == "West North Central");
idx_ENCentral = (CNTY_CENSUS.DIVNAME == "East North Central");
idx_ESCentral = (CNTY_CENSUS.DIVNAME == "East South Central");
idx_MAtlantic = (CNTY_CENSUS.DIVNAME == "Middle Atlantic");
idx_SAtlantic = (CNTY_CENSUS.DIVNAME == "South Atlantic");
idx_NEngland = (CNTY_CENSUS.DIVNAME == "New England");

numRows = size(CNTY_CENSUS, 1);
rowNumber = (1:numRows);

CNTY_CENSUS.RowNumber = rowNumber';

pacific_cntys = CNTY_CENSUS(idx_pacific, :);
pacific_cntys_sorted = sortrows(pacific_cntys, "POPESTIMATE2021", 'descend');
max = pacific_cntys_sorted(1, :);

pacific_testing_cntys = table();
pacific_training_cntys = table();

for i = 1:size(pacific_cntys_sorted, 1)
    if mod(i, 5) == 0
        pacific_testing_cntys = [pacific_testing_cntys; pacific_cntys_sorted(i, :)];
    else
        pacific_training_cntys = [pacific_training_cntys; pacific_cntys_sorted(i, :)];
    end
end

pacific_training_data = zeros(height(pacific_training_cntys), 156);

index = zeros(height(pacific_training_data),1);
index = pacific_training_cntys.RowNumber;
pacific_training_data = CNTY_COVID(index, :);

numcentroids = 5;
num_replicates = 10;  
distance_metric = 'cosine'; 


[idx, C] = kmeans(pacific_training_data, numcentroids);

% Create cell arrays to hold cluster data
cluster_data = cell(1, numcentroids);

% Display data for each cluster
for i = 1:numcentroids
    cluster_data{i} = pacific_training_cntys(idx == i, :);
    fprintf('Cluster %d Data:\n', i);
    disp(cluster_data{i});
end

silhouette_vals = silhouette(pacific_training_data, idx);

figure;
silhouette(pacific_training_data, idx);

xlabel('Silhouette Value');
ylabel('Cluster');
title('Silhouette Plot');

avg_silhouette = mean(silhouette_vals);
fprintf('Average Silhouette Score: %.4f\n', avg_silhouette);
Avg_Centroid = mean(C, 1); %Create average centroid to represent the average of all of the centroids d



% lop of last 25 % of data from training set to be used as test data 
% 9 centroids ? one for each region



