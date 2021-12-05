% �����e�J�����V�~�����[�V�����ɂ��4DPSK��BER�Z�o
% 190441091, �i�d�r�� 
% 
% ������
% ���̃v���O�����ł͈ȉ��̃t�@���N�V����m�t�@�C�����g�p���܂��D
% bin_data_src.m, noise_src.m

% �y���Ӂz�֐��� ex10_2 �́Cm�t�@�C���̃t�@�C�����O�ƈ�v�����邱��
function ex10_2()
    clc;
    clear all;

    %%%%%%%%%%%%%%%%
    % �V�~�����[�V�����p�����[�^
    nDataBits = 1000000; % �S���M�r�b�g��[bit]
    % EbN0_dB = 8; % Eb/N0[dB]
    %%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%
    % �V�~�����[�V������

    max_dB = 16;
    EbN0_dB_range = 0:max_dB;
    dqpsk_ber = zeros(1, length(EbN0_dB_range));
    
    % qpsk_ber_theory = zeros(1, length(EbN0_dB_range));
    qpsk_ber = zeros(1, length(EbN0_dB_range));
    qpsk_ser = zeros(1, length(EbN0_dB_range));

    % �u�O���͈̔́v�Ƃ͉����H�H
    
    index=1;
    for EbN0_dB=EbN0_dB_range
        % �V�~�����[�V�������s
        dqpsk_ber(index) = sim_4DPSK(nDataBits, EbN0_dB);
        
        % �V�~�����[�V�������s
        [qpsk_ber(index), qpsk_ser(index)] = sim_QPSK(nDataBits, EbN0_dB);
        
        % ���ʂ̕\��
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
    % �ȉ��Cplot�����₷�����邽�߂ׂ̍����ݒ�
    set(gca, 'FontName', font_name); % �t�H���g�̎�ނ��w��
    set(gca, 'FontSize', font_size); % �t�H���g�̑傫�����w��
    set(gca,'XTick', 0:max_dB); % �c���̖ڐ���ݒ�
    yt = -7:1:0; % �c���̎w����
    yt = 10.^yt; % �c���ڐ���̐��l
    set(gca,'YTick', yt); % �c���̖ڐ���ݒ�
    xlim([0 max_dB]); % �\�����鉡���͈̔�
    ylim([10^-7 10^-0]); % �\������c���͈̔�
    xlabel('Eb/N0 [dB]'); % �������x��
    ylabel('BER'); % �c�����x��
    legend('4dpsk','dpsk'); % �}��
    grid on; % �O���b�h�̕\��
    
    % �����܂�
    %%%%%%%%%%%%%%%%%%%%

end
% function ex10_2() �����܂�

% ���[�J���֐� enc_DPSK �̒�`��������
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
% ���[�J���֐� enc_DPSK �̒�`�����܂�

% ���[�J���֐� sim_4DPSK �̒�`��������
function ber = sim_4DPSK(nDataBits, EbN0_dB)
    %%%%%%%%%%%%%%%%%%%%%%%%
    % QPSK �M���g�`�p�����[�^
    mapping = [0 1 3 2];
    s = [ 1,  j, -1, -j]; % s00, s01, s11, s10
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
    % ����������
    ms = enc_DPSK(M, mapping, dataBit); % ms:���M�V���{���ԍ��̔z��
    % �V���{���ԍ�����Ή�����g�`��
    for n=1:nDataBits/k
        transmitSymbol(n) = s(ms(n)+1);
    end
    %
    % ���M�킱���܂�
    %%%%%%%%%%%%%%%%


    %%%%%%%%%%%%%%%%
    % �ʐM�H��������
    %
    % AWGN�̔���
    noisePower = 10 ^ -(EbN0_dB/10);
    noise = noise_src( nDataBits/k, noisePower/k ); % noise_src.m���Ăяo��

    % AWGN�ʐM�H
    reciveSymbol = transmitSymbol + noise;
    %
    % �ʐM�H�����܂�
    %%%%%%%%%%%%%%%%


    % (���܂�)��M�V���{���̃R���X�^���[�V������\��
    % �ŏ���if���ɂ��C�\���Ɣ�\����؂�ւ�����
    % �\������ꍇ��if(1)�ɂ���D
    % �\�����Ȃ��ꍇ��if(0)�ɂ���D
    if(0)
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
    c = zeros(1, length(s)); % ���֒l�i�[�p�̔z��m��(MATLAB tips)
    demodBit = zeros(1, nDataBits); % ��M�r�b�g�i�[�p�̔z��m��(MATLAB tips)
    prev_theta = 0;
    for n=1:nDataBits/k
        % ��M�M���̈ʑ����Z�o
        theta = mod(angle(reciveSymbol(n)), 2*pi);
        % �ʑ������Z�o
        delta_theta = mod(theta - prev_theta, 2*pi);
        prev_theta = theta;
        
        % �ʑ����ɑΉ�����r�b�g�𕜒�
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
    % ��M�킱���܂�
    %%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%
    % �r�b�g��藦 BER �̌v�Z��������
    ber = sum(abs(dataBit - demodBit)) ./ nDataBits;
    % �����܂�
    %%%%%%%%%%%%%%%%%%%%

end
% ���[�J���֐� sim_4DPSK �̒�`�����܂�

% ���[�J���֐� sim_QPSK �̒�`��������
function [ber, ser] = sim_QPSK(nDataBits, EbN0_dB)
    %%%%%%%%%%%%%%%%%%%%%%%%
    % QPSK �M���g�`�p�����[�^
    s = [ 1,  j, -j, -1]; % s00, s01, s10, s11
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
    for n=1:nDataBits/k
        % bit=>symbol  mapping
        ms(n) = (dataBit(n*k-1) + dataBit(n*k)*k) + 1;
        transmitSymbol(n) = s(ms(n));
    end
    %
    % ���M�킱���܂�
    %%%%%%%%%%%%%%%%


    %%%%%%%%%%%%%%%%
    % �ʐM�H��������
    %
    % AWGN�̔���
    noisePower = 10 ^ -(EbN0_dB/10);
    noise = noise_src( nDataBits/k, noisePower/k ); % noise_src.m���Ăяo��

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
    c = zeros(1, length(s)); % ���֒l�i�[�p�̔z��m��(MATLAB tips)
    demodBit = zeros(1, nDataBits); % ��M�r�b�g�i�[�p�̔z��m��(MATLAB tips)
    for n=1:nDataBits/k
        % ���ւ����߂�
        for m=1:length(s)
            c(m) = real( reciveSymbol(n) * conj(s(m)) ); % ���f�������|���邱�Ƃő��ւ��Z�o
        end
        [dummy_max, mr(n)] = max(c); % �ő�l�����ߑ��M���ꂽ�V���{��mr������
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
% ���[�J���֐� sim_QPSK �̒�`�����܂�


% Programming by K.Asahi 2015
