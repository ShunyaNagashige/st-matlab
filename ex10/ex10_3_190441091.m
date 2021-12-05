% モンテカルロシミュレーションによるQAMのBER算出
% 190441091, 永重俊弥
%
% ＊注意
% このプログラムでは以下のファンクションmファイルを使用します．
% bin_data_src.m, noise_src.m theoretical_ber_16qam.m

% 【注意】関数名 ex10_3 は，mファイルのファイル名前と一致させること
function ex10_3()
    clc;
    clear all;

    %%%%%%%%%%%%%%%%
    % シミュレーションパラメータ
    nDataBits = 1000000; % 全送信ビット数[bit]
    % EbN0_dB = 8; % Eb/N0[dB]
    %%%%%%%%%%%%%%%%

    EbN0_dB_range = 8:14;
    ber_16qam = zeros(1, length(EbN0_dB_range));
    ber_16qam_gray = zeros(1, length(EbN0_dB_range));
    theoretical_ber = zeros(1, length(EbN0_dB_range));
    % qpsk_ber_theory = zeros(1, length(EbN0_dB_range));
    % qpsk_ber = zeros(1, 14+1);

    d = 1;
    s = [ -3*d+j*3*d, ...
          -1*d+j*3*d, ...
           1*d+j*3*d, ...
           3*d+j*3*d, ...
          -3*d+j*1*d, ...
          -1*d+j*1*d, ...
           1*d+j*1*d, ...
           3*d+j*1*d, ...
          -3*d-j*1*d, ...
          -1*d-j*1*d, ...
           1*d-j*1*d, ...
           3*d-j*1*d, ...
          -3*d-j*3*d, ...
          -1*d-j*3*d, ...
           1*d-j*3*d, ...
           3*d-j*3*d]; % s0000, ..., s1111
    
    s_gray = [ -3*d+j*3*d, ... % s0000
          -1*d+j*3*d, ... %s0001
           3*d+j*3*d, ... %s0010
           1*d+j*3*d, ... %s0011
          -3*d+j*1*d, ... %s0100
          -1*d+j*1*d, ... %s0101
           3*d+j*1*d, ... %s0110
           1*d+j*1*d, ... %s0111
          -3*d-j*3*d, ... %s1000
          -1*d-j*3*d, ... %s1001
           3*d-j*3*d, ... %s1010
           1*d-j*3*d, ... %s1011
          -3*d-j*1*d, ... %s1100
          -1*d-j*1*d, ... %s1101
           3*d-j*1*d, ... %s1110
           1*d-j*1*d];  %s1111
    
    %%%%%%%%%%%%%%%%%%%%
    % シミュレーション部
        
    index = 1;
    for EbN0_dB=EbN0_dB_range
        % シミュレーション実行
        ber_16qam(index) = sim_16qam(nDataBits, EbN0_dB, s);
        ber_16qam_gray(index) = sim_16qam(nDataBits, EbN0_dB, s_gray);
        
        % 理論値の算出
        theoretical_ber(index) = theoretical_ber_16qam(10 ^ (EbN0_dB/10));

        % 結果の表示
        disp(['Simulated BER = ' num2str(ber_16qam) ' in Eb/N0 = ' num2str(EbN0_dB) '[dB]']);
        disp(['(Theoretical BER (gray-code mapped)  = ' num2str(theoretical_ber) ')']);

        
        index = index + 1;
    end

    font_name = 'Times New Roman';
    font_size = 20;
    
    figure(2);
    semilogy(EbN0_dB_range, ber_16qam, 'b--', 'linewidth', 2);
    hold on;
    semilogy(EbN0_dB_range, ber_16qam_gray, 'b-', 'linewidth', 2);
    semilogy(EbN0_dB_range, theoretical_ber, 'ro-', 'linewidth', 2);
    hold off;
    % 以下，plotを見やすくするための細かい設定
    set(gca, 'FontName', font_name); % フォントの種類を指定
    set(gca, 'FontSize', font_size); % フォントの大きさを指定
    set(gca,'XTick', 8:14); % 横軸の目盛を設定
    yt = -7:1:-1; % 縦軸の指数部
    yt = 10.^yt; % 縦軸目盛りの数値
    set(gca,'YTick', yt); % 縦軸の目盛を設定
    xlim([8 14]); % 表示する横軸の範囲
    ylim([10^-7 10^-1]); % 表示する縦軸の範囲
    xlabel('Eb/N0 [dB]'); % 横軸ラベル
    ylabel('BER'); % 縦軸ラベル
    legend('actual values', 'gray code actual values', 'theoretical values'); % 凡例
    grid on; % グリッドの表示
    
    % ここまで
    %%%%%%%%%%%%%%%%%%%%

end
% function ex10_3() ここまで

