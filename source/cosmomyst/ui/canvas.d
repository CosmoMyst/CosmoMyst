module cosmomyst.ui.canvas;

import dath;
import cosmomyst.ui.widget;
import cosmomyst.ui.alignment;
import cosmomyst.graphics;

public class Canvas : Widget
{
    public override void initialize()
    {
        super.initialize();

        horizontalAlignment = HorizontalAlignment.stretch;
        verticalAlignment = VerticalAlignment.stretch;
        color = Colors.transparent;
    }

    public override void draw(Renderer renderer) @nogc nothrow
    {
        size = renderer.getViewport().size;
        actualSize = size;
        position = Vec2.zero;

        foreach (child; children)
        {
            child.draw(renderer);
        }
    }
}
