module cosmomyst.graphics.impl.sdl.sdl_renderer;

version(SDL):

import bindbc.sdl;
import dath;
import cosmomyst.graphics;
import cosmomyst.graphics.impl.sdl;

private struct DrawCall
{
    public uint sortOrder;

    public Sprite sprite;

    public Rectf source;

    public Rectf dest;

    public Color color;

    public Font font;

    public string text;
}

public class SDLRenderer : Renderer
{
    private SDL_Renderer* renderer;
    private Color clearColor = Colors.black;

    private DrawCall[] drawCalls;
    private uint numDrawCalls = 0;

    private Sprite rectSprite;

    /++
     + Params:
     +   maxDrawCalls = Specifies the max amount of draw calls that can be executed per frame.
     +/
    public this(SDLWindow window, uint maxDrawCalls = 2000)
    {
        import core.stdc.stdlib : exit;
        import std.stdio : writeln;

        renderer = SDL_CreateRenderer(window.getInternalWindow(), -1, SDL_RENDERER_ACCELERATED);

        if (renderer is null)
        {
            writeln("Failed to create the SDL renderer. Error: ", SDL_GetError());
            exit(1);
        }

        SDL_SetRenderDrawBlendMode(renderer, SDL_BLENDMODE_BLEND);

        drawCalls.length = maxDrawCalls;

        // create a texture used for drawing rectangles
        SDL_Texture* rectTex = SDL_CreateTexture(renderer, SDL_PIXELFORMAT_RGBA8888, SDL_TEXTUREACCESS_TARGET, 1, 1);

        SDL_SetRenderTarget(renderer, rectTex);
        setSDLDrawColor(Colors.white);
        SDL_RenderClear(renderer);
        SDL_SetRenderTarget(renderer, null);
        setSDLDrawColor(clearColor);

        rectSprite = new SDLSprite(rectTex);
    }

    public void cleanup()
    {
        SDL_DestroyRenderer(renderer);
    }

    public override void begin() @nogc nothrow
    {
        numDrawCalls = 0;

        SDL_RenderClear(renderer);

        setSDLDrawColor(clearColor);
    }

    public override void end() @nogc nothrow
    {
        import std.algorithm : sort;

        drawCalls[0..numDrawCalls].sort!((a, b) => a.sortOrder < b.sortOrder);

        for (int i = 0; i < numDrawCalls; i++)
        {
            executeDrawCall(drawCalls[i]);
        }

        SDL_RenderPresent(renderer);
    }

    public override Color getClearColor() @nogc nothrow const
    {
        return clearColor;
    }

    public override void setClearColor(Color c) @nogc nothrow
    {
        clearColor = c;
    }

    public override Rectf getViewport() @nogc nothrow
    {
        SDL_Rect rect;
        SDL_RenderGetViewport(renderer, &rect);

        return Rectf(rect.x, rect.y, rect.w, rect.h);
    }

    public SDL_Renderer* getInternalRenderer() @nogc nothrow
    {
        return renderer;
    }

    public override void drawFillRect(Rectf rect, Color color, uint sortingOrder = 0) @nogc nothrow
    {
        DrawCall call = DrawCall(sortingOrder, rectSprite, Rectf(0, 0, 1, 1), rect, color, null, null);
        addDrawCall(call);
    }

    public override void drawStrokeRect(Rectf rect, uint lineWidth, Color color, uint sortingOrder = 0) @nogc nothrow
    {
        auto src = Rectf(0, 0, 1, 1);
        auto rectLeft = Rectf(rect.x, rect.y, lineWidth, rect.h);
        auto rectTop = Rectf(rect.x, rect.y, rect.w, lineWidth);
        auto rectRight = Rectf(rect.x + rect.w - lineWidth, rect.y, lineWidth, rect.h);
        auto rectBottom = Rectf(rect.x, rect.y + rect.h - lineWidth, rect.w, lineWidth);

        auto left = DrawCall(sortingOrder, rectSprite, src, rectLeft, color, null, null);
        auto top = DrawCall(sortingOrder, rectSprite, src, rectTop, color, null, null);
        auto right = DrawCall(sortingOrder, rectSprite, src, rectRight, color, null, null);
        auto bottom = DrawCall(sortingOrder, rectSprite, src, rectBottom, color, null, null);

        addDrawCall(left);
        addDrawCall(right);
        addDrawCall(top);
        addDrawCall(bottom);
    }

    public override void drawSprite(Sprite sprite, Rectf source, Rectf dest,
        Color color = Colors.white, uint sortingOrder = 0) @nogc nothrow
    {
        DrawCall call = DrawCall(sortingOrder, sprite, source, dest, color, null, null);
        addDrawCall(call);
    }

    public override void drawText(Font font, const(string) text, Rectf dest,
        Color color = Colors.white, uint sortingOrder = 0, bool outline = false) @nogc nothrow
    {
        if (outline)
        {
            drawStrokeRect(dest, 2, Colors.red, sortingOrder - 1);
        }

        DrawCall call = DrawCall(sortingOrder, null, Rectf(0), dest, color, font, text);
        addDrawCall(call);
    }

    /// Adds the draw call to the list of calls for this frame
    private void addDrawCall(DrawCall call) @nogc nothrow
    {
        drawCalls[numDrawCalls++] = call;
    }

    /// Executes a draw call, actually draws to the screen
    private void executeDrawCall(DrawCall call) @nogc nothrow
    {
        SDL_Rect source = { cast(int) call.source.x, cast(int) call.source.y,
                            cast(int) call.source.w, cast(int) call.source.h };

        SDL_Rect dest = { cast(int) call.dest.x, cast(int) call.dest.y,
                          cast(int) call.dest.w, cast(int) call.dest.h };

        // draw text
        if (call.font !is null)
        {
            SDLFont sfont = cast(SDLFont) call.font;

            SDL_Surface* surf = TTF_RenderText_Blended_Wrapped(sfont.getInternalFont(), call.text.ptr,
                call.color.toSDLColor(), cast(uint) call.dest.w);

            SDL_Texture* tex = SDL_CreateTextureFromSurface(renderer, surf);

            dest.w = surf.w;
            dest.h = surf.h;

            SDL_RenderCopy(renderer, tex, null, &dest);

            // caching maybe?
            SDL_DestroyTexture(tex);
            SDL_FreeSurface(surf);
        }
        // draw sprite
        else
        {
            SDL_Texture* tex = (cast(SDLSprite) call.sprite).getInternalTexture();

            // set color and alpha
            SDL_SetTextureColorMod(tex, call.color.r, call.color.g, call.color.b);
            SDL_SetTextureAlphaMod(tex, call.color.a);

            SDL_RenderCopy(renderer, tex, &source, &dest);

            // reset color and alpha
            SDL_SetTextureColorMod(tex, Colors.white.r, Colors.white.g, Colors.white.b);
            SDL_SetTextureAlphaMod(tex, 255);
        }
    }

    private void setSDLDrawColor(Color c) @nogc nothrow
    {
        SDL_SetRenderDrawColor(renderer, c.r, c.g, c.b, c.a);
    }
}
