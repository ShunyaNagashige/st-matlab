% sinとcosの波形をプロットする例題

clc; % コマンドウィンドウ消去
clear all; % 全変数初期化

% 設定項目（パラメタ）
time_length = 1; %信号の時間長[s]
Fs = 1000; % サンプリング周波数[Hz]
fc = 1; % 生成する正弦波の周波数[Hz]

% パラメタから定数等を算出
Ts = 1 / Fs; % サンプリング周期[s]の算出
n = 0:((Fs * time_length) - 1); % 時間軸のサンプル番号n=[0 fs*t_l-1]
t = n .* Ts; % 時間軸の算出(サンプル番号nのサンプリング周期を掛ける)

% 信号の生成
omega_c = 2 .* pi .* fc; % ωc = 2 pi fc
x = sin(omega_c .* t);
y = cos(omega_c .* t); 

% 時間領域sinプロット
figure(1); % 1つ目のウィンドウを開く
plot(t, x, 'b-' , 'linewidth', 2); % 横軸t，縦軸xでプロットする
xlabel('Time t[s]'); % 横軸のラベル文字列を設定
ylabel('sin(2 \pi f t)'); % 縦軸のラベル文字列を設定
grid on; % グリッド線を追加

% 時間領域cosプロット
figure(2); % 2つ目のウィンドウを開く
plot(t, y, 'b-' , 'linewidth', 2); % 横軸t，縦軸xでプロットする
xlabel('Time t[s]'); % 横軸のラベル文字列を設定
ylabel('cos(2 \pi f t)'); % 縦軸のラベル文字列を設定
grid on; % グリッド線を追加

% 課題3-1
xy = x.*y;
figure(3);
plot(t, xy, 'b-' , 'linewidth', 2); % 横軸t，縦軸xでプロットする
xlabel('Time t[s]'); % 横軸のラベル文字列を設定
ylabel('xy'); % 縦軸のラベル文字列を設定
grid on; % グリッド線を追加

% 課題3-2
sum(xy)

% 課題3-3
xx = x.*x;
yy = y.*y;
figure(4);
subplot(211); plot(t, xx, 'b-' , 'linewidth', 2); xlabel('Time t[s]'); ylabel('xx'); grid on;
subplot(212); plot(t, yy, 'b-' , 'linewidth', 2); xlabel('Time t[s]'); ylabel('yy'); grid on;

% 課題3-4
sum(xx)
sum(yy)

% 課題3-5
xy = 2 * x + 3 * y;
sum(xy.*x)
sum(xy.*y)

% おまけ
% 各 plot コマンドの次に以下の2つのsetコマンドを入れるとフォントを変更出来る
% set(gca, 'FontName', 'Times New Roman'); % フォントの種類を指定
% set(gca, 'FontSize', 20); % フォントの大きさを指定