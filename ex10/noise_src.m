function c_noise = noise_src( length, power )
%noise_src �w�肳�ꂽ�����C�p���[�̕��f���F�K�E�X�G���n����쐬
%   �w�肳�ꂽ����length�C�^�l�p���[power[W]�̕��f���F�K�E�X�G���n����쐬����
n_rand1 = randn(1, length); % �W���K�E�X���z���� 1
n_rand2 = randn(1, length); % �W���K�E�X���z���� 2
j = sqrt(-1); % �����P��
c_noise = (n_rand1 + j * n_rand2) .* sqrt(power / 2);
