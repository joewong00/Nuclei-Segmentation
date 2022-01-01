Wong Qing Joe
10268818
IIP Coursework
=============================

Function: solution.m

Input: Image (StackNinja1.bmp/StackNinja3.bmp/StackNinja3.bmp)
Output: Image (binary image corresponding to the nuclei)
        nr (number of nuclei detected)
        config (a structure containing size, shapes, brightness and others)

To run:
1) Make sure the function (solution.m) is in the same directory with the input images

2) Use "imread" to read one of the images (StackNinja1.bmp/StackNinja3.bmp/StackNinja3.bmp) and store in a variable (in)

3) Call the function (solution) and put the image as input, and assign the outputs to 3 variables
  - Example: [im_out, nr, config] = solution(in)

4) While running, the intermediate results will be shown

5) The config structure contains:
  - size (distribution, max, min and average)
  - shape (circularity, centers, radii)
  - brightness (distribution, max, min and average)

6) To get the data of config, use dot operator
   Example to get the max size of the nucleus in he image:
  - config.areas.max

