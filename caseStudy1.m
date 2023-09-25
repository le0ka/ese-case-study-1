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

pacific_cntys = CNTY_CENSUS(idx_pacific, :);
pacific_cntys_sorted = sortrows(pacific_cntys, "POPESTIMATE2021", 'descend');
max = pacific_cntys_sorted(1, :);



