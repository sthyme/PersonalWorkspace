//offset = 1; // use this to add to the 'fish number' output in the file name

setBatchMode(true); //doesn't show images, much faster
run("Bio-Formats Macro Extensions");

cmdoptions = getArgument;
print (cmdoptions);
cmdoptionssplit = split(cmdoptions," ");
FilePrefix = cmdoptionssplit[0]
target_dir = cmdoptionssplit[1]
ysize = cmdoptionssplit[2]
offset= cmdoptionssplit[3]
print (FilePrefix);
print (target_dir);
print (ysize);

//filestring = File.openAsString(cmdoptions);
//rows = split(filestring,"\n");

//FilePrefix_line = split(rows[0],"=");
//target_dir_line = split(rows[1],"=");
//size_line = split(rows[2],"=");

//FilePrefix = FilePrefix_line[1];
//target_dir = target_dir_line[1];
//ysize = size_line[1];


	Prefix = split(FilePrefix,"(");
	//print (Prefix[0]);
	//print (Prefix[1]);
	number = split(Prefix[1],")");
	numbertile2 = parseInt(number[0]) + parseInt(offset);
	//print (numbertile2);
	tile2name = Prefix[0] + "(" + toString(numbertile2) + ")" + number[1]
	//print (tile2number);

	//source_file = target_dir + list[i];
	//i = 0;
	source_file = target_dir + FilePrefix;
	source_file_2 = target_dir + tile2name;
	print (source_file);
	saveNamelist = split(source_file, ".");
	saveName0 = saveNamelist[0];
	run("Bio-Formats Importer", "open='"+ source_file + "' color_mode=Default view=Hyperstack stack_order=XYCZT");
	rename(""+FilePrefix); //
	run("Split Channels");
	if (isOpen("C3-"+FilePrefix)){
		selectWindow("C3-"+FilePrefix);
		saveName = saveName0 + "_03.nrrd";
		run("Nrrd ... ", "nrrd=[saveName]"); }
	selectWindow("C2-"+FilePrefix);
	saveName = saveName0 + "_01.nrrd";
	run("Nrrd ... ", "nrrd=[saveName]");
	selectWindow("C1-"+FilePrefix);
	saveName = saveName0 + "_02.nrrd";
	run("Nrrd ... ", "nrrd=[saveName]");

	run("Bio-Formats Importer", "open='"+ source_file_2 + "' color_mode=Default view=Hyperstack stack_order=XYCZT");
	rename(""+tile2name); //
	run("Split Channels");
	if (isOpen("C3-"+tile2name)){
		selectWindow("C3-"+tile2name);
		saveName = saveName0 + "t2" + "_03.nrrd";
		run("Nrrd ... ", "nrrd=[saveName]"); }
	selectWindow("C2-"+tile2name);
	saveName = saveName0 + "t2" + "_01.nrrd";
	run("Nrrd ... ", "nrrd=[saveName]");
	selectWindow("C1-"+tile2name);
	saveName = saveName0 + "t2" + "_02.nrrd";
	run("Nrrd ... ", "nrrd=[saveName]");
//	c1name1 = "C1-" + FilePrefix
//	c1name2 = "C1-" + tile2name


	selectWindow("C1-"+FilePrefix);
//	saveName = saveName0 + "TESTTEST" + "_01.nrrd";
//	run("Nrrd ... ", "nrrd=[saveName]");
	rename("Tile1");

	selectWindow("C1-"+tile2name);
//	saveName = saveName0 + "TEST" + "_01.nrrd";
//	run("Nrrd ... ", "nrrd=[saveName]");
	rename("Tile2");

	run("Pairwise stitching", "first_image='"+"Tile1"+"' second_image='"+"Tile2"+"' fusion_method=[Linear Blending] check_peaks=5 x=0.0000 y=ysize z=0 registration_channel_image_1=[Average all channels] registration_channel_image_2=[Average all channels]");
	rename("StitchedTiles"); //
	saveName = saveName0 + "_s.nrrd";
	run("Nrrd ... ", "nrrd=[saveName]");

//	names = newArray(nImages);
//	ids = newArray(nImages);
//	print ("MADE IT");
//	print (nImages);
//	for (i=0; i < ids.length; i++){
 // 	selectImage(i+1);
//		ids[i] = getImageID()
//		names[i] = getTitle();
//		print(ids[i] + " = " + names[i]);
//	}
//	saveName = saveName0 + "_test.nrrd";
//	run("Nrrd ... ", "nrrd=[saveName]");

//	run("Split Channels");
	//if (nImages == 4) { // three channels
	//	selectWindow("C3-Tile1"); // select the X Channel
	//	saveName = saveName0 + "_01.nrrd";
	//	run("Nrrd ... ", "nrrd=[saveName]");
	//	close();
	//	selectWindow("C2-Tile1");
//		saveName = saveName0 + "_02.nrrd";
//		run("Nrrd ... ", "nrrd=[saveName]");
//		close();
//		selectWindow("C1-Tile1");
//		saveName = saveName0 + "_03.nrrd";
//		run("Nrrd ... ", "nrrd=[saveName]");
//		close();
//		}
//	else if (nImages == 3){
	//	selectWindow("C2-Tile1");
	//	saveName = saveName0 + "_01.nrrd";
	//	run("Nrrd ... ", "nrrd=[saveName]");
	//	close();
	//	selectWindow("C1-Tile1");
	//	saveName = saveName0 + "_02.nrrd";
	//	run("Nrrd ... ", "nrrd=[saveName]");
	//	close();
