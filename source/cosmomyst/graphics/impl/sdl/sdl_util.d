module cosmomyst.graphics.impl.sdl.sdl_util;

version(SDL):

import bindbc.sdl;
import cosmomyst.graphics.color;

/** 
 *  Converts a standard `Color` to the `SDL_Color` struct
 */
public SDL_Color toSDLColor(Color c) @nogc nothrow
{
    return SDL_Color(
        c.r,
        c.g,
        c.b,
        c.a,
    );
}
