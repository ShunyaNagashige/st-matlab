function bin_data = bin_data_src( length )
%bin_data_src �w�肳�ꂽ������0��1�̃f�[�^�n����쐬
%   �m��0.5��0��1�𒷂�length��������
uni_rand = rand(1, length);
bin_data = zeros(1, length); % �z������炩���ߊm�ۂ��Ă����iMATLAB��tips�j
for k=1:length
    if (uni_rand(k) < 0.5)
        bin_data(k) = 0;
    else
        bin_data(k) = 1;
    end
end