//	}
//	else{
//		exit("ERROR: not a 2, 3 or 4 channel image");
//	}
	//saveName = saveName0 + "_t1.nrrd";
	//run("Nrrd ... ", "nrrd=[saveName]");
	run("Bio-Formats Importer", "open='"+ source_file_2 + "' color_mode=Default view=Hyperstack stack_order=XYCZT");
	rename("Tile2");
	//saveName = saveName0 + "_04.nrrd";
	//saveName = saveName0 + "_t2.lsm";
	//run("LSM ... ", "lsm=[saveName]");
	//rename(""+FilePrefix);

//	run("Bio-Formats Importer", "open='"+ source_file +"' color_mode=Default view=Hyperstack stack_order=XYCZT series_2");
//	rename("Tile2");

	getVoxelSize(width, height, depth, unit);

	run("Pairwise stitching", "first_image='"+""+Tile1+"' second_image='"+"Tile2"+"' fusion_method=[Linear Blending] check_peaks=5 x=0.0000 y=ysize z=0 registration_channel_image_1=[Average all channels] registration_channel_image_2=[Average all channels]");
	rename("StitchedTiles"); //
	saveName = saveName0 + "_s.nrrd";
	run("Nrrd ... ", "nrrd=[saveName]");

	//print ("STITCHED");
	setVoxelSize(width, height, depth, unit);

	//print Stitched;

  //rename(""+FilePrefix); //
	//print ("TEST");
	//print ("C2-" + FilePrefix);
//	run("Split Channels");
//	selectWindow("C1-"+FilePrefix);
//	saveName = saveName0 + "_02.nrrd";
//	run("Nrrd ... ", "nrrd=[saveName]");
//	selectWindow("C2-"+FilePrefix);
//	saveName = saveName0 + "_01.nrrd";
//	run("Nrrd ... ", "nrrd=[saveName]");
	//saveName = saveName0 + "_02.nrrd";
	//run("Nrrd ... ", "nrrd=[saveName]");
	//saveName0 = split(source_file, ".")[0];
	//print (saveName0);

	rename("StitchedTiles"); //
	//run("Split Channels");
	//selectWindow("C1-"+StitchedTiles);
	selectWindow(StitchedTiles);
	saveName = saveName0 + "_02.nrrd";
	run("Nrrd ... ", "nrrd=[saveName]");
	selectWindow("C2-"+StitchedTiles);
	saveName = saveName0 + "_01.nrrd";
	run("Nrrd ... ", "nrrd=[saveName]");
	saveName = saveName0 + "_02.nrrd";
	run("Nrrd ... ", "nrrd=[saveName]");

	//saveName0 = split(source_file, ".")[0];
	//print (saveName0);

if (nImages == 6) { // four channels plus the original two images
		selectWindow("C4-StitchedTiles"); // select the X Channel

		//saveName = target_dir + FilePrefix + toString(i+offset) + "_04.nrrd"; // assign Y suffix number
		saveName = saveName0 + "_04.nrrd";

		run("Nrrd ... ", "nrrd=[saveName]");
		close();

		selectWindow("C3-StitchedTiles"); // select the X Channel

		//saveName = target_dir + FilePrefix + toString(i+offset) + "_01.nrrd"; // assign Y suffix number
		saveName = saveName0 + "_01.nrrd";

		run("Nrrd ... ", "nrrd=[saveName]");
		close();

		selectWindow("C2-StitchedTiles");

		//saveName = target_dir + FilePrefix + toString(i+offset) + "_02.nrrd";
		saveName = saveName0 + "_02.nrrd";

		run("Nrrd ... ", "nrrd=[saveName]");
		close();

		selectWindow("C1-StitchedTiles");

		//saveName = target_dir + FilePrefix + toString(i+offset) + "_03.nrrd";
		saveName = saveName0 + "_03.nrrd";

		run("Nrrd ... ", "nrrd=[saveName]");
		close();
		}
	else if (nImages == 5) { // three channels plus the original two OIBs

		selectWindow("C3-StitchedTiles"); // select the X Channel

		//saveName = target_dir + FilePrefix + toString(i+offset) + "_01.nrrd"; // assign Y suffix number
		saveName = saveName0 + "_01.nrrd";

		run("Nrrd ... ", "nrrd=[saveName]");
		close();

		selectWindow("C2-StitchedTiles");

		//saveName = target_dir + FilePrefix + toString(i+offset) + "_02.nrrd";
		saveName = saveName0 + "_02.nrrd";

		run("Nrrd ... ", "nrrd=[saveName]");
		close();

		selectWindow("C1-StitchedTiles");

		//saveName = target_dir + FilePrefix + toString(i+offset) + "_03.nrrd";
		saveName = saveName0 + "_03.nrrd";

		run("Nrrd ... ", "nrrd=[saveName]");
		close();
		}
	else if (nImages == 4){

		selectWindow("C2-StitchedTiles");

		//saveName = target_dir + FilePrefix + toString(i+offset) + "_01.nrrd";
		saveName = saveName0 + "_01.nrrd";

		run("Nrrd ... ", "nrrd=[saveName]");
		close();

		selectWindow("C1-StitchedTiles");

		//saveName = target_dir + FilePrefix + toString(i+offset) + "_02.nrrd";
		saveName = saveName0 + "_02.nrrd";

		run("Nrrd ... ", "nrrd=[saveName]");
		close();



	}
	else{
		exit("ERROR: not a 2, 3 or 4 channel image");
	}

	while (nImages > 0){
		close();
		}
	run("Collect Garbage");

//setBatchMode(false);
