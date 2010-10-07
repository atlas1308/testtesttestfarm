package classes.view.components.map
{
    import classes.utils.*;
    
    import flash.display.*;

	/**
	 * 树
	 * 
	 * 最重要的就是spacing 这个值了,是前台显示上的东西
	 */ 
    public class Tree extends CollectObject
    {
        private var shadow:Bitmap;
        private var _spacing:Number;

        public function Tree(value:Object)
        {
            _spacing = value.tree_spacing ? (value.tree_spacing) : (0);
            super(value);
        }

        public function clear_highlight() : void
        {
            if (tree)
            {
                Effects.clear(tree);
            }
        }

        public function get spacing() : Number
        {
            return _spacing;
        }

        override public function apply_rain(a:Number, b:Boolean = false) : void
        {
            start_time = start_time - a * collect_in;
            update_stage();
        }

        public function collect() : void
        {
            start_time = 0;
            start();
            update_stage();
        }

        override protected function update_stage() : void
        {
            if (!bmp)
            {
                return;
            }
            clear_asset();
            asset.addChild(loader.get_bmp_by_frame(6));
            asset.addChild(loader.get_bmp_by_frame(current_stage()));
        }

        override protected function init() : void
        {
            super.init();
        }

        private function get tree() : DisplayObject
        {
            if (asset.numChildren != 2)
            {
                return null;
            }
            return asset.getChildAt(1);
        }

        public function highlight_collect() : void
        {
            if (tree)
            {
                Effects.glow(tree);
            }
        }

    }
}
