vpp = 1.07:0.01:1.16;

neg_firsttry = [68.04 68.09 68.14 68.15 68.16 68.16 68.15 68.12 68.08 68.01];
neg_secondtry = [68.0 68.07 68.10 68.12 68.13 68.13 68.12 68.08 68.05 68.0];
neg_thirdtry = [68.07 68.12 68.16 68.18 68.19 68.19 68.18 68.16 68.11 68.06];

figure
plot(vpp,neg_firsttry,'.-','MarkerSize',12)
hold all
plot(vpp,neg_secondtry,'.-','MarkerSize',12)
plot(vpp,neg_thirdtry,'.-','MarkerSize',12)
hold off
legend('1','2','3')

pos_firsttry = [75.15 75.21 75.26 75.29 75.31 75.32 75.31 75.29 75.25 75.19];
pos_secondtry = [75.22 75.27 75.31 75.34 75.35 75.35 75.33 75.30 75.25 75.2];
pos_thirdtry = [75.21 75.27 75.32 75.35 75.37 75.37 75.36 75.33 75.29 75.24];
pos_fourthtry = [75.27 75.33 75.38 75.40 75.41 75.41 75.39 75.36 75.31 75.26];

figure
plot(vpp,pos_firsttry,'.-','MarkerSize',12)
hold all
plot(vpp,pos_secondtry,'.-','MarkerSize',12)
plot(vpp,pos_thirdtry,'.-','MarkerSize',12)
plot(vpp,pos_fourthtry,'.-','MarkerSize',12)
hold off
legend('1','2','3','4')
