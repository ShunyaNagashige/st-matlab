clc; % コマンドウィンドウ消去
clear all; % 全変数初期化

% 課題5-1
x1 = randn(1,256);

% a(1)が，式(1)のa[0]に対応している
for d=0:128
    a1(d+1)= (x1(1:128) * x1((1+d):(128+d))') / 128;
end

figure(1);
plot(0:9, a1(1:10), 'b-' , 'linewidth', 2); % 横軸t，縦軸xでプロットする
xlabel('d'); % 横軸のラベル文字列を設定
ylabel('a[d]'); % 縦軸のラベル文字列を設定
grid on; % グリッド線を追加

% 課題5-2
for k=1:256
    x2(k) = sin(2*pi*(k-1)/128);
end

for d=0:127
    a2(d+1) = (x2(1:128) * x2((1+d):(128+d))') / 128;
end

figure(2);
plot(0:127, a2, 'b-' , 'linewidth', 2); % 横軸t，縦軸xでプロットする
xlabel('d'); % 横軸のラベル文字列を設定
ylabel('a[d]'); % 縦軸のラベル文字列を設定
grid on; % グリッド線を追加

% 課題5-3
figure(3);
plot_autocorr_fft(a1);

% 課題5-4
figure(4);
plot_autocorr_fft(a2);