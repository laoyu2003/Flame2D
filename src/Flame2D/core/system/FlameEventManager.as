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
package Flame2D.core.system
{
    import Flame2D.core.data.Consts;
    import Flame2D.core.utils.Vector2;
    import Flame2D.renderer.FlameRenderer;
    
    import flash.display.Stage;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.FocusEvent;
    import flash.events.IMEEvent;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.events.TextEvent;
    import flash.events.TimerEvent;
    import flash.system.Capabilities;
    import flash.system.IME;
    import flash.system.IMEConversionMode;
    import flash.system.System;
    import flash.text.TextField;
    import flash.text.TextFieldType;
    import flash.utils.Timer;
    import flash.utils.getTimer;
    
    import org.osmf.events.TimeEvent;
    
    public class FlameEventManager extends EventDispatcher
    {
        private static const IME_OFFSETX:Number = 0;
        private static const IME_OFFSETY:Number = 30;
        
        private var d_stage:Stage;
        
        private var d_leftButtonDown:Boolean = false;
        private var d_lastPointX:Number = 0;
        private var d_lastPointY:Number = 0;
        
        //a timer to inject time pulse
        private var d_timer:Timer;
        
        //a textfield to accept input
        private var d_input:TextField; 
        
        private static var d_singleton:FlameEventManager = new FlameEventManager();

        
        public function FlameEventManager()
        {
            if(d_singleton){
                throw new Error("FlameEventManager: can only be accessed via singleton");
            }
        }
        
        public static function getSingleton():FlameEventManager
        {
            return d_singleton;
        }
        
        public function initialize(stage:Stage):void
        {
            d_stage = stage;
            
//            if (Capabilities.hasIME)
//            {
//                IME.enabled = true;
//                try
//                {
//                    IME.conversionMode = IMEConversionMode.CHINESE;
//                }
//                catch (error:Error)
//                {
//                    trace("Unable to change IME.");
//                }
//                System.ime.addEventListener(IMEEvent.IME_COMPOSITION, imeCompositionHandler);
//            }
//            else
//            {
//                trace("Please install IME");
//            }
//           
            d_input = new TextField(); 
            d_input.type = TextFieldType.INPUT; 
            d_input.width = 128; 
            d_input.height = 24; 
            d_input.border = false; 
            d_input.background = false; 
            //make the textfiled invisible
            d_input.alpha = 0;
//            d_input.background = true;
//            d_input.backgroundColor = 0x0000FF;
            d_input.textColor = 0x00FF00;
            //focus on the textfield
            d_stage.focus = null;

            d_stage.addChild(d_input); 
            d_input.addEventListener(TextEvent.TEXT_INPUT, onTextInput);
            d_input.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
            d_input.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
            //d_input.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);

            // register event handlers
            // the events will be injected to FlameEventManager
            //d_stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false, 0, true);
            //d_stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp, false, 0, true);
            d_stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false, 0, true);
            d_stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, false, 0, true);
            d_stage.addEventListener(MouseEvent.CLICK, onMouseClick, false, 0, true);
            d_stage.addEventListener(MouseEvent.DOUBLE_CLICK, onMouseDblClick, false, 0, true);
            d_stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false, 0, true);
            d_stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel, false, 0, true);
//            d_stage.addEventListener(Event.RESIZE, onResize, false, 0, true);
            //touch event
            //to do
            
            //timer to inject
            d_timer = new Timer(100);
            d_timer.addEventListener(TimerEvent.TIMER, onTimeClick); 
            d_timer.start();
        }
        
