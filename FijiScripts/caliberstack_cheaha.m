setBatchMode(true); //doesn't show images, much faster
run("Bio-Formats Macro Extensions");
//fiji -macro ../FijiScripts/caliberstack_cheaha.m "/data/project/thymelab/calibertests/stack1/ 488/images/col0000.tif"
///data/project/thymelab/calibertests/stack1/layer000/488/images
// /data/project/thymelab/calibertests/stack1/
// /488/images/col000$SLURM_ARRAY_TASK_ID.tif
setOption("ExpandableArrays", true);

// This is excessive because I only have on argument, but keeping logic in case I add argument later
cmdoptions = getArgument;
print (cmdoptions);
cmdoptionssplit = split(cmdoptions," ");
dir1 = cmdoptionssplit[0]
dir2 = cmdoptionssplit[1]


list = getFileList(dir1);
list = Array.sort(list);
dirlist = newArray;
count=0
for (i=0; i<list.length; i++){
	if (startsWith(list[i], "layer"))
		count = count+1;
		name = dir1 + list[i] + dir2;
		print (name);
		//col = split(name, "/");
		//colname = col[col.length-1];
	//	print(colname);
//		if (i > 0) {
//			colname = split(colname, ".")[0] + "-" + i + ".tif"
//		}
	//	print(colname);
	//	selectImage(name);
		dirlist[i] = name;
}
print (count);

run("Stack From List...", dirlist);

//run("Images to Stack", "name=Stack title=[] use");
saveName = dir1 + "test" + ".nrrd";
run("Nrrd ... ", "nrrd='" +saveName+ "'");

//FilePrefix = split(dir,"/");
//layer=FilePrefix.length-3;
//print(FilePrefix.length-3);
//print(FilePrefix[layer]);
//FilePrefix2 = split(FilePrefix[layer],"r");

//run("Grid/Collection stitching", "type=[Grid: snake by rows] order=[Right & Up] grid_size_x=" +count+" grid_size_y=1 tile_overlap=5 first_file_index_i=0 directory="+dir+ " file_names=col000{i}.tif output_textfile_name=output fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap computation_parameters=[Save memory (but be slower)] image_output=[Fuse and display]");
//finalname="col_" + FilePrefix2[1]
//saveName = dir + finalname + ".nrrd";
//run("Nrrd ... ", "nrrd='" +saveName+ "'");
