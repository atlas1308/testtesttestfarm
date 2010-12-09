package classes.view.components.popups
{
    import flash.display.*;
    import flash.text.*;
    
    import mx.resources.ResourceManager;
    
    import tzh.core.VersionManager;

    public class SnapshotPreviewPopup extends DynamicPopup
    {
        private var bmp:Bitmap;
        private var caption:TextField;

        public function SnapshotPreviewPopup(value:Bitmap) : void
        {
            this.bmp = value;
            var version:String = VersionManager.instance.version;
            var hh:Number = 400;
            var msg_h:Number = 100;
            if(VersionManager.instance.pl){
            	hh = 300;
            	msg_h = 0;
            }
            super(500, hh, 400, msg_h, "", true);
        }

        override protected function init() : void
        {
            caption = new TextField();
            caption.embedFonts = true;
            caption.autoSize = TextFieldAutoSize.LEFT;
            caption.selectable = false;
            var locTextFormat:TextFormat = new TextFormat();
            locTextFormat.color = 3355392;
            locTextFormat.size = 15;
            locTextFormat.font = new Futura().fontName;
            caption.defaultTextFormat = locTextFormat;
            caption.text = ResourceManager.getInstance().getString("message","add_caption_message");
            show_close_btn = true;
            inner_cont_padd = bmp.height + caption.height + 30;
            tf_padd_h = 10;
            align_tf = false;
            selectable = true;
            super.init();
            content.addChild(bmp);
            content.addChild(caption);
            var version:String = VersionManager.instance.version;
            if(version == VersionManager.PL_VERSION){
            	this.tf.visible = false;
	            this.inner_cont.visible = false;
	            this.caption.visible = false;
            }
        }

        override protected function alignButtons() : void
        {
            super.alignButtons();
            bmp.y = 20;
            bmp.x = (_w - bmp.width) / 2;
            caption.y = bmp.y + bmp.height + 10;
            caption.x = (_w - caption.width) / 2;
        }

    }
}
