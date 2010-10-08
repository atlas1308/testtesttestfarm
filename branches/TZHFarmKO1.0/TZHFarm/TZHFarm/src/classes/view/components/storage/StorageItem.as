﻿package classes.view.components.storage
{
    import classes.utils.*;
    
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import flash.utils.*;
    
    import mx.resources.ResourceManager;

    public class StorageItem extends Sprite
    {
        public var sell_all_for:TextField;
        public var down_btn:SimpleButton;
        public var sell:SimpleButton;
        private var loader:Cache;
        private var slide_interval:Number;
        public var image:MovieClip;
        public var sell_for:TextField;
        private var data:Object;
        public const ON_SELL:String = "onSell";
        public var qty:TextField;// 总的数量
        private var slide_started:Boolean = false;
        public var up_btn:SimpleButton;

        public function StorageItem(value:Object)
        {
            this.data = value;
            this.createChildren();
            this.init();
        }
        
        private var skin:StorageItemSkin;
        public function createChildren():void {
        	this.skin = this.addChild(new StorageItemSkin()) as StorageItemSkin;
        	this.qty = this.skin.qty;// 总的数量
        	this.down_btn = this.skin.down_btn;
        	this.image = this.skin.image;
        	this.sell_all_for = this.skin.sell_all_for;
        	this.sell = this.skin.sell;
        	this.sell_for = this.skin.sell_for;
        	this.up_btn = this.skin.up_btn;
        }

        private function onTextChange(event:Event) : void
        {
            var count:int = int(qty.text);
            if (count < 1)
            {
                count = 1;
            }
            if (count > data.qty)
            {
                count = data.qty;
            }
            qty.text = String(count);
        }

        private function sellClicked(event:MouseEvent) : void
        {
            dispatchEvent(new Event(ON_SELL));
        }

        private function upPressed(event:MouseEvent) : void
        {
            slide_interval = setTimeout(slide_value, 300, 1);
        }

        private function upClicked(event:MouseEvent) : void
        {
            clearTimeout(slide_interval);
            if (!slide_started)
            {
                change_qty(1);
            }
            slide_started = false;
            return;
        }

        private function sellOver(event:MouseEvent) : void
        {
            sell_all_for.text = ResourceManager.getInstance().getString("message","sell_for_message",[ Algo.number_format(int(qty.text) * data.sell_for)]);
        }

        private function loadComplete(event:Event) : void
        {
            var bitmap:Bitmap = Bitmap(event.target.asset);
            this.skin.addChild(bitmap);
            bitmap.x = image.x;
            bitmap.y = image.y;
            image.visible = false;
            this.skin.swapChildren(bitmap, image);
        }

        private function init() : void
        {
            qty.text = String(data.qty);
            qty.maxChars = 4;
            qty.restrict = "0-9";
            sell_for.text = data.name;
            sell_all_for.text = ResourceManager.getInstance().getString("message","sell_all_for_message",[String(data.sell_for)]);
            loader = new Cache();
            loader.addEventListener(Cache.LOAD_COMPLETE, loadComplete);
            loader.load(data.image);
            if (data.qty > 0)
            {
                qty.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
                up_btn.addEventListener(MouseEvent.CLICK, upClicked);
                up_btn.addEventListener(MouseEvent.MOUSE_DOWN, upPressed);
                down_btn.addEventListener(MouseEvent.MOUSE_DOWN, downPressed);
                down_btn.addEventListener(MouseEvent.CLICK, downClicked);
                qty.addEventListener(Event.CHANGE, onTextChange);
                sell.addEventListener(MouseEvent.CLICK, sellClicked);
                sell.addEventListener(MouseEvent.MOUSE_OVER, sellOver);
                sell.addEventListener(MouseEvent.MOUSE_OUT, sellOut);
            }
            else
            {
                alpha = 0.35;
                up_btn.enabled = false;
                down_btn.enabled = false;
                sell.enabled = false;
                qty.selectable = false;
            }
        }

        public function get_id() : Number
        {
            return data.id as Number;
        }

        private function onFocusOut(event:FocusEvent) : void
        {
            if (qty.text == "")
            {
                qty.text = String(data.qty);
            }
            return;
        }

        public function kill() : void
        {
            removeEventListener(MouseEvent.MOUSE_UP, sellClicked);
            qty.removeEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
            parent.removeChild(this);
            return;
        }

        private function downPressed(event:MouseEvent) : void
        {
            slide_interval = setTimeout(slide_value, 300, -1);
            return;
        }

        public function get_qty() : Number
        {
            return data.qty as Number;
        }

        private function sellOut(event:MouseEvent) : void
        {
            sell_all_for.text = ResourceManager.getInstance().getString("message","sell_all_for_message",[String(data.sell_for)]);
        }

        private function downClicked(event:MouseEvent) : void
        {
            clearTimeout(slide_interval);
            if (!slide_started)
            {
                change_qty(-1);
            }
            slide_started = false;
            return;
        }

        private function change_qty(addChild:Number) : Boolean
        {
            var _loc_2:* = int(qty.text);
            var _loc_3:Boolean = true;
            _loc_2 = _loc_2 + addChild;
            if (_loc_2 < 1)
            {
                _loc_2 = 1;
                _loc_3 = false;
            }
            if (_loc_2 > data.qty)
            {
                _loc_2 = data.qty;
                _loc_3 = false;
            }
            qty.text = String(_loc_2);
            return _loc_3;
        }

        public function get event_data() : Object
        {
            return {id:data.id, qty:qty.text};
        }

        private function slide_value(downPressed:Number) : void
        {
            slide_started = true;
            if (change_qty(downPressed))
            {
                slide_interval = setTimeout(slide_value, 40, downPressed);
            }
        }

    }
}
