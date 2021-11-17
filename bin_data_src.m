function bin_data = bin_data_src( length )
%bin_data_src 指定された長さの0と1のデータ系列を作成
%   確率0.5で0と1を長さlength個発生する
uni_rand = rand(1, length);
bin_data = zeros(1, length); % 配列をあらかじめ確保しておく（MATLABのtips）
for k=1:length
    if (uni_rand(k) < 0.5)
        bin_data(k) = 0;
    else
        bin_data(k) = 1;
    end
end

