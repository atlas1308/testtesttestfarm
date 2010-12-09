package classes.view.components
{
    import classes.utils.*;
    
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    
    import mx.resources.ResourceManager;

    public class NameBar extends Sprite
    {
        public const SHOW_TOOLTIP:String = "showTooltip";
        public const HIDE_TOOLTIP:String = "hideTooltip";
        public var message:String;
        private var friend_name:Boolean = false;
        public var title:TextField;

        public function NameBar()
        {
        	this.createChildren();
            this.init();
        }
        
        private var skin:NameBarSkin;
        public function createChildren():void {
        	skin = this.addChild(new NameBarSkin()) as NameBarSkin;
        	this.title = this.skin.title;
        }

        public function update(userName:String, friend_name:Boolean = false):void
        {
            this.friend_name = friend_name;
            title.text = ResourceManager.getInstance().getString("message","user_ranch_tip_message",[userName]);
        }

        private function mouseOut(event:Event) : void
        {
            dispatchEvent(new Event(HIDE_TOOLTIP));
        }

        private function mouseMove(event:Event) : void
        {
            Cursor.hide();
            if (friend_name)
            {
                message = ResourceManager.getInstance().getString("message","visit_friend_message",[title.text]);
                dispatchEvent(new Event(SHOW_TOOLTIP));
            }
        }

        private function init() : void
        {
            mouseChildren = false;
            addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
            addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
        }

    }
}
