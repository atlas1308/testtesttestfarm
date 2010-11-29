package classes.view.components
{
    import flash.display.*;

    public class Overlay extends Sprite
    {
        private var loader:*;
        private var color:Number = 0;
        private var _alpha:Number = 0.3;

        public function Overlay()
        {
            visible = false;
        }

        public function draw(isLoginUser:Boolean = false, color:Number = 0, _alpha:Number = 0.3, showLogoLoading:Boolean = false) : void
        {
            this.color = color;
            this._alpha = _alpha;
            if (isLoginUser)
            {
                loader = new FarmLoading();//new Loader();
                if(loader){
	                addChild(loader);
	                loader.visible = true;
	                loader.play();
                }
            }
            else
            {
                remove_loader();
            }
            refresh();
            visible = true;
        }

        private function remove_loader() : void
        {
            if (loader)
            {
                removeChild(loader);
                loader = null;
            }
        }

        public function hide() : void
        {
            visible = false;
            remove_loader();
        }

        public function refresh() : void
        {
            if (loader)
            {
                loader.x = stage.stageWidth / 2;
            	loader.y = stage.stageHeight / 2;
            }
            graphics.clear();
            graphics.beginFill(color, _alpha);
            graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
            graphics.endFill();
        }

    }
}
