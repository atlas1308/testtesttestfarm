package classes.view.components {
    import classes.view.components.buttons.*;
    import classes.view.components.gifts.*;
    
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    
    import tzh.core.AlignSprite;

    public class Gifts extends AlignSprite {

        public const USE_ITEM:String = "useItem";
        public const TRADE_ITEM:String = "tradeItem";
        public const ON_CLOSE:String = "onClose";

        public var container:MovieClip;
        public var no_items:TextField;
        private var page:Number = 0;
        public var prev_btn:SimpleButton;
        private var pages:Number;
        public var close_btn:SimpleButton;
        public var next_btn:SimpleButton;
        public var cont_bounds:MovieClip;
        private var data:Array;
        public var item_clicked:Object;

        public function Gifts(){
            super();
            this.createChildren();
            this.init();
        }
        
        private var skin:GiftsSkin;
        public function createChildren():void {
        	this.skin = this.addChild(new GiftsSkin()) as GiftsSkin;
        	this.cont_bounds = this.skin.cont_bounds;
        	this.container = this.skin.container;
        	this.prev_btn = this.skin.prev_btn;
        	this.next_btn = this.skin.next_btn;
        	this.no_items = this.skin.no_items;
        	this.close_btn = this.skin.close_btn;
        }
        
        public function goTo(id:Number):void{
            var i:Number = 0;
            while (i < data.length) {
                if (data[i].id == id){
                    show_page(Math.floor((i / 6)));
                };
                i++;
            };
        }
        
        private function show_page(p:Number):void{
            var item_w:Number;
            var item_h:Number;
            var _gift:Gift;
            var gift:Gift;
            while (container.numChildren) {
                _gift = (container.getChildAt(0) as Gift);
                _gift.kill();
                _gift.removeEventListener(_gift.USE_CLICKED, useClicked);
                _gift.removeEventListener(_gift.TRADE_CLICKED, tradeClicked);
            };
            page = p;
            var i:Number = (p * 6);
            while (i < Math.min(((p + 1) * 6), data.length)) {
                gift = new Gift(data[i]);
                container.addChild(gift);
                gift.x = (((i - (p * 6)) % 3) * (gift.width + 10));
                gift.y = (int(((i - (p * 6)) / 3)) * (gift.height + 10));
                item_w = (gift.width + 10);
                item_h = (gift.height + 10);
                gift.addEventListener(gift.USE_CLICKED, useClicked);
                gift.addEventListener(gift.TRADE_CLICKED, tradeClicked);
                i++;
            };
            container.y = (cont_bounds.y + (((cont_bounds.height - (2 * item_h)) + 10) / 2));
            container.x = (cont_bounds.x + (((cont_bounds.width - (3 * item_w)) + 10) / 2));
            next_btn.visible = (prev_btn.visible = true);
            if ((((page == (pages - 1))) || (!(pages)))){
                next_btn.visible = false;
            };
            if ((((page == 0)) || (!(pages)))){
                prev_btn.visible = false;
            };
        }
        
        public function update(data:Array):void{
            this.data = data;
            pages = Math.ceil((data.length / 6));
            if (data.length == 0){
                no_items.visible = true;
            } else {
                no_items.visible = false;
            };
            show_page(page);
        }
        
        private function prev_page(e:MouseEvent):void{
            if (page == 0){
                return;
            };
            show_page((page - 1));
        }
        
        private function init():void{
            close_btn.addEventListener(MouseEvent.MOUSE_UP, closeClicked);
            prev_btn.addEventListener(MouseEvent.MOUSE_UP, prev_page);
            next_btn.addEventListener(MouseEvent.MOUSE_UP, next_page);
            no_items.visible = false;
        }
        
        private function tradeClicked(e:Event):void{
            item_clicked = e.target;
            dispatchEvent(new Event(TRADE_ITEM));
        }
        
        private function useClicked(e:Event):void{
            item_clicked = e.target;
            dispatchEvent(new Event(USE_ITEM));
        }
        private function closeClicked(e:MouseEvent):void{
            dispatchEvent(new Event(ON_CLOSE));
        }
        private function next_page(e:MouseEvent):void{
            if (page == (pages - 1)){
                return;
            };
            show_page((page + 1));
        }

    }
}
