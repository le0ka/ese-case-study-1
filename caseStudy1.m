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


[idx, C] = kmeans(pacific_training_data, 2);


%Broken becuase idexes changed - fix now!!!!!!!!!!!!
logInd1 = (idx == 1);
logInd2 = (idx == 2);

disp(CNTY_CENSUS(logInd1, :));
disp(CNTY_CENSUS(logInd2, :));

% lop of last 25 % of data from training set to be used as test data 
% 9 centroids ? one for each region



