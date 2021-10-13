% 190441091 永重俊弥
clc;
clear all;

% 課題4-1
y = randn(1,1000);
x=1:10;

figure(1);
plot(x, y(1:10), 'b-' , 'linewidth', 2); % 横軸t，縦軸xでプロットする
xlabel('試行回数 x'); % 横軸のラベル文字列を設定
ylabel('乱数値 y'); % 縦軸のラベル文字列を設定
grid on; % グリッド線を追加

% 課題4-2
m=6;
[n,x]=hist(y,m);
px=n./1000;

figure(2); % 2つ目のウィンドウを開く
plot(x, px, 'b-' , 'linewidth', 2); % 横軸y，縦軸pyでプロットする
xlabel('x'); % 横軸のラベル文字列を設定
ylabel('p(x)'); % 縦軸のラベル文字列を設定
grid on; % グリッド線を追加

% mの値を6もしくは7とすると，課題4-2のグラフは4-3のグラフに最も近づく（似る）．
% しかし，mを5以下とすると4-2のグラフは4-3のグラフより大きくなる．
% また，mを8以上とすると4-2のグラフは4-3のグラフより小さく成る．

% 課題4-3
hold on;

time_length = 10;
fs=100;
x=(-fs*time_length/2):(fs*time_length/2);x=x./fs;

px=1/sqrt(2*pi)*exp(-(x.^2)/2);

plot(x, px, 'b-' , 'linewidth', 2); % 横軸x，縦軸pxでプロットする
