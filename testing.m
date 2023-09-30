load centroidsAndTestData.mat;
load COVIDbyCounty.mat;

%classifying centroids

regions = ["Pacific", "Mountain", "West South Central", "West North Central", ...
           "East North Central", "East South Central", "Middle Atlantic", ...
           "South Atlantic", "New England"];
regions_num = [1, 2, 3, 4, 5, 6, 7, 8, 9];

num_centroids = height(all_centroids_matrix) / 9;

region_centroid_map = [];

for k = 1:length(regions)
    repeatedEntry = repmat(regions_num(k), 1, num_centroids);
    region_centroid_map = [region_centroid_map, repeatedEntry];
end



%This will loop through testing data and find centroid each one is closest
%to, still need to add some way to check correctness

rowNums = full_test_set.RowNumber;
for i = 1: length(rowNums')
    index = rowNums(i);
    row = CNTY_COVID(index, :);
    curr_region = CNTY_CENSUS(index, :).REGION;
    
    min_dist = intmax;
    min_centroid_region = 0;
    min_centroid = zeros(1, 256);

    for j = 1:height(all_centroids_matrix)
        curr_centroid = all_centroids_matrix(j, :);
        curr_centroid_region = region_centroid_map(j);
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

