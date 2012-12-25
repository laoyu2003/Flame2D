package Flame2D.elements.editbox
{
    import Flame2D.core.system.FlameWindowRenderer;
    import Flame2D.core.utils.Rect;

    public class MultiLineEditboxWindowRenderer extends FlameWindowRenderer
    {
        
        
        /*!
        \brief
        Constructor
        */
        public function MultiLineEditboxWindowRenderer(name:String)
        {
            super(name,  FlameMultiLineEditbox.EventNamespace);   
        }
        
        /*!
        \brief
        Return a Rect object describing, in un-clipped pixels, the window relative area
        that the text should be rendered in to.
        
        \return
        Rect object describing the area of the Window to be used for rendering text.
        */
        public function getTextRenderArea():Rect
        {
            return new Rect();
        }
        
        // base class overrides
        override public function onLookNFeelAssigned():void
        {
            //assert(d_window != 0);
            if(d_window == null)
            {
                throw new Error("null window");
            }
            // ensure window's text has a terminating \n
            var text:String = d_window.getText();
            if (text.length == 0 || text[text.length - 1] != '\n')
            {
                text += "\n";
                d_window.setText(text);
            }
        }
    }
}