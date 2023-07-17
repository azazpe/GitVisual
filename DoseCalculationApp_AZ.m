function DoseCalculationApp_AZ
% Create figure
hFig = figure('Position',[200 20 1000 800],'MenuBar','none');

% Create axes and titles
hAxes1 = axes('Parent',hFig,'Units','normalized','Position',[0.05 0.525 0.22 0.4]);
title(hAxes1,'I');

hAxes1b = axes('Parent',hFig,'Units','normalized','Position',[0.285 0.525 0.22 0.4]);
title(hAxes1b,'I0');

hAxes2 = axes('Parent',hFig,'Units','normalized','Position',[0.52 0.525 0.45 0.4]);
title(hAxes2,'Mapa de Dosis');

hAxes3 = axes('Parent',hFig,'Units','normalized','Position',[0.05 0.05 0.22 0.4]);
title(hAxes3,'Histogram');

hTextBox = uicontrol('Style','text','FontSize',12,'Units','normalized','Position',[0.3 0.05 0.65 0.4],...
                  'HorizontalAlignment','left');

% Create load image button
hLoad = uicontrol('Style','pushbutton','String','Load Image','Units','normalized','Position',[.05 .95 .1 .03],...
                  'Callback',@loadImageCallback);

% Create crop button
hCrop = uicontrol('Style','pushbutton','String','Crop Image','Units','normalized','Position',[.16 .95 .1 .03],...
                  'Callback',@cropImageCallback);

% Create dropdown menu for calculation method
hMethod = uicontrol('Style','popupmenu','String',{'getDoseT1_I','getDoseT3_I'},'Units','normalized','Position',[.27 .95 .1 .03]);

% Create calculate and display button
hCalcAndDisp = uicontrol('Style','pushbutton','String','Calculate & Display','Units','normalized','Position',[.38 .95 .1 .03],...
                  'Callback',@calcAndDispCallback);

% Create save dose map button
hSaveDoseMap = uicontrol('Style','pushbutton','String','Save Dose Map','Units','normalized','Position',[.49 .95 .1 .03],...
                  'Callback',@saveDoseMapCallback);
                  
% Define global variables
global imPath I I0 D dD maxBits

imPath = '';
I = [];
I0 = [];
D = [];
dD = [];
maxBits = [];

% Callback functions
    function loadImageCallback(~,~)
        [file,path] = uigetfile('*.tif');
        if ~isequal(file,0)
            imPath = fullfile(path,file);
            I_orig = imread(imPath);
            imshow(I_orig, 'Parent', hAxes1);
            I = I_orig;
        end
    end


    function cropImageCallback(~,~)
        if isempty(I)
            return;
        end
        I = imcrop(I);
        imshow(I, 'Parent', hAxes1);
    end


    function calcAndDispCallback(~,~)
        % Calculate dose
        method = hMethod.String{hMethod.Value};
        [pixCM, maxBits] = getImgMetaInfo(imPath);
       scriptPath = [];
        dataFilePath = []; 
        dataFilePath3 = []; 
        CoefB1_noHDR = []; 
        CoefB1_siHDR = []; 
        CoefB3_noHDR = [];
        CoefB3_siHDR = []; 
        CoefG1_noHDR = []; 
        CoefG1_siHDR = []; 
        CoefG3_noHDR = [];
        CoefG3_siHDR = []; 
        CoefR1_noHDR = []; 
        CoefR1_siHDR = []; 
        CoefR3_noHDR = [];
        CoefR3_siHDR = []; 
        dCoefB1_noHDR = []; 
        dCoefB1_siHDR = []; 
        dCoefB3_noHDR = [];
        dCoefB3_siHDR = []; 
        dCoefG1_noHDR = []; 
        dCoefG1_siHDR = []; 
        dCoefG3_noHDR = [];
        dCoefG3_siHDR = []; 
        dCoefR1_noHDR = []; 
        dCoefR1_siHDR = []; 
        dCoefR3_noHDR = [];
        dCoefR3_siHDR = []; 
        RCCalCoefs = []; 
        RCCalCoefs3 = [];
        basePath = [];
        calFile = [];
        calFile3 = [];
        fullCalFilePath = []; 
        fullCalFilePath3 = [];

        loadRCCoefs
        %loadRCCoefsV2('C:\Users\azazp\OneDrive\Escritorio\ProyectoGit\Aplicacion Visual Matlab Radiocromicas\GFNtools-Adrian');
        % Insert your original path for loading coefs
        % Call the method you want based on method
        if strcmp(method,'getDoseT1_I')
            [D, dD] = getDoseT1_I(I, maxBits);
        elseif strcmp(method,'getDoseT3_I')
            if isempty(I0)
                [file,path] = uigetfile('*.tif');
                if ~isequal(file,0)
                    I0 = imread(fullfile(path,file));
                    I0 = imcrop(I0);  % Allow cropping of reference image
                    imshow(I0, 'Parent', hAxes1b); %
                end
            end
            [D, dD] = getDoseT3_I(I, I0, maxBits);
        end
        
        
        % Convert axis from pixels to cm
        pixelSize = 0.01693;  % Pixel size in cm
        imagesc(D,'Parent',hAxes2, 'XData', [0 size(D,2)*pixelSize], 'YData', [0 size(D,1)*pixelSize]); 
        hAxes2.XLabel.String = 'cm'; 
        hAxes2.YLabel.String = 'cm'; 
        hcolorbar = colorbar('peer',hAxes2);
        hcolorbar.Label.String = 'Gy'; 

        % Display Histogram
        histogram(hAxes3,D(:),100);
        title(hAxes3,'Histogram');
        xlabel(hAxes3,'Dose [Gy]');
        ylabel(hAxes3,'Frequency');

        % Show Statistics
        minDose = min(D(:));
        maxDose = max(D(:));
        meanDose = mean(D(:));
        medianDose = median(D(:));
        stdDose = std(D(:));
        hTextBox.String = sprintf('Min: %.2f\nMax: %.2f\nMean: %.2f\nMedian: %.2f\nStd: %.2f',minDose,maxDose,meanDose,medianDose,stdDose);
    end
    
    function saveDoseMapCallback(~,~)
    if isempty(D)
        return;
    end
    [file,path] = uiputfile('*.mat');
    if ~isequal(file,0)
        save(fullfile(path,file), 'D');
    end
    end
end
