%TreeFrogMeasurementControl - TFMC

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Properties
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%User defined properties

%Webcam video
%Settings webcam1
webcam.set1.Resolution = 'MJPG_1920x1080';
webcam.set1.ColorSpace = 'grayscale';
webcam.set1.BacklightCompensation = 'off';
webcam.set1.Brightness = 128;
webcam.set1.Contrast = 128;
webcam.set1.Exposure = -5;
webcam.set1.ExposureMode = 'manual';
webcam.set1.Focus = 0;
webcam.set1.FocusMode = 'manual';
webcam.set1.FrameRate = '30.0000';
webcam.set1.Gain = 0;
webcam.set1.Pan = 0;
webcam.set1.Saturation = 128;
webcam.set1.Sharpness = 128;
webcam.set1.Tilt = 0;
webcam.set1.WhiteBalance = 4000;
webcam.set1.WhiteBalanceMode = 'manual';
webcam.set1.Zoom = 100;
%Settings webcam2
webcam.set2=webcam.set1;
webcam.frame = 0;

%Audio pulse
audio.PulseWidth = 10; %milliseconds

%Arduino connection
arduino.COM = 'COM3';

%Motor connection
motor.COM = 'COM9';
motor.speed.slope = 28.08107;
motor.speed.intercept = -7.15028;

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
storage.root = 'F:';
storage.subfolder.cam1 = 'webcam1';
storage.subfolder.cam2 = 'webcam2';
storage.subfolder.TIRM = 'TIRM';

%Measurement settings
meas.sampleangle = 2;

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
meas.individual = '00';
meas.speed = '2 deg_sec';
meas.roughness = 'Rough';
meas.repetition = '01';
meas.start_expermiment = now;
meas.stop_expermiment = now;
meas.bodyweight = 0;
meas.humidity = 0;
meas.temperature = 0;

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
    overwrite = false;
    % Construct a questdlg with three options
    choice = questdlg('Overwrite data?', ...
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
viewer_handle = msgbox('Is the webcam view okay?', 'Webcam Okay?','help');
uiwait(viewer_handle)
closepreview(cam1)
closepreview(cam2)

%Preallocate video memory
disp('Allocate video memory...')
videoRes1 = cam1.VideoResolution;
mem_cam1 = uint8(zeros(videoRes1(2),videoRes1(1),ceil(360/meas.sampleangle)));
videoRes2 = cam2.VideoResolution;
mem_cam2 = uint8(zeros(videoRes2(2),videoRes2(1),ceil(360/meas.sampleangle)));
disp('Done!')
%Preallocate time memory
mem_time = zeros(1,ceil(360/meas.sampleangle));

%Set motor speed
disp(['Set angular velocity to ',meas.speed])
%Set motor speed
disp(['Set angular velocity to ',meas.speed])
str_speed_idx = find(isstrprop(meas.speed,'digit'));
num_speed = str2double(meas.speed(min(str_speed_idx):max(str_speed_idx)));
speed_value = round(motor.speed.slope*num_speed+motor.speed.intercept);
speed ='/21S0010'; %Add conversion
%fprintf(motor_con,['/21S',sprintf('%04i',speed_value)]);
disp(['/21S',sprintf('%04i',speed_value)]);


%Start dialog window
start_dialog = dialog('Position',[300 300 250 150],'Name','Start Measurement');
start_btn = uicontrol('Parent',start_dialog,...
    'Position',[85 20 70 25],...
    'String','START',...
    'Callback','delete(gcf)');
uiwait(start_dialog);
stop_dialog = dialog('Position',[300 300 250 150],'Name','Stop Measurement');

stop_txt = uicontrol('Parent',stop_dialog,...
    'Style','text',...
    'Position',[20 80 210 40],...
    'String','Click the STOP button when you''re done.');

stop_btn = uicontrol('Parent',stop_dialog,...
    'Position',[85 20 70 25],...
    'String','STOP',...
    'Callback','delete(gcf)');
meas.start_expermiment = now;
%Start timer
    tic;
while ishandle(stop_dialog)
    %Read angular position
    angular_position = fscanf(arduino_con,'%f'); %Read Data from Serial as Float
    if(~isempty(angular_position) && isfloat(angular_position))
        [angular]=update_angular_graph(angular_position,angular,toc);
    end
    %Generate audio pulse
    soundsc(ones(1,audio.PulseWidth),audio.Fs);
    %Get snapshot from webcams
    webcam.frame=webcam.frame+1;
    mem_cam1(:,:,webcam.frame)=getsnapshot(cam1);
    mem_cam2(:,:,webcam.frame)=getsnapshot(cam2);
    mem_time(1,webcam.frame)=toc;
    pause(meas.sampleangle)
end
meas.stop_expermiment = now;

%Save data
disp('Saving Webcam Video...')
for frame = 1:webcam.frame
    %Webcam1
    imwrite(mem_cam1(:,:,frame),fullfile(storage.root,storage.measurementfolder,...
    storage.subfolder.cam1,['IMG_',sprintf('%03i',frame),'.tif']));
    %Webcam2
    imwrite(mem_cam2(:,:,frame),fullfile(storage.root,storage.measurementfolder,...
    storage.subfolder.cam2,['IMG_',sprintf('%03i',frame)]))
end
%Timestamp
timestamp_webcam = mem_time;
save(fullfile(storage.root,storage.measurementfolder,...
    'timestamp_webcam.mat'),'timestamp_webcam')
disp('Done!')
disp('Saving angular position...')
save(fullfile(storage.root,storage.measurementfolder,...
    'angular_position.mat'),'angular.time','angular.data')
disp('Done!')

%Store TIRM data
uiwait(msgbox('Save TIRM data!','TIRM','modal'));
winopen(fullfile(storage.root,storage.measurementfolder,...
    storage.subfolder.TIRM))


morp_param = inputdlg({'Enter body weight (g)','Enter humidity (%):','Enter temperature (Celcius)'},...
    'Morphological parameters',1);
meas.bodyweight = morp_param{1,1};
meas.humidity = morp_param{1,2};
meas.temperature = morp_param{1,3};

disp('Saving measurement parameters...')
save(fullfile(storage.root,storage.measurementfolder,...
    'measurement_parameters.mat'),'meas')
disp('Done!')

%Close all connections & windows
fclose(arduino_con);
%fclose(motor_con);
stop(cam1)
stop(cam2)

