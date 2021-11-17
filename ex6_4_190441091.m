% OOK BER算出シミュレーション
% 190441091，永重俊弥 
%
% ＊注意
% このプログラムでは以下のファンクションmファイルを使用します．
% bin_data_src.m, noise_src.m

% 【注意】関数名 ex6_4 は，mファイルのファイル名前と一致させること
function ex6_4()
    clc;
    clear all;

    %%%%%%%%%%%%%%%%
    % シミュレーションパラメータ
    nDataBits = 1000000; % 全送信ビット数[bit]
    %%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%
    % シミュレーション部
    
    k = 1;
    max = 16;
    EbN0_dB_range = 0:2:max;
    ber = zeros(1, max / 2 + 1);
    
    %EbN0_dBを0~16[dB]の間で2[dB]刻みに変化させる    
    for EbN0_dB = EbN0_dB_range
        % シミュレーション実行
        ber(k) = ook_sim(nDataBits, EbN0_dB);

        % 結果の表示
        disp(['Simulated BER = ' num2str(ber(k)) ' in Eb/N0 = ' num2str(EbN0_dB) '[dB]']);
        
        k = k + 1;
    end
    
    % BERをグラフにプロットする
    figure(2);
    semilogy(EbN0_dB_range, ber, '-ob' , 'linewidth', 2); % 横軸t，縦軸xでプロットする
    xlabel('Eb/N0 [dB]'); % 横軸ラベル
    ylabel('BER'); % 縦軸ラベル
    grid on; % グリッド線を追加
   
    % 理論値の算出，プロットここから
    
    % 結果を格納する配列を確保する
    ook_ber_theory = zeros(1, max / 2 + 1);

    % 配列添字を初期化（MATLABの配列は，1はじまり）
    idx = 1;
    % 指定されたEb/N0の範囲で繰り返す
    for EbN0_dB = EbN0_dB_range
        % dBから真値に換算
        EbN0_tv = 10 ^ (EbN0_dB/10);
        % 各方式の理論BERを算出
        ook_ber_theory(idx) = erfc(sqrt(EbN0_tv/4)) / 2; % OOK
        % 配列の添字を1つ進める
        idx = idx + 1;
    end
    
    hold on;
    semilogy(EbN0_dB_range, ook_ber_theory, '--*r' , 'linewidth', 2); % 横軸t，縦軸xでプロットする
    
    % 理論値の算出，プロットここまで
    
    % 以下，plotを見やすくするための細かい設定
    font_name = 'Times New Roman';
    font_size = 20;
    
    set(gca, 'FontName', font_name); % フォントの種類を指定
    set(gca, 'FontSize', font_size); % フォントの大きさを指定
    set(gca,'XTick', 0:2:16); % 縦軸の目盛を設定
    yt = -6:1:0; % 縦軸の指数部
    yt = 10.^yt; % 縦軸目盛りの数値
    set(gca,'YTick', yt); % 縦軸の目盛を設定
    xlim([0 16]); % 表示する横軸の範囲
    ylim([10^-6 10^0]); % 表示する縦軸の範囲
    xlabel('Eb/N0 [dB]'); % 横軸ラベル
    ylabel('BER'); % 縦軸ラベル

    
    % ここまで
    %%%%%%%%%%%%%%%%%%%%

end
% function ex6_4() ここまで

% ローカル関数 ook_sim の定義ここから
function ber = ook_sim(nDataBits, EbN0_dB)
    %%%%%%%%%%%%%%%%%%%%%%%%
    % OOK 信号波形パラメータ
    s0 = 0;
    s1 = 1;
    threshold_alpha = (s0 + s1) / 2; % 受信器の判定閾値
    % ここまで
    %%%%%%%%%%%%%%%%%%%%%%%%


    %%%%%%%%%%%%%%%%
    % 送信器ここから
    %
    % データビットの生成
    dataBit = bin_data_src( nDataBits ); % bin_data_src.mを呼び出す
    transmitSymbol = zeros(1, nDataBits); % 送信波形格納用の配列確保(MATLAB tips)
    % データビットから対応する信号波形への割り当て(変調)
    % bit=>symbol  {0 => s0=0, 1 => s1=1}
    for k=1:nDataBits
        if (dataBit(k) == 0)
            transmitSymbol(k) = s0;
        else
            transmitSymbol(k) = s1;
        end
    end
    % (おまけ)上記for文をMATLAB風に書くと以下
    % transmitSymbol(dataBit==0) = s0;
    % transmitSymbol(dataBit==1) = s1;
    % おまけ ここまで
    %
    % 送信器ここまで
    %%%%%%%%%%%%%%%%


    %%%%%%%%%%%%%%%%
    % 通信路ここから
    %
    % AWGNの発生
    noisePower = 10 ^ -(EbN0_dB/10);
    noise = noise_src( nDataBits, noisePower ); % noise_src.mを呼び出す

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
        plot([real(s0) real(s1)], [imag(s0) imag(s1)], 'r*');
        hold off;
        axis square
    end
    % おまけ ここまで


    %%%%%%%%%%%%%%%%
    % 受信器ここから
    %
    % 信号波形から対応するデータビットへ戻す(復調)
    realSymbol = real(reciveSymbol); % OOKなので実部を抽出
    demodBit = zeros(1, nDataBits); % 受信ビット格納用の配列確保(MATLAB tips)
    for k=1:nDataBits
        if (realSymbol(k) < threshold_alpha)
            demodBit(k) = 0;
        else
            demodBit(k) = 1;
        end
    end
    % (おまけ)上記for文をMATLAB風に書くと以下
    % demodBit(realSymbol<threshold_alpha) = 0;
    % demodBit(realSymbol>=threshold_alpha) = 1;
    % おまけ ここまで
    %
    % 受信器ここまで
    %%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%
    % BER の計算ここから
    ber = sum(abs(dataBit - demodBit)) ./ nDataBits;
    % ここまで
    %%%%%%%%%%%%%%%%%%%%
end
% ローカル関数 ook_sim の定義ここまで

% Programming by K.Asahi 2015
