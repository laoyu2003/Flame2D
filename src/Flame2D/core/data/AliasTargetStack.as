
package Flame2D.core.data
{

    /*!
    \brief
    Class used to track active alias targets for Window factory types.
    */
    public class AliasTargetStack
    {
        
        //typedef std::vector<String>	TargetTypeStack;		//!< Type used to implement stack of target type names.
        
        //TargetTypeStack	d_targetStack;		//!< Container holding the target types.

        public var d_targetStack:Vector.<String> = new Vector.<String>();
        
        /*!
        \brief
        Constructor for WindowAliasTargetStack objects
        */
        public function AliasTargetStack()
        {
            
        }
        
        //////////////////////////////////////////////////////////////////////////
        /*************************************************************************
         Methods for AliasTargetStack class
         *************************************************************************/
        //////////////////////////////////////////////////////////////////////////
        public function getActiveTarget():String
        {
            if(d_targetStack.length > 0){
                return d_targetStack[d_targetStack.length-1];
            } else {
                return "";
            }
        }
        
        
        public function getStackedTargetCount():uint
        {
            return d_targetStack.length
        }

        
    }
}