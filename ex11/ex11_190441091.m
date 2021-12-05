% 190441091 永重俊弥

function ex11()
    clc;
    clear all;
    
    sample_per_symbol = 4;
    
    % csvファイルの読み込み
    m = csvread('data.csv');

    demodBit = zeros(1, length(m)); % 受信ビット格納用の配列確保
    y = zeros(1, length(m) / 4); % 受信ビットの16進表現を格納用の配列確保
    
    % psi1 = sqrt(0.5 * 10.^6) * cos(0.5 * 10.^6 * pi * t)
    
    % mの1番目から4番目の値を取り出してr_tへ
    for n=1:length(m) / sample_per_symbol
        r_t = m((n * 4) - 3:n * 4);
        
        % M値信号伝送ならば，Mを代入する
        s_num = 2;
        
        s0 = zeros(sample_per_symbol, 2);
        
        for k=1:sample_per_symbol
            s0(k, 1) = 1;
            s0(k, 2) = 0;
        end
            
        s1 = zeros(sample_per_symbol, 2);
        
        for k=1:sample_per_symbol
            s1(k, 1) = -1;
            s1(k, 2) = 0;
        end
        
        s = [s0 s1];
        
        r = zeros(sample_per_symbol, 2);
        
        for k=1:length(r_t)
            t = (n + k - 1) * (10.^(-6));
            
            % キャリアを求める
            psi = [sqrt(0.5 * 10.^6) * cos(0.5 * 10.^6 * pi * t), -sqrt(0.5 * 10.^6) * sin(0.5 * 10.^6 * pi * t)];
            
            % 相関値を求める
            r(k, 1) = r_t(k) * psi(1);
            r(k, 2) = r_t(k) * psi(2);
        end
        
        c = zeros(1, s_num); % 相関値格納用の配列確保
        % mr = zeros(1, nDataBits/k); % 受信シンボル番号格納用の配列確保
        
        % 内積(距離)を求める
        for k=1:s_num
            c(k) = sum(sum(r.*s(k), 2));
        end
        
        [dummy_max, mr] = max(c); % 最大値を求め送信されたシンボルmrを決定
        
        if (mr == 1)
            demodBit(n) = 0;
        end
        if (mr == 2)
            demodBit(n) = 1;
        end
    end
    
    for n=1:length(m) / 4
        disp(['hex: ' demodBit((n * 4) - 3:n * 4)]);
        y(n) = dec2hex(demodBit((n * 4) - 3:n * 4));
    end
    
    % 結果の表示
    disp(['y = ' y]);
    
    