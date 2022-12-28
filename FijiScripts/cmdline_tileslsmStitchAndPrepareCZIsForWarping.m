//FilePrefix = "140923Fut9bHet_fish"; // name that will be assigned to the output file


offset = 0; // use this to add to the 'fish number' output in the file name
// set to 0 if no offset required

setBatchMode(true); //doesn't show images, much faster
run("Bio-Formats Macro Extensions");

//source_file = File.openDialog("Choose the CZI File");
//target_dir = getDirectory("Target Directory");

cmdoptions = getArgument;
filestring = File.openAsString(cmdoptions);
rows = split(filestring,"\n");

FilePrefix_line = split(rows[0],"=");
target_dir_line = split(rows[1],"=");
source_dir_line = split(rows[2],"=");

FilePrefix = FilePrefix_line[1];
target_dir = target_dir_line[1];
source_dir = source_dir_line[1];

//target_dir = getDirectory("current");

//source_dir = getDirectory("Source Directory");
//target_dir = getDirectory("Target Directory");

list = getFileList(source_dir);
//list = Array.sort(list);


list = Array.sort(list);
j=0
  for (i=0; i<list.length; i++) {

  ImageName = source_dir + list[i];

	run("Bio-Formats Importer", "open='"+ ImageName +"' color_mode=Default view=Hyperstack stack_order=XYCZT  series_1");

	rename("Tile1");

	ImageName2 = source_dir + list[i+1];
	run("Bio-Formats Importer", "open='"+ ImageName2 +"' color_mode=Default view=Hyperstack stack_order=XYCZT series_2");

	rename("Tile2");

	getVoxelSize(width, height, depth, unit);

//	run("Pairwise stitching", "first_image='"+"Tile1"+"' second_image='"+"Tile2"+"' fusion_method=[Linear Blending] check_peaks=5 x=0.0000 y=665 z=0 registration_channel_image_1=[Average all channels] registration_channel_image_2=[Average all channels]");

//filenumber = 2;
//for (i=1; i<=filenumber; i++) {
//	source_file = target_dir + FilePrefix +"\("+i+"\)\.czi";
//	print (source_file);


//	Ext.setId(source_file); // for some reason the .czi files saved individually during acquisition have multiple image series, all of which are blank except the last one. So we need to figure out how many series there are in each .czi file
//	Ext.getSeriesCount(NumSeries);

//	NumFish = NumSeries/2;

//	run("Bio-Formats Importer", "open='"+ source_file +"' color_mode=Default view=Hyperstack stack_order=XYCZT series_"+toString(NumFish));
//	rename("Tile1");

	//run("Bio-Formats Importer", "open='"+ source_file +"' color_mode=Default view=Hyperstack stack_order=XYCZT series_"+toString(NumSeries));
//	rename("Tile2");


	//getVoxelSize(width, height, depth, unit);

	run("Pairwise stitching", "first_image='"+"Tile1"+"' second_image='"+"Tile2"+"' fusion_method=[Linear Blending] check_peaks=5 x=0.0000 y=486.0 z=0 registration_channel_image_1=[Average all channels] registration_channel_image_2=[Average all channels]");

	setVoxelSize(width, height, depth, unit);


  rename("StitchedTiles"); //
	run("Split Channels");

if (nImages == 6) { // four channels plus the original two images
		selectWindow("C4-StitchedTiles"); // select the X Channel

		saveName = target_dir + FilePrefix + toString(j+offset+1) + "_04.nrrd"; // assign Y suffix number

		run("Nrrd ... ", "nrrd=[saveName]");
		close();

		selectWindow("C3-StitchedTiles"); // select the X Channel

		saveName = target_dir + FilePrefix + toString(j+offset+1) + "_01.nrrd"; // assign Y suffix number

		run("Nrrd ... ", "nrrd=[saveName]");
		close();

		selectWindow("C2-StitchedTiles");

		saveName = target_dir + FilePrefix + toString(j+offset+1) + "_02.nrrd";

		run("Nrrd ... ", "nrrd=[saveName]");
		close();

		selectWindow("C1-StitchedTiles");

		saveName = target_dir + FilePrefix + toString(j+offset+1) + "_03.nrrd";

		run("Nrrd ... ", "nrrd=[saveName]");
		close();
		}
	else if (nImages == 5) { // three channels plus the original two OIBs

		selectWindow("C3-StitchedTiles"); // select the X Channel

		saveName = target_dir + FilePrefix + toString(j+offset+1) + "_01.nrrd"; // assign Y suffix number

		run("Nrrd ... ", "nrrd=[saveName]");
		close();

		selectWindow("C2-StitchedTiles");

		saveName = target_dir + FilePrefix + toString(j+offset+1) + "_02.nrrd";

		run("Nrrd ... ", "nrrd=[saveName]");
		close();

		selectWindow("C1-StitchedTiles");

		saveName = target_dir + FilePrefix + toString(j+offset+1) + "_03.nrrd";

		run("Nrrd ... ", "nrrd=[saveName]");
		close();
		}
	else if (nImages == 4){

		selectWindow("C2-StitchedTiles");

		saveName = target_dir + FilePrefix + toString(j+offset+1) + "_01.nrrd";

		run("Nrrd ... ", "nrrd=[saveName]");
		close();

		selectWindow("C1-StitchedTiles");

		saveName = target_dir + FilePrefix + toString(j+offset+1) + "_02.nrrd";

		run("Nrrd ... ", "nrrd=[saveName]");
		close();



	}
	else{
		exit("ERROR: not a 2, 3 or 4 channel image");
	}
	i = i + 1;
	j++;

	while (nImages > 0){
		close();
		}
	run("Collect Garbage");

  }
//setBatchMode(false);
