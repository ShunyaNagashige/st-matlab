% 190441091 永重俊弥

function ex11()
    clc;
    clear all;
    
    sample_per_symbol = 4;
    
    % csvファイルの読み込み
    m = csvread('data.csv');

    demodBit = zeros(1, length(m) / 4); % 受信ビット格納用の配列確保
    y = zeros(1, length(m) / 4 / 4); % 受信ビットの16進表現を格納用の配列確保
    
    % psi1 = sqrt(0.5 * 10.^6) * cos(0.5 * 10.^6 * pi * t)
    
    % mの1番目から4番目の値を取り出してr_tへ
    for n=1:length(m) / sample_per_symbol
        r_t = m((n * 4) - 3:n * 4);
        
        % M値信号伝送ならば，Mを代入する
        s_num = 2;
        
        s0 = zeros(1, 2);
        
        s0(1, 1) = 1;
        s0(1, 2) = 0;
            
        s1 = zeros(1, 2);
        
        s1(1, 1) = -1;
        s1(1, 2) = 0;
        
        % s = [s0 s1];
        
        r = zeros(1, 2);
        
        for k=1:length(r_t)
            t = (n * 4 - 4 + k) * (10.^(-6))
            
            % キャリアを求める
            psi = [sqrt(0.5 * 10.^6) * cos(0.5 * 10.^6 * pi * t), -sqrt(0.5 * 10.^6) * sin(0.5 * 10.^6 * pi * t)];
            
            % 相関値を求める
            r(1, 1) = r(1, 1) + r_t(k) * psi(1);
            r(1, 2) = r(1, 2) + r_t(k) * psi(2);
        end
        
        c = zeros(1, 2); % 相関値格納用の配列確保
        
        % 相関距離尺度を求める
        c(1) = r * s0';
        c(2) = r * s1';
        
        [dummy_max, mr] = max(c); % 最大値を求め送信されたシンボルmrを決定
        
        if (mr == 1)
            demodBit(n) = 1;
        end
        if (mr == 2)
            demodBit(n) = 0;
        end
    end
    
    D = "0b";
    
    for n=1:length(m) / 4
        D = append(D, num2str(demodBit(n)));
    end
    
    hexStr = dec2hex(D);
    
    % 結果の表示
    % disp(['y = ' dec2hex(demodBit)]);
    
    