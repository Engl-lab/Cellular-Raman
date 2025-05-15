% smoothening data and linear baseline subtraction 
% for Renishaw Raman spectrum in 633 grating
% change parametres if xx length is not 1015
%input xx 
%input y (stacked or arrayed) as data 

if size(data, 2) == 1
n = size (data,1);
raw_data = [];
grouped_data = cell(ceil(n/1015), 1); 
for i = 1:ceil(n/1015)
    start_idx = (i-1)*1015 + 1; 
    end_idx = min(i*1015, n); 
    grouped_data{i} = data(start_idx:end_idx);
    raw_data(:,i) =  data(start_idx:end_idx); 
end
clear n i end_idx grouped_data start_idx
data = raw_data;
end

n = size (data,2);
windowSize = 11;
polynomialOrder = 3;
data = sgolayfilt(data, polynomialOrder, windowSize);
startIdx1 = 322;
endIdx1 = 382;
startIdx2 = 670;
endIdx2 = 725;
startIdx3 = 962;
endIdx3 = 1015;
minValues = zeros(3, n);
minIndices = zeros(3, n);
minPosition= zeros(3, n);

for col = 1:n
    range1 = data(startIdx1:endIdx1, col);
    range2 = data(startIdx2:endIdx2, col);
    range3 = data(startIdx3:endIdx3, col);
    minValues(1, col) = min(range1);
    minValues(2, col) = min(range2);
    minValues(3, col) = min(range3);
    [minValue1, minIndex1] = min(range1);
    [minValue2, minIndex2] = min(range2);
    [minValue3, minIndex3] = min(range3);    
    minIndices(1, col) = minIndex1 + startIdx1 - 1;
    minIndices(2, col) = minIndex2 + startIdx2 - 1;
    minIndices(3, col) = minIndex3 + startIdx3 - 1;
end

for row = 1:3
    for col = 1:n
        index = minIndices(row, col);
        value = xx(index);
        minPosition(row, col) = value;
    end
end
tbl_temp = zeros (size (data));

for col = 1:n
    fit_x = [minPosition(1,col); minPosition(2,col); minPosition(3,col)];
    fit_y = [minValues(1,col); minValues(2,col); minValues(3,col)];
    x_interp = xx; 
y_interp = interp1(fit_x, fit_y, x_interp, 'linear'); 

data_temp = data(:,col) - y_interp;

tbl_temp (:,col) = data_temp;
end

temp_1 = zeros (1,n);
temp_2 = zeros (1,n);
for col = 1:n
    if any (tbl_temp (670:1015,col)<0)
   neg_temp = min(tbl_temp(670:1015, col));
   minpos_temp = find (tbl_temp (:,col) == neg_temp);
   neg_pos = xx (minpos_temp);
   neg_val = data (minpos_temp,col);
   temp_1 (:,col) = neg_pos;
   temp_2 (:,col) = neg_val;
    else 
   temp_1 (:,col) =   (minPosition(1,col) + minPosition(2,col))/2;
   temp_2 (:,col) =   (minValues(1,col)+ minValues(2,col))/2;
    end
end
minPosition = [minPosition;temp_1];
minValues = [minValues; temp_2];
for col = 1:n
    fit_x = [minPosition(1,col); minPosition(2,col); minPosition(3,col); minPosition(4,col)];
    fit_y = [minValues(1,col); minValues(2,col); minValues(3,col); minValues(4,col)];
    x_interp = xx;  
y_interp = interp1(fit_x, fit_y, x_interp, 'linear'); 
data_temp = data(:,col) - y_interp;
tbl_temp (:,col) = data_temp;
end
temp_3 = zeros (1,n);
temp_4 = zeros (1,n);  
for col = 1:n
    if any (tbl_temp (670:1015,col)<0)
   neg_temp = min(tbl_temp(670:1015, col));
   minpos_temp = find (tbl_temp (:,col) == neg_temp);
   neg_pos = xx (minpos_temp);
   neg_val = data (minpos_temp,col);
   temp_3 (:,col) = neg_pos;
   temp_4 (:,col) = neg_val;
    else 
   temp_3 (:,col) =  2* (minPosition(1,col) + minPosition(2,col))/3;
   temp_4 (:,col) =  2* (minValues(1,col)+ minValues(2,col))/3;
    end
end
minPosition = [minPosition;temp_3];
minValues = [minValues; temp_4];
for col = 1:n
    fit_x = [minPosition(1,col); minPosition(2,col); minPosition(3,col); minPosition(4,col);minPosition(5,col)];
    fit_y = [minValues(1,col); minValues(2,col); minValues(3,col); minValues(4,col);minValues(5,col)];
    x_interp = xx;  
y_interp = interp1(fit_x, fit_y, x_interp, 'linear'); 
data_temp = data(:,col) - y_interp;
tbl_temp (:,col) = data_temp;
end
result = tbl_temp;
result(isnan(result)) = 0;
result((result<0)) = 0;
result1 = result (352:1015,:);
result1 = result1(1:637,:);
x1=xx(352:1015); x1=x1(1:637);

clear m* range* start* temp* neg* tbl_temp value x_interp y_interp endIdx* data_temp index fit*
figure;
plot (xx,raw_data);
figure; 
plot (x1,result1)
