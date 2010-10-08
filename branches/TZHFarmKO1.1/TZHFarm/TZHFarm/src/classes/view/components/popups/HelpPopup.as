package classes.view.components.popups
{
    import classes.utils.Cache;
    import classes.view.components.buttons.*;
    
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;
    
    import mx.resources.ResourceManager;

    public class HelpPopup extends BasicPopup
    {
        private var _close_btn:GameButton;
        private var _ok_btn:GameButton;
        private var data:Object;

        public function HelpPopup(param1:Object)
        {
            this.data = param1;
            super(new HelpPopupContainer());
        }

        override protected function init() : void
        {
            super.init();
            content.friend_name.text = data.friend_name;
            content.message.text = data.message;
            var _loc_1:* = new LoaderContext();
            _loc_1.checkPolicyFile = true;
            /* var _loc_2:* = new Loader();
            _loc_2.load(new URLRequest(data.photo), _loc_1);
            _loc_2.contentLoaderInfo.addEventListener(Event.COMPLETE, photoComplete); */
            // cache method
            var load_photo:Cache=new Cache();
            load_photo.addEventListener(Cache.LOAD_COMPLETE, photoComplete);
            load_photo.load(data.photo);
            
            _ok_btn = new GameButton(ResourceManager.getInstance().getString("message","game_button_accpet_message"));
            _close_btn = new GameButton(ResourceManager.getInstance().getString("message","game_button_cancel_message"));
            _close_btn.set_colors(11534336, 13959168, 7405568);
            _ok_btn.set_fixed_width(120);
            _ok_btn.set_padd_height(5);
            _close_btn.set_fixed_width(120);
            _close_btn.set_padd_height(5);
            content.addChild(_ok_btn);
            content.addChild(_close_btn);
            var _loc_3:* = _ok_btn.width + 20 + _close_btn.width;
            _ok_btn.y = content.buttons_area.y + (content.buttons_area.height - _ok_btn.height) / 2;
            _close_btn.y = _ok_btn.y;
            _ok_btn.x = content.buttons_area.x + (content.buttons_area.width - _loc_3) / 2;
            _close_btn.x = _ok_btn.x + _ok_btn.width + 20;
            _ok_btn.addEventListener(MouseEvent.CLICK, acceptClicked);
            _close_btn.addEventListener(MouseEvent.CLICK, closeClicked);
        }

        private function photoComplete(event:Event) : void
        {
            var ww:Number = content.photo.width;
            var hh:Number = content.photo.height;
            var loader:Bitmap = event.target.asset;
            content.addChild(loader);
            loader.x = content.photo.x + (content.photo.width - loader.width) / 2;
            loader.y = content.photo.y + (content.photo.height - loader.height) / 2;
            content.photo.visible = false;
        }

    }
}
