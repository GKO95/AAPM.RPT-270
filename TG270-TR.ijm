//Use this code to generate a series of temporal resolution images for an animated gif

//Define the size of the frame
vsize = 1024;
hsize = 1024;

// Define a scalar to adjust from the default size
vsc = vsize / 1024;
hsc = hsize / 1024;

// Define the number of rows (powers of 2 work best)
rows = 16;

// Define the size of the blocks (assumes square size)
block = 32;

// Define the number of blocks (4 - 7 recommended)
numbl = 6;

// Define the number of frames (based on block count)
frames = hsize / (2 * block) + 2 + (numbl - 1);

// Define frame rate
fps = 60;

// Create the image stack
newImage("TG270-TR2", "black", hsize, vsize, frames);

// Set the gray level pairs. 2 * rows pairs are required.
gl = newArray(
    015, 020, 
    015, 030,
    015, 045,
    015, 065,
    120, 125,
    120, 135,
    120, 150,
    120, 170,
    245, 240,
    245, 230, 
    245, 215,
    245, 195,
    000, 075,
    000, 255,
    255, 180,
    255, 000
);

setFont("SansSerif", 10, "antialiased");
setJustification("center");

// Creation the test pattern background. Loop through each gray level pair base.
for(i = 0; i < rows; i++) {
    setColor(gl[2 * i], gl[2 * i], gl[2 * i]);
    run("Macro...", "code=[if(y >= "+ i * vsize / rows +"&&y <= "+ (i + 1) * vsize / rows +") v= "+ gl[2 * i] +"] stack");
    run("Macro...", "code=[if(y >= "+ i * vsize / rows + 0.5 * (vsize / rows - vsc * block) +" &&y <= "+(i + 1) * vsize / rows - 0.5 * (vsize / rows - vsc * block) +" &&x >= "+ 2 * block * hsc + " * z - "+ hsize - (hsize - hsc * 2 * numbl * block) +" &&x < "+ 2 * block * hsc +" * z &&x % "+2 * block * hsc+" > "+ block * hsc - 1 +") v = "+ gl[2 * i] +" + ("+ gl[2 * i + 1] +" - "+ gl[2 * i] +")] stack");
    
    // set text color
    tcolor = gl[2 * i] + (64 * pow(-1, floor(gl[2 * i] / 128)));
    setColor(tcolor, tcolor, tcolor);

    // setup labels
    for(j = 0; j < frames; j++) {
        setSlice(j + 1);

        // label each frame
        drawString(j, j * hsc * block * 2 - (numbl - 0.5) * hsc * block, i * vsize / rows + 0.50 * (vsize / rows - vsc * block));

        // label each pair
        drawString(gl[2 * i] + " / " + gl[2 * i + 1], hsize/2, i * vsize / rows + (vsize / rows - vsc * block) + vsc * block);
    }
}

// set up the animation options, set to desired fps
run("Animation Options...", "speed=" + fps + " first=1 last=" + frames + " start");

//run("Image Sequence...", ); //If this command is enabled, just select the option to use the slice labels as the file names.
