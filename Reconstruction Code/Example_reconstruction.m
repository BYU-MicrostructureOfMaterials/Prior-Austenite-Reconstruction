

scandata = Scandata('example_gf1.txt','example_gf2.txt');

grainmap = Grainmap(scandata);
imshow(grainmap.grainIPFmap.IPFimage);
grainmap.find_neighbors;


reconstructor = Reconstructor(grainmap,'KS',[0]); %The zero indicates the phase ID number you want to reconstruct, as defined by OIM

reconstructor.find_triplets;
reconstructor.find_trios;
reconstructor.grow_clusters_from_trios;

reconstructor.filter_clusters(12*pi/180,5*pi/180);

reconstructor.handle_reconstruction_overlap;

reconstructor.genReconstructedIPFmap('filled');


