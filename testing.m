load centroidsAndTestData.mat;
load COVIDbyCounty.mat;

%classifying centroids?????

%This will loop through testing data and find centroid each one is closest
%to, still need to add some way to check correctness
rowNums = full_test_set.RowNumber;
for i = 1: length(rowNums')
    index = rowNums(i);
    row = CNTY_COVID(index, :);
    
    min_dist = intmax;
    min_centroid = zeros(1, 256);

    for j = 1:height(all_centroids_matrix)
        curr_centroid = all_centroids_matrix(j, :);
        dist = norm(curr_centroid - row);

        if dist < min_dist
            min_dist = dist;
            min_centroid = curr_centroid;
        end
    end
end

