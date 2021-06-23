/*
    This code will generate a modified TG18PQC pattern following the same
    basic modifications used in the pacsDisplay iQC pattern. The user should
    set up the size variable for the desired image size. Typically this is
    either a 1024 x 1024 image or 2048 x 2048 image. In this script,
    a square pattern is generated , though it can be of arbitrary size.
    The size of everything is based on the TG18PQC definitions and will just 
    be scaled accordingly (though it may have some errors).

    This version of the script will assume an 8-bit grayscale.
*/
size = 1024;
newImage("TG270-pQC", "8-bit black", size, size, 1);

// Define some of the sizes (everything is normalized to 1024)
sidew = floor(size / 1024 * 87);
barh  = floor(size / 1024 * 50);
toph  = floor(size / 1024 * 62);

// Create the horizontal bars and the contrast modulation within (varying contrast and frequency)
// 18 bars (0, 15, 30, ..., 240, 255)
run("Macro...", "code=[if(y >= "+ toph +" &&y < "+ size - toph +") v = floor((y - "+ toph +") / "+ barh +") * 15]");

// Contrast modulation
// Horizontal bars
freqH = newArray (18, 12, 6, 4);
for(i = 0; i < 4; i++) {
    f = freqH[i];

    // Left contrast (8)
    run("Macro...", "code=[if(x >= "+ sidew + i * barh +" &&x < "+ sidew + barh + i * barh +" && ((y - "+ toph +") % "+ f +" < "+ f/2 +")) v = v - 4]");
    run("Macro...", "code=[if(x >= "+ sidew + i * barh +" &&x < "+ sidew + barh + i * barh +" && ((y - "+ toph +") % "+ f +" >= "+ f/2 +")) v = v + 4]");

    // Add additional four to the top row and subtract four from the bottom row
    run("Macro...", "code=[if(x >= "+ sidew + i * barh +" &&x < "+ sidew + barh + i * barh +" &&y < "+ toph + barh +" &&((y - "+ toph +") % "+ f +" >= "+ f/2 +")) v = v + 4]");
    run("Macro...", "code=[if(x >= "+ sidew + i * barh +" &&x < "+ sidew + barh + i * barh +" &&y >= "+ size - toph - barh +" &&((y - "+ toph +") % "+f +" < "+ f/2 +")) v = v - 4]");

    // Left contrast (2)
    run("Macro...", "code=[if(x >= "+ sidew + (i + 4) * barh +" &&x < "+ sidew + barh + (i + 4) * barh +" &&((y - "+ toph +") % "+ f +" < "+ f/2 +")) v = v - 1]");
    run("Macro...", "code=[if(x >= "+ sidew + (i + 4) * barh +" &&x < "+ sidew + barh + (i + 4) * barh +" &&((y - "+ toph +") % "+ f +" >= "+ f/2 +")) v = v + 1]");

    // Add additional one to the top row and subtract one from the bottom row
    run("Macro...", "code=[if(x >= "+ sidew + (i + 4) * barh +" &&x < "+ sidew + barh + (i + 4) * barh +" &&y < "+ toph + barh +" &&((y - "+ toph +") % "+ f +" >= "+ f/2 +")) v = v + 1]");
    run("Macro...", "code=[if(x >= "+ sidew + (i + 4) * barh +" &&x < "+ sidew + barh + (i + 4) * barh +" &&y >= "+ size - toph - barh +" &&((y - "+ toph +") % "+ f +" < "+ f/2 +")) v = v - 1]");
}

// Vertical bars
freqV = newArray(4, 6, 12, 18);
for (i = 9; i < 13; i++) {
    f = freqV[i - 9];

    // Right contrast (8)
    run("Macro...", "code=[if(x >= "+ sidew + (i + 4) * barh +" &&x < "+ sidew + barh + (i + 4) * barh +" &&((x - "+ sidew + i * barh +") % "+ f +" < "+ f/2 +")) v = v - 4]");
    run("Macro...", "code=[if(x >= "+ sidew + (i + 4) * barh +" &&x < "+ sidew + barh + (i + 4) * barh +" &&((x - "+ sidew + i * barh +") % "+ f +" >= "+ f/2 +")) v = v + 4]");

    // Add additional four to the top row and subtract four from the bottom row
    run("Macro...", "code=[if(x >= "+ sidew + (i + 4) * barh +" &&x < "+ sidew + barh + (i + 4) * barh + " &&y < "+ toph + barh +" &&((x - "+ sidew + i * barh +") % "+ f +" >= "+ f/2 +")) v = v + 4]");
    run("Macro...", "code=[if(x >= "+ sidew + (i + 4) * barh +" &&x < "+ sidew + barh + (i + 4) * barh + " &&y >= "+ size - toph - barh +" &&((x - "+ sidew + i * barh +") % "+ f +" < "+ f/2 +")) v = v - 4]");

    // Right contrast (2)
    run("Macro...", "code=[if(x >= "+ sidew + i * barh +" &&x < "+ sidew + barh + i * barh +" &&((x - "+ sidew + i * barh +") % "+ f +" >= "+ f/2 +")) v = v + 1]");
    run("Macro...", "code=[if(x >= "+ sidew + i * barh +" &&x < "+ sidew + barh + i * barh +" &&((x - "+ sidew + i * barh +") % "+ f +" < "+ f/2 +")) v = v - 1]");

    // Add additional one to the top row and subtract one from the bottom row
    run("Macro...", "code=[if(x >= "+ sidew + i * barh +" &&x < "+ sidew + barh + i * barh +" &&y >= "+ size - toph - barh +" &&((x - "+ sidew + i * barh +") % "+ f +" < "+ f/2 +")) v = v - 1]");
    run("Macro...", "code=[if(x >= "+ sidew + i * barh +" &&x < "+ sidew + barh + i * barh +" &&y < "+ toph + barh +" &&((x - "+ sidew + i * barh +") % "+ f +" >= "+ f/2 +")) v = v + 1]");
}

