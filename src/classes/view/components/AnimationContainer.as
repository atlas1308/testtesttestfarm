package classes.view.components
{
    import flash.display.*;

    public class AnimationContainer extends Sprite
    {
        private var target:MovieClip;

        public function AnimationContainer(value:MovieClip)
        {
            this.target = value;
        }

        public function show(value:Object) : void
        {
        	var index:int = Math.max(0,this.parent.numChildren - 1);
            this.parent.setChildIndex(this, index);
            var animation:Animation = new Animation(value, target);
            addChild(animation);
            animation.start();
        }

    }
}
