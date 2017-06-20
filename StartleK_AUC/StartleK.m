%file opening and channels setting
clear all;
[abfFileName,path] = uigetfile('*.abf');
filename = strcat(path,abfFileName);
FS = 100;
window = 1000;
pausetime = 2;                                              %holding plot time
%%
prompt = {'K recording channel 1(1-2)','Reference channel 2(1-2)','Startle channel','EEG','Using K concentration?(1 Yes, 2 No)','correlation?(1 Yes, 2 No)'};
dlg_title = 'Input(min)';
num_lines = 1;
defaultans = {'BP','IN 0','IN 5','IN 1','2','2'};           % default values
answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
%%
k1 = abfload(char(filename),'channels',{char(answer(1))});
k2 = abfload(char(filename),'channels',{char(answer(2))});
startle = abfload(char(filename),'channels',{char(answer(3))});
EEG = abfload(char(filename),'channels',{char(answer(4))});

K = k1-k2;
clear k1 k2;

%%
Calibrate;
%% correlation
if char(answer(6)) == '1'
    Correlate;    
end

%% define startle times and range
answer2 = inputdlg('input times of startles','Times',1,{'3'});
p3 = figure(3);
set(p3,'position',[200 400 1500 400]);
plot((1:length(startle))/(FS*60),startle);
count = str2double(char(answer2(1)));
[sx,sy] = ginput(2 * str2double(char(answer2(1))));
close(p3);
%% calculation and plot
AUC = zeros(count,1);                                               %pre-allocation
Kmax = zeros(count,1);
baseline = zeros(count,1);
interval = zeros(count,2);
AUC_5min = zeros(count,1);
for i = 1:count
    stim = startle(ceil(sx(i*2-1)*FS*60):ceil(sx(i*2)*FS*60),:);
    index = find(stim > 10);                                        %find stimulus interval
    Kstim = Ktrace(ceil(sx(i*2-1)*FS*60):ceil(sx(i*2)*FS*60),:);    %selected segment of trace
    p4 = figure(4);
    set(p4,'position',[100 200 1000 600]);
    subplot(2,1,1);
    plot((1:length(stim))/(FS*60),stim);
    subplot(2,1,2);
    plot((1:length(Kstim))/(FS*60),Kstim);
    ylim(Yrange)
    fprintf('Select 2 points to set baseline\n');
    [bx,by] = ginput(2);
    fprintf('Select 2 points to set peak value\n');
    [px,py] = ginput(2);
    base = mean(Kstim(ceil(bx(1)*FS*60):ceil(bx(2)*FS*60),:));
    Kstartle = Kstim(index(1):index(length(index)),:);                  % startle 2min interval
    [Kmax(i),I] = max(Kstim(px(1)*FS*60:px(2)*FS*60,:));
    baseline(i) = base;
    interval(i,:)= [(sx(i*2-1)+index(1)/(FS*60)) (sx(i*2-1)+index(length(index))/(FS*60))];      %interval of startle in min
    ts = (1:length(Kstartle))/FS;                                                         % time in seconds
    AUC(i) = trapz(ts,Kstartle-base);                                                    % AUC in unit mM * sec 
    K5 = Ktrace(interval(i,2)*FS*60:(interval(i,2)+5)*FS*60);
    t5 = (1:length(K5))/FS; 
    AUC_5min(i) = trapz(t5,K5 - base);        %calculate AUC after startle for 5min
    
    close(p4);
    
    PlotFull;
end

%% 
