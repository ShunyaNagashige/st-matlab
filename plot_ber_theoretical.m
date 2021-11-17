% Plot Theoretical BER for Antipodal / OOK / Orthogonal
% Programming by K.Asahi 2015
clc;
clear all;

font_name = 'Times New Roman';
font_size = 20;


% パラメータ
EbN0_dB_range = -10:16; % Eb/N0[dB]

% 結果を格納する配列を確保する
ook_ber_theory = zeros(1, length(EbN0_dB_range));
orth_ber_theory = zeros(1, length(EbN0_dB_range));
anti_ber_theory = zeros(1, length(EbN0_dB_range));

% 配列添字を初期化（MATLABの配列は，1はじまり）
idx = 1;
% 指定されたEb/N0の範囲で繰り返す
for EbN0_dB = EbN0_dB_range;
    % dBから真値に換算
    EbN0_tv = 10 ^ (EbN0_dB/10);
    % 各方式の理論BERを算出
    ook_ber_theory(idx) = erfc(sqrt(EbN0_tv/4)) / 2; % OOK
    orth_ber_theory(idx) = erfc(sqrt(EbN0_tv/2)) / 2; % Orthogonal
    anti_ber_theory(idx) = erfc(sqrt(EbN0_tv)) / 2; % Antipodal
    % 配列の添字を1つ進める
    idx = idx + 1;
end

% Plot theoretical BER results
figure(1);
semilogy(EbN0_dB_range, ook_ber_theory, 'b.-', 'linewidth', 2);
hold on;
semilogy(EbN0_dB_range, orth_ber_theory, 'bo-', 'linewidth', 2);
semilogy(EbN0_dB_range, anti_ber_theory, 'b*-', 'linewidth', 2);
hold off;
% 以下，plotを見やすくするための細かい設定
set(gca, 'FontName', font_name); % フォントの種類を指定
set(gca, 'FontSize', font_size); % フォントの大きさを指定
set(gca,'XTick', 0:2:16); % 縦軸の目盛を設定
yt = -6:1:0; % 縦軸の指数部
yt = 10.^yt; % 縦軸目盛りの数値
set(gca,'YTick', yt); % 縦軸の目盛を設定
xlim([-10 16]); % 表示する横軸の範囲
ylim([10^-6 10^0]); % 表示する縦軸の範囲
xlabel('Eb/N0 [dB]'); % 横軸ラベル
ylabel('BER'); % 縦軸ラベル
legend('OOK', 'Orthogonal', 'Antipodal',  'Location','SouthWest'); % 凡例
grid on; % グリッドの表示

