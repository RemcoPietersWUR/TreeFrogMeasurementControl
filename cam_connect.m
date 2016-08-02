function [cam1]=cam_connect(set1)
%cam_connect Establish connection with cameras connected to the PC. Set
%device properties, e.g. resolution, colorspace, auto control....

%Input: set1, set2, camera settings for camera 1&2
%Output: control handle for camera 1&2

%Identify available devices supported by the generic video driver
hwInfo = imaqhwinfo('winvideo');
if numel(hwInfo.DeviceIDs)~=1 %2
   error('Webcam1 not avialable!')
end


%Create camera object and set settings
cam1 = videoinput('winvideo', 1,set1.Resolution,...
    'ReturnedColorSpace',set1.ColorSpace,'FramesPerTrigger',1);
src1 = getselectedsource(cam1);
src1.BacklightCompensation = set1.BacklightCompensation;
src1.Brightness = set1.Brightness;
% src1.Contrast = set1.Contrast;
src1.Exposure = set1.Exposure;
src1.ExposureMode = set1.ExposureMode;
src1.Focus = set1.Focus;
src1.FocusMode = set1.FocusMode;
src1.FrameRate = set1.FrameRate;
src1.Gain = set1.Gain;
src1.Pan = set1.Pan;
src1.Saturation = set1.Saturation;
%src1.Sharpness = set1.Sharpness;
src1.Tilt = set1.Tilt;
src1.WhiteBalance = set1.WhiteBalance;
src1.WhiteBalanceMode = set1.WhiteBalanceMode;
src1.Zoom = set1.Zoom;

% cam2 = videoinput('winvideo', 2,set2.Resolution,...
%     'ReturnedColorSpace',set2.ColorSpace,'FramesPerTrigger',1);
% src2 = getselectedsource(cam2);
% src2.BacklightCompensation = set2.BacklightCompensation;
% src2.Brightness = set2.Brightness;
% src2.Contrast = set2.Contrast;
% src2.Exposure = set2.Exposure;
% src2.ExposureMode = set2.ExposureMode;
% src2.Focus = set2.Focus;
% src2.FocusMode = set2.FocusMode;
% src2.FrameRate = set2.FrameRate;
% src2.Gain = set2.Gain;
% src2.Pan = set2.Pan;
% src2.Saturation = set2.Saturation;
% src2.Sharpness = set2.Sharpness;
% src2.Tilt = set2.Tilt;
% src2.WhiteBalance = set2.WhiteBalance;
% src2.WhiteBalanceMode = set2.WhiteBalanceMode;
% src2.Zoom = set2.Zoom;

%Trigger setting to manual
triggerconfig(cam1, 'manual');
%triggerconfig(cam2, 'manual');