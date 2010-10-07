package classes.view.components.popups
{
    import flash.display.*;
    import flash.text.*;
    
    import mx.resources.ResourceManager;

    public class SnapshotPreviewPopup extends DynamicPopup
    {
        private var bmp:Bitmap;
        private var caption:TextField;

        public function SnapshotPreviewPopup(value:Bitmap) : void
        {
            this.bmp = value;
            super(500, 400, 400, 100, "", true);
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
