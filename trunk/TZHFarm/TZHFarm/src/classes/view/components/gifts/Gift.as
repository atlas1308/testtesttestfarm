
package classes.view.components.gifts {
    import classes.utils.*;
    import classes.view.components.buttons.*;
    
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    
    import mx.resources.ResourceManager;

    import tzh.core.Image;

    public class Gift extends Sprite {

        public const TRADE_CLICKED:String = "tradeClicked";
        public const USE_CLICKED:String = "useclicked";

        private var trade_btn:GameButton;
        public var bg:MovieClip;
        private var flip_btn:RotateBtn;
        public var sell_for:TextField;
        public var desc:TextField;
        private var use_btn:GameButton;
        private var data:Object;
        public var collect:TextField;
        public var item_title:TextField;
        public var qty:TextField;
        public var image:MovieClip;

        public function Gift(data:Object){
            super();
            this.data = data;
            this.createChildren();
            this.init();
        }
        
        private var skin:GiftSkin;
        public function createChildren():void {
        	this.skin = this.addChild(new GiftSkin()) as GiftSkin;
        	this.item_title = this.skin.item_title;
        	this.qty = this.skin.qty;
        	this.image = this.skin.image;
        	this.collect = this.skin.collect;
        	this.sell_for = this.skin.sell_for;
        	this.desc = this.skin.desc;
        	//this.skin.sell_btn.visible = false;
        	//this.skin.use_btn.visible = false;
        }
        
        private function imageLoaded(e:Event):void{
        	var img:Image = e.currentTarget as Image;
            img.x = -(img.width / 2);
            image.addChild(img);
            image.x = (qty.x / 2);
            flip_btn.x = (((image.x + (img.width / 2)) - (flip_btn.width / 2)) + (flip_btn.width / 3));
            flip_btn.y = ((image.y + img.height) - (flip_btn.height / 2));
        }
        
        private function init():void{
            var dw:Number;
            use_btn = new GameButton(ResourceManager.getInstance().getString("message","game_button_use_message"), 13, (15 / 13));
            use_btn.set_fixed_width(60);
            trade_btn = new GameButton(ResourceManager.getInstance().getString("message","game_button_trade_message"), 13, (15 / 13));
            trade_btn.set_fixed_width(60);
            addChild(use_btn);
            addChild(trade_btn);
            use_btn.y = (this.skin.height - (use_btn.height / 2));
            trade_btn.y = (this.skin.height - (trade_btn.height / 2));
            if (!data.trade_for){
                trade_btn.visible = false;
                use_btn.x = ((width - use_btn.width) / 2);
            } else {
                dw = (((this.skin.width - use_btn.width) - trade_btn.width) / 3);
                use_btn.x = dw;
                trade_btn.x = dw + 12 + use_btn.width;
            } 
            flip_btn = new RotateBtn();
            flip_btn.scaleX = (flip_btn.scaleY = 0.8);
            if (data.show_name !== false){
                item_title.text = data.name;
            };
            if (data.trade_for){
                sell_for.text = ResourceManager.getInstance().getString("message","trade_for_message",[String(data.trade_for)]);
            } else {
                sell_for.visible = false;
            };
            if (data.collect_in){
                collect.text = ResourceManager.getInstance().getString("message","collect_in_message",[Algo.prep_time(data.collect_in)]);
            } else {
                collect.visible = false;
            };
            qty.text = ("x" + String(data.qty));
            if (data.desc){
                desc.text = data.desc;
            } else {
                desc.visible = false;
            };
            addChild(flip_btn);
            flip_btn.visible = false;
            if (data.flipable){
                flip_btn.addEventListener(MouseEvent.CLICK, flipClicked);
            };
            var imageChild:Image = new Image(data.image,image,false);
            imageChild.addEventListener(Event.COMPLETE,imageLoaded);
            use_btn.addEventListener(MouseEvent.MOUSE_UP, useClicked);
            trade_btn.addEventListener(MouseEvent.MOUSE_UP, tradeClicked);
            addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
            addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
        }
        
        private function onMouseOver(e:MouseEvent):void{
            var btn:GameButton = (e.target.parent as GameButton);
            if (((btn) && ((((btn === use_btn)) || ((btn === trade_btn)))))){
                flip_btn.visible = false;
                return;
            }
            if (((!(data.locked)) && (data.flipable))){
                flip_btn.visible = true;
        }
        }
        
        private function flipClicked(e:MouseEvent):void{
            image.scaleX = (image.scaleX * -1);
            flip_btn.scaleX = (flip_btn.scaleX * -1);
        }
        
        public function get id():Number{
            return (data.id);
        }
        
        public function kill():void{
            use_btn.removeEventListener(MouseEvent.CLICK, useClicked);
            trade_btn.addEventListener(MouseEvent.CLICK, tradeClicked);
            parent.removeChild(this);
        }
        
        private function useClicked(e:MouseEvent):void{
            dispatchEvent(new Event(USE_CLICKED));
        }
        
        private function onMouseOut(e:MouseEvent):void{
            if (data.flipable){
                flip_btn.visible = false;
        }
        }
        
        public function get is_flipped():Boolean{
            return ((image.scaleX < 0));
        }
        
        private function tradeClicked(e:MouseEvent):void{
            dispatchEvent(new Event(TRADE_CLICKED));
        }

    }
} 
