% �G���n��̐����m�F
% 190441091�C�i�d�r�� 
% 
% ������
% ���̃v���O�����ł͈ȉ��̃t�@���N�V����m�t�@�C�����g�p���܂��D
% noise_src.m

clc; % �R�}���h�E�B���h�E����
clear all; % �S�ϐ�����
close all; % �S�Ă�figure�E�B���h�E�����

% �V�~�����[�V�����p�����[�^�̐ݒ�
nDataBits = 1000; % ��������r�b�g��[bit]
noisePower = 1; % �G���d��[W]

% �G���n��̐���
complexNoise = noise_src(nDataBits, noisePower);

% �������ꂽ�n��̍ŏ�10�̎����Ƌ������v���b�g
subplot(211); plot(real(complexNoise(1:10)));
title('noise (real part)')
xlabel('k[sample]');
ylabel('Re[n(k)]');
subplot(212); plot(imag(complexNoise(1:10)));
title('noise (imaginary part)')
xlabel('k[sample]');
ylabel('Im[n(k)]');

% �����Ɏ����C�c���ɋ��������CcomplexNoise��_�Ńv���b�g
figure(2);
plot(real(complexNoise), imag(complexNoise), '.');
title('�ۑ�6-2');
xlabel('Re');
ylabel('Im');
grid on;

% Programming by K.Asahi 2015
