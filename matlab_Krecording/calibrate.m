function [KmM ] = calibrate(KmV,FS)
pausetime = 2;
Kc = KmV(1:3600*FS,:);
p1 = figure(1);
set(p1,'position',[200 100 1000 400]);
plot((1:length(Kc))/(FS*60),Kc);
ylim([-5,30]);
fprintf('Select 6 points to plot calibration curve\n');
[cx,cy] = ginput(6);
close(p1);
%%
cx = cx*60*FS;
x = [mean(KmV(cx(1):cx(2),:));mean(KmV(cx(3):cx(4),:));mean(KmV(cx(5):cx(6),:))];
y = [log(2.5/150);log(3.5/150);log(4.5/150)];
X = [ones(length(x),1) x];
b = X\y;                  %muldivide y = bx + e,b(1,:) is intersect
yCalc = X*b;
p2 = figure(2);
plot(yCalc,x);
hold;
scatter(y,x);
pause(pausetime);
close(p2);

KmM = 150 * exp([ones(length(KmV),1) KmV]*b);
end