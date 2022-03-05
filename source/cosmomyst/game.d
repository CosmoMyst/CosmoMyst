module cosmomyst.game;

import cosmomyst;

version(SDL)
{
    import cosmomyst.graphics.impl.sdl;
    import cosmomyst.input.impl.sdl;
}

/// Base game class. Your game should implement this class.
public abstract class Game
{
    protected Window window;
    protected Renderer renderer;
    protected Input input;

    /// Time elapsed since the start;
    protected double elapsedTime = 0f;

    public this(string title, uint width, uint height)
    {
        window = new SDLWindow(title, width, height);
        renderer = new SDLRenderer(cast(SDLWindow) window);
        input = new SDLInput();

        renderer.setClearColor(Colors.white);
    }

    public void run() nothrow
    {
        import std.algorithm : min;

        double t = 0f;
        double dt = 1 / 120f;

        double currentTime = window.getHighResCounter();

        while(window.isOpen())
        {
            double newTime = window.getHighResCounter();
            double frameTime = (newTime - currentTime) / cast(double) window.getHighResFrequency();
            elapsedTime += frameTime;
            double updateFrameTime = frameTime;
            currentTime = newTime;

            while (frameTime > 0)
            {
                float deltaTime = min(frameTime, dt);
                fixedUpdate(deltaTime);
                frameTime -= deltaTime;
                t += deltaTime;
            }

            window.pollEvents();

            input.begin();

            update(updateFrameTime);

            input.end();

            renderer.begin();

            draw();

            renderer.end();
        }
    }

    protected void fixedUpdate(double) @nogc nothrow { }
    protected void update(double) @nogc nothrow { }
    protected void draw() @nogc nothrow { }
}
