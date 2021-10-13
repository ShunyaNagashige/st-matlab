function plot_autocorr_fft( auto_corr )
%plot_autocorr_fft 自己相関関数を引数にとりFFTしてパワースペクトルを表示
%   引数の自己相関関数auto_corrをFFTしてパワースペクトルを表示

len_auto_corr = length(auto_corr);
% FFTを実行する．計算誤差で複素数となる場合があるので実部を取出す
pw = real(fft(auto_corr));
% dBに換算する
pw_db = 10*log10(pw);
% plotの横軸数値を生成する
fl = 0:len_auto_corr-1;
fl = fl ./ len_auto_corr;
% plotする
plot(fl, pw_db, '-o');
% plot結果を見やすくする
ylim([-40 20]);
title('power spectrum density')
xlabel('Normalized frequency[{\times}fs Hz]');
ylabel('Magnitude[dB]');
grid on;

end

