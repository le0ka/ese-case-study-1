load COVIDbyCounty.mat;

[idx, C] = kmeans(CNTY_COVID, 9);

logInd = (idx == 1);

disp(CNTY_CENSUS(logInd, :));