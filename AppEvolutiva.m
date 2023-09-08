classdef AppEvolutiva < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        I;
        I0;
        imPath;
        imPath2;
        I_orig;
        D;
        RE;
        c;
        selectedCalculationMethod = 'Pixel Value';  % Valor predeterminado
        UIAxes5                        matlab.ui.control.UIAxes
        Label4                         matlab.ui.control.Label
        CalREButton                    matlab.ui.control.Button
        RETextArea                     matlab.ui.control.TextArea
        RETextAreaLabel                matlab.ui.control.Label
        Stadistics                       matlab.ui.control.TextArea
        StadisticsLabel                  matlab.ui.control.Label
        UIFigure                       matlab.ui.Figure
        ListListBox                    matlab.ui.control.ListBox
        ListListBoxLabel               matlab.ui.control.Label
        Label3                         matlab.ui.control.Label
        Label2                         matlab.ui.control.Label
        Image                          matlab.ui.control.Image
        RelativeEfficiencyREPanel      matlab.ui.container.Panel
        ApplyREButton                  matlab.ui.control.Button
        SpacecmEditField               matlab.ui.control.NumericEditField
        SpacecmEditFieldLabel          matlab.ui.control.Label
        EnergyMeVEditField             matlab.ui.control.NumericEditField
        EnergyMeVEditFieldLabel        matlab.ui.control.Label
        RadiochromicTypeDropDown       matlab.ui.control.DropDown
        RadiochromicTypeDropDownLabel  matlab.ui.control.Label
        TabGroup                       matlab.ui.container.TabGroup
        LoadImageTab                   matlab.ui.container.Tab
        ProblemImageLabel              matlab.ui.control.Label
        ReferenceImageLabel            matlab.ui.control.Label
        ResetImageButton_2             matlab.ui.control.Button
        UncropButton                   matlab.ui.control.Button
        ResetImageButton               matlab.ui.control.Button
        LoadRefImageButton             matlab.ui.control.Button
        CropImageButton                matlab.ui.control.Button
        LoadProblemImageButton         matlab.ui.control.Button
        CalibrationsTab                matlab.ui.container.Tab
        netODButton_3                  matlab.ui.control.StateButton
        pvButton                       matlab.ui.control.StateButton
        ShowcalibrationmethodLabel     matlab.ui.control.Label
        SelectcalibrationmethodLabel   matlab.ui.control.Label
        netODButton_2                  matlab.ui.control.Button
        PixelValueButton_2             matlab.ui.control.Button
        CalculateTab                   matlab.ui.container.Tab
        CalculateButton                matlab.ui.control.Button
        DoseprofileLabel               matlab.ui.control.Label
        DosemaphistogramandstadisticsLabel  matlab.ui.control.Label
        CalButton                      matlab.ui.control.Button
        UIAxes4                        matlab.ui.control.UIAxes
        UIAxes3                        matlab.ui.control.UIAxes
        UIAxes2                        matlab.ui.control.UIAxes
        UIAxes                         matlab.ui.control.UIAxes
    end

    % Callbacks that handle component events
    methods (Access = private)

%         % Button pushed function: LoadProblemImageButton
%         function LoadProblemImageButtonPushed(app, event)
%             
%             [file,path] = uigetfile('*.tif');
%         if ~isequal(file,0)
%             app.imPath = fullfile(path,file);
%             app.I_orig = imread(app.imPath);
%             imshow(app.I_orig, 'Parent', app.UIAxes);        
%         end
%         end

        function LoadProblemImageButtonPushed(app, event)
        [file, path] = uigetfile('*.tif');
        if ~isequal(file,0)
        app.imPath = fullfile(path, file);
        app.I_orig = imread(app.imPath);
        
        % Convert axis from pixels to cm
        pixelSize = 0.01693;   % Pixel size in cm
        xExtent = [-size(app.I_orig,2)*pixelSize/2, size(app.I_orig,2)*pixelSize/2];
        yExtent = [-size(app.I_orig,1)*pixelSize/2, size(app.I_orig,1)*pixelSize/2];
        
        imagesc(app.I_orig, 'Parent', app.UIAxes, 'XData', xExtent, 'YData', yExtent);
        
        % Updating the axis labels
        app.UIAxes.XLabel.String = 'cm';
        app.UIAxes.YLabel.String = 'cm';
        end
        end

        
        % Button pushed function: ResetImageButton
         function ResetImageButtonPushed(app, event)
        % Clear the UIAxes content
         cla(app.UIAxes, 'reset');
        % Reset the original image property
         app.I_orig = [];
         end

        % Button pushed function: CropImageButton
        function CropImageButtonPushed(app, event)
        % Now call imcrop
        app.I = imcrop(app.UIAxes);
