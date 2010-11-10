package classes.view.components.achievements
{
    import classes.utils.*;
    
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;

    public class Achievement extends Sprite
    {
        public var ribbon3:MovieClip;
        public var ribbon4:MovieClip;
        public var ribbon5:MovieClip;
        private var cache:Cache;
        public var image:MovieClip;
        public var desc:TextField;
        private var data:Object;
        public var ribbon1:MovieClip;
        public var ribbon2:MovieClip;
        public var title:TextField;

        public function Achievement(value:Object)
        {
            this.data = value;
            init();
        }

        private function imageLoaded(event:Event) : void
        {
            /* var _loc_2:* = event.target.asset as Bitmap;
            image.addChild(_loc_2); */
        }

        public function kill() : void
        {
            /* parent.removeChild(this);
            return; */
        }

        private function init() : void
        {
            /* title.text = data.name;
            desc.text = data.desc;
            cache = new Cache();
            cache.addEventListener(Cache.LOAD_COMPLETE, imageLoaded);
            cache.load(data.image);
            var _loc_1:Number = 1;
            while (_loc_1++ <= 5)
            {
                
                if (_loc_1 <= data.ribbon)
                {
                    this["ribbon" + _loc_1].gotoAndStop(2);
                    continue;
                }
                this["ribbon" + _loc_1].gotoAndStop(1);
            } */
        }

    }
}
