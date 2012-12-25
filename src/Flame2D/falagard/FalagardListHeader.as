/***************************************************************************
 *   Copyright (C) 2004 - 2010 Paul D Turner & The CEGUI Development Team
 *
 *   Porting to Flash Stage3D
 *   Copyright (C) 2012 Mingjian Yu(laoyu20032003@hotmail.com)
 *
 *   Permission is hereby granted, free of charge, to any person obtaining
 *   a copy of this software and associated documentation files (the
 *   "Software"), to deal in the Software without restriction, including
 *   without limitation the rights to use, copy, modify, merge, publish,
 *   distribute, sublicense, and/or sell copies of the Software, and to
 *   permit persons to whom the Software is furnished to do so, subject to
 *   the following conditions:
 *
 *   The above copyright notice and this permission notice shall be
 *   included in all copies or substantial portions of the Software.
 *
 *   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 *   EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 *   MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 *   IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
 *   OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
 *   ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 *   OTHER DEALINGS IN THE SOFTWARE.
 ***************************************************************************/
package Flame2D.falagard
{
    import Flame2D.core.system.FlameWindowManager;
    import Flame2D.elements.list.FlameListHeaderSegment;
    import Flame2D.elements.list.ListHeaderWindowRenderer;
    import Flame2D.core.falagard.FalagardStateImagery;
    import Flame2D.core.falagard.FalagardWidgetLookFeel;

    /*!
    \brief
    ListHeader class for the FalagardBase module.
    
    This class requires LookNFeel to be assigned.  The LookNFeel should provide the following:
    
    Property Initialisers:
    SegmentWidgetType   - type of widget to create for segments.
    
    Imagery States:
    - Enabled           - basic rendering for enabled state.
    - Disabled          - basic rendering for disabled state.
    */
    public class FalagardListHeader extends ListHeaderWindowRenderer
    {
        
        public static const TypeName:String = "Falagard/ListHeader";
     
        // properties
        protected static var d_segmentWidgetTypeProperty:FalagardListHeaderPropertySegmentWidgetType = new FalagardListHeaderPropertySegmentWidgetType();


        // data fields
        protected var d_segmentWidgetType:String;


        public function FalagardListHeader(type:String)
        {
            super(type);
            
            registerProperty(d_segmentWidgetTypeProperty);
        }
        
        override public function render():void
        {
            var imagery:FalagardStateImagery;
            // get WidgetLookFeel for the assigned look.
            const wlf:FalagardWidgetLookFeel = getLookNFeel();
            // render basic imagery
            imagery = wlf.getStateImagery(d_window.isDisabled() ? "Disabled" : "Enabled");
            imagery.render(d_window);
        }
        
        public function getSegmentWidgetType():String
        {
            return d_segmentWidgetType;
        }
        
        public function setSegmentWidgetType(type:String):void
        {
            d_segmentWidgetType = type;
        }
        

        override public function createNewSegment(name:String):FlameListHeaderSegment
        {
            // make sure this has been set
            if (d_segmentWidgetType.length == 0)
            {
                throw new Error("FalagardListHeader::createNewSegment - Segment widget type has not been set!");
            }
            
            return FlameWindowManager.getSingleton().createWindow(d_segmentWidgetType, name) as FlameListHeaderSegment;
        }
        
        override public function destroyListSegment(segment:FlameListHeaderSegment):void
        {
            // nothing special required here.
            FlameWindowManager.getSingleton().destroyWindow(segment);
        }
        
        
        
    }
}