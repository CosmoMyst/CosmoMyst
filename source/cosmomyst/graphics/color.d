module cosmomyst.graphics.color;

import dath;

public alias Color = Vec!(ubyte, 4);

public enum Colors : Color
{
    black = Color(0, 0, 0, 255),
    white = Color(255, 255, 255, 1)
}
