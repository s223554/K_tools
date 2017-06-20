fprintf('select 2 points to correlate\n');
figure;
plot(Ktrace);
set(gcf,'position',[100 200 1000 600]);
ylim(Yrange);
[cox coy] = ginput(2);
close;
%%
y1 = [Ktrace(cox(1):cox(2))];
x1 = (1:length(Ktrace(cox(1):cox(2))))';
X1 = [ones(length(x1),1) x1];
b1 = X1\y1;                  %muldivide y = bx + e,b(1,:) is intersect
x2 = (1:length(Ktrace))';
X2 = [ones(length(x2),1) x2-cox(1)];
yCalc1 = X1*b1;
yCalc2 = X2*b1;
%%
plot(Ktrace);
hold;plot(yCalc2);
set(gcf,'position',[100 200 1000 600]);
ylim([-5 upper]);
pause(pausetime);
close;
Ktrace2 = Ktrace-yCalc2 + coy(1);
plot(Ktrace,'Color',[0.7 0.7 0.7]);
hold;
plot(Ktrace2,'Color',[0 0 0]);

set(gcf,'position',[100 200 1000 600]);
ylim([-5 upper]);
pause(pausetime);
close;
Ktrace = Ktrace2;

