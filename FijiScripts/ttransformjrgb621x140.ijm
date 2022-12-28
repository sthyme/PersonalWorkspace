source_dir = "/n/schierfs2/projects/ImageRegistration/data/sthyme/tmapfilesforwebsite";
target_dir = "/n/schierfs2/projects/ImageRegistration/data/sthyme/tmapfilesforwebsitergb";
list = getFileList(source_dir);
//print ("test");
for (i=0; i<list.length; i++) {
	//print ("test2");
	print (list[i]);
	//print ("test3");
	open(source_dir + "/" + list[i]);
//	print ("test4");
	run("8-bit");
	//run("RGB Color", "slices");
	//run("TransformJ Scale", "x-factor=2.07 y-factor=2.070692194403535 z-factor=1.725 interpolation=Linear");
	//selectWindow(list[i]);
	//close();
	//PROBNEEDrun("RGB Color", "slices");
	//run("TransformJ Scale", "x-factor=2.07 y-factor=2.070692194403535 z-factor=1.725 interpolation=Linear");
	saveAs("Tiff", target_dir + "/" + list[i]);
	//run("RGB Color", "slices");
	close();
	//selectWindow(list[i]);
	//close();
}
