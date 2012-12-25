//
//package Flame2D.core.system
//{
//    
//    /*!
//    \brief
//    Base class encapsulating a type name and common parts of WindowRenderer
//    factory registration.
//    */
//    public class FlameWRFactoryRegisterer
//    {
//        
//        //! describes the WindowRenderer type this class registers a factory for.
//        //const CEGUI::utf8* d_type;
//        private var d_type:String;
//        
//        
//        public function FlameWRFactoryRegisterer(type:String)
//        {
//            d_type = type;
//        }
//        
//        
//        
//        /*!
//        \brief
//        Perform registration (addition) of the factory for whichever
//        WindowRenderer type this class registers a factory for.
//        */
//        public function registerFactory():void
//        {
//            /*
//            if (FlameWindowRendererManager.getSingleton().isFactoryPresent(d_type))
//                CEGUI::Logger::getSingleton().logEvent(
//                    "Factory for '" + CEGUI::String(d_type) +
//                    "' appears to be  already registered, skipping.",
//                    CEGUI::Informative);
//            else
//                this->doFactoryAdd();
//
//            */
//        }
//        
//        /*!
//        \brief
//        Perform unregistration (removal) of the factory for whichever
//        WindowRenderer type this class registers a factory for.
//        */
//        public function unregisterFactory():void
//        {
//           // WindowRendererManager::getSingleton().removeFactory(d_type);
//        }
//        
//        
//    }
//}