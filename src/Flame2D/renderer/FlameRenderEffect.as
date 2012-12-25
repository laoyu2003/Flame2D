/***************************************************************************
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

package Flame2D.renderer
{
    import Flame2D.core.system.FlameRenderingWindow;
    
    public class FlameRenderEffect implements FlameIRenderEffect
    {
        
        public function FlameRenderEffect()
        {
        }

        public function getPassCount():int
        {
            return 0;
        }
            
        public function performPreRenderFunctions(pass:int):void
        {
            
        }
        
        public function performPostRenderFunctions():void
        {
            
        }
        
        public function realiseGeometry(window:FlameRenderingWindow, geometry:FlameGeometryBuffer):void
        {
            
        }
        
        public function update(elapsed:Number, window:FlameRenderingWindow):Boolean
        {
            return false;
        }
        
    }
    
}