
package Flame2D.core.events
{
    import Flame2D.core.animations.FlameAnimationInstance;

    public class AnimationEventArgs extends EventArgs
    {
        //! pointer to a AnimationInstance object of relevance to the event.
        public var instance:FlameAnimationInstance;

        public function AnimationEventArgs(inst:FlameAnimationInstance)
        {
            instance = inst;
        }
    }
}