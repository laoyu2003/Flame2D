
package Flame2D.core.effects
{
    import Flame2D.renderer.FlameRenderEffect;

    /*!
    \brief
    Interface for factory objects that create RenderEffect instances.
    Currently this interface is intended for internal use only.
    */
    public class FlameRenderEffectFactory
    {
        private var d_class:Class;
        
        
        public function FlameRenderEffectFactory(factoryClass:Class)
        {
            d_class = factoryClass;
        }
        

        public function create():*
        {
            return new d_class();
        }

        public function destroy(effect:FlameRenderEffect):void
        {
            
        }
        
    }
}