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

        public function Animation(data:Object, target:MovieClip)
        {
            this.data = data;
            this.target = target;
            ///addEventListener(Event.ADDED_TO_STAGE, init);
        }

        private function bounceComplete(event:TweenEvent) : void
        {
            TweenMax.to(target, 0.5, {scaleX:1, scaleY:1});
            TweenMax.killAll(true);
            this.dispatchEvent(new Event(Event.COMPLETE));
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
            //bounce.addEventListener(TweenEvent.COMPLETE, bounceComplete);
            bounce.addEventListener(TweenEvent.COMPLETE, tweenComplete);
        }

        private function init(event:Event) : void
        {
            return;
        }
    }
}
