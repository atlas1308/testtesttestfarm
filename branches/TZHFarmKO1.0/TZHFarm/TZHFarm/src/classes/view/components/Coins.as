package classes.view.components
{
    import flash.text.*;
    
    import mx.resources.ResourceManager;

    public class Coins extends NumericBar
    {
        public var val:TextField;

        public function Coins()
        {
            this.createChildren();
        }
        
        private var skin:CoinsSkin;
        public function createChildren():void {
        	this.skin = this.addChild(new CoinsSkin()) as CoinsSkin;
        	this.val = this.skin.val;
        }

        override protected function get tf() : TextField
        {
            return val;
        }

        override protected function get_tool_tip_message() : String
        {
        	return ResourceManager.getInstance().getString("message","user_coins_tip_message",[val.text]);
        }

    }
}
