function [hFig]=custom_viewer(cam)
%custom_viewer Create GUI for camera preview

%Create figure handle
hFig = figure('Toolbar','none',...
       'Menubar', 'none',...
       'NumberTitle','Off',...
       'Name',['Preview camera ',num2str(cam.deviceID)]);

%Get video resolution information
vidRes = cam.VideoResolution;
imWidth = vidRes(1);
imHeight = vidRes(2);
nBands = cam.NumberOfBands;
hImage = image( zeros(imHeight, imWidth, nBands) );

%Adjust figure size
figSize = get(hFig,'Position');
figWidth = figSize(3);
figHeight = figSize(4);
gca.unit = 'pixels';
gca.position = [ ((figWidth - imWidth)/2)... 
               ((figHeight - imHeight)/2)...
               imWidth imHeight ];

%Start preview           
preview(cam, hImage);
end