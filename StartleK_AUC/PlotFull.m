p5 = figure(5);
set(p5,'position',[100,100,1500,700])
    subplot(2,2,1);
    trace = EEG(ceil(sx(i*2-1)*FS*60):ceil(sx(i*2)*FS*60),:);
    v = [index(1)/(FS*60) -1;index(1)/(FS*60) 1;index(length(index))/(FS*60) 1;index(length(index))/(FS*60) -1];
    f = [1 2 3 4];
    plot((1:length(trace))/(FS*60),trace);
    patch('Faces',f,'Vertices',v,'FaceColor','red','EdgeColor','none','FaceAlpha',0.2);
    xlim([0 (length(trace))/(FS*60)]);
    ylim([-1 1]);
    title('ECoG');
    
    subplot(2,2,3);
    v = [index(1)/(FS*60) Yrange(1);index(1)/(FS*60) Yrange(2);index(length(index))/(FS*60) Yrange(2);index(length(index))/(FS*60) Yrange(1)];;
    plot((1:length(Kstim))/(FS*60),Kstim);
    patch('Faces',f,'Vertices',v,'FaceColor','red','EdgeColor','none','FaceAlpha',0.2);
    xlim([0 (length(Kstim))/(FS*60)]);
    ylim(Yrange);
    line([0 50000],[base base],'color','green')
    title(Tl);
    hold;
    scatter(px(1)+I/(FS*60)+interval(i,1)/(FS*60),Kmax(i));

    
    subplot(2,2,2);                     % -5min ~ 10min Power plot
    spec = EEG(ceil((interval(i,1)-5)*FS*60):ceil((interval(i,2)+10)*FS*60),:);
    [s, f, t, p] = spectrogram(spec, window, 0, [], FS, 'yaxis', 'power');
    CalcRelativePwr;
    bar(RelativePower, 'stacked'), colormap('jet');
    set(gca, 'XTick', 0:30:120,'XTickLabel', 0:5:20);
    v = [30 0;30 1.5;42 1.5;42 0];
    f = [1 2 3 4];
    patch('Faces',f,'Vertices',v,'FaceColor','red','EdgeColor','none','FaceAlpha',0.2);
    title('Relative Frequency', 'fontsize', 12);
    legend('1-3Hz','3-5Hz','5-8Hz','8-13Hz','13-32Hz');
    ylim([0 1.2])
    xlim([0 length(RelativePower)])
    
    subplot(2,2,4);
    xlim([0 1]);
    ylim([0 1]);
    text(0.1,1.0,strcat(char(abfFileName(1:15)),' startle#',num2str(i)),'fontsize', 16,'interpreter','none');
    text(0.1,0,strcat('K peak:',{'  '},num2str(Kmax(i)),unit), 'fontsize', 16);
    text(0.1,0.8,strcat('Startle:',{'  '},num2str(interval(i,1)),' -',{' '},num2str(interval(i,2)),' min'), 'fontsize', 16);
    text(0.1,0.6,strcat('Base line:',{'  '},num2str(base),unit), 'fontsize', 16);
    text(0.1,0.4,strcat('AUC:',{'  '},num2str(AUC(i)),unit, '* sec'), 'fontsize', 16);
    text(0.1,0.2,strcat('AUC 5min after:',{'  '},num2str(AUC_5min(i)),unit,'* sec'), 'fontsize', 16);
    axis off
    mkdir(strcat(path,'\output'));
    print(p5,strcat(path,'\output','\',abfFileName, '_','startle_',num2str(i),'.pdf'),'-dpdf');
    pause(pausetime);
    
    close(p5);
    