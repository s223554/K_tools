function [peak slp1 slp2 p20 p80 tp1 tp2] = calcPeak( ROI,zx,FS )
%CALCPEAK Summary of this function goes here
%   zx: zoom in and ginput x-axis values.
    ROI = smooth(ROI,100);
    baseline = mean(ROI(zx(1):zx(2)));
    peak = ROI(floor(zx(3)));
    p20 = (peak-baseline)*0.2;
    p80 = (peak-baseline)*0.8;

    part_1 = ROI(1:zx(3));
    part_2 = ROI(zx(3):end);
    [c1 idx1] = min(abs(part_1-p20));
    [c2 idx2] = min(abs(part_1-p80));
    [c3 idx3] = min(abs(part_2-p80));
    [c4 idx4] = min(abs(part_2-p20));
    slp1 = (p80-p20)/(idx2-idx1)*FS;    % Unit of slope : mM/sec
    slp2 = (p20-p80)/(idx4-idx3)*FS;
    p1 = polyfit([idx1,idx2],[p20,p80],1);
    p2 = polyfit([idx3,idx4],[p80,p20],1);
    p_baseline = polyfit([1 2],[baseline,baseline],1);
    tp1 =(zx(3)- fzero(@(x) polyval(p1-p_baseline,x),3))/FS;
    tp2 =( fzero(@(x) polyval(p2-p_baseline,x),3))/FS;
    
end

