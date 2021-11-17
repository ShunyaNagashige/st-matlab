% OOK BER�Z�o�V�~�����[�V����
% 190441091�C�i�d�r�� 
%
% ������
% ���̃v���O�����ł͈ȉ��̃t�@���N�V����m�t�@�C�����g�p���܂��D
% bin_data_src.m, noise_src.m

% �y���Ӂz�֐��� ex6_4 �́Cm�t�@�C���̃t�@�C�����O�ƈ�v�����邱��
function ex6_4()
    clc;
    clear all;

    %%%%%%%%%%%%%%%%
    % �V�~�����[�V�����p�����[�^
    nDataBits = 1000000; % �S���M�r�b�g��[bit]
    %%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%
    % �V�~�����[�V������
    
    k = 1;
    max = 16;
    EbN0_dB_range = 0:2:max;
    ber = zeros(1, max / 2 + 1);
    
    %EbN0_dB��0~16[dB]�̊Ԃ�2[dB]���݂ɕω�������    
    for EbN0_dB = EbN0_dB_range
        % �V�~�����[�V�������s
        ber(k) = ook_sim(nDataBits, EbN0_dB);

        % ���ʂ̕\��
        disp(['Simulated BER = ' num2str(ber(k)) ' in Eb/N0 = ' num2str(EbN0_dB) '[dB]']);
        
        k = k + 1;
    end
    
    % BER���O���t�Ƀv���b�g����
    figure(2);
    semilogy(EbN0_dB_range, ber, '-ob' , 'linewidth', 2); % ����t�C�c��x�Ńv���b�g����
    xlabel('Eb/N0 [dB]'); % �������x��
    ylabel('BER'); % �c�����x��
    grid on; % �O���b�h����ǉ�
   
    % ���_�l�̎Z�o�C�v���b�g��������
    
    % ���ʂ��i�[����z����m�ۂ���
    ook_ber_theory = zeros(1, max / 2 + 1);

    % �z��Y�����������iMATLAB�̔z��́C1�͂��܂�j
    idx = 1;
    % �w�肳�ꂽEb/N0�͈̔͂ŌJ��Ԃ�
    for EbN0_dB = EbN0_dB_range
        % dB����^�l�Ɋ��Z
        EbN0_tv = 10 ^ (EbN0_dB/10);
        % �e�����̗��_BER���Z�o
        ook_ber_theory(idx) = erfc(sqrt(EbN0_tv/4)) / 2; % OOK
        % �z��̓Y����1�i�߂�
        idx = idx + 1;
    end
    
    hold on;
    semilogy(EbN0_dB_range, ook_ber_theory, '--*r' , 'linewidth', 2); % ����t�C�c��x�Ńv���b�g����
    
    % ���_�l�̎Z�o�C�v���b�g�����܂�
    
    % �ȉ��Cplot�����₷�����邽�߂ׂ̍����ݒ�
    font_name = 'Times New Roman';
    font_size = 20;
    
    set(gca, 'FontName', font_name); % �t�H���g�̎�ނ��w��
    set(gca, 'FontSize', font_size); % �t�H���g�̑傫�����w��
    set(gca,'XTick', 0:2:16); % �c���̖ڐ���ݒ�
    yt = -6:1:0; % �c���̎w����
    yt = 10.^yt; % �c���ڐ���̐��l
    set(gca,'YTick', yt); % �c���̖ڐ���ݒ�
    xlim([0 16]); % �\�����鉡���͈̔�
    ylim([10^-6 10^0]); % �\������c���͈̔�
    xlabel('Eb/N0 [dB]'); % �������x��
    ylabel('BER'); % �c�����x��

    
    % �����܂�
    %%%%%%%%%%%%%%%%%%%%

end
% function ex6_4() �����܂�

% ���[�J���֐� ook_sim �̒�`��������
function ber = ook_sim(nDataBits, EbN0_dB)
    %%%%%%%%%%%%%%%%%%%%%%%%
    % OOK �M���g�`�p�����[�^
    s0 = 0;
    s1 = 1;
    threshold_alpha = (s0 + s1) / 2; % ��M��̔���臒l
    % �����܂�
    %%%%%%%%%%%%%%%%%%%%%%%%


    %%%%%%%%%%%%%%%%
    % ���M�킱������
    %
    % �f�[�^�r�b�g�̐���
    dataBit = bin_data_src( nDataBits ); % bin_data_src.m���Ăяo��
    transmitSymbol = zeros(1, nDataBits); % ���M�g�`�i�[�p�̔z��m��(MATLAB tips)
    % �f�[�^�r�b�g����Ή�����M���g�`�ւ̊��蓖��(�ϒ�)
    % bit=>symbol  {0 => s0=0, 1 => s1=1}
    for k=1:nDataBits
        if (dataBit(k) == 0)
            transmitSymbol(k) = s0;
        else
            transmitSymbol(k) = s1;
        end
    end
    % (���܂�)��Lfor����MATLAB���ɏ����ƈȉ�
    % transmitSymbol(dataBit==0) = s0;
    % transmitSymbol(dataBit==1) = s1;
    % ���܂� �����܂�
    %
    % ���M�킱���܂�
    %%%%%%%%%%%%%%%%


    %%%%%%%%%%%%%%%%
    % �ʐM�H��������
    %
    % AWGN�̔���
    noisePower = 10 ^ -(EbN0_dB/10);
    noise = noise_src( nDataBits, noisePower ); % noise_src.m���Ăяo��

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
        plot([real(s0) real(s1)], [imag(s0) imag(s1)], 'r*');
        hold off;
        axis square
    end
    % ���܂� �����܂�


    %%%%%%%%%%%%%%%%
    % ��M�킱������
    %
    % �M���g�`����Ή�����f�[�^�r�b�g�֖߂�(����)
    realSymbol = real(reciveSymbol); % OOK�Ȃ̂Ŏ����𒊏o
    demodBit = zeros(1, nDataBits); % ��M�r�b�g�i�[�p�̔z��m��(MATLAB tips)
    for k=1:nDataBits
        if (realSymbol(k) < threshold_alpha)
            demodBit(k) = 0;
        else
            demodBit(k) = 1;
        end
    end
    % (���܂�)��Lfor����MATLAB���ɏ����ƈȉ�
    % demodBit(realSymbol<threshold_alpha) = 0;
    % demodBit(realSymbol>=threshold_alpha) = 1;
    % ���܂� �����܂�
    %
    % ��M�킱���܂�
    %%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%
    % BER �̌v�Z��������
    ber = sum(abs(dataBit - demodBit)) ./ nDataBits;
    % �����܂�
    %%%%%%%%%%%%%%%%%%%%
end
% ���[�J���֐� ook_sim �̒�`�����܂�

% Programming by K.Asahi 2015
