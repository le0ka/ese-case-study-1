%Load in COVID data and centroids
load centroidsAndTestData.mat;
load COVIDbyCounty.mat;
run("caseStudyKmeans.m");


% Totals to calculate accuracy
total_correct = 0;
total_incorrect = 0;

% loop through testing data
rowNums = full_test_set.RowNumber;
for i = 1: length(rowNums')
    % get current covid data vector + region from testing data set
    index = rowNums(i);
    row = CNTY_COVID(index, :);
    curr_region = CNTY_CENSUS(index, :).DIVISION;
    
    % initialize min values
    min_dist = intmax;
    min_centroid_region = 0;
    min_centroid = zeros(1, 256);
    
    % loop through all centroids
    for j = 1:height(all_centroids_matrix)
        % get current centroid + its region
        curr_centroid = all_centroids_matrix(j, :);
        curr_centroid_region = centroid_region_map(j);

        % calculate distance between current centroid and current testing
        % coivd vector
        dist = norm(curr_centroid - row); 
        
        % if current distance is smaller than min -> replace min
        if dist < min_dist
            min_dist = dist;
            min_centroid = curr_centroid;
            min_centroid_region = curr_centroid_region;
        end
    end
    
    % after closest centroid is found, check if it classified correctly
    if min_centroid_region ~= curr_region
        disp("incorrect");
        total_incorrect = total_incorrect+1;
    else
        disp("correct");
        total_correct = total_correct+1;
    end
end

% display accuracy
disp("Total Correct: " + total_correct);
disp("Total Incorrect: " + total_incorrect);
disp("Percentage Of Correct Guesses: " + total_correct/height(full_test_set));

