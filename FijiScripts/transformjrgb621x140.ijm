source_dir = "/n/schierfs2/projects/ImageRegistration/data/sthyme/mapfilesforwebsite";
target_dir = "/n/schierfs2/projects/ImageRegistration/data/sthyme/mapfilesforwebsite138rgb";
list = getFileList(source_dir);
for (i=0; i<list.length; i++) {
	print (list[i]);
	open(source_dir + "/" + list[i]);
	run("8-bit");
	//run("TransformJ Scale", "x-factor=2.07 y-factor=2.070692194403535 z-factor=1.725 interpolation=Linear");
	//selectWindow(list[i]);
	//close();
	run("RGB Color", "slices");
	run("TransformJ Scale", "x-factor=2.07 y-factor=2.070692194403535 z-factor=1.725 interpolation=Linear");
	saveAs("Tiff", target_dir + "/" + list[i]);
	close();
	selectWindow(list[i]);
	close();
}
