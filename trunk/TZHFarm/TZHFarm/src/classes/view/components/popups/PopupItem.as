package classes.view.components.popups {
    import classes.utils.*;
    import classes.view.components.buttons.*;
    import classes.view.components.map.MapObject;
    
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    
    import tzh.core.Image;

    public class PopupItem extends Sprite {

        public static const ITEM_CLICKED:String = "itemClicked";

        protected var container:Sprite;
        protected var title_size:Number = 13;
        //protected var cache:Cache;
        protected var image_h:Number = 60;
        protected var desc:TextField;
        protected var image_w:Number = 60;
        protected var image_cont:Sprite;
        protected var title:TextField;
        protected var image:Bitmap;
        protected var title_width:Number = 0;
        protected var data:Object;
        protected var button:GameButton;
        protected var title_color:Number = 10049313;

        public function PopupItem(data:Object){
            super();
            this.data = data;
            this.init();
        }
        
        public var _affectMapObject:MapObject;
        
        public function set affectMapObject(value:MapObject):void {
        	this._affectMapObject = value;
        }
        
        public function get affectMapObject():MapObject {
        	return this._affectMapObject;
        }
        
        protected function align():void{
            var padd:Number = (((((data.height - (button.height / 2)) - title.height) - image_h) - desc.height) / 4);
            title.x = ((data.width - title.width) / 2);
            image_cont.x = ((data.width - image_w) / 2);
            desc.x = ((data.width - desc.width) / 2);
            button.x = ((data.width - button.width) / 2);
            title.y = padd;
            image_cont.y = ((title.y + title.height) + padd);
            desc.y = ((image_cont.y + image_h) + padd);
            button.y = (data.height - (button.height / 2));
        }
        
        protected function create_tf(size:Number, color:Number, w:Number=0, font_name:String="", align:String="center", htmlTxt:String=""):TextField{
            var tf:TextField = new TextField();
            if (htmlTxt){
                tf.htmlText = htmlTxt;
            }
            if (w){
                tf.width = w;
            }
            tf.embedFonts = true;
            tf.selectable = false;
            tf.multiline = true;
            tf.wordWrap = true;
            tf.autoSize = TextFieldAutoSize.LEFT;
            var format:TextFormat = new TextFormat();
            format.align = align;
            format.size = size;
            format.color = color;
            format.font = (font_name) ? font_name : new HoboStd().fontName;
            if (htmlTxt){
                tf.setTextFormat(format);
            } else {
                tf.defaultTextFormat = format;
            }
            return (tf);
        }
        
        protected function init():void{
            create_objects();
            align();
            draw();
        }
        
        protected function draw(line:Number=16307865, bg:Number=16711663):void{
            draw_rect(container, line, bg, data.width, data.height);
        }
        
        protected function create_objects():void{
            container = new Sprite();
            image_cont = new Sprite();
            container.addChild(image_cont);
            addChild(container);
            button = new GameButton(data.button_label, 13);
            button.addEventListener(MouseEvent.CLICK, onClicked);
            var image:Image = new Image(data.image,this.image_cont);
            this.image_cont.addChild(image);
            title = create_tf(title_size, title_color, title_width);
            desc = create_tf(12, 10049313);
            container.addChild(title);
            container.addChild(desc);
            container.addChild(button);
            if (data.title_txt){
                title.text = data.title_txt;
            }
            if (data.desc_txt){
                desc.text = data.desc_txt;
            }
            if (data.disable_button){
                disable_button();
            }
        }
        
        public function refresh(data:Object):void {
        	this.data = data;
        	if (data.title_txt){
                title.text = data.title_txt;
            }
            if (data.desc_txt){
                desc.text = data.desc_txt;
            }
            if (data.disable_button){
                disable_button();
            }
        }
        
        public function get id():*{
            return data.id;
        }
        
        public function disable_button():void{
            button.removeEventListener(MouseEvent.CLICK, onClicked);
            button.disable();
        }
        
        protected function onClicked(e:Event):void{
            dispatchEvent(new Event(ITEM_CLICKED));
        }
        
        public function get type():String{
            return data.type;
        }
        
        protected function draw_rect(cont:Sprite, line:Number, fill:Number, w:Number, h:Number, x:Number=0, y:Number=0):void{
            var gr:Graphics = cont.graphics;
            gr.clear();
            gr.lineStyle(1, line, 1, true);
            gr.beginFill(fill, 1);
            gr.drawRoundRect(x, y, w, h, 20);
            gr.endFill();
        }
		
		
		public function getData():Object {
			return this.data;
		}
    }
}
