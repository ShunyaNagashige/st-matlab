clc; clear all;
time_length = 2;
fc=1;
fs=100;
t=0:(fs*time_length);t=t./fs;

sin_wave=sin(2*pi*t+pi/2);

plot(t,sin_wave,'LineWidth',2);grid on;
xlabel('t [s]');
ylabel('x(t)');

