function [meas] = measurement_administration(meas)

    d = dialog('Position',[300 300 500 300],'Name','Measurement administration');
    %[left bottom width height]
    current_date = uicontrol('Parent',d,...
           'Style','text',...
           'Position',[20 270 100 20],... %[left bottom width height]
           'String',['Today: ',datestr(meas.date,'yyyy mm dd')]);
    
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
    individual_txt = uicontrol('Parent',d,...
           'Style','text',...
           'Position',[20 190 100 20],...
           'String','Select individual:');
       
    individual_popup = uicontrol('Parent',d,...
           'Style','popup',...
           'Position',[120 190 100 20],...
           'String',{'01';'02';'03';'04';'05';'06';'07';'08';'09';'10';'11'},...
           'Callback',@individual_callback);
       
    %Speed
    speed_txt = uicontrol('Parent',d,...
           'Style','text',...
           'Position',[20 150 100 20],...
           'String','Select speed:');
       
    speed_popup = uicontrol('Parent',d,...
           'Style','popup',...
           'Position',[120 150 100 20],...
           'String',{'2 deg_sec';'4 deg_sec'},...
           'Callback',@speed_callback);
       
    %Roughness
    roughness_txt = uicontrol('Parent',d,...
           'Style','text',...
           'Position',[20 110 100 20],...
           'String','Select roughness:');
       
    roughness_popup = uicontrol('Parent',d,...
           'Style','popup',...
           'Position',[120 110 100 20],...
           'String',{'Rough';'15.0 um';'6.0 um';'0.5 um';'0.1 um';'Smooth'},...
           'Callback',@roughness_callback);
       
    %Repetition
    repetition_txt = uicontrol('Parent',d,...
           'Style','text',...
           'Position',[20 70 100 20],...
           'String','Select repetition:');
       
    repetition_popup = uicontrol('Parent',d,...
           'Style','popup',...
           'Position',[120 70 100 20],...
           'String',{'01';'02';'03';'04';'05';'06';'07';'08';'09';'10';'11';'12';'13';'14';'15'},...
           'Callback',@repetition_callback);
       
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
          meas.species = char(popup_items(idx,:));
       end
   
       function individual_callback(source,callbackdata)
          idx = source.Value;
          popup_items = source.String;
          % This code uses dot notation to get properties.
          % Dot notation runs in R2014b and later.
          % For R2014a and earlier:
          % idx = get(popup,'Value');
          % popup_items = get(popup,'String');
          meas.individual = char(popup_items(idx,:));
       end
   
       function speed_callback(source,callbackdata)
          idx = source.Value;
          popup_items = source.String;
          % This code uses dot notation to get properties.
          % Dot notation runs in R2014b and later.
          % For R2014a and earlier:
          % idx = get(popup,'Value');
          % popup_items = get(popup,'String');
          meas.speed = char(popup_items(idx,:));
       end
   
       function roughness_callback(source,callbackdata)
          idx = source.Value;
          popup_items = source.String;
          % This code uses dot notation to get properties.
          % Dot notation runs in R2014b and later.
          % For R2014a and earlier:
          % idx = get(popup,'Value');
          % popup_items = get(popup,'String');
          meas.roughness = char(popup_items(idx,:));
       end
   
       function repetition_callback(source,callbackdata)
          idx = source.Value;
          popup_items = source.String;
          % This code uses dot notation to get properties.
          % Dot notation runs in R2014b and later.
          % For R2014a and earlier:
          % idx = get(popup,'Value');
          % popup_items = get(popup,'String');
          meas.repetition = char(popup_items(idx,:));
       end
end
