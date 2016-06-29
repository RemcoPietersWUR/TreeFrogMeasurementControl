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

%------------------------------------------------------------------------%

%%Fixed properties
%Webcam video

%Audio Pulse
audio.Fs = 10000; %Sample frequency

%Arduino connection
arduino.BaudRate = 9600;

%Motor connection
motor.BaudRate = 9600;

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
fopen(motor_con);
disp('Connected')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Measurement Administration
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[meas.species,meas.speed] = measurement_administration;

%Create folder to save data
disp('Create folder structure to store data...')

%Add subfolders, webcam1, webcam2, TIRM

disp('Done!')
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

%Set motor speed
disp(['Set angular velocity to ',meas.speed])
speed ='/21S0010'; %Add conversion
fprintf(motor_con,speed);




%Generate audio pulse
soundsc(ones(1,audio.PulseWidth),audio.Fs);

%Close all connections & windows
fclose(arduino.COM)
fclose(motor.COM)
stoppreview(cam1)
stoppreview(cam2)
close all