%         imshow(app.I, 'Parent', app.UIAxes);
        % Convert axis from pixels to cm
        pixelSize = 0.01693;
        xExtent = [-size(app.I,2)*pixelSize/2, size(app.I,2)*pixelSize/2];
        yExtent = [-size(app.I,1)*pixelSize/2, size(app.I,1)*pixelSize/2];
        
        imagesc(app.I, 'Parent', app.UIAxes, 'XData', xExtent, 'YData', yExtent);
        
         % Updating the axis labels
         app.UIAxes.XLabel.String = 'cm';
         app.UIAxes.YLabel.String = 'cm';
        end

        % Button pushed function: UncropButton
        function UncropButtonPushed(app, event)
        % Show the original image stored in the property
        pixelSize = 0.01693;   % Pixel size in cm
        xExtent = [-size(app.I_orig,2)*pixelSize/2, size(app.I_orig,2)*pixelSize/2];
        yExtent = [-size(app.I_orig,1)*pixelSize/2, size(app.I_orig,1)*pixelSize/2];
        
        imagesc(app.I_orig, 'Parent', app.UIAxes, 'XData', xExtent, 'YData', yExtent);
        end

        % Button pushed function: LoadRefImageButton
        function LoadRefImageButtonPushed(app, event)
             [file,path] = uigetfile('*.tif');
            if ~isequal(file,0)
            app.imPath2 = fullfile(path,file);
            app.I0 = imread(app.imPath2);
        % Convert axis from pixels to cm
        pixelSize = 0.01693;
        xExtent = [-size(app.I0,2)*pixelSize/2, size(app.I0,2)*pixelSize/2];
        yExtent = [-size(app.I0,1)*pixelSize/2, size(app.I0,1)*pixelSize/2];
        
        imagesc(app.I0, 'Parent', app.UIAxes5, 'XData', xExtent, 'YData', yExtent);
        % Updating the axis labels
        app.UIAxes.XLabel.String = 'cm';
        app.UIAxes.YLabel.String = 'cm';

        app.I0 = imcrop(app.UIAxes5);
        xExtent = [-size(app.I0,2)*pixelSize/2, size(app.I0,2)*pixelSize/2];
        yExtent = [-size(app.I0,1)*pixelSize/2, size(app.I0,1)*pixelSize/2];
        imagesc(app.I0, 'Parent', app.UIAxes5, 'XData', xExtent, 'YData', yExtent);

        % Updating the axis labels
        app.UIAxes5.XLabel.String = 'cm';
        app.UIAxes5.YLabel.String = 'cm';

            end
        end

        % Button pushed function: ResetImageButton_2
        function ResetImageButton_2Pushed(app, event)
        % Reset the reference image property
        % Clear the UIAxes content
         cla(app.UIAxes5, 'reset');
         app.I0 = [];
        end

         % Value changed function: pvButton
        function pvButtonValueChanged(app, event)
            app.selectedCalculationMethod = 'Pixel Value';
        end

        % Value changed function: netODButton_3
        function netODButton_3ValueChanged(app, event)
            app.selectedCalculationMethod = 'netOD';
        end

        function CalculateButtonPushed(app, event)
        [pixCM, maxBits] = getImgMetaInfo(app.imPath);
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
              if strcmp(app.selectedCalculationMethod, 'Pixel Value')
              
              %app.I = app.I - mean(app.I0(:));  %% A ver que pasa?
              [app.D, dD] = getDoseT1_I(app.I, maxBits);
              app.Label3.Text = sprintf("You are using Pixel Value calibration");

              else 
              
              [app.D, dD] = getDoseT3_I(app.I, app.I0, maxBits);
              app.Label3.Text = sprintf("You are using netOD calibration");
              end
        

        % Convert axis from pixels to cm
        pixelSize = 0.01693;   % Pixel size in cm
        imagesc(app.D,'Parent',app.UIAxes2, 'XData', [-size(app.D,2)*pixelSize size(app.D,2)*pixelSize], 'YData', [-size(app.D,1)*pixelSize size(app.D,1)*pixelSize]); 
        app.UIAxes2.XLabel.String = 'cm'; 
        app.UIAxes2.YLabel.String = 'cm'; 
        hcolorbar = colorbar('peer',app.UIAxes2);
        hcolorbar.Label.String = 'Gy'; 

        % Display Histogram
        histogram(app.UIAxes3,app.D(:),100);
        title(app.UIAxes3,'Histogram');
        xlabel(app.UIAxes3,'Dose [Gy]');
        ylabel(app.UIAxes3,'Frequency');

        % Show Statistics
        minDose = min(app.D(:));
        maxDose = max(app.D(:));
        meanDose = mean(app.D(:));
        medianDose = median(app.D(:));
        stdDose = std(app.D(:));
        app.Stadistics.Value = sprintf('Min: %.2f\nMax: %.2f\nMean: %.2f\nMedian: %.2f\nStd: %.2f', minDose, maxDose, meanDose, medianDose, stdDose);
        

        end

        % Button pushed function: CalButton
     function CalButtonPushed(app, event)
    % Mostrar un mensaje 
    %uialert(app.UIFigure, 'Dibuja una línea en la imagen para obtener el perfil de dosis.', 'Perfil');
    t = msgbox('Draw a line on the Problem Image to obtain the dose profile. Double click on the drawn line.', 'Profile', 'help');
    pause(3.5);
    delete(t);
    
    % Permitir al usuario dibujar una línea en app.UIAxes
    h = drawline(app.UIAxes);
    
    % Esperar a que el usuario termine de dibujar la línea
    wait(h);
    
    % Obtener las posiciones de la línea
    pos = h.Position;

    % Convertir las coordenadas de pos de centímetros a píxeles
    pixelSize = 0.01693;   % Tamaño de píxel en cm
    posPixel = pos / pixelSize;
    posPixel(:,1) = posPixel(:,1) + size(app.D,2)/2;  % Ajuste para el origen
    posPixel(:,2) = posPixel(:,2) + size(app.D,1)/2;  % Ajuste para el origen
    
    % Asegúrate de que D está definido y accesible. Si no es así, 
    % puedes tener que pasar D como una propiedad de la app o cargarlo de otra forma.
    app.c = improfile(app.D, posPixel(:,1), posPixel(:,2));
    
    % Mostrar el perfil en app.UIAxes4
    plot(app.UIAxes4, app.c);
    title(app.UIAxes4, 'Line Profile');
    xlabel(app.UIAxes4, 'Position');
    ylabel(app.UIAxes4, 'Dose [Gy]');
    end

     % Button pushed function: CalREButton
        function CalREButtonPushed(app, event)
            
           % Obtener números de los Edit Fields
          E0 = app.EnergyMeVEditField.Value;
          z = app.SpacecmEditField.Value;
          wfilmType = app.RadiochromicTypeDropDown.Value;
          if strcmp(wfilmType,'EBT3')
              filmType = 1;
          else 
              filmType = 2;
          end
              
