module cosmomyst.ui.widgets.panel;

import dath;
import cosmomyst.graphics;
import cosmomyst.ui;

public class Panel : Widget
{
    protected override void draw(Renderer renderer) @nogc nothrow
    {
        super.draw(renderer);

        renderer.drawFillRect(Rectf(position, actualSize), color);
    }
}
