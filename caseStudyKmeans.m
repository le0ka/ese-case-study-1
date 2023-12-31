load COVIDbyCounty.mat;

%Used a list of all of the regions rather than a for loop with numbers so
%they can be assignes as variables later in the code
regions = ["Pacific", "Mountain", "West South Central", "West North Central", ...
           "East North Central", "East South Central", "Middle Atlantic", ...
           "South Atlantic", "New England"];
    numcentroids = 3; %Number of Centroids for each region
    number_replicates = 3;
    distance = 'cityblock'; % Distance metric used by kmeans in the initial clustering of regions
    distance2 = 'cityblock'; % Distance metric used by kmeans in the final creation of centroids
    total_centroids = numcentroids*9;


cluster_data_all_regions = cell(1, length(regions));

all_centroids_matrix = []; %creates an empty matrix that will end up storing all of the  final centroids
centroid_region_map = []; %assigns the centroids to be assosicated to a certain region


for region_idx = 1:length(regions) %this is the large for loop that completes all of the proceses that need to be done to all 9 centroids to save space and make code more efficient.
    current_region = regions(region_idx);
    
    idx_region = (CNTY_CENSUS.DIVNAME == current_region); %Sets the current region we are looping through
    
    numRows = size(CNTY_CENSUS, 1);
    rowNumber = (1:numRows);

    CNTY_CENSUS.RowNumber = rowNumber';

    region_cntys = CNTY_CENSUS(idx_region, :);
    region_cntys_sorted = sortrows(region_cntys, "POPESTIMATE2021", 'descend'); %sorts the data to be in greatest to smallest number of covid cases per region
    max = region_cntys_sorted(1, :);

    region_testing_cntys = table();
    region_training_cntys = table();

    for i = 1:size(region_cntys_sorted, 1) %This for loop goes through all of the data and assigns it to seperate testing and training sets. It is sorted by population and each fifth entry gets removed and added to the testing set
        if mod(i, 5) == 0
            region_testing_cntys = [region_testing_cntys; region_cntys_sorted(i, :)];
        else
            region_training_cntys = [region_training_cntys; region_cntys_sorted(i, :)];
        end
    end

    % Save the training and testing data into separate variables
    region_name = current_region;
    region_name = strrep(region_name, ' ', '_');  
    
    % Create variable names for training and testing data
    training_data_var = strcat(region_name, '_training_data');
    testing_data_var = strcat(region_name, '_testing_data');
    
    % Assign training and testing data to separate variables in the workspace
    assignin('base', training_data_var, region_training_cntys);
    assignin('base', testing_data_var, region_testing_cntys);

    region_training_data = zeros(height(region_training_cntys), 156);

    index = zeros(height(region_training_data),1); % creates a new matrix "index" that has the number of rows of the training data by 1
    index = region_training_cntys.RowNumber;
    region_training_data = CNTY_COVID(index, :);



    [idx, C] = kmeans(region_training_data, numcentroids, 'Replicates', number_replicates, 'Distance', distance); %completes the kmeans with x number of centroids for each division

    % Store data for the current region in separate variables
    cluster_data = cell(1, numcentroids);

    % Display data for each cluster
    for i = 1:numcentroids
        cluster_data{i} = region_training_cntys(idx == i, :);
        
        % Print cluster data for the current region and cluster
        fprintf('Region: %s, Cluster %d Data:\n', current_region, i);
        disp(cluster_data{i});
    end

    silhouette_vals = silhouette(region_training_data, idx);

    avg_silhouette = mean(silhouette_vals);
    
    % Create variable names based on region names
    variable_name = strcat('region_', region_name);
    
    % Assign data to separate variables in the workspace
    assignin('base', strcat(variable_name, '_region_name'), current_region);
    assignin('base', strcat(variable_name, '_cluster_data'), cluster_data);
    assignin('base', strcat(variable_name, '_average_silhouette'), avg_silhouette);
    assignin('base', strcat(variable_name, '_centroids'), C);
    centroids_cell{region_idx} = C;

    % Print the average silhouette value for the current region
    fprintf('Average Silhouette Score for Region %s: %.4f\n', current_region, avg_silhouette);
    all_centroids_matrix = [all_centroids_matrix; C];



end
mean_silhouette = mean([region_Pacific_average_silhouette, region_Mountain_average_silhouette, region_West_South_Central_average_silhouette, region_West_North_Central_average_silhouette, region_East_North_Central_average_silhouette, region_East_South_Central_average_silhouette, region_Middle_Atlantic_average_silhouette, region_South_Atlantic_average_silhouette, region_New_England_average_silhouette]);
fprintf('Mean Silhouette Score for All Regions: %.4f\n', mean_silhouette);
assignin('base', 'all_region_centroids', centroids_cell);


% Perform k-means clustering using the region_average_centroids as initial centroids
[idxOverall, COverall] = kmeans(CNTY_COVID, total_centroids, 'Start', all_centroids_matrix, 'Distance', distance2);

% Display the overall centroids
for i = 1:total_centroids
    fprintf('Data for Overall Centroid %d:\n', i);
    centroidData = CNTY_CENSUS(idxOverall == i, :);
    disp(centroidData);
    %assignin('base', strcat("finalCluster", string(i)), centroidData);
    %assignin('base', strcat('region_of_cluster_', string(i)), mode(centroidData.DIVISION));
    centroid_region_map = [centroid_region_map, mode(centroidData.DIVISION)];

end
% Calculate the overall silhouette value
silhouette_valsOverall = silhouette(CNTY_COVID, idxOverall);
bar(silhouette_valsOverall)

mean_silhouetteOverall = mean(silhouette_valsOverall);
fprintf('Overall Silhouette Score: %.4f\n', mean_silhouetteOverall);

%------------------------------------------------------------------------
% creating full testing set and classifying centroids

full_test_set = vertcat(Pacific_testing_data, Mountain_testing_data, ...
    West_South_Central_testing_data, West_North_Central_testing_data, ...
    East_North_Central_testing_data, East_South_Central_testing_data, ...
    Middle_Atlantic_testing_data, South_Atlantic_testing_data, ...
    New_England_testing_data);


save("centroidsAndTestData.mat", "full_test_set", "all_centroids_matrix", "centroid_region_map");