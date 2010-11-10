package classes.view.components.popups {
    import classes.ApplicationFacade;
    import classes.view.components.buttons.GameButton;
    import classes.view.components.shop.ShopItem;
    
    import flash.events.*;
    import flash.text.*;
    
    import mx.resources.ResourceManager;
    
    import org.puremvc.as3.multicore.patterns.facade.Facade;

    public class UnderConstructionPopupItem extends PopupItem {

        public static const LINK_CLICKED:String = "linkClicked";
        
        private var sendGiftButton:GameButton;
        
        public static const FREE_GIFT:String = "free_gift";// 免费的礼物   

        public function UnderConstructionPopupItem(data:Object){
            data.width = 200;
            data.height = 160;
            super(data);
        }

        override protected function init():void{
            create_objects();
            button.set_style("mauve");
            if(data.giftable){
            	sendGiftButton = new GameButton(ResourceManager.getInstance().getString("message","send_free_gifts_message"),13);
            	sendGiftButton.addEventListener(MouseEvent.CLICK,showNeighborsListPopup);
            	sendGiftButton.set_style("green");
            	container.addChild(sendGiftButton);
            }
            var message:String = "";// 默认rp
            if(data.buy_method == ShopItem.BUY_METHOD_COIN){
            	message = data.price + " " + data.ResourceManager.getInstance().getString("message","coins_message");
            }else {
            	message = data.rp_price + " " + ResourceManager.getInstance().getString("message","ranch_cash_message")
            }
            var button_label:String = button.label + " "+ message;
            button.set_label(button_label);
            align();
            draw();
        }
        
        // 弹出邀请好友的面板
        private function showNeighborsListPopup(event:MouseEvent):void {
        	Facade.getInstance(TZHFarm.MAIN_STAGE).sendNotification(ApplicationFacade.SHOW_NEIGHBORS_LIST_POPUP,this.data.id,FREE_GIFT);
        }
        
        protected function onHyperLinkEvent(e:TextEvent):void{
            dispatchEvent(new Event(LINK_CLICKED));
        }
        
        override protected function align():void{// - help_tf.height
            var padd:Number = (((((data.height - (button.height / 2)) - title.height) - image_h) - desc.height)) / 5;
            title.x = (data.width - title.width) / 2;
            image_cont.x = (data.width - image_w) / 2;
            desc.x = (data.width - desc.width) / 2;
            var vGap:Number = 3;
            button.x = (data.width - button.width) / 2;
            if(sendGiftButton){
            	sendGiftButton.x = (data.width - sendGiftButton.width) / 2;
            	sendGiftButton.y = data.height - sendGiftButton.height / 2;
            	button.y = sendGiftButton.y - vGap - button.height;
            }else {
            	button.y = data.height - button.height / 2;
            }
            title.y = padd;
            image_cont.y = (title.y + title.height) + padd;
            desc.y = (image_cont.y + image_h) + padd
        }
    }
}
