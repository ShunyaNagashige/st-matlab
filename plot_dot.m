% �_�Ńf�[�^���v���b�g����e�X�g

clc; % �R�}���h�E�B���h�E����
clear all; % �S�ϐ�����
close all; % �S�Ă�figure�E�B���h�E�����

% �K���ȃe�X�g�f�[�^�Ƃ��āCx��1���݂�
% -5 <= x <= 5 �ɂ����āCy = 2 * x^2 �����߂�
x = -5:5; % �����̒l
y = 2 .* (x .^ 2); % �c���̒l

% �e�X�g�f�[�^���v���b�g
plot(x, y, '.');
title('dot plot test');
xlabel('x');
ylabel('y');

