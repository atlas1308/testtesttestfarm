package classes.view.components.popups {
	import classes.view.components.buttons.GameButton;
	
	import flash.events.MouseEvent;
	
	import mx.resources.ResourceManager;
	
    public class CashPopup extends BasicPopup {

        private var _get_more:GameButton;

        public function CashPopup(){
            super(new CashPopupContainer());
        }
        override protected function init():void{
            var _y:Number;
            super.init();
            _get_more = new GameButton(ResourceManager.getInstance().getString("message","game_button_get_more_message"), 20);
            content.addChild(_get_more);
            _get_more.addEventListener(MouseEvent.CLICK, acceptClicked);
            _y = 51;
            var _h:Number = 78;
            _get_more.x = (-(_get_more.width) / 2);
            _get_more.y = (_y + ((_h - _get_more.height) / 2));
        }

    }
}