% ローカル関数 sim_16qam の定義ここから
function ber = sim_16qam(nDataBits, EbN0_dB, s)
    %%%%%%%%%%%%%%%%%%%%%%%%
    % 16QAM 信号波形パラメータ
    d = 1;
    
    M = length(s);
    k = log2(M);
    % ここまで
    %%%%%%%%%%%%%%%%%%%%%%%%


    %%%%%%%%%%%%%%%%
    % 送信器ここから
    %
    % データビットの生成
    dataBit = bin_data_src( nDataBits ); % bin_data_src.mを呼び出す
    transmitSymbol = zeros(1, nDataBits/k); % 送信波形格納用の配列確保(MATLAB tips)
    ms = zeros(1, nDataBits/k); % 送信シンボル番号格納用の配列確保(MATLAB tips)
    mr = zeros(1, nDataBits/k); % 受信シンボル番号格納用の配列確保(MATLAB tips)
    % データビットから対応する信号波形への割り当て(変調)
    for ni=1:k:nDataBits
        index = 0;
        for nj=ni:ni+k-1
            % 2をかけることで，2^xのxを増やす
            index = 2*index + dataBit(nj);
        end
        ms((ni+k-1)/k) = index+1;
        transmitSymbol((ni+k-1)/k) = s(index+1);
    end
    %
    % 送信器ここまで
    %%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%
    % 通信路ここから
    %
    % AWGNの発生
    Eav = 10*d^2;
    noisePower = 10 ^ -(EbN0_dB/10);
    noise = noise_src( nDataBits/k, Eav*noisePower/k ); % noise_src.mを呼び出す

    % AWGN通信路
    reciveSymbol = transmitSymbol + noise;
    %
    % 通信路ここまで
    %%%%%%%%%%%%%%%%


    % (おまけ)受信シンボルのコンスタレーションを表示
    % 最初のif文により，表示と非表示を切り替えられる
    % 表示する場合はif(1)にする．
    % 表示しない場合はif(0)にする．
    if(1)
        % 青色.でプロット
        plot(real(reciveSymbol), imag(reciveSymbol), 'b.');
        pmax = ceil(max([abs(real(reciveSymbol)), imag(reciveSymbol), 2]));
        xlim([-pmax pmax]); ylim([-pmax pmax]);
        set(gca,'XTick', -pmax:pmax); % 横軸の目盛を設定
        set(gca,'YTick', -pmax:pmax); % 縦軸の目盛を設定
        xlabel('I');
        ylabel('Q');
        grid on;
        % 雑音が無い場合のコンスタレーションを赤色*で重ね書き
        hold on;
        plot(real(s), imag(s), 'r*');
        hold off;
        axis square
    end
    % おまけ ここまで


    %%%%%%%%%%%%%%%%
    % 受信器ここから
    %
    d = zeros(1, length(s)); % 距離尺度格納用の配列確保(MATLAB tips)
    demodBit = zeros(1, nDataBits); % 受信ビット格納用の配列確保(MATLAB tips)
    for n=1:nDataBits/k
        % 距離尺度を求める
        for m=1:length(s)
            d_rs = reciveSymbol(n) - s(m); % 差を算出
            d(m) = d_rs * conj(d_rs); % 複素共役を掛けることで差の2乗を算出
        end
        [dummy_max, mr(n)] = min(d); % 最小距離を求め送信されたシンボルmrを決定
        if (mr(n) == 1)
            demodBit(n*k-3:n*k) = [0 0 0 0];
        elseif (mr(n) == 2)
            demodBit(n*k-3:n*k) = [0 0 0 1];
        elseif (mr(n) == 3)
            demodBit(n*k-3:n*k) = [0 0 1 0];
        elseif (mr(n) == 4)
            demodBit(n*k-3:n*k) = [0 0 1 1];
        elseif (mr(n) == 5)
            demodBit(n*k-3:n*k) = [0 1 0 0];
        elseif (mr(n) == 6)
            demodBit(n*k-3:n*k) = [0 1 0 1];
        elseif (mr(n) == 7)
            demodBit(n*k-3:n*k) = [0 1 1 0];
        elseif (mr(n) == 8)
            demodBit(n*k-3:n*k) = [0 1 1 1];
        elseif (mr(n) == 9)
            demodBit(n*k-3:n*k) = [1 0 0 0];
        elseif (mr(n) == 10)
            demodBit(n*k-3:n*k) = [1 0 0 1];
        elseif (mr(n) == 11)
            demodBit(n*k-3:n*k) = [1 0 1 0];
        elseif (mr(n) == 12)
            demodBit(n*k-3:n*k) = [1 0 1 1];
        elseif (mr(n) == 13)
            demodBit(n*k-3:n*k) = [1 1 0 0];
        elseif (mr(n) == 14)
            demodBit(n*k-3:n*k) = [1 1 0 1];
        elseif (mr(n) == 15)
            demodBit(n*k-3:n*k) = [1 1 1 0];
        elseif (mr(n) == 16)
            demodBit(n*k-3:n*k) = [1 1 1 1];
        end
    end
    %
    % 受信器ここまで
    %%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%
    % ビット誤り率 BER の計算ここから
    ber = sum(abs(dataBit - demodBit)) ./ nDataBits;
    % ここまで
    %%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%
    % シンボル誤り率 SER の計算ここから
    ser = 0;
    for n=1:nDataBits/k
        if(ms(n) ~= mr(n))
            ser = ser + 1;
        end
    end
    ser = ser ./ (nDataBits/k);
    % ここまで
    %%%%%%%%%%%%%%%%%%%%
end
% ローカル関数 sim_16qam の定義ここまで

% Programming by K.Asahi 2015
