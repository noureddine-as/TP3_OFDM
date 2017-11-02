% ce script récupère le résultat de matlab pour deux sous bande différentes
% à partir des deux fichiers corr_symb1.txt et corr_symb2.txt
% en plus on récupère le résultat de modelsim pour la bande simulée

% Le nombre de point est n = 3000 qui peut être changé

n = 3000;
fid = fopen('D:\TPs\TP_FPGA_PDSP\PDSP\TP3_OFDM\corr_symbol_out1.txt','r');

%%fid = fopen('G:\fich\CORR_SYMB.txt', 'r');
[corr_symbole,n]= fscanf(fid,'%6d\n',n);
fclose(fid);
plot(corr_symbole);
title('résultat: corrélation symbole');
grid;

