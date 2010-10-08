package classes.view.components.popups {
    import classes.utils.*;
    
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;

    public class ComplexPopup extends DynamicPopup {

        public static const ITEM_CLICKED:String = "itemClicked";

        protected var items_y:Number = 2;
        protected var use_arrows:Boolean = false;
        protected var pages:Number = 1;
        protected var popup_title:String;
        protected var page:Number = 1;
        protected var left_arrow:SimpleButton;
        public var item:PopupItem;
        protected var raw_list:Array;
        protected var items_cont:Sprite;
        protected var item_padd:Number = 5;
        protected var list:Array;
        protected var right_arrow:SimpleButton;
        protected var items_x:Number = 3;

        public function ComplexPopup(title:String, list:Array, w:Number, h:Number, inner_w:Number, inner_h:Number){
            this.list = new Array();
            raw_list = new Array();
            popup_title = title;
            raw_list = list;
            super(w, h, inner_w, inner_h, title, true);
        }
        protected function get numPages():Number{
            var n:Number = Math.ceil((raw_list.length / (items_x * items_y)));
            return (n);
        }
        override protected function alignButtons():void{
            corner_close_btn.x = ((_w - corner_close_btn.width) - 10);
            corner_close_btn.y = 10;
            tf.y = 10;
            tf.x = ((_w - tf.width) / 2);
            inner_cont.y = ((tf.y + tf.height) + inner_cont_padd);
            inner_cont.x = (inner_cont_padd_w + ((_w - msg_w) / 2));
//            left_arrow.y = (right_arrow.y = ((_h - left_arrow.height) / 2));
//            left_arrow.x = ((inner_cont.x - left_arrow.width) / 2);
//            right_arrow.x = ((inner_cont.x + msg_w) + ((((_w - inner_cont.x) - msg_w) - right_arrow.width) / 2));
        }
        protected function align_items():void{
            var w:Number;
            var h:Number;
            var start:Number;
            var item:PopupItem;
            while (items_cont.numChildren) {
                items_cont.removeChildAt(0);
            };
            start = ((page - 1) * (items_x * items_y));
            var end:Number = Math.min((start + (items_x * items_y)), list.length);
            var i:Number = start;
            while (i < end) {
                item = (list[i] as PopupItem);
                items_cont.addChild(item);
                item.addEventListener(PopupItem.ITEM_CLICKED, itemClicked);
                item.x = (((i - start) % items_x) * (item.width + item_padd));
                item.y = (int(((i - start) / items_x)) * (item.height + item_padd));
                w = item.width;
                h = item.height;
                i++;
            };
            items_cont.x = (((msg_w - (items_x * w)) - ((items_x - 1) * item_padd)) / 2);
            items_cont.y = (((msg_h - (items_y * h)) - ((items_y - 1) * item_padd)) / 2);
        }
        override protected function init():void{
            show_close_btn = false;
            show_ok_btn = false;
            bg_scale = 1.3;
            inner_cont_padd = 10;
            super.init();
            left_arrow = new LeftArrow();
            right_arrow = new RightArrow();
            content.addChild(left_arrow);
            content.addChild(right_arrow);
            left_arrow.visible = false;
            right_arrow.visible = false;
            left_arrow.addEventListener(MouseEvent.CLICK, prevPage);
            right_arrow.addEventListener(MouseEvent.CLICK, nextPage);
            Effects.white_glow(tf);
            content.addChild(tf);
            tf.multiline = false;
            tf.autoSize = TextFieldAutoSize.LEFT;
            tf.wordWrap = false;
            items_cont = new Sprite();
            inner_cont.addChild(items_cont);
            create_items();
            show_page(1);
        }
        protected function itemClicked(e:Event):void{
            item = (e.target as PopupItem);
            dispatchEvent(new Event(ITEM_CLICKED));
        }
        protected function nextPage(e:MouseEvent=null):void{
            show_page((page + 1));
        }
        override protected function get_text_format():TextFormat{
            var format:TextFormat = super.get_text_format();
            format.size = 32;
            format.color = 0xCC0000;
            return format;
        }
        protected function prevPage(e:MouseEvent=null):void{
            show_page((page - 1));
        }
        protected function create_item(data:Object):PopupItem{
            return (new PopupItem(data));
        }
        protected function create_items():void{
            var item:PopupItem;
            var i:Number = 0;
            while (i < raw_list.length) {
                item = create_item(raw_list[i]);
                list.push(item);
                i++;
            }
        }
        protected function show_page(value:Number):void{
            if ((((value < 1)) || ((value > numPages)))){
                return;
            };
            page = value;
            trace("numPages", numPages);
            left_arrow.visible = true;
            right_arrow.visible = true;
            if (page == 1){
                left_arrow.visible = false;
            };
            if (page == numPages){
                right_arrow.visible = false;
            };
            trace("right_arrow", right_arrow.visible, right_arrow.x, right_arrow.y);
            align_items();
        }

    }
}
