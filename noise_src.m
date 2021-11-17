function c_noise = noise_src( length, power )
%noise_src 指定された長さ，パワーの複素白色ガウス雑音系列を作成
%   指定された長さlength，真値パワーpower[W]の複素白色ガウス雑音系列を作成する
n_rand1 = randn(1, length); % 標準ガウス分布乱数 1
n_rand2 = randn(1, length); % 標準ガウス分布乱数 2
j = sqrt(-1); % 虚数単位
c_noise = (n_rand1 + j * n_rand2) .* sqrt(power / 2);
