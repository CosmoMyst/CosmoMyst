module cosmomyst.ui.widgets.button;

import dath;
import cosmomyst.ui;
import cosmomyst.graphics;

public class Button : Widget
{
    private TextBlock textBlock;

    public Color fgColor = Colors.lightGray;
    public Color bgColor = Colors.gray1;

    public Color fgColorHovered = Colors.lightGray;
    public Color bgColorHovered = Colors.gray3;

    public this()
    {
        textBlock = new TextBlock();
        textBlock.horizontalAlignment = HorizontalAlignment.stretch;
        textBlock.verticalAlignment = VerticalAlignment.stretch;
        textBlock.textHorizontalAlignment = TextHorizontalAlignment.center;
        textBlock.textVerticalAlignment = TextVerticalAlignment.center;
    }

    public override void initialize()
    {
        addChild(textBlock);
    }

    public string text() @nogc nothrow
    {
        return textBlock.text;
    }

    public void text(string value) @nogc nothrow
    {
        textBlock.text = value;
    }

    public Font font() @nogc nothrow
    {
        return textBlock.font;
    }

    public void font(Font value) @nogc nothrow
    {
        textBlock.font = value;
    }

    protected override void draw(Renderer renderer) @nogc nothrow
    {
        super.draw(renderer);

        textBlock.color = isHovered ? fgColorHovered : fgColor;
        Color bg = isHovered ? bgColorHovered : bgColor;

        renderer.drawFillRect(Rectf(position, actualSize), bg, sortOrder);
    }
}
