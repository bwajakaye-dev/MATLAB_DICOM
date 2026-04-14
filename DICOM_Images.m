% Find where the Image Processing Toolbox stores its sample data
toolboxDir = fullfile(matlabroot, 'toolbox', 'images', 'imdata');
dir(fullfile(toolboxDir, '*.dcm'))

% Search for all .dcm files in the MATLAB installation
dcmFiles = dir(fullfile(matlabroot, '**', '*.dcm'));
for i = 1:length(dcmFiles)
    fprintf('%s\n', fullfile(dcmFiles(i).folder, dcmFiles(i).name));
end

% Read the DICOM image pixel data
img = dicomread('CT-MONO2-16-ankle.dcm');

% Read the DICOM metadata
info = dicominfo('CT-MONO2-16-ankle.dcm');

% Display the image
figure;
imshow(img, []);  % The [] auto-scales the display window
title('Original DICOM Image');


% View key metadata fields available in YOUR DICOM file
fprintf('Patient Name: %s\n', info.PatientName.FamilyName);
fprintf('Modality: %s\n', info.Modality);
fprintf('Study Date: %s\n', info.StudyDate);
fprintf('Study Description: %s\n', info.StudyDescription);
fprintf('Manufacturer: %s\n', info.Manufacturer);
fprintf('Institution: %s\n', info.InstitutionName);
fprintf('Image Size: %d x %d\n', info.Rows, info.Columns);
fprintf('Bits Allocated: %d\n', info.BitsAllocated);
fprintf('Bits Stored: %d\n', info.BitsStored);
fprintf('Photometric Interpretation: %s\n', info.PhotometricInterpretation);
fprintf('Rescale Slope: %.2f\n', info.RescaleSlope);
fprintf('Rescale Intercept: %.2f\n', info.RescaleIntercept);
fprintf('Window Center: %.2f\n', info.WindowCenter);
fprintf('Window Width: %.2f\n', info.WindowWidth);
fprintf('Conversion Type: %s\n', info.ConversionType);
fprintf('Software Version: %s\n', info.SoftwareVersions);

% Dump everything
disp(info);

% Convert to double for processing
imgDouble = double(img);

% --- Technique 1: Median Filtering (removes salt-and-pepper noise/artifacts) ---
imgMedian = medfilt2(imgDouble, [5 5]);

% --- Technique 2: Wiener Filter (adaptive noise removal) ---
imgWiener = wiener2(imgDouble, [5 5]);

% --- Technique 3: Gaussian Smoothing (reduces general noise) ---
imgGauss = imgaussfilt(imgDouble, 1.5);

% --- Technique 4: Motion Blur Removal via Deconvolution ---
% Simulate or estimate a motion blur PSF
PSF = fspecial('motion', 15, 45);  % length=15, angle=45 degrees
imgDeblurred = deconvlucy(imgDouble, PSF, 20);  % Lucy-Richardson, 20 iterations

% --- Technique 5: Contrast Enhancement (CLAHE) ---
% Normalize to uint8 or uint16 first
imgNorm = mat2gray(imgDouble);
imgCLAHE = adapthisteq(imgNorm, 'ClipLimit', 0.02);

% --- Display all results side by side ---
figure;
subplot(2,3,1); imshow(imgDouble, []); title('Original');
subplot(2,3,2); imshow(imgMedian, []); title('Median Filter');
subplot(2,3,3); imshow(imgWiener, []); title('Wiener Filter');
subplot(2,3,4); imshow(imgGauss, []); title('Gaussian Smoothed');
subplot(2,3,5); imshow(imgDeblurred, []); title('Deconvolution');
subplot(2,3,6); imshow(imgCLAHE, []); title('CLAHE Enhanced');

% Compute quality metrics comparing enhanced vs original
% Using PSNR (Peak Signal-to-Noise Ratio) and SSIM (Structural Similarity)

refImg = mat2gray(imgDouble);  % normalize original as reference

methods = {'Median', 'Wiener', 'Gaussian', 'CLAHE'};
enhanced = {mat2gray(imgMedian), mat2gray(imgWiener), ...
            mat2gray(imgGauss), imgCLAHE};

fprintf('\n--- Image Quality Metrics ---\n');
for i = 1:length(methods)
    psnrVal = psnr(enhanced{i}, refImg);
    ssimVal = ssim(enhanced{i}, refImg);
    fprintf('%s: PSNR = %.2f dB, SSIM = %.4f\n', methods{i}, psnrVal, ssimVal);
end

% Write the enhanced image back as a new DICOM file
% Preserving the original metadata
enhancedImg = uint16(imgMedian);  % match original bit depth
dicomwrite(enhancedImg, 'enhanced_ankle.dcm', info);

% Verify it saved correctly
newInfo = dicominfo('enhanced_ankle.dcm');
disp(newInfo.Modality);