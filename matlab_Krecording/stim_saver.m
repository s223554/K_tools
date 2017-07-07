function varargout = stim_saver(varargin)
% STIM_SAVER MATLAB code for stim_saver.fig
%      STIM_SAVER, by itself, creates a new STIM_SAVER or raises the existing
%      singleton*.
%
%      H = STIM_SAVER returns the handle to a new STIM_SAVER or the handle to
%      the existing singleton*.
%
%      STIM_SAVER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STIM_SAVER.M with the given input arguments.
%
%      STIM_SAVER('Property','Value',...) creates a new STIM_SAVER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before stim_saver_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to stim_saver_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help stim_saver

% Last Modified by GUIDE v2.5 30-May-2017 18:03:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @stim_saver_OpeningFcn, ...
                   'gui_OutputFcn',  @stim_saver_OutputFcn, ...
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


% --- Executes just before stim_saver is made visible.
function stim_saver_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to stim_saver (see VARARGIN)

% 


% Choose default command line output for stim_saver
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes stim_saver wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = stim_saver_OutputFcn(hObject, eventdata, handles) 
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
global FS sheet data data_ref reference filename stimulus xmm1 xmv1 sheet_peak;
FS = 1000;
sheet = 0;
sheet_peak = 0;
xmm1 = 10;
xmv1 = 20;
[abfFileName,path] = uigetfile('*.abf');
filename = strcat(path,abfFileName);
if get(handles.radiobutton4, 'Value')== 1
    data = abfload(char(filename),'channels',{'potassium'});
    reference = abfload(char(filename),'channels',{'LFP raw'});
    stimulus = abfload(char(filename),'channels',{'LFP filter'});
else
    data = abfload(char(filename),'channels',{'potassium'});
    reference = abfload(char(filename),'channels',{'LFP raw'});
    stimulus = abfload(char(filename),'channels',{'STIM'});
end
data_ref = data - reference;
set(handles.text3, 'String', 'mV');

plot((1:numel(data_ref))/FS,data_ref,'parent',handles.axes1);
ylim(handles.axes1,[-10 xmv1]);
xlim(handles.axes1,[1/FS numel(data_ref)/FS]);

plot((1:numel(stimulus))/FS,stimulus,'parent',handles.axes3);
ylim(handles.axes3,[-5 5]);
xlim(handles.axes3,[1/FS numel(data_ref)/FS]);



% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)	
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sheet outpath outname ROI FS time_span;
savedata(:,1) = (time_span)';
savedata(:,2) = ROI;
savedata(:,3) = smooth(ROI,5000);
sheet = sheet + 1;
xlswrite(strcat(outpath,outname),savedata,sheet);



% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Calibration
global FS data_ref data_con;
try
Kc = data_ref(1:7000*FS,:);
catch
    Kc = data_ref;
end
p1 = figure(1);
set(p1,'position',[200 100 1000 400]);
plot((1:length(Kc))/(FS*60),Kc);
ylim([-5,30]);
[cx,cy] = ginput(6);
close(p1);
%%
cx = cx*60*FS;
x = [mean(data_ref(cx(1):cx(2),:));mean(data_ref(cx(3):cx(4),:));mean(data_ref(cx(5):cx(6),:))];
y = [log(2.5/150);log(3.5/150);log(4.5/150)];
X = [ones(length(x),1) x];
b = X\y;                  %muldivide y = bx + e,b(1,:) is intersect
yCalc = X*b;
p2 = figure(2);
plot(yCalc,x);
hold;
scatter(y,x);
pause(1);
close(p2);
%%
data_con = 150 * exp([ones(length(data_ref),1) data_ref]*b);
plot((1:numel(data_con))/FS,data_con,'parent',handles.axes1);
ylim(handles.axes1,[-2 15]);
xlim(handles.axes1,[1/FS numel(data_con)/FS]);
set(handles.text3, 'String', 'mM');


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% select 2 points in the plot.
global FS data_ref data_con ROI xmm2 xmv2;
xmm2 = 10;
xmv2 = 20;
[xp yp] = ginputax(handles.axes1,2);

