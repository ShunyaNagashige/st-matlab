function plot_autocorr_fft( auto_corr )
%plot_autocorr_fft ���ȑ��֊֐��������ɂƂ�FFT���ăp���[�X�y�N�g����\��
%   �����̎��ȑ��֊֐�auto_corr��FFT���ăp���[�X�y�N�g����\��

len_auto_corr = length(auto_corr);
% FFT�����s����D�v�Z�덷�ŕ��f���ƂȂ�ꍇ������̂Ŏ�������o��
pw = real(fft(auto_corr));
% dB�Ɋ��Z����
pw_db = 10*log10(pw);
% plot�̉������l�𐶐�����
fl = 0:len_auto_corr-1;
fl = fl ./ len_auto_corr;
% plot����
plot(fl, pw_db, '-o');
% plot���ʂ����₷������
ylim([-40 20]);
title('power spectrum density')
xlabel('Normalized frequency[{\times}fs Hz]');
ylabel('Magnitude[dB]');
grid on;

end

