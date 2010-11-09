package classes.view.components.popups
{
    import classes.view.components.buttons.*;
    
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;
    
    import mx.resources.ResourceManager;
    
    import tzh.core.Image;

    public class HelpPopup extends BasicPopup
    {
        private var _close_btn:GameButton;
        private var ok_btn:GameButton;
        private var data:Object;

        public function HelpPopup(value:Object)
        {
            this.data = value;
            super(new HelpPopupContainer());
        }

        override protected function init() : void
        {
            super.init();
            content.friend_name.text = data.friend_name;
            content.message.text = data.message;
            var image:Image = new Image(data.photo,content.photo);
            image.addEventListener(Event.COMPLETE,photoComplete);
            content.addChild(image);
            ok_btn = new GameButton(ResourceManager.getInstance().getString("message","game_button_accpet_message"));
            ok_btn.set_style("green");
            _close_btn = new GameButton(ResourceManager.getInstance().getString("message","game_button_cancel_message"));
            _close_btn.set_colors(11534336, 13959168, 7405568);
            ok_btn.set_fixed_width(120);
            ok_btn.set_padd_height(5);
            _close_btn.set_fixed_width(120);
            _close_btn.set_padd_height(5);
            content.addChild(ok_btn);
            content.addChild(_close_btn);
            var ww:Number = ok_btn.width + 20 + _close_btn.width;
            ok_btn.y = content.buttons_area.y + (content.buttons_area.height - ok_btn.height) / 2;
            _close_btn.y = ok_btn.y;
            ok_btn.x = content.buttons_area.x + (content.buttons_area.width - ww) / 2;
            _close_btn.x = ok_btn.x + ok_btn.width + 20;
            ok_btn.addEventListener(MouseEvent.CLICK, acceptClicked);
            _close_btn.addEventListener(MouseEvent.CLICK, closeClicked);
        }

        private function photoComplete(event:Event) : void
        {
        	var image:Image = event.currentTarget as Image;
            var ww:Number = content.photo.width;
            var hh:Number = content.photo.height;
            image.x = content.photo.x + (ww - image.width) / 2;
            image.y = content.photo.y + (hh - image.height) / 2;
            content.photo.visible = false;
        }

    }
}
