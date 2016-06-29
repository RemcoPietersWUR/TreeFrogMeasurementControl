function [species, speed] = measurement_administration

    %Default values
    species = 'Red';
    speed = '2 deg/sec';
    
    d = dialog('Position',[300 300 500 300],'Name','Measurement administration');
    %[left bottom width height]
    current_date = uicontrol('Parent',d,...
           'Style','text',...
           'Position',[20 270 100 20],... %[left bottom width height]
           'String',['Today: ',datestr(now,'yyyy mm dd')]);
    
    %Species
    species_txt = uicontrol('Parent',d,...
           'Style','text',...
           'Position',[20 230 100 20],...
           'String','Select species: ');
       
    species_popup = uicontrol('Parent',d,...
           'Style','popup',...
           'Position',[120 230 100 20],...
           'String',{'Litoria caerulea';'Hyla cinerea'},...
           'Callback',@species_callback);
    
    %Indivdual
    Individual_txt = uicontrol('Parent',d,...
           'Style','text',...
           'Position',[20 190 100 20],...
           'String','Select individual');
       
    Individual_popup = uicontrol('Parent',d,...
           'Style','popup',...
           'Position',[120 190 100 20],...
           'String',{'1';'2';'3';'4';'5';'6';'7';'8';'9';'10';'11'},...
           'Callback',@speed_callback);
       
    %Speed
    speed_txt = uicontrol('Parent',d,...
           'Style','text',...
           'Position',[20 150 100 20],...
           'String','Select speed');
       
    speed_popup = uicontrol('Parent',d,...
           'Style','popup',...
           'Position',[120 150 100 20],...
           'String',{'2 deg/sec';'4 deg/sec'},...
           'Callback',@speed_callback);
       
    %Roughness
    Roughness_txt = uicontrol('Parent',d,...
           'Style','text',...
           'Position',[20 110 100 20],...
           'String','Select roughness');
       
    Roughness_popup = uicontrol('Parent',d,...
           'Style','popup',...
           'Position',[120 110 100 20],...
           'String',{'Rough';'15 um';'6 um';'0,5 um';'0,1 um';'Smooth'},...
           'Callback',@speed_callback);
       
    %Repetition
    Repetition_txt = uicontrol('Parent',d,...
           'Style','text',...
           'Position',[20 70 100 20],...
           'String','Select repetition');
       
    Repetition_popup = uicontrol('Parent',d,...
           'Style','popup',...
           'Position',[120 70 100 20],...
           'String',{'1';'2';'3';'4';'5';'6';'7';'8';'9';'10';'11';'12';'13';'14';'15'},...
           'Callback',@speed_callback);
       
    btn = uicontrol('Parent',d,...
           'Position',[89 15 70 25],...
           'String','ASK REMCO',...
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