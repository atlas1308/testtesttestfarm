package classes.view.components.popups {
    import flash.events.*;
    import classes.utils.*;
    import flash.display.*;
	
	/**
	 * 这个是新产品,初始化返回的news这是一个数组,
	 */ 
    public class NewsPopup extends DynamicPopup {

        private var bmp:Bitmap;
        private var offset_x:Number = 0;
        private var bmp2:Bitmap;
        private var loader:Cache;
        private var image:Sprite;
        private var offset_y:Number = 0;
        private var data:Object;
        private var offset2_x:Number = 0;
        private var offset2_y:Number = 0;
        private var loader2:Cache;

        public function NewsPopup(data:Object){
            this.data = data;
            super(400, 270, 300, 160, data.message);
        }
        override protected function draw():void{
            super.draw();
            draw_inner_cont(image, 85, 85);
            alignButtons();
        }
        
        override protected function init():void{
            show_close_btn = false;
            ok_label = "OK";
            inner_cont_padd = 55;
            inner_cont_padd_w = 20;
            tf_padd_w = 20;
            super.init();
            ok_btn.set_text_size(20);
            image = new Sprite();
            image.x = 10;
            image.y = 10;
            offset_x = (data.offset_x) ? data.offset_x : 0;
            offset_y = (data.offset_y) ? data.offset_y : 0;
            offset2_x = (data.offset2_x) ? data.offset2_x : 0;
            offset2_y = (data.offset2_y) ? data.offset2_y : 0;
            content.addChild(image);
            loader = new Cache();
            loader.addEventListener(Cache.LOAD_COMPLETE, onLoadComplete);
            loader.load((("images/news/" + data.image) + ".png"));
            loader2 = new Cache();
            loader2.addEventListener(Cache.LOAD_COMPLETE, bmp2OnLoadComplete);
            if (data.image2){
                loader2.load((("images/news/" + data.image2) + ".png"));
            }
        }
        
        private function bmp2OnLoadComplete(e:Event):void{
            bmp2 = (e.target.asset as Bitmap);
            content.addChild(bmp2);
            alignButtons();
        }
        
        override protected function alignButtons():void{
            super.alignButtons();
            if (bmp){
                bmp.x = ((image.x + ((image.width - bmp.width) / 2)) + offset_x);
                bmp.y = ((image.y + ((image.height - bmp.height) / 2)) + offset_y);
            }
            if (bmp2){
                bmp2.x = (((_w - bmp2.width) - 4) + offset2_x);
                bmp2.y = (((inner_cont.y + msg_h) - (bmp2.height / 2)) + offset2_y);
            }
        }
        
        private function onLoadComplete(e:Event):void{
            bmp = (e.target.asset as Bitmap);
            content.addChild(bmp);
            alignButtons();
        }

    }
}
