package classes.view.components
{
    import classes.utils.*;
    
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    
    import mx.resources.ResourceManager;

    public class LevelBar extends Sprite
    {
        public const SHOW_TOOLTIP:String = "showTooltip";
        public var level:TextField;
        public const HIDE_TOOLTIP:String = "hideTooltip";
        public var message:String;
        private var data:Object;
        public var level_anim:MovieClip;
        public var exp:TextField;

        public function LevelBar()
        {
        	this.createChildren();
            addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
            addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
            addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
        }
        
        private var skin:LevelBarSkin;
        
        public function createChildren():void {
        	this.skin = this.addChild(new LevelBarSkin()) as LevelBarSkin;
        	this.level = this.skin.level;
        	this.level_anim = this.skin.level_anim;
        	this.exp = this.skin.exp;
        }

        public function update(value:Object) : void
        {
            this.data = value;
            exp.text = Algo.number_format(value.experience);
            level.text = value.level > 9 ? ("" + value.level) : ("0" + value.level);
            draw_level_percent(value.percent);
        }

        private function draw_level_percent(value:Number) : void
        {
            if(int(value * 100)>100||int(value * 100)<1)
            {
            	level_anim.gotoAndStop(1);
            } 
            else{
            	level_anim.gotoAndStop(int(value * 100));
            }
        }

        private function mouseOut(event:MouseEvent) : void
        {
            dispatchEvent(new Event(HIDE_TOOLTIP));
        }

        private function mouseMove(event:MouseEvent) : void
        {
        	if(!data)return;
            Cursor.hide();
            message = ResourceManager.getInstance().getString("message","level_tip_message",[Algo.number_format(data.max),(data.level + 1)]);
            dispatchEvent(new Event(SHOW_TOOLTIP));
        }

        private function mouseOver(event:MouseEvent) : void
        {
        	if(!data)return;
            message = ResourceManager.getInstance().getString("message","level_tip_message",[Algo.number_format(data.max),(data.level + 1)]);
            dispatchEvent(new Event(SHOW_TOOLTIP));
        }

    }
}
