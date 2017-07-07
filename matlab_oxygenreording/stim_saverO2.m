function varargout = stim_saverO2(varargin)
% STIM_SAVERO2 MATLAB code for stim_saverO2.fig
%      STIM_SAVERO2, by itself, creates a new STIM_SAVERO2 or raises the existing
%      singleton*.
%
%      H = STIM_SAVERO2 returns the handle to a new STIM_SAVERO2 or the handle to
%      the existing singleton*.
%
%      STIM_SAVERO2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STIM_SAVERO2.M with the given input arguments.
%
%      STIM_SAVERO2('Property','Value',...) creates a new STIM_SAVERO2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before stim_saverO2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to stim_saverO2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help stim_saverO2

% Last Modified by GUIDE v2.5 26-Jun-2017 22:16:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @stim_saverO2_OpeningFcn, ...
                   'gui_OutputFcn',  @stim_saverO2_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before stim_saverO2 is made visible.
function stim_saverO2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to stim_saverO2 (see VARARGIN)

% 


% Choose default command line output for stim_saverO2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes stim_saverO2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = stim_saverO2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% open file
global FS sheet data data_ref reference filename stimulus xp1 xmv1;
FS = 1000;
sheet = 0; 
xp1 = 100;
xmv1 = 30;
[abfFileName,path] = uigetfile('*.abf');

filename = strcat(path,abfFileName);

if get(handles.radiobutton1, 'Value')== 1
    data_ref = abfload(char(filename),'channels',{'O2'});
    stimulus = abfload(char(filename),'channels',{'STIM'});
else
    data_ref = abfload(char(filename),'channels',{'O2'});
    stimulus = data_ref;
end


set(handles.text3, 'String', 'mV');

plot((1:numel(data_ref))/FS,data_ref,'parent',handles.axes1);
plot((1:numel(stimulus))/FS,stimulus,'parent',handles.axes3);
ylim(handles.axes1,[-5 xmv1]);
xlim(handles.axes1,[1/FS numel(data_ref)/FS]);




% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sheet ROI outpath outname FS time_span;
sheet = sheet + 1;
savedata(:,1) = time_span;
savedata(:,2) = ROI;
%filtered data
validm = ones(length(ROI),1);
thresed = ROI;
thresed(ROI>50) = 50;
thresed(ROI<-20) = -20;
savedata(:,3) = smooth(ROI,5000);           % set smooth factor here!

xlswrite(strcat(outpath,outname),savedata,sheet);



% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Calibration
global FS data_ref data_p xmv1 xp1;
Oc = data_ref(1:2000*FS,:);
p1 = figure(1);
set(p1,'position',[200 100 1000 400]);
plot((1:length(Oc))/(FS*60),Oc);
ylim([-10,250]);
[cx,cy] = ginput(4);
close(p1);
%%
cx = cx*60*FS;
x = [mean(data_ref(cx(1):cx(2),:));mean(data_ref(cx(3):cx(4),:))];
sa = x(1);
s0 = x(2);
a = -157*s0/(sa-s0);
b = (157/(sa-s0));

%%
data_p = a + b.*data_ref;
plot((1:numel(data_p))/FS,data_p,'parent',handles.axes1);
ylim(handles.axes1,[-10 xp1]);
xlim(handles.axes1,[1/FS numel(data_p)/FS]);
set(handles.text3, 'String', 'mmH2O');


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% select 2 points in the plot.
global FS data_ref data_p ROI xp2 xmv2;
xp2 = 40;
xmv2 = 20;
[xp yp] = ginputax(handles.axes1,2);

if get(handles.text3,'String')== 'mmH2O';
    ROI = data_p(xp(1)*FS:xp(2)*FS);
    plot((1:numel(ROI))/FS,ROI,'parent',handles.axes2);
    ylim(handles.axes2,[-10 xp2]);
else
    ROI = data_ref(xp(1)*FS:xp(2)*FS);
    plot((1:numel(ROI))/FS,ROI,'parent',handles.axes2);
    ylim(handles.axes2,[-10 xmv2]);
end
xlim(handles.axes2,[1/FS numel(ROI)/FS]);


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global outpath outname sheet
[outname,outpath] = uiputfile('*.xlsx');
set(handles.edit1,'String',strcat(outpath,outname));





function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function text3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global FS ROI savedata
[xpp ypp] = ginputax(handles.axes2,1);
savedata = zeros((30+120)*FS+1,2);

