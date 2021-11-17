% 190441091 永重俊弥
clc; % コマンドウィンドウ消去
clear all; % 全変数初期化

% 課題8-1
r_c = 0;
r_s = 0;

for k=1:128
    u(k) = cos((2*pi*(k-1)/128)+(pi/4));
    c(k) = cos(2*pi*(k-1)/128);
    s(k) = -sin(2*pi*(k-1)/128);
end

% dだけずらしながら，相互相関関数r_c[d+1]を計算する
for d=0:64
    r_c(d+1) = (u(1:64) * c((1+d):(64+d))') / 64;
    r_s(d+1) = (u(1:64) * s((1+d):(64+d))') / 64;
end

% 解答を表示
r_c
r_s

% 課題8-2

% [rad]単位の値を表示
rad = atan2(r_c, r_s)

% [度]単位の値を表示
deg = rad2deg(rad)