%  % Verificar si los valores ingresados son números válidos
%     if isnan(E0)
%         app.RETextArea.Value = 'El valor en EditField1 no es un número válido.';
%         return;
%     end
%     if isnan(z)
%         app.RETextArea.Value = 'El valor en EditField2 no es un número válido.';
%         return;
%     end

          app.RE = EficienciaRelativa(E0,z,filmType);
          app.RETextArea.Value = sprintf('%.2f', app.RE);

        end

        % Button pushed function: ApplyREButton
        function ApplyREButtonPushed(app, event)
            % Divide dose by RE
            app.D = app.D/ app.RE;
            app.c = app.c/ app.RE;

            app.Label4.Text = sprintf('You are using a Relative Efficiency of %.2f',app.RE);

        % Convert axis from pixels to cm
        pixelSize = 0.01693;   % Pixel size in cm
        imagesc(app.D,'Parent',app.UIAxes2, 'XData', [-size(app.D,2)*pixelSize size(app.D,2)*pixelSize], 'YData', [-size(app.D,1)*pixelSize size(app.D,1)*pixelSize]); 
        app.UIAxes2.XLabel.String = 'cm'; 
        app.UIAxes2.YLabel.String = 'cm'; 
        hcolorbar = colorbar('peer',app.UIAxes2);
        hcolorbar.Label.String = 'Gy'; 

        % Display Histogram
        histogram(app.UIAxes3,app.D(:),100);
        title(app.UIAxes3,'Histogram');
        xlabel(app.UIAxes3,'Dose [Gy]');
        ylabel(app.UIAxes3,'Frequency');

        % Show Statistics
        minDose = min(app.D(:));
        maxDose = max(app.D(:));
        meanDose = mean(app.D(:));
        medianDose = median(app.D(:));
        stdDose = std(app.D(:));
        app.Stadistics.Value = sprintf('Min: %.2f\nMax: %.2f\nMean: %.2f\nMedian: %.2f\nStd: %.2f', minDose, maxDose, meanDose, medianDose, stdDose);

        % Mostrar el perfil en app.UIAxes4
         plot(app.UIAxes4, app.c);
         title(app.UIAxes4, 'Line Profile');
         xlabel(app.UIAxes4, 'Position');
         ylabel(app.UIAxes4, 'Dose [Gy]');
         
         %PONER BIEN EL MENSAJE: 
         %app.Label3.Text = sprintf("Está utilizando la calibración %.2f y utilizando un RE de %.2f.", app.selectedCalculationMethod, app.RE);
        end

        

    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 1306 855];
            app.UIFigure.Name = 'MATLAB App';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, 'Problem Image')
            xlabel(app.UIAxes, 'cm')
            ylabel(app.UIAxes, 'cm')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.Position = [406 552 224 208];


            % Create UIAxes2
            app.UIAxes2 = uiaxes(app.UIFigure);
            title(app.UIAxes2, 'Dose Map ')
            xlabel(app.UIAxes2, 'cm')
            ylabel(app.UIAxes2, 'cm')
            zlabel(app.UIAxes2, 'Z')
            app.UIAxes2.Position = [881 519 336 289];

            % Create UIAxes3
            app.UIAxes3 = uiaxes(app.UIFigure);
            title(app.UIAxes3, 'Histogram')
            xlabel(app.UIAxes3, 'Dose [Gy]')
            ylabel(app.UIAxes3, 'Frequency')
            zlabel(app.UIAxes3, 'Z')
            app.UIAxes3.Position = [406 180 272 229];

            % Create UIAxes4
            app.UIAxes4 = uiaxes(app.UIFigure);
            title(app.UIAxes4, 'Dose Profile')
            xlabel(app.UIAxes4, 'Position')
            ylabel(app.UIAxes4, 'Dose [Gy]')
            zlabel(app.UIAxes4, 'Z')
            app.UIAxes4.Position = [917 180 281 229];

            % Create TabGroup
            app.TabGroup = uitabgroup(app.UIFigure);
            app.TabGroup.Position = [28 341 293 360];

            % Create LoadImageTab
            app.LoadImageTab = uitab(app.TabGroup);
            app.LoadImageTab.Title = 'Load Image';

            % Create LoadProblemImageButton
            app.LoadProblemImageButton = uibutton(app.LoadImageTab, 'push');
            app.LoadProblemImageButton.ButtonPushedFcn = createCallbackFcn(app, @LoadProblemImageButtonPushed, true);
            app.LoadProblemImageButton.Position = [19 235 130 28];
            app.LoadProblemImageButton.Text = 'Load Problem Image';

            % Create CropImageButton
            app.CropImageButton = uibutton(app.LoadImageTab, 'push');
            app.CropImageButton.ButtonPushedFcn = createCallbackFcn(app, @CropImageButtonPushed, true);
            app.CropImageButton.Position = [20 178 129 26];
            app.CropImageButton.Text = 'Crop Image';

            % Create LoadRefImageButton
            app.LoadRefImageButton = uibutton(app.LoadImageTab, 'push');
            app.LoadRefImageButton.ButtonPushedFcn = createCallbackFcn(app, @LoadRefImageButtonPushed, true);
            app.LoadRefImageButton.Position = [19 75 130 31];
            app.LoadRefImageButton.Text = 'Load Ref. Image';

            % Create ResetImageButton
            app.ResetImageButton = uibutton(app.LoadImageTab, 'push');
            app.ResetImageButton.ButtonPushedFcn = createCallbackFcn(app, @ResetImageButtonPushed, true);
            app.ResetImageButton.Position = [172 235 84 28];
            app.ResetImageButton.Text = 'Reset Image';

            % Create UncropButton
            app.UncropButton = uibutton(app.LoadImageTab, 'push');
            app.UncropButton.ButtonPushedFcn = createCallbackFcn(app, @UncropButtonPushed, true);
            app.UncropButton.Position = [172 175 84 28];
            app.UncropButton.Text = 'Uncrop';

            % Create ResetImageButton_2
            app.ResetImageButton_2 = uibutton(app.LoadImageTab, 'push');
            app.ResetImageButton_2.ButtonPushedFcn = createCallbackFcn(app, @ResetImageButton_2Pushed, true);
            app.ResetImageButton_2.Position = [172 75 84 31];
            app.ResetImageButton_2.Text = 'Reset Image';

            % Create ReferenceImageLabel
            app.ReferenceImageLabel = uilabel(app.LoadImageTab);
            app.ReferenceImageLabel.FontWeight = 'bold';
            app.ReferenceImageLabel.Position = [20 123 182 26];
            app.ReferenceImageLabel.Text = 'Reference Image:';

            % Create ProblemImageLabel
            app.ProblemImageLabel = uilabel(app.LoadImageTab);
            app.ProblemImageLabel.FontWeight = 'bold';
            app.ProblemImageLabel.Position = [20 284 178 29];
            app.ProblemImageLabel.Text = 'Problem Image: ';

            % Create CalibrationsTab
            app.CalibrationsTab = uitab(app.TabGroup);
            app.CalibrationsTab.Title = 'Calibrations';

            % Create PixelValueButton_2
            app.PixelValueButton_2 = uibutton(app.CalibrationsTab, 'push');
            app.PixelValueButton_2.Position = [25 98 148 26];
            app.PixelValueButton_2.Text = 'Pixel Value';

            % Create netODButton_2
            app.netODButton_2 = uibutton(app.CalibrationsTab, 'push');
            app.netODButton_2.Position = [25 47 148 29];
            app.netODButton_2.Text = 'netOD';

            % Create SelectcalibrationmethodLabel
            app.SelectcalibrationmethodLabel = uilabel(app.CalibrationsTab);
            app.SelectcalibrationmethodLabel.FontWeight = 'bold';
            app.SelectcalibrationmethodLabel.Position = [25 286 193 26];
            app.SelectcalibrationmethodLabel.Text = 'Select calibration method: ';

            % Create ShowcalibrationmethodLabel
            app.ShowcalibrationmethodLabel = uilabel(app.CalibrationsTab);
            app.ShowcalibrationmethodLabel.FontWeight = 'bold';
            app.ShowcalibrationmethodLabel.Position = [25 139 195 29];
            app.ShowcalibrationmethodLabel.Text = 'Show calibration method: ';

            % Create pvButton
            app.pvButton = uibutton(app.CalibrationsTab, 'state');
            app.pvButton.ValueChangedFcn = createCallbackFcn(app, @pvButtonValueChanged, true); %

            app.pvButton.Text = 'Pixel Value';
            app.pvButton.Position = [27 229 146 47];

            % Create netODButton_3
            app.netODButton_3 = uibutton(app.CalibrationsTab, 'state');
            app.netODButton_3.ValueChangedFcn = createCallbackFcn(app, @netODButton_3ValueChanged, true);
            app.netODButton_3.Text = 'netOD';
            app.netODButton_3.Position = [27 172 147 32];

            % Create CalculateTab
            app.CalculateTab = uitab(app.TabGroup);
            app.CalculateTab.Title = 'Calculate';

            % Create CalButton
            app.CalButton = uibutton(app.CalculateTab, 'push');
            app.CalButton.ButtonPushedFcn = createCallbackFcn(app, @CalButtonPushed, true);
            app.CalButton.Position = [26 105 158 44];
            app.CalButton.Text = 'Calculate';
          

            % Create DosemaphistogramandstadisticsLabel
            app.DosemaphistogramandstadisticsLabel = uilabel(app.CalculateTab);
            app.DosemaphistogramandstadisticsLabel.FontWeight = 'bold';
            app.DosemaphistogramandstadisticsLabel.Position = [26 276 230 35];
            app.DosemaphistogramandstadisticsLabel.Text = 'Dose map, histogram and stadistics:';

            % Create DoseprofileLabel
            app.DoseprofileLabel = uilabel(app.CalculateTab);
            app.DoseprofileLabel.FontWeight = 'bold';
            app.DoseprofileLabel.Position = [27 157 212 34];
            app.DoseprofileLabel.Text = 'Dose profile: ';

           
            % Create CalculateButton
            app.CalculateButton = uibutton(app.CalculateTab, 'push');
            app.CalculateButton.ButtonPushedFcn = createCallbackFcn(app, @CalculateButtonPushed, true);
            app.CalculateButton.Position = [27 225 158 38];
            app.CalculateButton.Text = 'Calculate';

            % Create RelativeEfficiencyREPanel
            app.RelativeEfficiencyREPanel = uipanel(app.UIFigure);
            app.RelativeEfficiencyREPanel.TitlePosition = 'centertop';
            app.RelativeEfficiencyREPanel.Title = 'Relative Efficiency (RE)';
            app.RelativeEfficiencyREPanel.FontWeight = 'bold';
            app.RelativeEfficiencyREPanel.Position = [29 75 292 244];

            % Create RadiochromicTypeDropDownLabel
            app.RadiochromicTypeDropDownLabel = uilabel(app.RelativeEfficiencyREPanel);
            app.RadiochromicTypeDropDownLabel.HorizontalAlignment = 'right';
            app.RadiochromicTypeDropDownLabel.Position = [19 174 115 22];
            app.RadiochromicTypeDropDownLabel.Text = 'Radiochromic Type: ';

            % Create RadiochromicTypeDropDown
            app.RadiochromicTypeDropDown = uidropdown(app.RelativeEfficiencyREPanel);
            app.RadiochromicTypeDropDown.Items = {'EBT3', 'EBT-XD'};
            app.RadiochromicTypeDropDown.Position = [149 164 79 41];
            app.RadiochromicTypeDropDown.Value = 'EBT3';

            % Create EnergyMeVEditFieldLabel
            app.EnergyMeVEditFieldLabel = uilabel(app.RelativeEfficiencyREPanel);
            app.EnergyMeVEditFieldLabel.HorizontalAlignment = 'right';
            app.EnergyMeVEditFieldLabel.Position = [19 116 85 22];
            app.EnergyMeVEditFieldLabel.Text = 'Energy [MeV]: ';

            % Create EnergyMeVEditField
            app.EnergyMeVEditField = uieditfield(app.RelativeEfficiencyREPanel, 'numeric');
            app.EnergyMeVEditField.Position = [119 113 65 27];

            % Create SpacecmEditFieldLabel
            app.SpacecmEditFieldLabel = uilabel(app.RelativeEfficiencyREPanel);
            app.SpacecmEditFieldLabel.HorizontalAlignment = 'right';
            app.SpacecmEditFieldLabel.Position = [18 71 72 22];
            app.SpacecmEditFieldLabel.Text = 'Space [cm]: ';

            % Create SpacecmEditField
            app.SpacecmEditField = uieditfield(app.RelativeEfficiencyREPanel, 'numeric');
            app.SpacecmEditField.Position = [119 68 65 27];

            % Create ApplyREButton
            app.ApplyREButton = uibutton(app.RelativeEfficiencyREPanel, 'push');
            app.ApplyREButton.ButtonPushedFcn = createCallbackFcn(app, @ApplyREButtonPushed, true);
            app.ApplyREButton.Position = [160 17 106 35];
            app.ApplyREButton.Text = 'Apply RE';

            % Create Image
            app.Image = uiimage(app.UIFigure);
            app.Image.Position = [29 726 291 109];
            app.Image.ImageSource = fullfile('LOGO FN.png');

            % Create Label3
            app.Label3 = uilabel(app.UIFigure);
            app.Label3.HorizontalAlignment = 'center';
            app.Label3.Position = [524 92 481 69];
            app.Label3.Text = '';

            % Create Label4
            app.Label4 = uilabel(app.UIFigure);
            app.Label4.HorizontalAlignment = 'center';
            app.Label4.Position = [524 52 481 83];
            app.Label4.Text = '';

            % Create TextAreaLabel
            app.StadisticsLabel = uilabel(app.UIFigure);
            app.StadisticsLabel.HorizontalAlignment = 'right';
            app.StadisticsLabel.Position = [731 365 55 22];
            app.StadisticsLabel.Text = 'Stadistics';

            % Create TextArea
            app.Stadistics = uitextarea(app.UIFigure);
            app.Stadistics.Position = [801 209 88 180];

            % Create CalREButton
            app.CalREButton = uibutton(app.RelativeEfficiencyREPanel, 'push');
            app.CalREButton.ButtonPushedFcn = createCallbackFcn(app, @CalREButtonPushed, true);
            app.CalREButton.Position = [213 92 54 30];
            app.CalREButton.Text = 'Cal RE';

             % Create RETextAreaLabel
            app.RETextAreaLabel = uilabel(app.RelativeEfficiencyREPanel);
            app.RETextAreaLabel.HorizontalAlignment = 'right';
            app.RETextAreaLabel.Position = [27 27 26 22];
            app.RETextAreaLabel.Text = 'RE:';

            % Create RETextArea
            app.RETextArea = uitextarea(app.RelativeEfficiencyREPanel);
            app.RETextArea.Position = [68 20 66 31];
            
            % Create UIAxes5
            app.UIAxes5 = uiaxes(app.UIFigure);
            title(app.UIAxes5, 'Reference Image')
            xlabel(app.UIAxes5, 'cm')
            ylabel(app.UIAxes5, 'cm')
            zlabel(app.UIAxes5, 'Z')
            app.UIAxes5.Position = [629 551 221 209];


            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = AppEvolutiva

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end