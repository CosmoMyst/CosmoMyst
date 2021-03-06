module cosmomyst.graphics.impl.sdl.sdl_font;

version(SDL):

import bindbc.sdl;
import dath;
import cosmomyst.graphics;

public class SDLFont : Font
{
    private TTF_Font* font;

    public this(TTF_Font* font)
    {
        this.font = font;
    }

    public override void cleanup()
    {
        TTF_CloseFont(font);
    }

    public TTF_Font* getInternalFont() @nogc nothrow
    {
        return font;
    }
}
