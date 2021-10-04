% sin��cos�̔g�`���v���b�g������

clc; % �R�}���h�E�B���h�E����
clear all; % �S�ϐ�������

% �ݒ荀�ځi�p�����^�j
time_length = 1; %�M���̎��Ԓ�[s]
Fs = 1000; % �T���v�����O���g��[Hz]
fc = 1; % �������鐳���g�̎��g��[Hz]

% �p�����^����萔�����Z�o
Ts = 1 / Fs; % �T���v�����O����[s]�̎Z�o
n = 0:((Fs * time_length) - 1); % ���Ԏ��̃T���v���ԍ�n=[0 fs*t_l-1]
t = n .* Ts; % ���Ԏ��̎Z�o(�T���v���ԍ�n�̃T���v�����O�������|����)

% �M���̐���
omega_c = 2 .* pi .* fc; % ��c = 2 pi fc
x = sin(omega_c .* t);
y = cos(omega_c .* t); 

% ���ԗ̈�sin�v���b�g
figure(1); % 1�ڂ̃E�B���h�E���J��
plot(t, x, 'b-' , 'linewidth', 2); % ����t�C�c��x�Ńv���b�g����
xlabel('Time t[s]'); % �����̃��x���������ݒ�
ylabel('sin(2 \pi f t)'); % �c���̃��x���������ݒ�
grid on; % �O���b�h����ǉ�

% ���ԗ̈�cos�v���b�g
figure(2); % 2�ڂ̃E�B���h�E���J��
plot(t, y, 'b-' , 'linewidth', 2); % ����t�C�c��x�Ńv���b�g����
xlabel('Time t[s]'); % �����̃��x���������ݒ�
ylabel('cos(2 \pi f t)'); % �c���̃��x���������ݒ�
grid on; % �O���b�h����ǉ�

% �ۑ�3-1
xy = x.*y;
figure(3);
plot(t, xy, 'b-' , 'linewidth', 2); % ����t�C�c��x�Ńv���b�g����
xlabel('Time t[s]'); % �����̃��x���������ݒ�
ylabel('xy'); % �c���̃��x���������ݒ�
grid on; % �O���b�h����ǉ�

% �ۑ�3-2
sum(xy)

% �ۑ�3-3
xx = x.*x;
yy = y.*y;
figure(4);
subplot(211); plot(t, xx, 'b-' , 'linewidth', 2); xlabel('Time t[s]'); ylabel('xx'); grid on;
subplot(212); plot(t, yy, 'b-' , 'linewidth', 2); xlabel('Time t[s]'); ylabel('yy'); grid on;

% �ۑ�3-4
sum(xx)
sum(yy)

% �ۑ�3-5
xy = 2 * x + 3 * y;
sum(xy.*x)
sum(xy.*y)

% ���܂�
% �e plot �R�}���h�̎��Ɉȉ���2��set�R�}���h������ƃt�H���g��ύX�o����
% set(gca, 'FontName', 'Times New Roman'); % �t�H���g�̎�ނ��w��
% set(gca, 'FontSize', 20); % �t�H���g�̑傫�����w��