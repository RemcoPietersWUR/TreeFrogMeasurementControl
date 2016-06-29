function [species, speed] = measurement_administration

    %Default values
    species = 'Red';
    speed = '2 deg/sec';
    
    d = dialog('Position',[300 300 500 300],'Name','Measurement administration');
    %[left bottom width height]
    current_date = uicontrol('Parent',d,...
           'Style','text',...
           'Position',[20 250 100 20],... %[left bottom width height]
           'String',['Today: ',datestr(now,'yyyy mm dd')]);
    
    %Species
    species_txt = uicontrol('Parent',d,...
           'Style','text',...
           'Position',[20 200 100 20],...
           'String','Select species: ');
       
    species_popup = uicontrol('Parent',d,...
           'Style','popup',...
           'Position',[120 200 100 20],...
           'String',{'LC';'DD';'AA'},...
           'Callback',@species_callback);
       
    %Speed
    speed_txt = uicontrol('Parent',d,...
           'Style','text',...
           'Position',[20 160 100 20],...
           'String','Select rotational speed');
       
    speed_popup = uicontrol('Parent',d,...
           'Style','popup',...
           'Position',[120 160 100 20],...
           'String',{'2 deg/sec';'3 deg/sec';'4 deg/sec'},...
           'Callback',@speed_callback);
    
       
    btn = uicontrol('Parent',d,...
           'Position',[89 20 70 25],...
           'String','Okay',...
           'Callback','delete(gcf)');
       

       
    % Wait for d to close before running to completion
    uiwait(d);
   
       function species_callback(source,callbackdata)
          idx = source.Value;
          popup_items = source.String;
          % This code uses dot notation to get properties.
          % Dot notation runs in R2014b and later.
          % For R2014a and earlier:
          % idx = get(popup,'Value');
          % popup_items = get(popup,'String');
          species = char(popup_items(idx,:));
       end
   
       function speed_callback(source,callbackdata)
          idx = source.Value;
          popup_items = source.String;
          % This code uses dot notation to get properties.
          % Dot notation runs in R2014b and later.
          % For R2014a and earlier:
          % idx = get(popup,'Value');
          % popup_items = get(popup,'String');
          speed = char(popup_items(idx,:));
       end
end