/*
    Use this code to generate the sQC (simple QC) TG270 pattern.

    This version of the script will assume an 8-bit grayscale.

    This pattern is intended to be used by non-physicists as a quick visual
    evaluation of display performance. It contains three rows
    of six incrementing grayscale squares (for a total of 18 squares)
    that cover from 0 to 255. Each square contains a smaller square in the
    upper left and lower right corner. These sub-squares contain a modulation
    pattern with a period of 6 pixels and 50% duty cycle. The patterns use
    vertical bars that differ from the background value of the square by 5 gray
    levels. The pattern in the upper left corner of each square has vertical
    bars with a lower pixel value than the square, while the pattern in the
    lower right has vertical bars with higher pixel values. For the first
    square (GL 0), the pattern in the upper left cannot be lower than the
    main square. Its bars have a contrastof 3 gray levels above the
    background. Similarly, the last square (GL 255) cannot have a lower right
    sub-square with higher pixel values, and so it has a modulation contrast
    of 3 gray levels below the background.

    For a DICOM-conformant display, the user should be able to quickly scan
    the three rows of squares and assess if the modulation patterns in each
    are equally visible across all 18 gray levels. The upper-leftmost and
    lower-rightmost patterns correspond to the ones with the lower contrast
    (3 gray levels vs. 5); these may only be visible on the highest-performance
    displays.

    The sQC pattern also includes three larger squares at the bottom of the
    pattern that allow for minimum and maximum luminance calculations (and
    therefore luminance ratio). These three patterns (black, mid-gray, white)
    can be zoomed and panned around the display for bad pixel and uniformity
    measurements. Furthermore, any of the squares in the three rows can be
    zoomed and panned for similar use. The squares in the three rows correspond
    67 to the gray levels used in the traditional 18-point TG18 luminance
    response measurement.
    
    Along the bottom of the pattern, a grayscale gradient is included with
    continuous pixel value variation for evaluating bit depth issues,
    contouring artifacts, and grayscale errors. At the side of the gradient,
    line pairs in the horizontal and vertical direction can be used to verify 
    correct pixel mapping.
*/

// Define the size of the image (1024 or 2048)
size = 1024;

// Based on the size, set a scaler value
sc = size / 1024;

// Create the image
newImage("TG270-sQC", "8-bit black", size, size, 1);

// Set the background
background = 128;

// Set the period of the bar patterns (pixels / lp)
barper = 6;

// Set the entire page to the background
run("Macro...", "code=v=" + background + " ");

// Set up fonts for labeling
setFont("SansSerif", 18, "antialiased");
setJustification("center");
color = background - 75;
setColor(color, color, color);
drawString("TG270-sQC", size /2 - 1, 32);
setMetadata("Label", "TG270-sQC");

