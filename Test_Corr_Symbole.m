% ce script r�cup�re le r�sultat de matlab pour deux sous bande diff�rentes
% � partir des deux fichiers corr_symb1.txt et corr_symb2.txt
% en plus on r�cup�re le r�sultat de modelsim pour la bande simul�e

% Le nombre de point est n = 3000 qui peut �tre chang�

n = 3000;
fid = fopen('D:\TPs\TP_FPGA_PDSP\PDSP\TP3_OFDM\corr_symbol_out1.txt','r');

%%fid = fopen('G:\fich\CORR_SYMB.txt', 'r');
[corr_symbole,n]= fscanf(fid,'%6d\n',n);
fclose(fid);
plot(corr_symbole);
title('r�sultat: corr�lation symbole');
grid;

