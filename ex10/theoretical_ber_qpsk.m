% QPSK‚ÌBER‚ÌŒµ–§‚È—˜_’l
function ber = theoretical_ber_qpsk(EbN0_tv)
ber = erfc(sqrt(EbN0_tv)) / 2;
