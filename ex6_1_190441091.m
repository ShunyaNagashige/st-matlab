% �f�[�^�n��̐����m�F
% 190441091�C�i�d�r�� 
% 
% ������
% ���̃v���O�����ł͈ȉ��̃t�@���N�V����m�t�@�C�����g�p���܂��D
% bin_data_src.m

clc; % �R�}���h�E�B���h�E����
clear all; % �S�ϐ�����
close all; % �S�Ă�figure�E�B���h�E�����

% �V�~�����[�V�����p�����[�^�̐ݒ�
nDataBits = 1000; % ��������r�b�g��[bit]

% �f�[�^�n��̐���
dataBit = bin_data_src(nDataBits);

% �������ꂽ�n��̍ŏ�10���v���b�g
stem(dataBit(1:10));
title('data bit sequence')
xlabel('k[sample]');
ylabel('data(k)');

% dataBit�Ɋ܂܂��1�̌��𐔂���
count1 = 0;

for k=1:nDataBits
    if dataBit(k)
        count1 = count1 + 1;
    end
end

% 1�̊�����\��
count1 / nDataBits

% 0�̊�����\��
(nDataBits - count1) / nDataBits

% Programming by K.Asahi 2015