//        private function imeCompositionHandler(event:IMEEvent):void
//        {
//            trace("=============Your input is:" + event.text);
//        }
//        
        private function onTimeClick(event:TimerEvent):void
        {
            FlameSystem.getSingleton().injectTimePulse(0.1);
        }
        
        public function enableInput(setting:Boolean):void
        {
            if(setting)
            {
                d_stage.focus = d_input;
            }
            else
            {
                d_stage.focus = null;
            }
        }
        
        public function moveIMEWindowTo(xp:Number, yp:Number):void
        {
            d_input.x = xp + IME_OFFSETX;
            d_input.y = yp + IME_OFFSETY;
        }
        
        private function onTextInput(event:TextEvent):void
        {
            //clear the text field
            d_input.text = "";
            
            var text:String = event.text;
            
            for(var i:uint=0; i<event.text.length; i++)
            {
                FlameSystem.getSingleton().injectChar(event.text.charCodeAt(i));
            }
            
        }
        
        private function onKeyDown(event:KeyboardEvent):void
        {
            trace("==== key down: keycode:" + event.keyCode.toString(16) + " charcode:" + event.charCode.toString());
            FlameSystem.getSingleton().injectKeyDown(event.keyCode);

            
//            trace("==== key down: keycode:" + event.keyCode.toString(16) + " charcode:" + event.charCode.toString());
//            if(isValidCharCode(event.keyCode))
//                FlameSystem.getSingleton().injectChar(event.charCode);
//            else
//                FlameSystem.getSingleton().injectKeyDown(event.keyCode);
        }
        
        private function isValidCharCode(charCode:uint):Boolean
        {
            if((charCode >= Consts.Key_A && charCode <= Consts.Key_Z) || 
                charCode == Consts.Key_Space ||
                (charCode >= Consts.Key_0 && charCode <= Consts.Key_9) ||
                (charCode >= Consts.Key_Numpad0 && charCode <= Consts.Key_NumpadDivide) ||
                charCode >= Consts.Key_Semicolon)
                return true;
            return false;
        }
        
        private function onKeyUp(event:KeyboardEvent):void
        {
            FlameSystem.getSingleton().injectKeyUp(event.keyCode);
        }
        
        private function onMouseDown(event:MouseEvent):void
        {
            var wnd:FlameWindow = FlameSystem.getSingleton().getTargetWindow(new Vector2(event.stageX, event.stageY), false);
            if(wnd && wnd.isMousePassThroughEnabled())
            {
                trace("Mouse down event at " + event.stageX + "," + event.stageY + " to game system");
                return;
            }
            
            FlameSystem.getSingleton().injectMouseButtonDown(Consts.MouseButton_LeftButton);
            d_lastPointX = event.stageX;
            d_lastPointY = event.stageY;
            d_leftButtonDown = true;
        }
        
        private function onMouseUp(event:MouseEvent):void
        {
            FlameSystem.getSingleton().injectMouseButtonUp(Consts.MouseButton_LeftButton);
            d_leftButtonDown = false;
        }
        
        private function onMouseClick(event:MouseEvent):void
        {
            FlameSystem.getSingleton().injectMouseButtonClick(Consts.MouseButton_LeftButton);
        }
        
        private function onMouseDblClick(event:MouseEvent):void
        {
            FlameSystem.getSingleton().injectMouseButtonDoubleClick(Consts.MouseButton_LeftButton);
        }
        
        private function onMouseMove(event:MouseEvent):void
        {
            //trace("in ject mouse move :" + event.stageX + "," + event.stageY);
            FlameSystem.getSingleton().injectMousePosition(event.stageX, event.stageY);
            //if(d_leftButtonDown)
//            {
//                var mx:Number = event.stageX;
//                var my:Number = event.stageY;
//                FlameSystem.getSingleton().injectMouseMove(mx - d_lastPointX, my - d_lastPointY);
//                d_lastPointX = mx;
//                d_lastPointY = my;
//            }
        }
        
        private function onMouseWheel(event:MouseEvent):void
        {
            FlameSystem.getSingleton().injectMouseWheelChange(event.delta);
        }
        
        //on resized...the main program configure the backbuffer size
        //this function will reset projection matrix
//        private function onResize(event:flash.events.Event):void
//        {
//            FlameRenderer.getSingleton().onResize();
//        }
        
        public function dispose():void
        {
            d_stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false);
            d_stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp, false);
            d_stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false);
            d_stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp, false);
            d_stage.addEventListener(MouseEvent.CLICK, onMouseClick, false, 0, true);
            d_stage.addEventListener(MouseEvent.DOUBLE_CLICK, onMouseDblClick, false, 0, true);
            d_stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false);
            d_stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel, false);
//            d_stage.removeEventListener(Event.RESIZE, onResize, false);
            
            d_timer.stop();
            d_timer.removeEventListener(TimerEvent.TIMER, onTimeClick);
        }
        

    }
}