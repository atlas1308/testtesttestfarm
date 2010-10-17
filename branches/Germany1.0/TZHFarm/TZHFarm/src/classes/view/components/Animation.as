package classes.view.components
{
    import classes.utils.*;
    
    import com.greensock.TweenMax;
    import com.greensock.events.TweenEvent;
    
    import fl.transitions.easing.Bounce;
    
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    

    public class Animation extends Sprite
    {
        private var bounce:TweenMax;
        private var data:Object;
        private var tween:TweenMax;
        private var target:MovieClip;
        private var loader:Cache;
        private var image:Loader;

        public function Animation(param1:Object, param2:MovieClip)
        {
            this.data = param1;
            this.target = param2;
            addEventListener(Event.ADDED_TO_STAGE, init);
        }

        private function bounceComplete(event:TweenEvent) : void
        {
            TweenMax.to(target, 0.5, {scaleX:1, scaleY:1});
            return;
        }

        private function tweenComplete(event:TweenEvent) : void
        {
            bounce = TweenMax.to(target, 0.5, {scaleX:1.2, scaleY:1.2, ease:Bounce.easeOut});
            bounce.addEventListener(TweenEvent.COMPLETE, bounceComplete);
            parent.removeChild(this);
        }

        public function start() : void
        {
            bounce = TweenMax.to(target, 0.5, {scaleX:1.2, scaleY:1.2, ease:Bounce.easeOut});
            bounce.addEventListener(TweenEvent.COMPLETE, bounceComplete);
        }

        private function init(event:Event) : void
        {
            return;
        }

        private function loadComplete(event:Event) : void
        {
            /* image = event.target.loader;
            addChild(image);
            image.x = data.x;
            image.y = data.y;
            var _loc_2:* = target.localToGlobal(new Point(0, 0));
            var _loc_3:* = new Point(_loc_2.x, image.y);
            tween = TweenMax.to(image, 0.5, {bezier:[{x:_loc_3.x, y:_loc_3.y}, {x:_loc_2.x, y:_loc_2.y}], ease:Quad.easeIn});
            tween.addEventListener(TweenEvent.COMPLETE, tweenComplete);
            return; */
        }

    }
}
