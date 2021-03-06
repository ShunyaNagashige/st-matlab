% モンテカルロシミュレーションによる4DPSKのBER算出
% 190441091, 永重俊弥 
% 
% ＊注意
% このプログラムでは以下のファンクションmファイルを使用します．
% bin_data_src.m, noise_src.m

% 【注意】関数名 ex10_2 は，mファイルのファイル名前と一致させること
function ex10_2()
    clc;
    clear all;

    %%%%%%%%%%%%%%%%
    % シミュレーションパラメータ
    nDataBits = 1000000; % 全送信ビット数[bit]
    % EbN0_dB = 8; % Eb/N0[dB]
    %%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%
    % シミュレーション部

    max_dB = 16;
    EbN0_dB_range = 0:max_dB;
    dqpsk_ber = zeros(1, length(EbN0_dB_range));
    
    % qpsk_ber_theory = zeros(1, length(EbN0_dB_range));
    qpsk_ber = zeros(1, length(EbN0_dB_range));
    qpsk_ser = zeros(1, length(EbN0_dB_range));

    % 「前項の範囲」とは何か？？
    
    index=1;
    for EbN0_dB=EbN0_dB_range
        % シミュレーション実行
        dqpsk_ber(index) = sim_4DPSK(nDataBits, EbN0_dB);
        
        % シミュレーション実行
        [qpsk_ber(index), qpsk_ser(index)] = sim_QPSK(nDataBits, EbN0_dB);
        
        % 結果の表示
        disp(['Simulated BER = ' num2str(dqpsk_ber(index)) ' in Eb/N0 = ' num2str(EbN0_dB) '[dB]']); 
        
        index = index + 1;
    end

    font_name = 'Times New Roman';
    font_size = 20;
    
    figure(2);
    semilogy(EbN0_dB_range, dqpsk_ber, 'b-', 'linewidth', 2);
    hold on;
    semilogy(EbN0_dB_range, qpsk_ber, 'r--', 'linewidth', 2);
    hold off;
    % 以下，plotを見やすくするための細かい設定
    set(gca, 'FontName', font_name); % フォントの種類を指定
    set(gca, 'FontSize', font_size); % フォントの大きさを指定
    set(gca,'XTick', 0:max_dB); % 縦軸の目盛を設定
    yt = -7:1:0; % 縦軸の指数部
    yt = 10.^yt; % 縦軸目盛りの数値
    set(gca,'YTick', yt); % 縦軸の目盛を設定
    xlim([0 max_dB]); % 表示する横軸の範囲
    ylim([10^-7 10^-0]); % 表示する縦軸の範囲
    xlabel('Eb/N0 [dB]'); % 横軸ラベル
    ylabel('BER'); % 縦軸ラベル
    legend('4dpsk','dpsk'); % 凡例
    grid on; % グリッドの表示
    
    % ここまで
    %%%%%%%%%%%%%%%%%%%%

end
% function ex10_2() ここまで

% ローカル関数 enc_DPSK の定義ここから
function [enc] = enc_DPSK(M, mapping, bit)
    k = log2(M);
    N = length(bit);
    enc = zeros(1, N/k+1);
    d_index = 0;
    for ni=1:k:N
        index = 0;
        for nj=ni:ni+k-1
            index = 2*index + bit(nj);
        end
        d_index = mod(d_index + mapping(index+1) , M);
        enc((ni+k-1)/k) = d_index;
    end
end
% ローカル関数 enc_DPSK の定義ここまで

