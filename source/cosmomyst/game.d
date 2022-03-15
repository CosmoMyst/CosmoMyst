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

    protected ContentManager contentManager;

    /// Time elapsed since the start;
    protected double elapsedTime = 0f;

    protected UIHost uiHost;

    public this(string title, uint width, uint height)
    {
        version(SDL)
        {
            window = new SDLWindow(title, width, height);
            renderer = new SDLRenderer(cast(SDLWindow) window);
            input = new SDLInput();
        }

        uiHost = new UIHost();

        contentManager = new ContentManager(renderer);

        renderer.setClearColor(Colors.white);
    }

    public ~this()
    {
        contentManager.cleanup();
        renderer.cleanup();
        window.cleanup();
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

    protected void update(double dt) @nogc nothrow
    {
        uiHost.update(input, dt);
    }

    protected void draw() @nogc nothrow
    {
        uiHost.draw(renderer);
    }
}
