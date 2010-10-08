package classes.view.components.map
{
    import flash.display.*;

    public class Fence extends Decoration
    {
        private var _hide_second_post:Boolean = false;
        private var post1:Bitmap;
        private var post2:Bitmap;
        private var _hide_first_post:Boolean = false;
        private var rail:Bitmap;

        public function Fence(value:Object)
        {
            super(value);
        }

        override protected function init_asset() : void
        {
            if (!bmp)
            {
                return;
            }
            clear_asset();
            post1 = loader.get_bmp_by_frame(1);
            post2 = loader.get_bmp_by_frame(3);
            rail = loader.get_bmp_by_frame(2);
            asset.addChild(post1);
            asset.addChild(rail);
            asset.addChild(post2);
            if (_hide_first_post)
            {
                post1.visible = false;
            }
            if (_hide_second_post)
            {
                post2.visible = false;
            }
        }

        public function hide_first_post() : void
        {
            _hide_first_post = true;
            if (!bmp)
            {
                return;
            }
            post1.visible = false;
            return;
        }

        public function hide_second_post() : void
        {
            _hide_second_post = true;
            if (!bmp)
            {
                return;
            }
            post2.visible = false;
            return;
        }

        public function show_posts() : void
        {
            if (!bmp)
            {
                return;
            }
            post1.visible = true;
            post2.visible = true;
            return;
        }

    }
}
