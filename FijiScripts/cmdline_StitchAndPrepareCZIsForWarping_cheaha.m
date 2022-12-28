setBatchMode(true); //doesn't show images, much faster
run("Bio-Formats Macro Extensions");

cmdoptions = getArgument;
print (cmdoptions);
cmdoptionssplit = split(cmdoptions," ");
FilePrefix = cmdoptionssplit[0];
//way26-01(12).czi
FilePrefix2 = split(FilePrefix, "(");
FilePrefix3 = split(FilePrefix2[1], ")");
prefix = FilePrefix2[0];
idnumber = FilePrefix3[0];
target_dir = cmdoptionssplit[1];
ysize = cmdoptionssplit[2];
print (FilePrefix);
print (target_dir);
print (ysize);

source_file = target_dir + FilePrefix;
print (source_file);
saveName0 = target_dir + prefix + "_" + idnumber;
print (saveName0);

Ext.setId(source_file); // for some reason the .czi files saved individually during acquisition have multiple image series, all of which are blank except the last one. So we need to figure out how many series there are in each .czi file
//Ext.getSeriesCount(NumSeries);

run("Bio-Formats Importer", "open='"+ source_file +"' color_mode=Default color_mode=Default open_files rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT  series_1");
//rename("Tile1");
//run("Bio-Formats Importer", "open='"+ source_file +"' color_mode=Default view=Hyperstack stack_order=XYCZT series_2");
//rename("Tile2");
//getVoxelSize(width, height, depth, unit);
//run("Pairwise stitching", "first_image='"+"Tile1"+"' second_image='"+"Tile2"+"' fusion_method=[Linear Blending] check_peaks=5 x=0.0000 y=" +ysize+ " z=0 registration_channel_image_1=[Average all channels] registration_channel_image_2=[Average all channels]");
//setVoxelSize(width, height, depth, unit);
rename("StitchedTiles");
run("Split Channels");
//selectWindow("C1-StitchedTiles");
//run("Nrrd ... ", "nrrd='" +saveName0+ "'");
//close();
//run("Collect Garbage");
//
selectWindow("C2-StitchedTiles");
saveName = saveName0 + "_01.nrrd";
run("Nrrd ... ", "nrrd='" +saveName+ "'");
close();
selectWindow("C1-StitchedTiles");
saveName = saveName0 + "_02.nrrd";
run("Nrrd ... ", "nrrd='" +saveName+ "'");
close();
run("Collect Garbage");
