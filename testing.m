% THIS FILE IS TOTALLY INCORRECT!!!!!!!!!!!!!!!!!! - will be fixed soon
load centroidsAndTestData.mat;
load COVIDbyCounty.mat;

%This will loop through testing data and find centroid each one is closest
%to, will print out correct or incorrect

rowNums = full_test_set.RowNumber;
for i = 1: length(rowNums')
    index = rowNums(i);
    row = CNTY_COVID(index, :);
    curr_region = CNTY_CENSUS(index, :).DIVISION;
    
    min_dist = intmax;
    min_centroid_region = 0;
    min_centroid = zeros(1, 256);

    for j = 1:height(all_centroids_matrix)
        curr_centroid = all_centroids_matrix(j, :);
        curr_centroid_region = centroid_region_map(j);
        dist = norm(curr_centroid - row);

        if dist < min_dist
            min_dist = dist;
            min_centroid = curr_centroid;
            min_centroid_region = curr_centroid_region;
        end
    end

    if min_centroid_region ~= curr_region
        disp("incorrect");
    else
        disp("correct");
    end
end

