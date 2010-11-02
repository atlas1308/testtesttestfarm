package classes.view.components.popups {
    import flash.events.*;
    import classes.utils.*;
    import flash.display.*;
    import flash.text.*;
	
	/**
	 * 到好友家里弹出的好友的是否给好友的土地浇水的面板 
	 */
    public class BasicPopup extends Sprite implements IPopup {

        public const ON_ACCEPT:String = "onAccept";
        public const ON_CLOSE:String = "onClose";

        protected var message:String;
        protected var msg_box:TextField;
        protected var overlay:Sprite;
        protected var close_btn:Sprite;
        protected var accept_btn:Sprite;
        protected var corner_close_btn:Sprite;
        protected var align_x:Number = 0.5;
        protected var content:MovieClip;
        protected var align_y:Number = 0.5;

        public function BasicPopup(content:MovieClip, message:String=""){
            super();
            this.content = content;
            this.message = message;
            this.init();
        }
        
        protected function draw():void{
            overlay.graphics.clear();
            overlay.graphics.lineStyle(1, 0, 0);
            overlay.graphics.beginFill(0, 0.1);
            overlay.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
            overlay.graphics.endFill();
        }
        
        protected function align():void{
            content.x = (stage.stageWidth * align_x);
            content.y = (stage.stageHeight * align_y);
        }
        
        protected function acceptClicked(e:MouseEvent):void{
            dispatchEvent(new Event(ON_ACCEPT));
        }
        
        protected function cornerCloseClicked(e:MouseEvent):void{
            dispatchEvent(new Event(ON_CLOSE));
        }
        
        protected function closeClicked(e:MouseEvent):void{
            dispatchEvent(new Event(ON_CLOSE));
        }
        
        public function remove():void{
            if (content.accept_btn){
                content.accept_btn.removeEventListener(MouseEvent.MOUSE_UP, acceptClicked);
            };
            if (content.close_btn){
                content.close_btn.removeEventListener(MouseEvent.MOUSE_UP, closeClicked);
            };
            if (content.corner_close_btn){
                content.corner_close_btn.removeEventListener(MouseEvent.MOUSE_UP, cornerCloseClicked);
            };
            removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            parent.removeChild(this);
        }
        
        public function refresh():void{
            align();
            draw();
        }
        
        protected function init():void{
            Cursor.hide();
            overlay = new Sprite();
            addChild(overlay);
            addChild(content);
            if (content.accept_btn){
                content.accept_btn.addEventListener(MouseEvent.MOUSE_UP, acceptClicked);
            }
            if (content.close_btn){
                content.close_btn.addEventListener(MouseEvent.MOUSE_UP, closeClicked);
            }
            if (content.corner_close_btn){
                content.corner_close_btn.addEventListener(MouseEvent.MOUSE_UP, cornerCloseClicked);
            }
            if (((content.msg_box) && (message))){
                content.msg_box.text = message;
            }
            addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        }
        
        protected function onAddedToStage(e:Event):void{
            refresh();
        }

    }
}
