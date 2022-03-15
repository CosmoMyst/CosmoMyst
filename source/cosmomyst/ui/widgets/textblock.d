module cosmomyst.ui.widgets.textblock;

import dath;
import cosmomyst.graphics;
import cosmomyst.ui;

public class TextBlock : Widget
{
    public string text = "";
    public Font font;

    public TextHorizontalAlignment textHorizontalAlignment = TextHorizontalAlignment.left;
    public TextVerticalAlignment textVerticalAlignment = TextVerticalAlignment.top;

    protected override void draw(Renderer renderer) @nogc nothrow
    {
        super.draw(renderer);

        if (parent.actualSize.x <= 0 || parent.actualSize.y <= 0) return;

        actualSize = renderer.measureText(font, text, actualSize);
        actualSize = actualSize.clamp(Vec2(0), parent.actualSize);

        final switch (textHorizontalAlignment)
        {
            case TextHorizontalAlignment.left: break;

            case TextHorizontalAlignment.right:
            {
                position.x = parent.position.x + parent.actualSize.x - actualSize.x - parent.padding.right;
            } break;

            case TextHorizontalAlignment.center:
            {
                position.x = parent.position.x + (parent.actualSize.x / 2) - (actualSize.x / 2);
            } break;
        }

        final switch (textVerticalAlignment)
        {
            case TextVerticalAlignment.top: break;

            case TextVerticalAlignment.bottom:
            {
                position.y = parent.position.y + parent.actualSize.y - actualSize.y - parent.padding.bottom;
            } break;

            case TextVerticalAlignment.center:
            {
                position.y = parent.position.y + (parent.actualSize.y / 2) - (actualSize.y / 2);
            } break;
        }

        renderer.drawText(font, text, Rectf(position, actualSize), color, sortOrder);
    }
}
