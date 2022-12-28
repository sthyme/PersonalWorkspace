offset = 1; // use this to add to the 'fish number' output in the file name

setBatchMode(true); //doesn't show images, much faster
run("Bio-Formats Macro Extensions");

cmdoptions = getArgument;
print (cmdoptions);
cmdoptionssplit = split(cmdoptions," ");
FilePrefix = cmdoptionssplit[0]
target_dir = cmdoptionssplit[1]
ysize = cmdoptionssplit[2]
print (FilePrefix);
print (target_dir);
print (ysize);
source_file = target_dir + FilePrefix;
print (source_file);
saveNamelist = split(source_file, ".");
saveName0 = saveNamelist[0];
print (saveName0);
run("Bio-Formats Importer", "open='"+ source_file + "' color_mode=Default view=Hyperstack stack_order=XYCZT");
run("Split Channels");
selectWindow("C1-"+FilePrefix);
saveName = saveName0 + "_01.nrrd";
run("Nrrd ... ", "nrrd=[saveName]");
close();
selectWindow("C2-"+FilePrefix);
saveName = saveName0 + "_02.nrrd";
run("Nrrd ... ", "nrrd=[saveName]");
close();
selectWindow("C3-"+FilePrefix);
saveName = saveName0 + "_03.nrrd";
run("Nrrd ... ", "nrrd=[saveName]");
close();
run("Collect Garbage");