% ローカル関数 sim_4DPSK の定義ここから
function ber = sim_4DPSK(nDataBits, EbN0_dB)
    %%%%%%%%%%%%%%%%%%%%%%%%
    % QPSK 信号波形パラメータ
    mapping = [0 1 3 2];
    s = [ 1,  j, -1, -j]; % s00, s01, s11, s10
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
    % 差動符号化
    ms = enc_DPSK(M, mapping, dataBit); % ms:送信シンボル番号の配列
    % シンボル番号から対応する波形へ
    for n=1:nDataBits/k
        transmitSymbol(n) = s(ms(n)+1);
    end
    %
    % 送信器ここまで
    %%%%%%%%%%%%%%%%


    %%%%%%%%%%%%%%%%
    % 通信路ここから
    %
    % AWGNの発生
    noisePower = 10 ^ -(EbN0_dB/10);
    noise = noise_src( nDataBits/k, noisePower/k ); % noise_src.mを呼び出す

    % AWGN通信路
    reciveSymbol = transmitSymbol + noise;
    %
    % 通信路ここまで
    %%%%%%%%%%%%%%%%


    % (おまけ)受信シンボルのコンスタレーションを表示
    % 最初のif文により，表示と非表示を切り替えられる
    % 表示する場合はif(1)にする．
    % 表示しない場合はif(0)にする．
    if(0)
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
    c = zeros(1, length(s)); % 相関値格納用の配列確保(MATLAB tips)
    demodBit = zeros(1, nDataBits); % 受信ビット格納用の配列確保(MATLAB tips)
    prev_theta = 0;
    for n=1:nDataBits/k
        % 受信信号の位相を算出
        theta = mod(angle(reciveSymbol(n)), 2*pi);
        % 位相差を算出
        delta_theta = mod(theta - prev_theta, 2*pi);
        prev_theta = theta;
        
        % 位相差に対応するビットを復調
        if ((delta_theta < pi/4) || (delta_theta > 7*pi/4))
            demodBit(n*k-1) = 0;
            demodBit(n*k)   = 0;
        elseif (delta_theta < 3*pi/4)
            demodBit(n*k-1) = 0;
            demodBit(n*k)   = 1;
        elseif (delta_theta < 5*pi/4)
            demodBit(n*k-1) = 1;
            demodBit(n*k)   = 1;
        else
            demodBit(n*k-1) = 1;
            demodBit(n*k)   = 0;
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

end
% ローカル関数 sim_4DPSK の定義ここまで

% ローカル関数 sim_QPSK の定義ここから
function [ber, ser] = sim_QPSK(nDataBits, EbN0_dB)
    %%%%%%%%%%%%%%%%%%%%%%%%
    % QPSK 信号波形パラメータ
    s = [ 1,  j, -j, -1]; % s00, s01, s10, s11
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
    for n=1:nDataBits/k
        % bit=>symbol  mapping
        ms(n) = (dataBit(n*k-1) + dataBit(n*k)*k) + 1;
        transmitSymbol(n) = s(ms(n));
    end
    %
    % 送信器ここまで
    %%%%%%%%%%%%%%%%


    %%%%%%%%%%%%%%%%
    % 通信路ここから
    %
    % AWGNの発生
    noisePower = 10 ^ -(EbN0_dB/10);
    noise = noise_src( nDataBits/k, noisePower/k ); % noise_src.mを呼び出す

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
    c = zeros(1, length(s)); % 相関値格納用の配列確保(MATLAB tips)
    demodBit = zeros(1, nDataBits); % 受信ビット格納用の配列確保(MATLAB tips)
    for n=1:nDataBits/k
        % 相関を求める
        for m=1:length(s)
            c(m) = real( reciveSymbol(n) * conj(s(m)) ); % 複素共役を掛けることで相関を算出
        end
        [dummy_max, mr(n)] = max(c); % 最大値を求め送信されたシンボルmrを決定
        if (mr(n) == 1)
            demodBit(n*k-1) = 0;
            demodBit(n*k)   = 0;
        end
        if (mr(n) == 2)
            demodBit(n*k-1) = 1;
            demodBit(n*k)   = 0;
        end
        if (mr(n) == 3)
            demodBit(n*k-1) = 0;
            demodBit(n*k)   = 1;
        end
        if (mr(n) == 4)
            demodBit(n*k-1) = 1;
            demodBit(n*k)   = 1;
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
% ローカル関数 sim_QPSK の定義ここまで


% Programming by K.Asahi 2015
