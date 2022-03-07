module cosmomyst.graphics.impl.sdl.sdl_sprite;

version(SDL):

import bindbc.sdl;
import dath;
import cosmomyst.graphics.sprite;

public class SDLSprite : Sprite
{
    private SDL_Texture* texture;

    private Vec2 size;

    public this(SDL_Texture* texture)
    {
        this.texture = texture;

        int w, h;
        SDL_QueryTexture(texture, null, null, &w, &h);
        size = Vec2(w, h);

        SDL_SetTextureBlendMode(texture, SDL_BLENDMODE_BLEND);
    }

    public ~this()
    {
        SDL_DestroyTexture(texture);
    }

    public override Vec2 getSize() @nogc nothrow
    {
        return size;
    }

    public SDL_Texture* getInternalTexture() @nogc nothrow
    {
        return texture;
    }
}
