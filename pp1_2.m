clc; clear all;
f_length = 20;
fc=1;
fs=100;
f=(-10*fs):(fs*f_length/2);f=f./fs;

wave=sinc(f);

plot(f,wave,'LineWidth',2);grid on;
xlabel('f');
ylabel('X(f)');