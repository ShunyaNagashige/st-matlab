% 雑音系列の生成確認
% 190441091，永重俊弥 
% 
% ＊注意
% このプログラムでは以下のファンクションmファイルを使用します．
% noise_src.m

clc; % コマンドウィンドウ消去
clear all; % 全変数消去
close all; % 全てのfigureウィンドウを閉じる

% シミュレーションパラメータの設定
nDataBits = 1000; % 生成するビット数[bit]
noisePower = 1; % 雑音電力[W]

% 雑音系列の生成
complexNoise = noise_src(nDataBits, noisePower);

% 生成された系列の最初10個の実部と虚部をプロット
subplot(211); plot(real(complexNoise(1:10)));
title('noise (real part)')
xlabel('k[sample]');
ylabel('Re[n(k)]');
subplot(212); plot(imag(complexNoise(1:10)));
title('noise (imaginary part)')
xlabel('k[sample]');
ylabel('Im[n(k)]');

% 横軸に実部，縦軸に虚部を取り，complexNoiseを点でプロット
figure(2);
plot(real(complexNoise), imag(complexNoise), '.');
title('課題6-2');
xlabel('Re');
ylabel('Im');
grid on;

% Programming by K.Asahi 2015
