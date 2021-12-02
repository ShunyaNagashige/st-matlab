% 16QAM‚ÌBER‚ÌŒµ–§‚È—˜_’l
function ber = theoretical_ber_16qam(EbN0_tv)
gam = sqrt( 2 * EbN0_tv / 5 );
ber = (3*erfc(gam) + 2*erfc(3*gam) - erfc(5*gam)) / 8;
