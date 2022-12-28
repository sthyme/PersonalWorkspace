offset = 1; // use this to add to the 'fish number' output in the file name

setBatchMode(true); //doesn't show images, much faster
run("Bio-Formats Macro Extensions");
//fiji -macro /data/project/thymelab/FijiScripts/caliberstackandsplit_cheaha.m "/data/project/thymelab/stack1/layer000/488/images/"
///layer000/488/images/
//col0000.tif  col0001.tif  col0002.tif  col0003.tif  
//xvfb-run -d fiji -macro /data/project/thymelab/sthyme/imaging_fromschierlab/chrna7sbno1promoutkmt2eprom/chrna7_cleanredo/cmdline_lsmStitchAndPrepareCZIsForWarping_cluster.m "chrna7_2019_05_13__13_36_20__p$SLURM_ARRAY_TASK_ID.lsm /data/project/thymelab/sthyme/imaging_fromschierlab/chrna7sbno1promoutkmt2eprom/chrna7_cleanredo/  486.4"
//xvfb-run -d fiji -macro /data/project/thymelab/sthyme/imaging_fromschierlab/chrna7sbno1promoutkmt2eprom/chrna7_cleanredo/cmdline_lsmStitchAndPrepareCZIsForWarping_cluster.m "/stack1/layer000/488/images/"
//module load fiji/2.0.0pre-10.lua
//xvfb-run -d fiji -macro /data/project/thymelab/FijiScripts/caliberstackandsplit_cheaha.m "/stack1/layer000/488/images/"

cmdoptions = getArgument;
print (cmdoptions);
cmdoptionssplit = split(cmdoptions," ");

dir = cmdoptionssplit[0]
//FilePrefix = cmdoptionssplit[0]
//target_dir = cmdoptionssplit[1]
//ysize = cmdoptionssplit[2]
//print (FilePrefix);
//print (target_dir);
//print (ysize);

//filestring = File.openAsString(cmdoptions);
//rows = split(filestring,"\n");

//FilePrefix_line = split(rows[0],"=");
//target_dir_line = split(rows[1],"=");
//size_line = split(rows[2],"=");

//FilePrefix = FilePrefix_line[1];
//target_dir = target_dir_line[1];
//ysize = size_line[1];



run("Grid/Collection stitching", "type=[Grid: snake by rows] order=[Right & Up] grid_size_x=4 grid_size_y=1 tile_overlap=5 first_file_index_i=0 directory=/Users/sthyme/stack1/layer000/488/images file_names=col000{i}.tif output_textfile_name=output fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap computation_parameters=[Save memory (but be slower)] image_output=[Fuse and display]");


list = getFileList(dir);
list = Array.sort(list);
finalname = ""
run("Open...", "path='"+dir+list[0]+"'");
rename("StitchedTiles0");
for (i=1; i<(list.length); i++) {
	//print(i);
	print (list[i]);
	//source_file = target_dir + FilePrefix +"\("+i+"\)\.czi";
	//print (source_file);
//}

	//source_file = target_dir + list[i];
	//i = 0;
	//source_file = dir + "col000";
	//print (source_file);
	//saveNamelist = split(source_file, ".");
	//saveName0 = saveNamelist[0];
	//print (saveName0);
	run("Open...", "path='"+dir+list[i]+"'");
	//run("Bio-Formats Importer", "open='"+ dir+list[0] +"' color_mode=Default view=Hyperstack stack_order=XYCZT  series_1");
	rename(list[i]);
	//run("Open...", "path='"+dir+list[i+1]+"'");
	//run("Bio-Formats Importer", "open='"+ dir+list[1] +"' color_mode=Default view=Hyperstack stack_order=XYCZT  series_1");
	//rename(list[i+1]);
	//run("Open...", "path='"+dir+list[2]+"'")
	//rename(list[2]);
	//run("Open...", "path='"+dir+list[3]+"'")
	//rename(list[3]);
	//rename("Tile1");

	//run("Bio-Formats Importer", "open='"+ source_file +"' color_mode=Default view=Hyperstack stack_order=XYCZT series_2");
	//rename("Tile2");
	print("StitchedTiles"+i-1);
	print("StitchedTiles"+i);
	//getVoxelSize(width, height, depth, unit);
	selectWindow("StitchedTiles"+i-1);
	run("Pairwise stitching", "first_image='"+"StitchedTiles"+i-1+"' second_image='"+list[i]+"' fusion_method=[Linear Blending] fused_image=StitchedTiles"+i+" check_peaks=5 compute_overlap x=0.0000 y=0.000");
	saveName = dir + "StitchedTiles"+i + ".nrrd";
	run("Nrrd ... ", "nrrd='" +saveName+ "'");
//	run("Pairwise stitching", "first_image='"+"StitchedTiles"+"' second_image='"+list[2]+"' fusion_method=[Linear Blending] fused_image=StitchedTiles2 check_peaks=5 compute_overlap x=0.0000 y=0.000");
//	run("Pairwise stitching", "first_image='"+"StitchedTiles2"+"' second_image='"+list[3]+"' fusion_method=[Linear Blending] fused_image=StitchedTiles3 check_peaks=5 compute_overlap x=0.0000 y=0.000");
//	finalname="StitchedTiles" + i;
}
//
//	saveName = dir + finalname + ".nrrd";
//	run("Nrrd ... ", "nrrd='" +saveName+ "'");
//	while (nImages > 0){
//		close();
////		}
//	run("Collect Garbage");
