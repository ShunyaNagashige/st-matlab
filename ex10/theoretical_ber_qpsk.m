% QPSKのBERの厳密な理論値
function ber = theoretical_ber_qpsk(EbN0_tv)
ber = erfc(sqrt(EbN0_tv)) / 2;
