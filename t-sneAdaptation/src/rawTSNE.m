%Developed by Pablo Vicente-Munuera

load('Matrices_cc.mat')

load('PCA2/PCA_CONT_100_CONT_120_seleccion_cc_81.mat')
cc_2_TSNE(CONT_100, CONT_120, 'CONT_100', 'CONT_120', indice_cc_seleccionadas)
label=[ones(1, size(CONT_100, 1)), 2*ones(1, size(CONT_120, 1))];
h = figure;
tsne([CONT_100; CONT_120], label);
saveas(h,['rawTSNE_CONT_100_CONT_120.jpg'])
close all


load('PCA2/PCA_CONT_100_G93A_100_seleccion_cc_81.mat')
h = figure;
cc_2_TSNE(CONT_100, G93A_100, 'CONT_100', 'G93A_100', indice_cc_seleccionadas)
label=[ones(1, size(CONT_100, 1)), 2*ones(1, size(G93A_100, 1))];
h = figure;
tsne([CONT_100; G93A_100], label);
saveas(h,['rawTSNE_CONT_100_G93A_100.jpg'])
close all

load('PCA2/PCA_CONT_100_WT_100_seleccion_cc_81.mat')
h = figure;
cc_2_TSNE(CONT_100, WT_100, 'CONT_100', 'WT_100', indice_cc_seleccionadas)
label=[ones(1, size(CONT_100, 1)), 2*ones(1, size(WT_100, 1))];
h = figure;
tsne([CONT_100; WT_100], label);
saveas(h,['rawTSNE_CONT_100_WT_100.jpg'])
close all

load('PCA2/PCA_CONT_120_G93A_120_seleccion_cc_81.mat')
h = figure;
cc_2_TSNE(CONT_120, G93A_120, 'CONT_120', 'G93A_120', indice_cc_seleccionadas)
close(h)
label=[ones(1, size(CONT_120, 1)), 2*ones(1, size(G93A_120, 1))];
h = figure;
tsne([CONT_120; G93A_120], label);
saveas(h,['rawTSNE_CONT_120_G93A_120.jpg'])
close all

load('PCA2/PCA_CONT_120_WT_120_seleccion_cc_81.mat')
h = figure;
cc_2_TSNE(CONT_120, WT_120, 'CONT_120', 'WT_120', indice_cc_seleccionadas)
label=[ones(1, size(CONT_120, 1)), 2*ones(1, size(WT_120, 1))];
h = figure;
tsne([CONT_120; WT_120], label);
saveas(h,['rawTSNE_CONT_120_WT_120.jpg'])
close all

load('PCA2/PCA_G93A_100_G93A_120_seleccion_cc_81.mat')
h = figure;
cc_2_TSNE(G93A_100, G93A_120, 'G93A_100', 'G93A_120', indice_cc_seleccionadas)
label=[ones(1, size(G93A_100, 1)), 2*ones(1, size(G93A_120, 1))];
h = figure;
tsne([G93A_100; G93A_120], label);
saveas(h,['rawTSNE_G93A_100_G93A_120.jpg'])
close all

load('PCA2/PCA_WT_100_WT_120_seleccion_cc_81.mat')
h = figure;
cc_2_TSNE(WT_100, WT_120, 'WT_100', 'WT_120', indice_cc_seleccionadas)
label=[ones(1, size(WT_100, 1)), 2*ones(1, size(WT_120, 1))];
h = figure;
tsne([WT_100; WT_120], label);
saveas(h,['rawTSNE_WT_100_WT_120.jpg'])
close all

load('PCA2/PCA_WT_120_G93A_120_seleccion_cc_81.mat')
h = figure;
cc_2_TSNE(WT_120, G93A_120, 'WT_120', 'G93A_120', indice_cc_seleccionadas)
label=[ones(1, size(WT_120, 1)), 2*ones(1, size(G93A_120, 1))];
h = figure;
tsne([WT_120; G93A_120], label);
saveas(h,['rawTSNE_WT_120_G93A_120.jpg'])
close all
