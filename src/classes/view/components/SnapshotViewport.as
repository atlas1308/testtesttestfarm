package classes.view.components
{
    import classes.view.components.buttons.*;
    
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;

    public class SnapshotViewport extends Sprite
    {
        private var container:Sprite;
        private var _h:Number = 403;
        private var _viewfinder:MovieClip;
        private var _mask:Sprite;
        private var _w:Number = 604;
        public const TAKE_PHOTO:String = "takePhoto";

        public function SnapshotViewport()
        {
            addEventListener(Event.ADDED_TO_STAGE, addedToStage);
            this.init();
        }

        private function addedToStage(event:Event) : void
        {
            return;
        }

        public function stop() : void
        {
            visible = false;
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
            stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
        }

        private function onMouseDown(event:MouseEvent) : void
        {
            stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
        }

        public function get rectangle() : Rectangle
        {
            return new Rectangle(container.x, container.y, _w, _h);
        }

        public function start() : void
        {
            visible = true;
            stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
            stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            onMouseMove();
        }

        private function init() : void
        {
            container = new Sprite();
            _viewfinder = new viewfinder();
            _mask = new Sprite();
            addChild(container);
            container.addChild(_viewfinder);
            var scale:Number = _h / _viewfinder.height;
            _viewfinder.scaleY = scale;
            _viewfinder.scaleX = scale;
            _viewfinder.x = (_w - _viewfinder.width) / 2;
            _viewfinder.mask = _mask;
            container.graphics.lineStyle(3, 15588285, 1);
            container.graphics.beginFill(0, 0);
            container.graphics.drawRoundRect(0, 0, _w, _h, 10);
            container.graphics.endFill();
            _mask.graphics.lineStyle(3, 15588285, 1);
            _mask.graphics.beginFill(0, 1);
            _mask.graphics.drawRect(0, 0, _w - 6, _h - 6);
            _mask.graphics.endFill();
            _mask.x = 3;
            _mask.y = 3;
            container.addChild(_mask);
            visible = false;
            mouseEnabled = false;
            mouseChildren = false;
        }

        private function onMouseUp(event:MouseEvent) : void
        {
            if (event.target as GameButton)
            {
                return;
            }
            dispatchEvent(new Event(TAKE_PHOTO));
        }

        private function onMouseMove(event:MouseEvent = null) : void
        {
            container.x = mouseX - _w / 2;
            container.y = mouseY - _h / 2;
            if (container.x < 0)
            {
                container.x = 0;
            }
            if (container.x + _w > stage.stageWidth)
            {
                container.x = stage.stageWidth - _w;
            }
            if (container.y < 0)
            {
                container.y = 0;
            }
            if (container.y + _h > stage.stageHeight)
            {
                container.y = stage.stageHeight - _h;
            }
            stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
        }

    }
}