// Create a for loop to draw the boxes and contrast squares
ioff = 1;   // Define i offset to move the group of boxes up/down
for(i = 0; i < 3; i++) {
    for(j = 0; j < 6; j++) {
        // Set the color based on the row, column (i, j) coordinates in steps of 15
        /*
            The power command allows the grays to be read continuously by switching
            the order of the second row. This way the eye can follow the grays from
            left to right, move down, then go from right to left in the second row
            before going left to right for the final row.
        */
        color = (i * 6 + 2.5 - 2.5 * pow(-1, i) + j * pow(-1, i)) * 15;
        setColor(color, color, color);

        // Draw the main squares (128x128 for 1024)
        fillRect((sc * 160 * j + sc * 48), sc * 128 * (i + ioff) + (i - 1) * sc * 32, sc * 128, sc * 128);

        // Label the squares (comment the drawString command to remove labels)
        setFont("SansSerif", 12, "antialiased");
        setJustification("center");
        tcolor = (i * 6 + 2.5 - 2.5 * pow(-1, i) + j * pow(-1, i)) % 9 * 15 + 75;
        setColor(tcolor, tcolor, tcolor);

        // Label the s q u a r e s with gray l e v e l s
        drawString((i * 6 + 2.5 - 2.5 * pow(-1, i) + j * pow(-1, i)) * 15, (sc * 160 * j + sc * 48) + sc * 64, sc * 128 * (i + ioff) + (i - 1) * sc * 32 + sc * 16);

        // Label the s q u a r e s with i n d i c e s
        // drawString((i * 6 + 2.5 - 2.5 * pow(-1, i) + j * pow(-1, i)) * 15, (sc * 160 * j + sc * 48) + sc * 64, sc * 128 * (i + ioff) + (i - 1) * sc * 32 + sc * 16);
        // Set the contrast color to 2% of the main square and draw the modulation pattern
        // Create special conditions for the first and last box
        if((i == 0) && (j == 0)) {
            for(k = 0; k < ((32 / barper) * sc); k++) {
                lowc = 3;
                setColor(lowc, lowc, lowc);
                fillRect((sc * 160 * j + sc * 48) + sc * 16 + k * barper, sc * 128 * (i + ioff) + (i - 1) * sc * 32 + sc * 16, barper / 2, sc * 32);
                cont = 5;
                setColor(cont, cont, cont);
                fillRect((sc * 160 * j + sc * 48) + sc * 80 + k * barper, sc * 128 * (i + ioff) + (i - 1) * sc * 32 + sc * 80, barper / 2, sc * 32);
            }
        } else {
            if ((i == 2) && (j == 5)) {
                for (k = 0; k < (32 / barper) * sc; k++) {
                    lowc = (i * 6 + 2.5 - 2.5 * pow(-1, i) + j * pow(-1, i)) * 15 - 3;
                    setColor(lowc, lowc, lowc);
                    fillRect((sc * 160 * j + sc * 48) + sc * 80 + k * barper, sc * 128 * (i + ioff) + (i - 1) * sc * 32 + sc * 80, barper / 2, sc * 32);
                    cont = (i * 6 + 2.5 - 2.5 * pow(-1, i) + j * pow(-1, i)) * 15 - 5;
                    setColor(cont, cont, cont);
                    fillRect((sc * 160 * j + sc * 48) + sc * 16 + k * barper, sc * 128 * (i + ioff) + (i - 1) * sc * 32 + sc * 16, barper / 2, sc * 32);
                }
            } else {
                for (k = 0; k < (32 / barper) * sc; k++) {
                    cont = (i * 6 + 2.5 - 2.5 * pow(-1, i) + j * pow(-1, i)) * 15 - 5;
                    setColor(cont, cont, cont);
                    fillRect((sc * 160 * j + sc * 48) + sc * 16 + k * barper, sc * 128 * (i + ioff) + (i - 1) * sc * 32 + sc * 16, barper / 2, sc * 32);
                    cont = (i * 6 + 2.5 - 2.5 * pow(-1, i) + j * pow(-1, i)) * 15 + 5;
                    setColor(cont, cont, cont);
                    fillRect((sc * 160 * j + sc * 48) + sc * 80 + k * barper, sc * 128 * (i + ioff) + (i - 1) * sc * 32 + sc * 80, barper / 2, sc * 32);
                }
            }
        }
    }
}

// Draw some big squares along the bottom for bad pixel testing and luminance measuring
koff = 4;
for (k = 0; k < 3; k++) {
    color = k * 128;    // Set the color
    setColor(color, color, color);
    fillRect(sc * (128 + k * 256), sc * 128 * (koff + 1), sc * 256, sc * 256);  // Draw the main squares (128x128 for 1024)
}

// Draw vertical gradient along the right side:
// run("Macro...", "code=[if(x > "+ sc * (size - 64) +" &&y <= "+ size - sc * 64 +" &&y >= "+ sc * 64 +") v = (y - "+ sc * 64 +") / "+ size - sc * 64 * 2 +" * 255]");

// Draw horizontal gradient along the bottom (either with or without line patterns):
// With line patterns at the sides
run("Macro...", "code=[if(y > "+ (size - sc * 64) +" &&x <= "+ size - 2 * sc * 64 +") v = (x - "+ sc * 64 +") / "+ size - sc * 64 * 2 +" * 255]");
run("Macro...", "code=[if(y > "+ (size - sc * 64) +" &&x > "+ size - 2 * sc * 64 +" &&x < "+ size - sc * 64 +") v = (x % 2) * 255]");
run("Macro...", "code=[if(y > "+ (size - sc * 64) +" &&x > "+ size - sc * 64 +") v = (y % 2) * 255]");

// Without the line patterns
// run("Macro...", "code=[if(y > "+ sc * (size - 64) +") v = (x - "+ sc * 64 +") / "+ size - sc * 64 * 2 +" * 255]");
