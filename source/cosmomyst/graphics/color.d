module cosmomyst.graphics.color;

import dath;

public alias Color = Vec!(ubyte, 4);

public enum Colors : Color
{
    black = Color(0, 0, 0, 255),
    gray1 = Color(29, 31, 33, 255),
    gray2 = Color(40, 42, 46, 255),
    gray3 = Color(55, 59, 65, 255),
    gray4 = Color(150, 152, 150, 255),
    lightGray = Color(197, 200, 198, 255),
    white = Color(255, 255, 255, 255),
    transparent = Color(0, 0, 0, 0),
    red = Color(204, 102, 102, 255),
    orange = Color(222, 147, 95, 255),
    yellow = Color(240, 198, 116, 255),
    green = Color(181, 189, 104, 255),
    aqua = Color(138, 190, 183, 255),
    blue = Color(129, 162, 190, 255),
    purple = Color(178, 148, 187, 255),
}
