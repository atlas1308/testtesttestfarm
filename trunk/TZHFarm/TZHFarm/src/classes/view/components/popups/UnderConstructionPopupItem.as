package classes.view.components.popups {
    import classes.view.components.buttons.GameButton;
    
    import flash.events.*;
    import flash.text.*;
    
    import mx.resources.ResourceManager;

    public class UnderConstructionPopupItem extends PopupItem {

        public static const LINK_CLICKED:String = "linkClicked";

        private var help_tf:TextField;
        
        private var sendGiftButton:GameButton;

        public function UnderConstructionPopupItem(data:Object){
            data.width = 200;
            //data.width = 125;
            data.height = 160;
            super(data);
        }
        
        override protected function init():void{
            create_objects();
            if(data.giftable){
            	sendGiftButton = new GameButton(ResourceManager.getInstance().getString("message","send_free_gifts_message"),13);
            	container.addChild(sendGiftButton);
            }
            help_tf = create_tf(12, 10049313, 0, new Futura().fontName, "center", (data.help_txt as String));
            container.addChild(help_tf);
            help_tf.addEventListener(TextEvent.LINK, onHyperLinkEvent);
            align();
            draw();
        }
        
        protected function onHyperLinkEvent(e:TextEvent):void{
            dispatchEvent(new Event(LINK_CLICKED));
        }
        
        override protected function align():void{
            var padd:Number = (((((data.height - (button.height / 2)) - title.height) - image_h) - desc.height) - help_tf.height) / 5;
            title.x = (data.width - title.width) / 2;
            image_cont.x = (data.width - image_w) / 2;
            desc.x = (data.width - desc.width) / 2;
            help_tf.x = (data.width - desc.width) / 2;
            var hGap:Number = 5;
            var ww:Number = button.width;
            if(sendGiftButton){
            	ww = ww + hGap + sendGiftButton.width;
            	button.x = (data.width - ww) / 2;
            	sendGiftButton.x = button.x + button.width + hGap;
            }else {
            	button.x = (data.width - button.width) / 2;
            }
            title.y = padd;
            image_cont.y = (title.y + title.height) + padd;
            desc.y = (image_cont.y + image_h) + padd;
            help_tf.y = (desc.y + desc.height) + padd;
            button.y = data.height - (button.height / 2);
            if(sendGiftButton){
            	sendGiftButton.y = (data.height - (button.height / 2));
            }
        }
    }
}
