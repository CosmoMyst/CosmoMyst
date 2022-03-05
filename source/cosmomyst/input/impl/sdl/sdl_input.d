module cosmomyst.input.impl.sdl.sdl_input;

version(SDL):

import core.stdc.string;
import bindbc.sdl;
import dath;
import cosmomyst.input.input;

public class SDLInput : Input
{
    private ubyte[SDL_NUM_SCANCODES] previousKbState;
    private ubyte[SDL_NUM_SCANCODES] currentKbState;

    private uint previousMbState;
    private uint currentMbState;

    private Vec2 mousePosition;

    public this()
    {
        previousKbState[] = 0;
        currentKbState = SDL_GetKeyboardState(null)[0..SDL_NUM_SCANCODES];
    }

    public override void begin() @nogc nothrow
    {
        // force the events to update
        SDL_PumpEvents();

        previousKbState = currentKbState;
        currentKbState = SDL_GetKeyboardState(null)[0..SDL_NUM_SCANCODES];

        previousMbState = currentMbState;

        int mx, my;
        currentMbState = SDL_GetMouseState(&mx, &my);
        mousePosition = Vec2(mx, my);
    }

    public override void end() @nogc nothrow
    {
        previousKbState = currentKbState;
        previousMbState = currentMbState;
    }

    public override Vec2 mousePos() @nogc nothrow const
    {
        return mousePosition;
    }

    public override bool isKeyPressed(Key k) @nogc nothrow const
    {
        int b = convertSDLKey(k);
        return previousKbState[b] == 0 && currentKbState[b] == 1;
    }

    public override bool isKeyReleased(Key k) @nogc nothrow const
    {
        int b = convertSDLKey(k);
        return previousKbState[b] == 1 && currentKbState[b] == 0;
    }

    public override bool isKeyHeld(Key k) @nogc nothrow const
    {
        int b = convertSDLKey(k);
        return currentKbState[b] == 1;
    }

    public override bool isMouseButtonPressed(MouseButton m) @nogc nothrow const
    {
        int b = convertSDLMouseKey(m);
        return (previousMbState & b) == 0 && (currentMbState & b) != 0;
    }

    public override bool isMouseButtonReleased(MouseButton m) @nogc nothrow const
    {
        int b = convertSDLMouseKey(m);
        return (previousMbState & b) != 0 && (currentMbState & b) == 0;
    }

    public override bool isMouseButtonHeld(MouseButton m) @nogc nothrow const
    {
        int b = convertSDLMouseKey(m);
        return (currentMbState & b) == 0;
    }

    private int convertSDLMouseKey(MouseButton m) @nogc nothrow const
    {
        final switch (m)
        {
            case MouseButton.left: return SDL_BUTTON_LMASK;
            case MouseButton.middle: return SDL_BUTTON_MMASK;
            case MouseButton.right: return SDL_BUTTON_RMASK;
        }
    }

    private int convertSDLKey(Key k) @nogc nothrow const
    {
        final switch (k)
        {
            case Key.w: return SDL_SCANCODE_W;
            case Key.s: return SDL_SCANCODE_S;
            case Key.a: return SDL_SCANCODE_A;
            case Key.d: return SDL_SCANCODE_D;
            case Key.p: return SDL_SCANCODE_P;
            case Key.x: return SDL_SCANCODE_X;
            case Key.c: return SDL_SCANCODE_C;
            case Key.escape: return SDL_SCANCODE_ESCAPE;
            case Key.space: return SDL_SCANCODE_SPACE;
            case Key.lctrl: return SDL_SCANCODE_LCTRL;
        }
    }
}