// Horizontal bars at the top and bottom of the pattern with high-contrast line pair phantoms
run("Macro...", "code=[if(y < "+ toph +") v = 64]");
run("Macro...", "code=[if(y >= "+ size - toph +") v = 191]");

// Line pairs
freqLP = newArray(6, 4, 2, 2, 4, 6);
topM = toph / 2;
for (i = 0; i < 3; i++) {
    f = freqLP[i];
    run("Macro...", "code=[if(x >= "+ sidew + (2 * i + 2) * barh +" &&x < "+ sidew + barh + (2 * i + 2) * barh +" &&y > "+ topM - barh / 2 +" &&y <= "+ topM + barh / 2 +" &&((y - "+ (topM - barh / 2) +") % "+ f +" < "+ f/2 +")) v = 128]");
    run("Macro...", "code=[if(x >= "+ sidew + (2 * i + 2) * barh +" &&x < "+ sidew + barh + (2 * i + 2) * barh +" &&y > "+ topM - barh / 2 +" &&y <= "+ topM + barh / 2 +" &&((y - "+ (topM - barh / 2) +") % "+ f +" >= "+ f/2 +")) v = 0]");
    run("Macro...", "code=[if(x >= "+ sidew + (2 * i + 2) * barh +" &&x < "+ sidew + barh + (2 * i + 2) * barh +" &&y > "+ size - topM - barh / 2 +" &&y <= "+ size - topM + barh / 2 +" &&((y - "+ (topM - barh / 2) +") % "+ f +" < "+ f/2 +")) v = 128]");
    run("Macro...", "code=[if(x >= "+ sidew + (2 * i + 2) * barh +" &&x < "+ sidew + barh + (2 * i + 2) * barh +" &&y > "+ size - topM - barh / 2 +" &&y <= "+ size - topM + barh / 2 +" &&((y - "+ (topM - barh / 2) +") % "+ f +" >="+ f /2 +")) v = 255]");
}

for(i = 3; i < 6; i++) {
    f = freqLP[i];
    run ("Macro...", "code=[if(x >= "+ sidew + (2 * i +4) *barh + " &&x < "+ sidew + barh + (2 * i +4) * barh +" &&y > "+ topM - barh / 2 +" &&y <= "+ topM + barh / 2 +" &&((x - "+ sidew + (2 * i + 4) * barh + ") % "+ f +" < "+ f/2 +")) v = 128]");
    run ("Macro...", "code=[if(x >= "+ sidew + (2 * i +4) *barh + " &&x < "+ sidew + barh + (2 * i +4) * barh +" &&y > "+ topM - barh / 2 +" &&y <= "+ topM + barh / 2 +" &&((x - "+ sidew + (2 * i + 4) * barh + ") % "+ f +" >= "+ f/2 +")) v = 0]");
    run ("Macro...", "code=[if(x >= "+ sidew + (2 * i +4) *barh + " &&x < "+ sidew + barh + (2 * i +4) * barh +" &&y > "+ size - topM - barh / 2 +" &&y <= "+ size - topM + barh / 2 +" &&((x - "+ sidew + (2 * i + 4) * barh +") % "+ f +" < "+ f/2 +")) v = 128]");
    run ("Macro...", "code=[if(x >= "+ sidew + (2 * i +4) *barh + " &&x < "+ sidew + barh + (2 * i +4) * barh +" &&y > "+ size - topM - barh / 2 +" &&y <= "+ size - topM + barh / 2 +" &&((x - "+ sidew + (2 * i + 4) * barh +") % "+ f +" >= "+ f/2 +")) v = 255]");
}

// Vertical side bars with modulating gradient
strip = sidew / 2;

// Left side
run("Macro...", "code=[if(x < "+ sidew +") v = y / "+ size - 1 +" * 1031 / 1024 * 255]");
run("Macro...", "code=[if(x < "+ sidew / 2 + (strip / 2) +" &&x > "+ sidew / 2 - (strip / 2) +") v = v + 3 * sin(y / 2)]");

// Right Side
run("Macro...", "code=[if(x >= "+ size - sidew +") v = -1 * (y - "+ size - 1 +") / "+ size - 1 +" * 1031 / 1024 * 255]");
run("Macro...", "code=[if(x < "+ size - sidew / 2 + (strip / 2) +" &&x > "+ size - sidew / 2 - (strip / 2) +") v = v + 3 * sin(y / 1.5)]");

// Set up fonts for labeling
setFont("SansSerif", 18, "antialiased");
setJustification("center");
setColor(128, 128, 128);
drawString("TG270-pQC", size / 2 - 1, 32);
setMetadata("Label", "TG270-pQC");
