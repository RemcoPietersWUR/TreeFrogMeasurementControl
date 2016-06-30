function [angular]=update_angular_graph(angular_position,angular,current_time)
angular.count = angular.count + 1;
angular.time(angular.count) = current_time;    %Extract Elapsed Time
angular.data(angular.count) = angular_position(1); %Extract 1st Data Element

%Set Axis according to Scroll Width
if(angular.scrollWidth > 0)
    set(angular.plotGraph,'XData',...
        angular.time(angular.time > angular.time(angular.count)-...
        angular.scrollWidth),'YData',...
        angular.data(angular.time > angular.time(angular.count)-angular.scrollWidth));
    axis([angular.time(angular.count)-angular.scrollWidth angular.time(angular.count)...
        angular.ymin angular.ymax]);
else
    set(angular.plotGraph,'XData',angular.time,'YData',angular.data);
    axis([0 angular.time(angular.count) angular.ymin angular.ymax]);
end
end