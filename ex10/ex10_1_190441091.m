% �����e�J�����V�~�����[�V�����ɂ��QPSK��BER�Z�o
% 190441091�C�i�d�r�� 
% 
% ������
% ���̃v���O�����ł͈ȉ��̃t�@���N�V����m�t�@�C�����g�p���܂��D
% bin_data_src.m, noise_src.m

% �y���Ӂz�֐��� ex10_1 �́Cm�t�@�C���̃t�@�C�����O�ƈ�v�����邱��
function ex10_1()
    clc;
    clear all;

    %%%%%%%%%%%%%%%%
    % �V�~�����[�V�����p�����[�^
    
    % 8���Ȃ�12[dB]�܂�0�ɂȂ�Ȃ�
    nDataBits = 10000000; % �S���M�r�b�g��[bit]
    %EbN0_dB = 0; % Eb/N0[dB]
    %%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%
    % �V�~�����[�V������
    
    EbN0_dB_range = 0:0;
    qpsk_ber = zeros(1, length(EbN0_dB_range));
    qpsk_ser = zeros(1, length(EbN0_dB_range));
    qpsk_ber_theory = zeros(1, length(EbN0_dB_range));
    
    index = 1;
    for EbN0_dB=EbN0_dB_range
        % �V�~�����[�V�������s
        [qpsk_ber(index), qpsk_ser(index)] = sim_QPSK(nDataBits, EbN0_dB);

        % dB����^�l�Ɋ��Z
        EbN0_tv = 10 ^ (EbN0_dB/10);
        % ���_BER���Z�o
        qpsk_ber_theory(index) = theoretical_ber_qpsk(EbN0_tv); % qpsk
        
        % ���ʂ̕\��
        disp(['Simulated BER = ' num2str(qpsk_ber(EbN0_dB+1)) ', SER = ' num2str(qpsk_ser(EbN0_dB+1)) ' in Eb/N0 = ' num2str(EbN0_dB) '[dB]']);
        
        index = index + 1;
    end
    
    % �����܂�
    %%%%%%%%%%%%%%%%%%%%
    
    font_name = 'Times New Roman';
    font_size = 20;
    
    figure(1);
    semilogy(EbN0_dB_range, qpsk_ber, 'b-', 'linewidth', 2);
    hold on;
    semilogy(EbN0_dB_range, qpsk_ber_theory, 'ro-', 'linewidth', 2);
    hold off;
    % �ȉ��Cplot�����₷�����邽�߂ׂ̍����ݒ�
    set(gca, 'FontName', font_name); % �t�H���g�̎�ނ��w��
    set(gca, 'FontSize', font_size); % �t�H���g�̑傫�����w��
    set(gca,'XTick', 0:14); % �c���̖ڐ���ݒ�
    yt = -13:1:-1; % �c���̎w����
    yt = 10.^yt; % �c���ڐ���̐��l
    set(gca,'YTick', yt); % �c���̖ڐ���ݒ�
    xlim([0 14]); % �\�����鉡���͈̔�
    ylim([10^-13 10^-1]); % �\������c���͈̔�
    xlabel('Eb/N0 [dB]'); % �������x��
    ylabel('BER'); % �c�����x��
    legend('actual values','theoretical values'); % �}��
    grid on; % �O���b�h�̕\��

end
% function ex10_1() �����܂�

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
    for n=1:nDataBits/k
        % ���ւ����߂�
        for m=1:length(s)
            reciveSymbol(n)
            conj(s(m))
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