setBatchMode(true); //doesn't show images, much faster
dir = "/data/project/thymelab/calibertests/"
count = 4
run("Grid/Collection stitching", "type=[Grid: snake by rows] order=[Right & Up] grid_size_x=" +count+" grid_size_y=1 tile_overlap=5 first_file_index_i=0 directory="+dir+ " file_names=col000{i}_stack.nrrd output_textfile_name=output fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap computation_parameters=[Save memory (but be slower)] image_output=[Fuse and display]");
saveName = "./fullstack.nrrd";
run("Nrrd ... ", "nrrd='" +saveName+ "'");
