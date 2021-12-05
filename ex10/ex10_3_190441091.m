% �����e�J�����V�~�����[�V�����ɂ��QAM��BER�Z�o
% 190441091, �i�d�r��
%
% ������
% ���̃v���O�����ł͈ȉ��̃t�@���N�V����m�t�@�C�����g�p���܂��D
% bin_data_src.m, noise_src.m theoretical_ber_16qam.m

% �y���Ӂz�֐��� ex10_3 �́Cm�t�@�C���̃t�@�C�����O�ƈ�v�����邱��
function ex10_3()
    clc;
    clear all;

    %%%%%%%%%%%%%%%%
    % �V�~�����[�V�����p�����[�^
    nDataBits = 1000000; % �S���M�r�b�g��[bit]
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
    % �V�~�����[�V������
        
    index = 1;
    for EbN0_dB=EbN0_dB_range
        % �V�~�����[�V�������s
        ber_16qam(index) = sim_16qam(nDataBits, EbN0_dB, s);
        ber_16qam_gray(index) = sim_16qam(nDataBits, EbN0_dB, s_gray);
        
        % ���_�l�̎Z�o
        theoretical_ber(index) = theoretical_ber_16qam(10 ^ (EbN0_dB/10));

        % ���ʂ̕\��
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
    % �ȉ��Cplot�����₷�����邽�߂ׂ̍����ݒ�
    set(gca, 'FontName', font_name); % �t�H���g�̎�ނ��w��
    set(gca, 'FontSize', font_size); % �t�H���g�̑傫�����w��
    set(gca,'XTick', 8:14); % �����̖ڐ���ݒ�
    yt = -7:1:-1; % �c���̎w����
    yt = 10.^yt; % �c���ڐ���̐��l
    set(gca,'YTick', yt); % �c���̖ڐ���ݒ�
    xlim([8 14]); % �\�����鉡���͈̔�
    ylim([10^-7 10^-1]); % �\������c���͈̔�
    xlabel('Eb/N0 [dB]'); % �������x��
    ylabel('BER'); % �c�����x��
    legend('actual values', 'gray code actual values', 'theoretical values'); % �}��
    grid on; % �O���b�h�̕\��
    
    % �����܂�
    %%%%%%%%%%%%%%%%%%%%

end
% function ex10_3() �����܂�

% ���[�J���֐� sim_16qam �̒�`��������
function ber = sim_16qam(nDataBits, EbN0_dB, s)
    %%%%%%%%%%%%%%%%%%%%%%%%
    % 16QAM �M���g�`�p�����[�^
    d = 1;
    
    M = length(s);
    k = log2(M);
    % �����܂�
    %%%%%%%%%%%%%%%%%%%%%%%%


    %%%%%%%%%%%%%%%%
    % ���M�킱������
    %
    % �f�[�^�r�b�g�̐���
    dataBit = bin_data_src( nDataBits ); % bin_data_src.m���Ăяo��
    transmitSymbol = zeros(1, nDataBits/k); % ���M�g�`�i�[�p�̔z��m��(MATLAB tips)
    ms = zeros(1, nDataBits/k); % ���M�V���{���ԍ��i�[�p�̔z��m��(MATLAB tips)
    mr = zeros(1, nDataBits/k); % ��M�V���{���ԍ��i�[�p�̔z��m��(MATLAB tips)
    % �f�[�^�r�b�g����Ή�����M���g�`�ւ̊��蓖��(�ϒ�)
    for ni=1:k:nDataBits
        index = 0;
        for nj=ni:ni+k-1
            % 2�������邱�ƂŁC2^x��x�𑝂₷
            index = 2*index + dataBit(nj);
        end
        ms((ni+k-1)/k) = index+1;
        transmitSymbol((ni+k-1)/k) = s(index+1);
    end
    %
    % ���M�킱���܂�
    %%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%
    % �ʐM�H��������
    %
    % AWGN�̔���
    Eav = 10*d^2;
    noisePower = 10 ^ -(EbN0_dB/10);
    noise = noise_src( nDataBits/k, Eav*noisePower/k ); % noise_src.m���Ăяo��

    % AWGN�ʐM�H
    reciveSymbol = transmitSymbol + noise;
    %
    % �ʐM�H�����܂�
    %%%%%%%%%%%%%%%%


    % (���܂�)��M�V���{���̃R���X�^���[�V������\��
    % �ŏ���if���ɂ��C�\���Ɣ�\����؂�ւ�����
    % �\������ꍇ��if(1)�ɂ���D
    % �\�����Ȃ��ꍇ��if(0)�ɂ���D
    if(1)
        % �F.�Ńv���b�g
        plot(real(reciveSymbol), imag(reciveSymbol), 'b.');
        pmax = ceil(max([abs(real(reciveSymbol)), imag(reciveSymbol), 2]));
        xlim([-pmax pmax]); ylim([-pmax pmax]);
        set(gca,'XTick', -pmax:pmax); % �����̖ڐ���ݒ�
        set(gca,'YTick', -pmax:pmax); % �c���̖ڐ���ݒ�
        xlabel('I');
        ylabel('Q');
        grid on;
        % �G���������ꍇ�̃R���X�^���[�V������ԐF*�ŏd�ˏ���
        hold on;
        plot(real(s), imag(s), 'r*');
        hold off;
        axis square
    end
    % ���܂� �����܂�


    %%%%%%%%%%%%%%%%
    % ��M�킱������
    %
    d = zeros(1, length(s)); % �����ړx�i�[�p�̔z��m��(MATLAB tips)
    demodBit = zeros(1, nDataBits); % ��M�r�b�g�i�[�p�̔z��m��(MATLAB tips)
    for n=1:nDataBits/k
        % �����ړx�����߂�
        for m=1:length(s)
            d_rs = reciveSymbol(n) - s(m); % �����Z�o
            d(m) = d_rs * conj(d_rs); % ���f�������|���邱�Ƃō���2����Z�o
        end
        [dummy_max, mr(n)] = min(d); % �ŏ����������ߑ��M���ꂽ�V���{��mr������
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
    % ��M�킱���܂�
    %%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%
    % �r�b�g��藦 BER �̌v�Z��������
    ber = sum(abs(dataBit - demodBit)) ./ nDataBits;
    % �����܂�
    %%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%
    % �V���{����藦 SER �̌v�Z��������
    ser = 0;
    for n=1:nDataBits/k
        if(ms(n) ~= mr(n))
            ser = ser + 1;
        end
    end
    ser = ser ./ (nDataBits/k);
    % �����܂�
    %%%%%%%%%%%%%%%%%%%%
end
% ���[�J���֐� sim_16qam �̒�`�����܂�

% Programming by K.Asahi 2015
