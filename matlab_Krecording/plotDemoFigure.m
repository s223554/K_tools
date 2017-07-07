%file opening and channels setting
clear all;
[abfFileName,path] = uigetfile('*.abf');
filename = strcat(path,abfFileName);
Fs = 1000;
                                            %holding plot time
%%
prompt = {'K recording channel','Reference channel','Stimulation channel','LFP','BP channel'};
dlg_title = 'Input(min)';
num_lines = 1;
defaultans = {'potassium','LFP raw','STIM','LFP filter','BP'};           % default values
answer = inputdlg(prompt,dlg_title,num_lines,defaultans);

k = abfload(char(filename),'channels',{char(answer(1))});
ref = abfload(char(filename),'channels',{char(answer(2))});
stimulation = abfload(char(filename),'channels',{char(answer(3))});
LFP = abfload(char(filename),'channels',{char(answer(4))});
BP = abfload(char(filename),'channels',{char(answer(5))});

K = k-ref;
KmM = calibrate(K,Fs);
%% plot
startTime = input('Type in the start time in sec');
endTime = input('Type in the end time in sec');
%%
time_span = startTime*Fs:endTime*Fs-1;
tvec = 1/Fs:1/Fs:(endTime-startTime);
figure;
set(gcf,'Position',[100 100 1000 600])

subplot(4,1,1)
plot(tvec,KmM(time_span))
xlim([0 endTime-startTime])
% ylim([-1 1])
ylabel('[K] (mM)')

subplot(4,1,2)
plot(tvec,stimulation(time_span))
xlim([0 endTime-startTime])
ylim([-10 50])
ylabel('Stimulation (mV)')

subplot(4,1,3)
plot(tvec,LFP(time_span))
xlim([0 endTime-startTime])
ylim([-1 1])
ylabel('LFP (mV)')

subplot(4,1,4)
plot(tvec,BP(time_span))
xlim([0 endTime-startTime])
ylim([-1 1])
ylabel('BP (mmHg)')
