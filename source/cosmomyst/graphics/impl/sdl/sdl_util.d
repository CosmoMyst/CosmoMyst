module cosmomyst.graphics.impl.sdl.sdl_util;

version(SDL):

import bindbc.sdl;
import dath;
import cosmomyst.graphics.color;

/** 
 *  Converts a standard `Color` to the `SDL_Color` struct.
 */
public SDL_Color toSDLColor(const Color c) @nogc nothrow
{
    return SDL_Color(
        c.r,
        c.g,
        c.b,
        c.a,
    );
}

/** 
 * Converts a position and size to the `SDL_Rect` struct.
 */
public SDL_Rect toSDLRect(const Vec2 pos, const Vec2 size) @nogc nothrow
{
    return SDL_Rect(
        cast(int) pos.x,
        cast(int) pos.y,
        cast(int) size.x,
        cast(int) size.y
    );
}

/** 
 * Converts a standard `Recti` to the `SDL_Rect` struct.
 */
public SDL_Rect toSDLRect(const Rectf rect) @nogc nothrow
{
    return SDL_Rect(
        cast(int) rect.x,
        cast(int) rect.y,
        cast(int) rect.w,
        cast(int) rect.h
    );
}

/** 
 * Converts a `bool` to an `SDL_bool`.
 */
public SDL_bool toSDLBool(const bool v) @nogc nothrow
{
    return v ? SDL_TRUE : SDL_FALSE;
}