%savedata(:,1) = (-30*FS:120*FS)/FS;
%savedata(:,2) = ROI(floor(xpp)*FS-30*FS:floor(xpp)*FS+120*FS);


% --- Executes during object creation, after setting all properties.
function text4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider




% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global  xmv1 xp1 data_p data_ref FS;
if get(handles.text3,'String')== 'mmH2O';
    xp1 = xp1 -10;
    plot((1:numel(data_p))/FS,data_p,'parent',handles.axes1);
    ylim(handles.axes1,[-10 xp1]);
    xlim(handles.axes1,[1/FS numel(data_p)/FS]);
else
    xmv1 = xmv1 -10;
    plot((1:numel(data_ref))/FS,data_ref,'parent',handles.axes1);
    ylim(handles.axes1,[-10 xmv1]);
    xlim(handles.axes1,[1/FS numel(data_ref)/FS]);
end


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data xmv1 xp1 data_p data_ref FS;
if get(handles.text3,'String')== 'mmH2O';
    xp1 = xp1 +10;
    plot((1:numel(data_p))/FS,data_p,'parent',handles.axes1);
    ylim(handles.axes1,[-10 xp1]);
    xlim(handles.axes1,[1/FS numel(data_p)/FS]);
else
    xmv1 = xmv1 +10;
    plot((1:numel(data_ref))/FS,data_ref,'parent',handles.axes1);
    ylim(handles.axes1,[-10 xmv1]);
    xlim(handles.axes1,[1/FS numel(data_ref)/FS]);
end
% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ROI xmv2 xp2 FS;
if get(handles.text3,'String')== 'mmH2O';
    xp2 = xp2 -10;
    plot((1:numel(ROI))/FS,ROI,'parent',handles.axes2);
    ylim(handles.axes2,[-10 xp2]);
    xlim(handles.axes2,[1/FS numel(ROI)/FS]);
else
    xmv2 = xmv2 -10;
    plot((1:numel(ROI))/FS,ROI,'parent',handles.axes2);
    ylim(handles.axes2,[-10 xmv2]);
    xlim(handles.axes2,[1/FS numel(ROI)/FS]);
end

% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ROI xmv2 xp2 FS;
if get(handles.text3,'String')== 'mmH2O';
    xp2 = xp2 +10;
    plot((1:numel(ROI))/FS,ROI,'parent',handles.axes2);
    xlim(handles.axes2,[1/FS numel(ROI)/FS]);
    ylim(handles.axes2,[-10 xp2]);
else
    xmv2 = xmv2 +10;
    plot((1:numel(ROI))/FS,ROI,'parent',handles.axes2);
    ylim(handles.axes2,[-10 xmv2]);
    xlim(handles.axes2,[1/FS numel(ROI)/FS]);
end


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global FS data_p ROI xp2 time_span t_peak stimulus;
time_span = [-200:1/FS:200];      % set time of ROI around peak in seconds.
[xp yp] = ginputax(handles.axes1,2);

if strcmp(get(handles.text3,'String'),'mmH2O');
    data_showed = data_p(xp(1)*FS:xp(2)*FS);
    stim_showed = stimulus(xp(1)*FS:xp(2)*FS);
    f1 = figure;
    subplot(211)
    plot(data_showed);
    subplot(212)
    plot(stim_showed);
    [zx,zy]=ginput(3);  % 3 points to input, first 2 for baseline, 3rd for peak.
    
%     try
%         data_showed = ROI(zx(3)+FS*time_span(1):zx(3)+time_span(2));
%     catch
%         data_showed = ROI;
%     end
    ROI = data_p(floor(xp(1)*FS+zx(3)+time_span*FS));
    close;
    [baseline peak slp1 slp2 p20 p80 tp1 tp2] = calcPeak(data_showed,zx,FS );
    
    plot(time_span,ROI,'parent',handles.axes2);
    ylim(handles.axes2,[-10 xp2]);
else
    msgbox('Please calibrate first');
end
t_peak = table(-baseline,-peak,-slp1,-slp2,-p20,-p80,tp1,tp2);
t_peak.Properties.VariableNames = {'Baseline' 'Peak' 'Slope1' 'Slope2' 'p20_peak' 'p80_peak' 'Time_to_peak' 'Time_after_peak'};
xlim(handles.axes2,time_span);



% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global t_peak sheet outpath outname
sheet = sheet + 1;
writetable(t_peak,strcat(outpath,outname),'Sheet',sheet);


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2
