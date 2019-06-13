# Quiver

Here you find 2 MATLAB functions: SetQuiverColor and SetQuiverLength.
They allow you to change the appearance of quiver plot in MATLAB.
You can either change the color of each arrow (SetQuiverColor) and
change the length of each arrow (SetQuiverLength) in units of the x/y/z axis.
It gives better control of what is going on.

You simply need to give the handle to the function and a magnitude for
SetQuiverColor or SetQuiverLength function.

In addition, the SetQuiverColor function offer the possibility to provide a
maximum and minimum value that would be different to that of the magnitudes that
you request. This allows to saturate or only use part of the colormap range.
The desired colormap should also be provided.
