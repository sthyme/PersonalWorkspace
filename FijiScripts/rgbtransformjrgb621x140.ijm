source_dir = "/n/schierfs2/projects/ImageRegistration/data/sthyme/mapfilesforwebsite138rgb";
target_dir = "/n/schierfs2/projects/ImageRegistration/data/sthyme/rgbmapfilesforwebsite138rgb";
list = getFileList(source_dir);
for (i=0; i<list.length; i++) {
	print (list[i]);
	open(source_dir + "/" + list[i]);
	run("RGB Color", "slices");
	print ("test");
	saveAs("Tiff", target_dir + "/" + list[i]);
	close();
}
