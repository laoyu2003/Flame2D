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
    import Flame2D.core.animations.BoolInterpolator;
    import Flame2D.core.animations.ColourInterpolator;
    import Flame2D.core.animations.ColourRectInterpolator;
    import Flame2D.core.animations.FlameAffector;
    import Flame2D.core.animations.FlameAnimation;
    import Flame2D.core.animations.FlameAnimationInstance;
    import Flame2D.core.animations.FloatInterpolator;
    import Flame2D.core.animations.IntInterpolator;
    import Flame2D.core.animations.Interpolator;
    import Flame2D.core.animations.PointInterpolator;
    import Flame2D.core.animations.RectInterpolator;
    import Flame2D.core.animations.SizeInterpolator;
    import Flame2D.core.animations.StringInterpolator;
    import Flame2D.core.animations.UBoxInterpolator;
    import Flame2D.core.animations.UDimInterpolator;
    import Flame2D.core.animations.URectInterpolator;
    import Flame2D.core.animations.UVector2Interpolator;
    import Flame2D.core.animations.UintInterpolator;
    import Flame2D.core.animations.Vector3Interpolator;
    import Flame2D.core.data.Consts;
    import Flame2D.core.properties.FlamePropertyHelper;
    import Flame2D.core.utils.MultiMap;
    import Flame2D.loaders.TextFileLoader;
    
    import flash.utils.Dictionary;

    public class FlameAnimationManager
    {

        
        //typedef std::map<String, Interpolator*> InterpolatorMap;
        //! stores available interpolators
        //InterpolatorMap d_interpolators;
        private var d_interpolators:Dictionary = new Dictionary();
        
        //typedef std::vector<Interpolator*> BasicInterpolatorList;
        //! stores interpolators that are inbuilt in CEGUI
        //BasicInterpolatorList d_basicInterpolators;
        private var d_basicInterpolators:Vector.<Interpolator> = new Vector.<Interpolator>();
        
        //typedef std::map<String, Animation*> AnimationMap;
        //! all defined animations
        //AnimationMap d_animations;
        private var d_animations:Dictionary = new Dictionary();
        
        
        //typedef std::multimap<Animation*, AnimationInstance*> AnimationInstanceMap;
        //! all instances of animations
        //AnimationInstanceMap d_animationInstances;
        private var d_animationInstances:MultiMap = new MultiMap();
        
        
        //! Name of the schema used for loading animation xml files.
        //static const String s_xmlSchemaName;
        //! Default resource group used when loading animation xml files.
        private static var s_defaultResourceGroup:String;
        //! Base name to use for generated window names.
        private static const GeneratedAnimationNameBase:String = "__ceanim_uid_";
        //! Counter used to generate unique animation names.
        private var d_uid_counter:uint = 0;
        
        private static var d_singleton:FlameAnimationManager = new FlameAnimationManager();
        
        public function FlameAnimationManager()
        {
            if(d_singleton)
            {
                throw new Error("FlameAnimationManager, only access via singleton");
            }
            initialize();
        }
        
        
        public function dispose():void
        {
//            // first we remove & destroy remaining animation instances
//            for (AnimationInstanceMap::const_iterator it = d_animationInstances.begin();
//                it != d_animationInstances.end(); ++it)
//            {
//                delete it->second;
//            }
            
            d_animationInstances.removeAll();
            
            // then we remove & destroy animation definitions
//            for (AnimationMap::const_iterator it = d_animations.begin();
//                it != d_animations.end(); ++it)
//            {
//                delete it->second;
//            }
            
            d_animations = null;
            
            // and lastly, we remove all interpolators, but we don't delete them!
            // it is the creator's responsibility to delete them
            d_interpolators = null;
            
            // we only destroy inbuilt interpolators
//            for (BasicInterpolatorList::const_iterator it = d_basicInterpolators.begin();
//                it != d_basicInterpolators.end(); ++it)
//            {
//                delete *it;
//            }
            
            d_basicInterpolators = null;
            
            trace("CEGUI::AnimationManager singleton destroyed.");
        }
        
        
        public static function getSingleton():FlameAnimationManager
        {
            return d_singleton;
        }
        
        
        /*************************************************************************
         Construction and Destruction
         *************************************************************************/
        /*!
        \brief
        Constructs a new AnimationManager object.
        
        NB: Client code should not create AnimationManager objects - they are of
        limited use to you!  The intended pattern of access is to get a pointer
        to the GUI system's AnimationManager via the System object, and use
        that.
        */
        public function initialize():void
        {
            // create and add basic interpolators shipped with CEGUI
            addBasicInterpolator(new StringInterpolator());
            addBasicInterpolator(new FloatInterpolator());
            addBasicInterpolator(new IntInterpolator());
            addBasicInterpolator(new UintInterpolator());
            addBasicInterpolator(new BoolInterpolator());
            addBasicInterpolator(new SizeInterpolator());
            addBasicInterpolator(new PointInterpolator());
            addBasicInterpolator(new Vector3Interpolator());
            addBasicInterpolator(new RectInterpolator());
            addBasicInterpolator(new ColourInterpolator());
            addBasicInterpolator(new ColourRectInterpolator());
            addBasicInterpolator(new UDimInterpolator());
            addBasicInterpolator(new UVector2Interpolator());
            addBasicInterpolator(new URectInterpolator());
            addBasicInterpolator(new UBoxInterpolator());
        }
        
        //#   define addBasicInterpolator(i) { Interpolator* in = i; addInterpolator(in); d_basicInterpolators.push_back(in); }
        private function addBasicInterpolator(i:*):void
        {
            var interpolator:Interpolator = i as Interpolator;
            addInterpolator(interpolator);
            d_basicInterpolators.push(interpolator);
        }

        /*!
        \brief
        Adds interpolator to be available for Affectors
        
        \par
        CEGUI ships with several basic interpolators that are always available,
        float, bool, colour, UDim, UVector2, ... but you can add your own
        custom interpolator if needed! just note that AnimationManager only
        deletes inbuilt interpolators. It will remove your interpolator if you
        don't do it yourself, but you definitely have to delete it yourself!
        */
        public function addInterpolator(interpolator:Interpolator):void
        {
            if(d_interpolators.hasOwnProperty(interpolator.getType()))
            {
                throw new Error(
                    "AnimationManager::addInterpolator: Interpolator of given type " +
                    "already exists.");
            }
            
            d_interpolators[interpolator.getType()] = interpolator;
        }
        
        /*!
        \brief
        Removes interpolator
        */
        public function removeInterpolator(interpolator:Interpolator):void
        {
            if(!d_interpolators.hasOwnProperty(interpolator.getType()))
            {
                throw new Error(
                    "AnimationManager::removeInterpolator: Interpolator of given type " +
                    "not found.");
            }
            
            delete d_interpolators[interpolator.getType()];
        }
        
        /*!
        \brief
        Retrieves interpolator by type
        */
        public function getInterpolator(type:String):Interpolator
        {
            if(! d_interpolators.hasOwnProperty(type))
            {
                throw new Error(
                    "AnimationManager::getInterpolator: Interpolator of given type " +
                    "not found.");
            }
            
            return d_interpolators[type];
        }
        
        /*!
        \brief
        Creates a new Animation definition
        
        \see
        Animation
        */
        public function createAnimation(name:String = ""):FlameAnimation
        {
            if (isAnimationPresent(name))
            {
                throw new Error(
                    "AnimationManager::createAnimation: Animation with given name " +
                    "already exists.");
            }
            
            var finalName:String = (name.length == 0 ?  generateUniqueAnimationName() : name);
            
            var ret:FlameAnimation = new FlameAnimation(finalName);
            d_animations[finalName] = ret;
            
            return ret;
        }
        
        /*!
        \brief
        Destroys given animation definition
        */
        public function destroyAnimation(animation:FlameAnimation):void
        {
            destroyAnimationByName(animation.getName());
        }
        
        /*!
        \brief
        Destroys given animation definition by name
        */
        public function destroyAnimationByName(name:String):void
        {
            if(! d_animations.hasOwnProperty(name))
            {
                throw new Error(
                    "AnimationManager::destroyAnimation: Animation with given name not " +
                    "found.");
            }
            
            var animation:FlameAnimation = d_animations[name];
            destroyAllInstancesOfAnimation(animation);
            
            delete d_animations[name];
            animation = null;
        }
        
        /*!
        \brief
        Retrieves animation by name
        */
        public function getAnimation(name:String):FlameAnimation
        {
            if(! d_animations.hasOwnProperty(name))
            {
                throw new Error(
                    "AnimationManager::getAnimation: Animation with given name not " +
                    "found.");
            }
            
            return d_animations[name];
        }
        
        /*!
        \brief
        Retrieves animation by index
        */
//        public function getAnimationAtIdx(index:uint):FlameAnimation
//        {
//            if (index >= d_animations.size())
//            {
//                CEGUI_THROW(InvalidRequestException(
//                    "AnimationManager::getAnimationAtIdx: Out of bounds."));
//            }
//            
//            AnimationMap::const_iterator it = d_animations.begin();
//            std::advance(it, index);
//            
//            return it->second;
//        }
        
        /*!
        \brief
        Retrieves number of defined animations
        */
        public function getNumAnimations():uint
        {
            var count:uint=0;
            for each(var obj:* in d_animations)
            {
                count ++;
            }
            
            return count;
        }
        
        /*!
        \brief
        Instantiates given animation
        
        \see
        AnimationInstance
        */
        public function instantiateAnimation(animation:FlameAnimation):FlameAnimationInstance
        {
            var ret:FlameAnimationInstance = new FlameAnimationInstance(animation);
            d_animationInstances.insertVal(animation, ret);
            
            return ret;
        }
        
        /*!
        \brief
        Instantiates given animation by name
        
        \see
        AnimationInstance
        */
        public function instantiateAnimationByName(name:String):FlameAnimationInstance
        {
            return instantiateAnimation(getAnimation(name));
        }
        
        /*!
        \brief
        Destroys given animation instance
        */
        public function destroyAnimationInstance(instance:FlameAnimationInstance):void
        {
            d_animationInstances.removeVal(instance);
//            
//            CEGUI_THROW(InvalidRequestException(
//                "AnimationManager::destroyAnimationInstance: Given animation instance "
//                "not found."));
        }
        
        /*!
        \brief
        Destroys all instances of given animation
        */
        public function destroyAllInstancesOfAnimation(animation:FlameAnimation):void
        {
            d_animationInstances.removeKey(animation);
//            AnimationInstanceMap::iterator it = d_animationInstances.find(animation);
//            
//            // the first instance of given animation is now it->second (if there is any)
//            while (it != d_animationInstances.end() && it->first == animation)
//            {
//                AnimationInstanceMap::iterator toErase = it;
//                ++it;
//                
//                delete toErase->second;
//                d_animationInstances.erase(toErase);
//            }
        }
        
        /*!
        \brief
        Retrieves animation instance at given index
        */
        //AnimationInstance* getAnimationInstanceAtIdx(size_t index) const;
        
        /*!
        \brief
        Retrieves number of animation instances, number of times any animation
        was instantiated.
        */
        public function getNumAnimationInstances():uint
        {
            return d_animationInstances.countAllVals();
        }
        
        /*!
        \brief
        Internal method, gets called by CEGUI::System automatically.
        
        Only use if you know what you're doing!
        */
        public function stepInstances(delta:Number):void
        {
//            for (AnimationInstanceMap::const_iterator it = d_animationInstances.begin();
//                it != d_animationInstances.end(); ++it)
//            {
//                it->second->step(delta);
//            }
        }
        
        /*!
        \brief
        Parses an XML file containing animation specifications to create
        and initialise Animation objects.
        
        \param filename
        String object holding the filename of the XML file to be processed.
        
        \param resourceGroup
        Resource group identifier to be passed to the resource provider when
        loading the XML file.
        */
        public function loadAnimationsFromFile(filename:String, resourceGroup:String = "", callback:Function = null):void
        {
            var url:String = FlameResourceProvider.getSingleton().getResourceDir() + 
                FlameResourceProvider.getSingleton().getAnimateDir() + 
                filename;
            
            new TextFileLoader({name:filename}, url, onAnimationLoaded);
        }
        
        private function onAnimationLoaded(tag:Object, str:String):void
        {
            loadAnimationFromString(str);
        }
        
        public function loadAnimationFromString(str:String, resourceGroup:String = ""):void
        {
            var xml:XML = new XML(str);
            
            //parse xml file
            var nodes:XMLList = xml.AnimationDefinition;
            var node:XML;
            for each(node in nodes)
            {
                var name:String = xml.@name.toString();
                var anim:FlameAnimation = createAnimation(name);
                anim.parseXML(node);
            }
        }
        

        /*!
        \brief
        Sets the default resource group to be used when loading animation xml
        data
        
        \param resourceGroup
        String describing the default resource group identifier to be used.
        */
        public static function setDefaultResourceGroup(resourceGroup:String):void
        {
            s_defaultResourceGroup = resourceGroup;
        }
        
        /*!
        \brief
        Returns the default resource group currently set for loading animation
        xml data.
        
        \return
        String describing the default resource group identifier that will be
        used when loading Animation xml data.
        */
        public static function getDefaultResourceGroup():String
        {
            return s_defaultResourceGroup;
        }
        
        /*!
        \brief
        Examines the list of Animations to see if one exists with the given name
        
        \param name
        String holding the name of the Animation to look for.
        
        \return
        true if an Animation was found with a name matching \a name.  false if
        no matching Animation was found.
        */
        public function isAnimationPresent(name:String):Boolean
        {
            return d_animations.hasOwnProperty(name);
        }
        
        
        private function generateUniqueAnimationName():String
        {
            // build name
            var uidname:String = GeneratedAnimationNameBase + d_uid_counter;
            
            // update counter for next time
            var old_uid:uint = d_uid_counter;
            ++d_uid_counter;
            
            // log if we ever wrap-around (which should be pretty unlikely)
            if (d_uid_counter < old_uid)
                trace("UID counter for generated Animation " +
                    "names has wrapped around - the fun shall now commence!");
            
            // return generated name as a CEGUI::String.
            return uidname;
        }
        

    }
}