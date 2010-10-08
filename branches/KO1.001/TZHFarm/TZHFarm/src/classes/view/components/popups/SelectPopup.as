package classes.view.components.popups {
    import flash.events.*;
    import flash.display.*;
    import flash.text.*;
    import classes.view.components.buttons.*;

    public class SelectPopup extends DynamicPopup {

        protected var buttons:Sprite;
        protected var image_size:Number = 40;
        protected var caption:String;
        public var selected_index:Number;
        public var selected_name:String;
        protected var _tf:TextField;
        public var selected_data:Object;
        protected var fields:Array;

        public function SelectPopup(data:Object){
            fields = (data.list as Array);
            caption = (data.caption as String);
            image_size = (data.image_size) ? data.image_size : 40;
            var w:Number = (Math.max(fields.length, 4) * (image_size + 30));
            var h:Number = (image_size + 110);
            super(w, h, 0, 0, "");
        }
        
        override protected function okClicked(e:MouseEvent):void{
            selected_index = buttons.getChildIndex((e.target as ImageButton));
            selected_data = fields[selected_index];
            if (ImageButton(e.target).is_disabled()){
                selected_name = e.target.name;
                super.closeClicked(e);
            } else {
                super.okClicked(e);
            };
        }
        
        override protected function init():void{
            var last_btn:ImageButton;
            var btn:ImageButton;
            _tf = new TextField();
            _tf.embedFonts = true;
            _tf.autoSize = TextFieldAutoSize.LEFT;
            _tf.selectable = false;
            var format:TextFormat = new TextFormat();
            format.font = new Futura().fontName;
            format.size = 16;
            format.color = 10049312;
            _tf.defaultTextFormat = format;
            _tf.text = caption;
            show_ok_btn = false;
            show_close_btn = false;
            inner_cont_padd = 90;
            buttons = new Sprite();
            use_corner_close = true;
            var i:Number = 0;
            while (i < fields.length) {
                btn = new ImageButton(image_size, image_size, fields[i].url);
                if (!fields[i].enabled){
                    btn.disable();
                } else {
                    use_corner_close = false;
                };
                btn.addEventListener(MouseEvent.CLICK, okClicked);
                btn.name = fields[i].name;
                if (fields[i].selected){
                    btn.selected();
                };
                if (last_btn){
                    btn.x = ((last_btn.width + last_btn.x) + 20);
                };
                buttons.addChild(btn);
                last_btn = btn;
                i++;
            };
            super.init();
            content.addChild(buttons);
            content.addChild(_tf);
            corner_close_btn.scaleX = (corner_close_btn.scaleY = 0.5);
            _tf.x = ((_w - _tf.width) / 2);
            _tf.y = 20;
            buttons.x = ((_w - buttons.width) / 2);
            buttons.y = ((_tf.y + _tf.height) + 30);
        }

    }
}