%TreeFrogMeasurementControl - TFMC

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Properties
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%User defined properties

%Webcam video
%Settings webcam1
webcam.set1.Resolution = 'MJPG_1920x1080';
webcam.set1.ColorSpace = 'grayscale';
webcam.set1.BacklightCompensation = 'on';
webcam.set1.Brightness = 128;
webcam.set1.Contrast = 128;
webcam.set1.Exposure = -5;
webcam.set1.ExposureMode = 'auto';
webcam.set1.Focus = 0;
webcam.set1.FocusMode = 'auto';
webcam.set1.FrameRate = '30.0000';
webcam.set1.Gain = 0;
webcam.set1.Pan = 0;
webcam.set1.Saturation = 128;
webcam.set1.Sharpness = 128;
webcam.set1.Tilt = 0;
webcam.set1.WhiteBalance = 4000;
webcam.set1.WhiteBalanceMode = 'auto';
webcam.set1.Zoom = 100;
%Settings webcam2
webcam.set2=webcam.set1;

%Audio pulse
audio.PulseWidth = 10; %milliseconds

%Arduino connection
arduino.COM = 'COM7';

%Motor connection
motor.COM = 'COM9';

%Angular position graph
angular.plotTitle = 'Angular Position Log';
angular.xLabel = 'Elapsed Time (s)';
angular.yLabel = 'Angular Postion (deg)';
angular.plotGrid = 'on';
angular.ymin = 0;
angular.ymax = 360;
angular.scrollWidth = 10;

%Angular position data
angular.time = 0;
angular.data = 0;
angular.count = 0;

%Data storage
storage.root = 'D:\Anne';
storage.subfolder.cam1 = 'webcam1';
storage.subfolder.cam2 = 'webcam2';
storage.subfolder.TIRM = 'TIRM';

%------------------------------------------------------------------------%

%%Fixed properties
%Webcam video

%Audio Pulse
audio.Fs = 10000; %Sample frequency

%Arduino connection
arduino.BaudRate = 9600;

%Motor connection
motor.BaudRate = 9600;

%Measurement administration default selections
meas.date = now;
meas.species = 'Litoria caerulea';
meas.individual = '01';
meas.speed = '2 deg_sec';
meas.roughness = 'Rough';
meas.repetition = '01';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Connect Devices
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Connect webcams
disp('Establish connection to webcam...')
[cam1, cam2]=cam_connect(webcam.set1,webcam.set2);
disp('Connected')

%Connect Arduino
disp('Establish connection to Arduino...')
arduino_con = serial(arduino.COM,'Baudrate',arduino.BaudRate);
fopen(arduino_con);
disp('Connected')

%Connect motor
disp('Establish connection to motor...')
motor_con = serial(motor.COM,'Baudrate',motor.BaudRate);
%fopen(motor_con);
disp('Connected')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Measurement Administration
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[meas] = measurement_administration(meas);

%Create folder to save data
disp('Create folder structure to store data...')
%Measurement subfolder
storage.measurementfolder = [datestr(meas.date,'yyyymmdd'),'_',...
    meas.species,'_', meas.individual,'_',meas.roughness,'_',...
    meas.speed,'_',meas.repetition];
%Check if file already exist
while isdir(fullfile(storage.root,storage.measurementfolder))
    % Construct a questdlg with three options
    choice = questdlg('Would you like a dessert?', ...
        'Overwrite data?', ...
        'Overwrite','Increment repetition','Increment repetition');
    % Handle response
    switch choice
        case 'Overwrite'
            overwrite = true;
        case 'Increment repetition'
            meas.repetition = sprintf('%02i',str2double(meas.repetition)+1);
    end
    if overwrite
        break
    end
end
%Make folder
mkdir(fullfile(storage.root,storage.measurementfolder))

%Add subfolders, webcam1, webcam2, TIRM
mkdir(fullfile(storage.root,storage.measurementfolder,...
    storage.subfolder.cam1));
mkdir(fullfile(storage.root,storage.measurementfolder,...
    storage.subfolder.cam2));
mkdir(fullfile(storage.root,storage.measurementfolder,...
    storage.subfolder.TIRM));

disp('Done!')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Create graphs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Angular Position Graph

%Set up Plot
angular.plotGraph = plot(angular.time,angular.data,'-mo',...
    'LineWidth',1,...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor',[.49 1 .63],...
    'MarkerSize',2);

title(angular.plotTitle,'FontSize',25);
xlabel(angular.xLabel,'FontSize',15);
ylabel(angular.yLabel,'FontSize',15);
axis([0 10 angular.ymin angular.ymax]);
grid(angular.plotGrid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Start measurement
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Start webcams & open viewers
disp('Start webcams...')
start(cam1);
start(cam2);
disp('Webcams running')
disp('Open viewer windows')
custom_viewer(cam1);
custom_viewer(cam2);

%Read angular position
tic
angular_position = fscanf(arduino_con,'%f'); %Read Data from Serial as Float
if(~isempty(angular_position) && isfloat(angular_position))
    [angular]=update_angular_graph(angular_position,angular);
end

%Set motor speed
disp(['Set angular velocity to ',meas.speed])
speed ='/21S0010'; %Add conversion
%fprintf(motor_con,speed);




%Generate audio pulse
soundsc(ones(1,audio.PulseWidth),audio.Fs);

%Close all connections & windows
fclose(arduino_con);
%fclose(motor_con);
stoppreview(cam1)
stoppreview(cam2)
close all
