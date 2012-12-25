
package Flame2D.core.data
{
    import flash.display3D.textures.Texture;

    public class BatchInfo
    {
        public var texture:Texture;
        public var length:uint;
        
        public function BatchInfo(_texture:Texture, _length:uint)
        {
            this.texture = _texture;
            this.length = _length;
        }
    }
}