setBatchMode(true); //doesn't show images, much faster
run("Bio-Formats Macro Extensions");
//fiji -macro /data/project/thymelab/FijiScripts/caliberstackandsplit_cheaha.m "/data/project/thymelab/stack1/layer000/488/images/"

cmdoptions = getArgument;
print (cmdoptions);
cmdoptionssplit = split(cmdoptions," ");

dir = cmdoptionssplit[0]

list = getFileList(dir);
list = Array.sort(list);
count=0
for (i=0; i<list.length; i++){
	if (endsWith(list[i], "tif"))
		count = count+1;
}
print (count);

//cmdoptionssplit = split(cmdoptions," ");
//string2 = replace(dir, "layer", "$");
//FilePrefix = split(string2,"$");
FilePrefix = split(dir,"/");
//FilePrefix = split(dir,"/layer")[1];
layer=FilePrefix.length-3;
print(FilePrefix.length-3);
print(FilePrefix[layer])
FilePrefix2 = split(FilePrefix[layer],"r")//split(FilePrefix[1],"/");
//print(FilePrefix2[1]);

run("Grid/Collection stitching", "type=[Grid: snake by rows] order=[Right & Up] grid_size_x=" +count+" grid_size_y=1 tile_overlap=5 first_file_index_i=0 directory="+dir+ " file_names=col000{i}.tif output_textfile_name=output fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap computation_parameters=[Save memory (but be slower)] image_output=[Fuse and display]");
finalname="col_" + FilePrefix2[1]
saveName = dir + finalname + ".nrrd";
run("Nrrd ... ", "nrrd='" +saveName+ "'");
//run("Grid/Collection stitching", "type=[Grid: snake by rows] order=[Right & Up] grid_size_x=4 grid_size_y=1 tile_overlap=5 first_file_index_i=0 directory="+dir+ " file_names=col000{i}.tif output_textfile_name=output fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap computation_parameters=[Save memory (but be slower)] image_output=[Write to disk] output_directory="+dir);

//	saveName = dir + finalname + ".nrrd";
//	run("Nrrd ... ", "nrrd='" +saveName+ "'");
//	while (nImages > 0){
//		close();
////		}
//	run("Collect Garbage");
