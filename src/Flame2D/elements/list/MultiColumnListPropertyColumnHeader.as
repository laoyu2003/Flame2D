/*!
\brief
Property to access a column.

\par Usage:
- Name: ColumnHeader
- Format: "text:[caption] width:{s,o} id:[uint]"

\par where:
- [caption] is the column header caption text.
- [{s,o}] is a UDim specification.
- [uint] is the unique ID for the column.
*/
package Flame2D.elements.list
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    import Flame2D.core.utils.TextUtils;
    
    public class MultiColumnListPropertyColumnHeader extends FlameProperty
    {
        public function MultiColumnListPropertyColumnHeader()
        {
            super(
                "ColumnHeader",
                "Property to set up a column (there is no getter for this property)",
                "");
        }
        
        
        override public function getValue(receiver:*):String
        {
            return "";
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            var idstart:int = value.lastIndexOf("id:");
            var wstart:int = value.lastIndexOf("width:");
            var capstart:int = value.lastIndexOf("text:");
            
            // some defaults in case of missing data
            var caption:String;
            var id:String = "0";
            var width:String = "{0.33,0}";
            
            // extract the caption field
            if (capstart != -1)
            {
                capstart = TextUtils.find_first_of(value, ":") + 1;
                
                if (wstart == -1)
                {
                    if (idstart == -1)
                        caption = value.substr(capstart);
                    else
                        caption = value.substr(capstart, idstart - capstart);
                }
                else
                {
                        caption = value.substr(capstart, wstart - capstart);
                }
                
                // trim trailing whitespace
                TextUtils.trimTrailingChars(caption, TextUtils.DefaultWhitespace);
            }
            
            // extract the width field
            if (wstart != -1)
            {
                width = value.substr(wstart);
                width = width.substr(TextUtils.find_first_of(width, "{"));
                width = width.substr(0, TextUtils.find_last_of(width, "}") + 1);
            }
            
            // extract the id field.
            if (idstart != -1)
            {
                id = value.substr(idstart);
                id = id.substr(TextUtils.find_first_of(id, ":") + 1);
            }
            
            // add the column accordingly
            (receiver as FlameMultiColumnList).addColumn(
                caption, FlamePropertyHelper.stringToUint(id), FlamePropertyHelper.stringToUDim(width));
        }

    }
}