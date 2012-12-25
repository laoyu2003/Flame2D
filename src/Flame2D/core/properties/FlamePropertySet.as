

package Flame2D.core.properties
{
    import flash.utils.Dictionary;

    /*!
    \brief
    Class that contains a collection of Property objects.
    */
    public class FlamePropertySet extends Object
    {
        //typedef std::map<String, Property*, String::FastLessCompare>	PropertyRegistry;
        //PropertyRegistry	d_properties;
        private var d_properties:Dictionary = new Dictionary();
        
        
        
        
        /*!
        \brief
        Adds a new Property to the PropertySet
        
        \param property
        Pointer to the Property object to be added to the PropertySet.
        
        \return
        Nothing.
        
        \exception NullObjectException		Thrown if \a property is NULL.
        \exception AlreadyExistsException	Thrown if a Property with the same name as \a property already exists in the PropertySet
        */
        public function addProperty(property:FlameProperty):void
        {
            if (!property)
            {
                throw new Error("The given Property object pointer is invalid.");
            }
            
            if(d_properties.hasOwnProperty(property.getName()))
            {
                throw new Error("A Property named '" + property.getName() + "' already exists in the PropertySet.");
            }
            
            
            d_properties[property.getName()] = property;
            
            property.initialisePropertyReceiver(this);
        }
        
        
        /*!
        \brief
        Removes a Property from the PropertySet.
        
        \param name
        String containing the name of the Property to be removed.  If Property \a name is not in the set, nothing happens.
        
        \return
        Nothing.
        */
        public function removeProperty(name:String):void
        {
            if(d_properties.hasOwnProperty(name))
            {
                delete d_properties[name];
            }
        }
        
        
        /*!
        \brief
        Removes all Property objects from the PropertySet.
        
        \return
        Nothing.
        */
        public function clearProperties():void
        {
            d_properties = new Dictionary();
        }
        
        
        /*!
        \brief
        Checks to see if a Property with the given name is in the PropertySet
        
        \param name
        String containing the name of the Property to check for.
        
        \return
        true if a Property named \a name is in the PropertySet.  false if no Property named \a name is in the PropertySet.
        */
        public function isPropertyPresent(name:String):Boolean
        {
            return d_properties.hasOwnProperty(name);
        }
        
        
        /*!
        \brief
        Return the help text for the specified Property.
        
        \param name
        String holding the name of the Property who's help text is to be returned.
        
        \return
        String object containing the help text for the Property \a name.
        
        \exception UnknownObjectException	Thrown if no Property named \a name is in the PropertySet.
        */
        public function getPropertyHelp(name:String):String
        {
            if(d_properties.hasOwnProperty(name))
            {
                return (d_properties[name] as FlameProperty).getHelp();
            }
            
            return "";
        }
        
        
        /*!
        \brief
        Gets the current value of the specified Property.
        
        \param name
        String containing the name of the Property who's value is to be returned.
        
        \return
        String object containing a textual representation of the requested Property.
        
        \exception UnknownObjectException	Thrown if no Property named \a name is in the PropertySet.
        */
        public function getProperty(name:String):String
        {
            if(! d_properties.hasOwnProperty(name)){
                throw new Error("There is no Property named '" + name + "' available in the set.");
            }
            
            return d_properties[name].getValue(this);
        }
        
        
        /*!
        \brief
        Sets the current value of a Property.
        
        \param name
        String containing the name of the Property who's value is to be set.
        
        \param value
        String containing a textual representation of the new value for the Property
        
        \return
        Nothing
        
        \exception UnknownObjectException	Thrown if no Property named \a name is in the PropertySet.
        \exception InvalidRequestException	Thrown when the Property was unable to interpret the content of \a value.
        */
        public function setProperty(name:String, value:String):void
        {
            if(! d_properties.hasOwnProperty(name))
            {
                throw new Error("There is no Property named '" + name + "' available in the set.");
            }
            
            d_properties[name].setValue(this, value);
        }
        
        
        /*!
        \brief
        Returns whether a Property is at it's default value.
        
        \param name
        String containing the name of the Property who's default state is to be tested.
        
        \return
        - true if the property has it's default value.
        - false if the property has been modified from it's default value.
        */
        public function isPropertyDefault(name:String):Boolean
        {
            if(! d_properties.hasOwnProperty(name))
            {
                throw new Error("There is no Property named '" + name + "' available in the set.");
            }
            
            //to be checked
            return d_properties[name].isDefault(this);
        }
        
        
        /*!
        \brief
        Returns the default value of a Property as a String.
        
        \param name
        String containing the name of the Property who's default string is to be returned.
        
        \return
        String object containing a textual representation of the default value for this property.
        */
        public function getPropertyDefault(name:String):String
        {
            if(! d_properties.hasOwnProperty(name))
            {
                throw new Error("There is no Property named '" + name + "' available in the set.");
            }
            
            return d_properties[name].getDefault(this);
        }

    }
    
    

}