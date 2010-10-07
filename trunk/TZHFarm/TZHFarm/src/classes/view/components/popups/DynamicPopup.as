package classes.view.components.popups
{
    import classes.view.components.buttons.*;
    
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.text.*;

    import mx.resources.ResourceManager;

    public class DynamicPopup extends Sprite implements IPopup
    {
        protected var ok_btn:GameButton;
        protected var inner_cont:Sprite;
        protected var message:String;
        protected var close_btn:GameButton;
        protected var tf:TextField;
   		protected var corner_close_btn:CloseButton;
        protected var inner_cont_padd_w:Number = 0;
        public var info:Object;
        protected var msg_h:Number;
        protected var popup_bg:BitmapData;
        protected var msg_w:Number;
        public var type:String;
        protected var align_x:Number = 0.5;
        protected var align_y:Number = 0.5;
        protected var bg:Sprite;
        protected var use_corner_close:Boolean = false;
        protected var tf_padd_h:Number = 0;
        protected var bg_scale:Number = 1;
        protected var ok_label:String = ResourceManager.getInstance().getString("message","game_button_accpet_message");
        protected var show_close_btn:Boolean = true;
        protected var overlay:Sprite;
        protected var tf_padd_w:Number = 10;
        protected var selectable:Boolean = true;
        protected var _h:Number;
        protected var align_tf:Boolean = true;
        protected var close_label:String = ResourceManager.getInstance().getString("message","game_button_cancel_message");
        protected var inner_cont_padd:Number = 20;
        protected var _w:Number;
        protected var content:Sprite;
        protected var show_ok_btn:Boolean = true;
        public static const ON_CLOSE:String = "onClose";
        public static const ON_ACCEPT:String = "onAccept";
		
        public function DynamicPopup(_w:Number, _h:Number, msg_w:Number, msg_h:Number, message:String, use_corner_close:Boolean = true) : void
        {
			this._w = _w;
            this._h = _h;
            this.msg_w = msg_w;
            this.msg_h = msg_h;
            this.message = message;
            this.use_corner_close = use_corner_close;
            this.init();
        }

        public function remove() : void
        {
            removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            if(parent){
            parent.removeChild(this);
        }
        }

        protected function align() : void
        {
            if (!stage)
            {
                return;
            }
            content.x = stage.stageWidth * align_x - _w / 2 - offset.x;
            content.y = stage.stageHeight * align_y - _h / 2 - offset.y;
            alignButtons();
        }

        protected function closeClicked(event:MouseEvent) : void
        {
            dispatchEvent(new Event(ON_CLOSE));
        }

        protected function init() : void
        {
            overlay = new Sprite();
            content = new Sprite();
            inner_cont = new Sprite();
            bg = new Sprite();
            addChild(overlay);
            addChild(content);
            content.addChild(bg);
            content.addChild(inner_cont);
            tf = create_tf(msg_w - 2 * tf_padd_w, msg_h - 2 * tf_padd_h);
            tf.selectable = selectable;
            tf.type = TextFieldType.INPUT;
            tf.defaultTextFormat = get_text_format();
            inner_cont.addChild(tf);
            popup_bg = new PopupBg(_w, _h);
            ok_btn = new GameButton(ok_label, 17);
            close_btn = new GameButton(close_label, 17);
            close_btn.set_colors(11534336, 13959168, 7405568);
            ok_btn.set_fixed_width(120);
            ok_btn.set_padd_height(5);
            close_btn.set_fixed_width(120);
            close_btn.set_padd_height(5);
            corner_close_btn = new CloseButton();
			
            content.addChild(ok_btn);
            content.addChild(close_btn);
            if (use_corner_close)
            {
                content.addChild(corner_close_btn);
			
            }
            if (!show_close_btn)
            {
                close_btn.visible = false;
            }
            if (!show_ok_btn)
            {
                ok_btn.visible = false;
            }
            ok_btn.addEventListener(MouseEvent.CLICK, okClicked);
            close_btn.addEventListener(MouseEvent.CLICK, closeClicked);
			alignButtons();
            corner_close_btn.addEventListener(MouseEvent.CLICK, closeClicked);
            addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            if (message)
            {
                tf.text = message;
            }
        }

        protected function get offset() : Point
        {
            return parent.localToGlobal(new Point(0, 0));
        }

        public function set_close_label(msg_w:String) : void
        {
            close_btn.set_label(msg_w);
        }

        protected function create_tf(ww:Number, hh:Number, textFormat:TextFormat = null) : TextField
        {
            var textField:TextField = new TextField();
            textField.width = ww;
            textField.height = hh;
            textField.selectable = false;
            textField.multiline = true;
            textField.wordWrap = true;
            textField.embedFonts = true;
            if (textFormat)
            {
                textField.defaultTextFormat = textFormat;
            }
            return textField;
        }

        public function get_message() : String
        {
            return tf.text;
        }

        protected function onAddedToStage(event:Event) : void
        {
            refresh();
        }

        public function set_ok_label(msg_w:String) : void
        {
            ok_btn.set_label(msg_w);
        }

        protected function okClicked(event:MouseEvent) : void
        {
            dispatchEvent(new Event(ON_ACCEPT));
        }

        protected function alignButtons() : void
        {
            corner_close_btn.x = _w - corner_close_btn.width - 10;
            corner_close_btn.y = 10;
            inner_cont.y = inner_cont_padd;
            inner_cont.x = inner_cont_padd_w + (_w - msg_w) / 2;
            if (align_tf)
            {
                tf.y = (msg_h - tf.textHeight) / 2;
            }
            else
            {
                tf.y = tf_padd_h;
            }
            tf.x = tf_padd_w;
            ok_btn.y = inner_cont.y + msg_h + (_h - inner_cont.y - msg_h - ok_btn.height) / 2;
            close_btn.y = inner_cont.y + msg_h + (_h - inner_cont.y - msg_h - close_btn.height) / 2;
            var bwidth:Number = 0;
            if (show_ok_btn)
            {
                bwidth = ok_btn.width;
            }
            if (show_close_btn)
            {
                if (show_ok_btn)
                {
                    bwidth = bwidth + 30;
                }
                bwidth = bwidth + close_btn.width;
            }
            ok_btn.x = (_w - bwidth) / 2;
            if (show_ok_btn)
            {
                close_btn.x = ok_btn.x + ok_btn.width + 30;
            }
            else
            {
                close_btn.x = (_w - bwidth) / 2;
            }
        }

        protected function draw() : void
        {
            if (!stage)
            {
                return;
            }
            overlay.graphics.clear();
            overlay.graphics.lineStyle(1, 0, 0);
            overlay.graphics.beginFill(0, 0.1);
            overlay.graphics.drawRect(-offset.x, -offset.y, stage.stageWidth, stage.stageHeight);
            overlay.graphics.endFill();
            var g:Graphics = bg.graphics;
            g.clear();
            g.lineStyle(2, 15700748, 1, true);
            var matrix:Matrix = new Matrix();// 边框和背景都在这里画出来的
            matrix.translate(0, 0);
            bg_scale = Math.max(_w / 510, _h / 360, 1);
            matrix.scale(bg_scale, bg_scale);
            g.beginBitmapFill(popup_bg, matrix);
            g.drawRoundRect(0, 0, _w, _h, 20);
            g.endFill();
            draw_inner_cont(inner_cont, msg_w, msg_h);
        }

        public function set_ok_fixed_width(msg_w:Number) : void
        {
            ok_btn.set_fixed_width(msg_w);
            refresh();
        }

        public function refresh() : void
        {
            align();
            draw();
        }

        public function hide_close_btn() : void
        {
            close_btn.visible = false;
            show_close_btn = false;//hide ? show ?
            refresh();
        }

        protected function get_text_format() : TextFormat
        {
            var textFormat:TextFormat = new TextFormat();
            textFormat.font = new HoboStd().fontName;
            textFormat.size = 16;
            textFormat.color = 10049312;
            textFormat.align = TextFormatAlign.CENTER;
            textFormat.leading = 3;
            return textFormat;
        }

		/**
		 * 空白的区域
		 */ 
        protected function draw_inner_cont(sprite:Sprite, w:Number, h:Number, offsetX:Number = 0, offsetY:Number = 0) : void
        {
            var graphics:Graphics = sprite.graphics;
            graphics.clear();
            graphics.lineStyle(2, 13926922, 1, true);
            graphics.beginFill(16513510, 1);
            graphics.drawRoundRect(offsetX, offsetY, w, h, 20);
            graphics.endFill(); 
        }

    }
}
