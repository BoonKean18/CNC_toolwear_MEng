
%load data
load('Segmented_Machining_Baseline.mat');


%iterate through each entry
for i = 1:420
    %iterate through the fields
    for j = 1:6
        
        %define the names for each field of interest from the original dataset
        field = {'PLATE_X','PLATE_Y','PLATE_Z','SPINDLE_X', 'SPINDLE_Y', 'SPINDLE_Z'};
        
        %define the field names for the result struct
        field_name_MEAN = sprintf('MEAN_%s', field{j});
        field_name_SD = sprintf('STANDARD_DEVIATION_%s', field{j});
        field_name_RMS = sprintf('RMS_%s', field{j});
        field_name_KURTOSIS = sprintf('KURTOSIS_%s', field{j});
        field_name_SKEWNESS = sprintf('SKEWNESS_%s', field{j});
        field_name_P2P = sprintf('PEAK2PEAK_%s', field{j});
        field_name_CREST = sprintf('CREST_%s', field{j});
        field_name_SHAPE = sprintf('SHAPE_%s', field{j});
        field_name_IMPULSE = sprintf('IMPULSE_%s', field{j});
        field_name_MARGIN = sprintf('MARGIN_%s', field{j});
        field_name_ENERGY = sprintf('ENERGY_%s', field{j});
        field_name_FFT = sprintf('FFT_%s', field{j});
        
        
        %create a cell that has all the field names
        name = {field_name_MEAN, field_name_SD, field_name_RMS, field_name_KURTOSIS, field_name_SKEWNESS, field_name_P2P, field_name_CREST, field_name_SHAPE, field_name_IMPULSE, field_name_MARGIN, field_name_ENERGY, field_name_FFT};
        
        
        %obtain the fieldnames from the input structure
        fn=fieldnames(BaselineCrop);
        
        
        %values needed for crest factor, shape factor and impulse factor
        %max value
        mx = max(BaselineCrop(i).(fn{j}));
        %RMS
        root_ms = rms(BaselineCrop(i).(fn{j}));
        %absolute mean value
        abs_mean = meanabs(BaselineCrop(i).(fn{j}));
        %square of absolute mean value
        abs_mean_sqr = abs_mean^2;
        
        
        %Time domain feature extraction
        %mean
        result(i).(name{1}) = mean(BaselineCrop(i).(fn{j}));
        %standard deviation
        result(i).(name{2}) = std(BaselineCrop(i).(fn{j}));
        %root mean square
        result(i).(name{3}) = root_ms;
        %kurtosis
        result(i).(name{4}) = kurtosis(BaselineCrop(i).(fn{j}));
        %skewness
        result(i).(name{5}) = skewness(BaselineCrop(i).(fn{j}));
        %peak-to-peak
        result(i).(name{6}) = peak2peak(BaselineCrop(i).(fn{j}));
        %crest factor
        result(i).(name{7}) = mx/root_ms;
        %shape factor
        result(i).(name{8}) = root_ms/abs_mean;
        %impulse factor
        result(i).(name{9}) = mx/abs_mean;
        %margin factor
        result(i).(name{10}) = mx/abs_mean_sqr;
        %energy
        result(i).(name{11}) = meansqr(BaselineCrop(i).(fn{j}));
        
        
        
        
        
        
       
    end
end

%convert structure to table
final_result = struct2table(result);

%export result to excel
filename = 'extracted_features_baseline.xlsx';
writetable(final_result,filename);


        
    