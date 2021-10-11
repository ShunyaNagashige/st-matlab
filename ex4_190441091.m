clc;
clear all;

% 課題4-1
y = randn(1,1000);
%y = y1000(1:10);

% figure(1);
% plot(x, y, 'b-' , 'linewidth', 2); % 横軸t，縦軸xでプロットする
% xlabel('Time t[s]'); % 横軸のラベル文字列を設定
% ylabel('sin(2 \pi f t)'); % 縦軸のラベル文字列を設定
% grid on; % グリッド線を追加

% 課題4-2
m=20;
[n,x]=hist(y,m);
py=n./m;

figure(2); % 2つ目のウィンドウを開く
plot(x, py, 'b-' , 'linewidth', 2); % 横軸y，縦軸pyでプロットする
xlabel('y'); % 横軸のラベル文字列を設定
ylabel('p(y)'); % 縦軸のラベル文字列を設定
grid on; % グリッド線を追加

% 課題4-3
hold on;

px=1/sqrt(2*pi)*exp()
