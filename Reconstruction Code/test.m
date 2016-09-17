% 
testscandata = Scandata('Arcelor_M1700_gf1.txt','Arcelor_M1700_gf2.txt');
% testscandata = Scandata('Arcelor_M1700_CROPPED_gf1.txt','Arcelor_M1700_CROPPED_gf2.txt');
% testscandata = Scandata('Arcelor_M1700_TWINCROPPED_gf1.txt','Arcelor_M1700_TWINCROPPED_gf2.txt');
% testscandata = Scandata('A27_X500_Arcelor_gf1.txt','A27_X500_Arcelor_gf2.txt');

% testscandata = Scandata('A5b_010_1um_gf1.txt','A5b_010_1um_gf2.txt');
% 
% testscandata = Scandata('Majid_400_7_Lower_NOC_GD_p8boundTol_gf1.txt','Majid_400_7_Lower_NOC_GD_p8boundTol_gf2.txt');
% 
testgrainmap = Grainmap(testscandata);
testgrainmap.find_neighbors;
testreconstructor = Reconstructor(testgrainmap,'KS',[0]);
testreconstructor.find_triplets;
testreconstructor.find_trios;
testreconstructor.grow_clusters_from_trios;
testreconstructor.place_clusters;
% testreconstructor.fill_unalloc_regions_by_expansion(100);
% testreconstructor.place_clusters;