if get(handles.text3,'String')== 'mM';
    ROI = data_con(xp(1)*FS:xp(2)*FS);
    plot((1:numel(ROI))/FS,ROI,'parent',handles.axes2);
    ylim(handles.axes2,[0 xmm2]);
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
global FS ROI 
[xpp ypp] = ginputax(handles.axes2,1);
%savedata(:,1) = (-10*FS:30*FS)/FS;
%savedata(:,2) = ROI(floor(xpp)*FS-10*FS:floor(xpp)*FS+30*FS);


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
global data xmv1 xmm1 data_con data_ref FS;
if get(handles.text3,'String')== 'mM';
    xmm1 = xmm1 -2;
    plot((1:numel(data_con))/FS,data_con,'parent',handles.axes1);
    ylim(handles.axes1,[0 xmm1]);
    xlim(handles.axes1,[1/FS numel(data_con)/FS]);
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
global data xmv1 xmm1 data_con data_ref FS;
if get(handles.text3,'String')== 'mM';
    xmm1 = xmm1 +2;
    plot((1:numel(data_con))/FS,data_con,'parent',handles.axes1);
    ylim(handles.axes1,[0 xmm1]);
    xlim(handles.axes1,[1/FS numel(data_con)/FS]);
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
global ROI xmv2 xmm2 FS;
if get(handles.text3,'String')== 'mM';
    xmm2 = xmm2 -2;
    plot((1:numel(ROI))/FS,ROI,'parent',handles.axes2);
    ylim(handles.axes2,[0 xmm2]);
    xlim(handles.axes2,[0 length(ROI)/FS]);
else
    xmv2 = xmv2 -10;
    plot((1:numel(ROI))/FS,ROI,'parent',handles.axes2);
    ylim(handles.axes2,[-10 xmv2]);
    xlim(handles.axes2,[0 length(ROI)/FS]);
end

% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ROI xmv2 xmm2 FS;
if get(handles.text3,'String')== 'mM';
    xmm2 = xmm2 +2;
    plot((1:numel(ROI))/FS,ROI,'parent',handles.axes2);
    ylim(handles.axes2,[0 xmm2]);
    xlim(handles.axes2,[0 length(ROI)/FS]);
else
    xmv2 = xmv2 +10;
    plot((1:numel(ROI))/FS,ROI,'parent',handles.axes2);
    ylim(handles.axes2,[-10 xmv2]);
    xlim(handles.axes2,[0 length(ROI)/FS]);
end


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global FS data_con ROI xmm2 xmv2 time_span t_peak stimulus;
xmm2 = 10;
xmv2 = 20;
time_span = [-200:1/FS:200];      % set time of ROI around peak in seconds.
[xp yp] = ginputax(handles.axes1,2);

if strcmp(get(handles.text3,'String'),'mM');
    data_showed = data_con(xp(1)*FS:xp(2)*FS);
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
    ROI = data_con(floor(xp(1)*FS+zx(3)+time_span*FS));
    SOI = stimulus(floor(xp(1)*FS+zx(3)+time_span*FS));
    close;
    if get(handles.radiobutton4, 'Value') ~= 1
        [baseline peak slp1 slp2 p20 p80 tp1 tp2] = calcPeakFoot(data_showed,stim_showed,zx,FS );
    else
   
        [baseline peak slp1 slp2 p20 p80 tp1 tp2] = calcPeak(data_showed,zx,FS );
    end
    plot((1:numel(ROI))/FS,ROI,'parent',handles.axes2);
    ylim(handles.axes2,[0 xmm2]);
else
    msgbox('Please calibrate first');
end
t_peak = table(baseline,peak,slp1,slp2,p20,p80,tp1,tp2);
t_peak.Properties.VariableNames = {'Baseline' 'Peak' 'Slope1' 'Slope2' 'P20_peak' 'P80_peak' 'Time_to_peak' 'Time_after_peak'};
xlim(handles.axes2,[1/FS numel(ROI)/FS]);


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


% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton4
