max = 255; // set the max value of the images here - either 65535 for uint16, or 4096 if uint12 mapped

setBatchMode(true);

source_dir = getArgument;
target_dir = source_dir;

print (source_dir);

//source_dir = getDirectory("Source Directory");
//target_dir = getDirectory("Target Directory");

 list = getFileList(source_dir);

  for (i=0; i<list.length; i++) {
				print (list[i]);
        open(source_dir + "/" + list[i]);
	run("Size...", "width=300 depth=80 constrain average interpolation=Bilinear");
        run("Gaussian Blur...", "sigma=2 stack");
        setMinAndMax(0, max);
	run("8-bit");
	saveAs("tiff", target_dir + "/" + list[i] + "GauSmooth.tiff");
	close();
	showProgress(i, list.length);
	run("Collect Garbage");
  }
