% データ系列の生成確認
% 190441091，永重俊弥 
% 
% ＊注意
% このプログラムでは以下のファンクションmファイルを使用します．
% bin_data_src.m

clc; % コマンドウィンドウ消去
clear all; % 全変数消去
close all; % 全てのfigureウィンドウを閉じる

% シミュレーションパラメータの設定
nDataBits = 1000; % 生成するビット数[bit]

% データ系列の生成
dataBit = bin_data_src(nDataBits);

% 生成された系列の最初10個をプロット
stem(dataBit(1:10));
title('data bit sequence')
xlabel('k[sample]');
ylabel('data(k)');

% dataBitに含まれる1の個数を数える
count1 = 0;

for k=1:nDataBits
    if dataBit(k)
        count1 = count1 + 1;
    end
end

% 1の割合を表示
count1 / nDataBits

% 0の割合を表示
(nDataBits - count1) / nDataBits

% Programming by K.Asahi 2015
