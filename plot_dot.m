% 点でデータをプロットするテスト

clc; % コマンドウィンドウ消去
clear all; % 全変数消去
close all; % 全てのfigureウィンドウを閉じる

% 適当なテストデータとして，xを1刻みで
% -5 <= x <= 5 において，y = 2 * x^2 を求める
x = -5:5; % 横軸の値
y = 2 .* (x .^ 2); % 縦軸の値

% テストデータをプロット
plot(x, y, '.');
title('dot plot test');
xlabel('x');
ylabel('y');

