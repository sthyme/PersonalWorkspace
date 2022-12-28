setBatchMode(true); //doesn't show images, much faster
run("Bio-Formats Macro Extensions");
cmdoptions = getArgument;
print (cmdoptions);
cmdoptionssplit = split(cmdoptions," ");
FilePrefix = cmdoptionssplit[0]
target_dir = cmdoptionssplit[1]
ysize = cmdoptionssplit[2]

list = getFileList(target_dir);
list = Array.sort(list);

largestnum = 0;
for (i=0; i<list.length; i++) {
	test = split(list[i],".");
	if (test.length > 1) {
	if (test[1] == "czi") {
		Prefix = split(list[i],"(");
		number = split(Prefix[1],")");
		numbertile2 = parseInt(number[0]);
		//print (test[0]);
		//print (Prefix[1]);
		//print (numbertile2);
		//print (largestnum);
		if (numbertile2 > largestnum) {
			largestnum = numbertile2;
		}
		}
		}
}
offset = (largestnum + 1) / 2

Prefix = split(FilePrefix,"(");
number = split(Prefix[1],")");
numbertile = parseInt(number[0]);
numbertile2 = parseInt(number[0]) + parseInt(offset);
tile2name = Prefix[0] + "(" + toString(numbertile2) + ")" + number[1]
	source_file = target_dir + FilePrefix;
	source_file_2 = target_dir + tile2name;
	saveNamelist = split(source_file, ".");
	saveName0 = saveNamelist[0];
	newnum = numbertile+1
	saveName1 = Prefix[0] + "_" + toString(newnum);
	//print (saveName1);
	saveNametest02 = toString(saveName1) + "_02.nrrd";
	saveNametest01 = toString(saveName1) + "_01.nrrd";
	saveNametest03 = toString(saveName1) + "_03.nrrd";
	//print (saveNametest02);
	//print (saveNametest01);
	//print (saveNametest03);
	run("Bio-Formats Importer", "open='"+ source_file + "' color_mode=Default view=Hyperstack stack_order=XYCZT");
	getVoxelSize(width, height, depth, unit);
	rename(""+FilePrefix);
	run("Split Channels");

	selectWindow("C1-"+FilePrefix);
	rename("red");
	selectWindow("C2-"+FilePrefix);
	rename("green");
	if (isOpen("C3-"+FilePrefix)){
		selectWindow("C3-"+FilePrefix);
		rename("blue");
		run("Merge Channels...", "c1=red c2=green c3=blue create");
	}
	else {
		run("Merge Channels...", "c1=red c2=green create");
	}
	selectWindow("Composite");
	rename("Tile1");
	run("Bio-Formats Importer", "open='"+ source_file_2 + "' color_mode=Default view=Hyperstack stack_order=XYCZT");
	rename(""+tile2name); //
	run("Split Channels");
	selectWindow("C1-"+tile2name);
	rename("red");
	selectWindow("C2-"+tile2name);
	rename("green");
	if (isOpen("C3-"+tile2name)){
		selectWindow("C3-"+tile2name);
		rename("blue");
		run("Merge Channels...", "c1=red c2=green c3=blue create");
	}
	else {
		run("Merge Channels...", "c1=red c2=green create");
	}
	selectWindow("Composite");
	rename("Tile2");
	run("Pairwise stitching", "first_image='"+"Tile1"+"' second_image='"+"Tile2"+"' fusion_method=[Linear Blending] check_peaks=5 x=0.0000 y=ysize z=0 registration_channel_image_1=[Average all channels] registration_channel_image_2=[Average all channels]");
	setVoxelSize(width, height, depth, unit);
	rename("StitchedTiles"); //
	run("Split Channels");
	if (isOpen("C3-StitchedTiles")){
		selectWindow("C1-StitchedTiles");
		saveName = toString(saveName0) + "_03.nrrd";
		run("Nrrd ... ", "nrrd=[saveName]");
	}
	else {
		selectWindow("C1-StitchedTiles");
		saveName = toString(saveName0) + "_02.nrrd";
		run("Nrrd ... ", "nrrd=[saveName]");
	}
	if (isOpen("C3-StitchedTiles")){
		selectWindow("C2-StitchedTiles");
		saveName = toString(saveName0) + "_02.nrrd";
		run("Nrrd ... ", "nrrd=[saveName]");
	}
	else {
		selectWindow("C2-StitchedTiles");
		saveName = toString(saveName0) + "_01.nrrd";
		run("Nrrd ... ", "nrrd=[saveName]");
	}
	if (isOpen("C3-StitchedTiles")){
		selectWindow("C3-StitchedTiles");
		saveName = toString(saveName0) + "_01.nrrd";
		run("Nrrd ... ", "nrrd=[saveName]");
	}
