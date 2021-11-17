% Plot Theoretical BER for Antipodal / OOK / Orthogonal
% Programming by K.Asahi 2015
clc;
clear all;

font_name = 'Times New Roman';
font_size = 20;


% �p�����[�^
EbN0_dB_range = -10:16; % Eb/N0[dB]

% ���ʂ��i�[����z����m�ۂ���
ook_ber_theory = zeros(1, length(EbN0_dB_range));
orth_ber_theory = zeros(1, length(EbN0_dB_range));
anti_ber_theory = zeros(1, length(EbN0_dB_range));

% �z��Y�����������iMATLAB�̔z��́C1�͂��܂�j
idx = 1;
% �w�肳�ꂽEb/N0�͈̔͂ŌJ��Ԃ�
for EbN0_dB = EbN0_dB_range;
    % dB����^�l�Ɋ��Z
    EbN0_tv = 10 ^ (EbN0_dB/10);
    % �e�����̗��_BER���Z�o
    ook_ber_theory(idx) = erfc(sqrt(EbN0_tv/4)) / 2; % OOK
    orth_ber_theory(idx) = erfc(sqrt(EbN0_tv/2)) / 2; % Orthogonal
    anti_ber_theory(idx) = erfc(sqrt(EbN0_tv)) / 2; % Antipodal
    % �z��̓Y����1�i�߂�
    idx = idx + 1;
end

% Plot theoretical BER results
figure(1);
semilogy(EbN0_dB_range, ook_ber_theory, 'b.-', 'linewidth', 2);
hold on;
semilogy(EbN0_dB_range, orth_ber_theory, 'bo-', 'linewidth', 2);
semilogy(EbN0_dB_range, anti_ber_theory, 'b*-', 'linewidth', 2);
hold off;
% �ȉ��Cplot�����₷�����邽�߂ׂ̍����ݒ�
set(gca, 'FontName', font_name); % �t�H���g�̎�ނ��w��
set(gca, 'FontSize', font_size); % �t�H���g�̑傫�����w��
set(gca,'XTick', 0:2:16); % �c���̖ڐ���ݒ�
yt = -6:1:0; % �c���̎w����
yt = 10.^yt; % �c���ڐ���̐��l
set(gca,'YTick', yt); % �c���̖ڐ���ݒ�
xlim([-10 16]); % �\�����鉡���͈̔�
ylim([10^-6 10^0]); % �\������c���͈̔�
xlabel('Eb/N0 [dB]'); % �������x��
ylabel('BER'); % �c�����x��
legend('OOK', 'Orthogonal', 'Antipodal',  'Location','SouthWest'); % �}��
grid on; % �O���b�h�̕\��

