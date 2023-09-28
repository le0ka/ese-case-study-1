load COVIDbyCounty.mat;

regions = ["Pacific", "Mountain", "West South Central", "West North Central", ...
           "East North Central", "East South Central", "Middle Atlantic", ...
           "South Atlantic", "New England"];

for region_idx = 1:length(regions)
    current_region = regions(region_idx);
    
    idx_region = (CNTY_CENSUS.DIVNAME == current_region);
    
    numRows = size(CNTY_CENSUS, 1);
    rowNumber = (1:numRows);

    CNTY_CENSUS.RowNumber = rowNumber';

    region_cntys = CNTY_CENSUS(idx_region, :);
    region_cntys_sorted = sortrows(region_cntys, "POPESTIMATE2021", 'descend');
    max = region_cntys_sorted(1, :);

    region_testing_cntys = table();
    region_training_cntys = table();

    for i = 1:size(region_cntys_sorted, 1)
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

    index = zeros(height(region_training_data),1);
    index = region_training_cntys.RowNumber;
    region_training_data = CNTY_COVID(index, :);

    numcentroids = 5;
    num_replicates = 10;
    distance_metric = 'cosine';

    [idx, C] = kmeans(region_training_data, numcentroids);

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
    assignin('base', strcat(variable_name, '_average_centroid'), mean(C, 1));
    
    % Print the average silhouette value for the current region
    fprintf('Average Silhouette Score for Region %s: %.4f\n', current_region, avg_silhouette);
end
