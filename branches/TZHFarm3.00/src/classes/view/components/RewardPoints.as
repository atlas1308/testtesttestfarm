package classes.view.components
{
    import classes.utils.*;
    
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    
    import mx.resources.ResourceManager;

    public class RewardPoints extends Sprite
    {
        public const SHOW_TOOLTIP:String = "showTooltip";
        public const HIDE_TOOLTIP:String = "hideTooltip";
        public var message:String;
        public var val:TextField;
        public const ADD_RANCH_CASH:String = "addRanchCash";
        public var add_rp:SimpleButton;

        public function RewardPoints()
        {
        	this.createChildren();
            addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
            addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
            this.skin.add_rp.addEventListener(MouseEvent.CLICK, add_rpClicked);
        }
        
        private var skin:RewardPointsSkin;
        public function createChildren():void {
        	this.skin = this.addChild(new RewardPointsSkin()) as RewardPointsSkin;
        	this.val = this.skin.val;
        	this.add_rp = this.skin.add_rp;
        }

        private function add_rpClicked(event:MouseEvent) : void
        {
            dispatchEvent(new Event(ADD_RANCH_CASH));
        }

        private function mouseOut(event:MouseEvent) : void
        {
            dispatchEvent(new Event(HIDE_TOOLTIP));
        }

        public function update(a:Number) : void
        {
            this.val.text = Algo.number_format(a);
        }

        private function mouseMove(event:MouseEvent) : void
        {
            Cursor.hide();
            if (event.target == add_rp)
            {
                mouseOut(event);
            }
            else
            {
                message = ResourceManager.getInstance().getString("message","user_has_rach_message",[this.val.text]);
                dispatchEvent(new Event(SHOW_TOOLTIP));
            }
        }

    }
}
