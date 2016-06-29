function [frame, metadata] = grabframe(cam)
%grabframe - Get a single frame from the camera

%Check if camera is already triggered
if isrunning(cam) 
    [frame, metadata] = getsnapshot(cam);
else
    start(cam)
    [frame, metadata] = getsnapshot(cam);
end
end
    