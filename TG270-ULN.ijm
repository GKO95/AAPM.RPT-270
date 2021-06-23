// Use this code to generate combination UN and LN test patterns (TG270-ULN)

// Define the number of images (18 (15 GL), 52 (5 GL) , 86 (3 GL) or 256 (1 GL))
images = 256;

// Define the size of the images (1024 or 2048)
size = 1024;

// Create the image stack (Re-define the image type for other bit-depths)
newImage ("TG270-ULN8-", "8-bit black", size, size, images);

// Set the image values and draw the appropriate lines
step = 255/(images - 1);

// Set the entire page to the z * step value
run("Macro...", "code=[v = z * "+ step +"] stack");

// Set up fonts for labeling
setFont ("SansSerif", 18, "antialiased");
setJustification("center");

// Create a for loop to label the images and draw the grid lines
for(i = 0; i < images; i++) {
    setSlice(i + 1);
    color = (i % (images / 2) + images / 6) * step;
    setColor(color, color, color);
    drawString("TG270-ULN8-" + IJ.pad(i * step, 3) + " ", size/2 - 1, 32);
    setMetadata("Label", "TG270-ULN8-" + IJ.pad( i * step, 3) + " ");
    drawRect(340 * size / 1024, 0, 2, size);
    drawRect(682 * size / 1024, 0, 2, size);
    drawRect(0, 340 * size / 1024, size, 2);
    drawRect(0, 682 * size / 1024, size, 2);
}

// If this command is enabled , just select the
// option to use the slice labels as the file names.
// run("Image Sequence...", );
