package classes.view.components.popups {
	import classes.view.components.buttons.GameButton;
	
	import flash.events.MouseEvent;
	
	import mx.resources.ResourceManager;
	
    public class CashPopup extends BasicPopup {

        private var get_more:GameButton;

        public function CashPopup(){
            super(new CashPopupContainer());
        }
        override protected function init():void{
            var _y:Number;
            super.init();
            get_more = new GameButton(ResourceManager.getInstance().getString("message","game_button_get_more_message"), 20);
            get_more.set_style("green");
            content.addChild(get_more);
            get_more.addEventListener(MouseEvent.CLICK, acceptClicked);
            _y = 51;
            var hh:Number = 78;
            get_more.x = (-(get_more.width) / 2);
            get_more.y = (_y + ((hh - get_more.height) / 2));
        }

    }
}
