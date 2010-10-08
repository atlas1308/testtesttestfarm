package classes.view
{
    import classes.*;
    import classes.model.*;
    import classes.view.components.*;
    
    import flash.events.*;
    
    import org.puremvc.as3.multicore.interfaces.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;

    public class ShopMediator extends Mediator implements IMediator
    {
        public static const NAME:String = "ShopMediator";

        public function ShopMediator(value:Object)
        {
            super(NAME, value);
        }

        override public function listNotificationInterests() : Array
        {
            return [ApplicationFacade.UPDATE_OBJECTS, ApplicationFacade.DISPLAY_SHOP, ApplicationFacade.HIDE_SHOP, ApplicationFacade.SHOW_SHOP_AND_ADD_PLANT, ApplicationFacade.ESCAPE_PRESSED, ApplicationFacade.STAGE_RESIZE];
        }

        protected function get app_data() : AppDataProxy
        {
            return facade.retrieveProxy(AppDataProxy.NAME) as AppDataProxy;
        }

        override public function onRegister() : void
        {
            shop.addEventListener(Shop.USE_ITEM, useItem);
            shop.addEventListener(shop.ON_CLOSE, closeShop);
            shop.addEventListener(shop.ADD_NEIGHBORS, addNeighbors);
            shop.addEventListener(shop.SEND_GIFT, sendGift);
        }

        override public function handleNotification(value:INotification) : void
        {
            var obj:Object = null;
            var body:Number = NaN;
            switch(value.getName())
            {
                case ApplicationFacade.UPDATE_OBJECTS:
                {
                    obj = value.getBody();
                    if (obj.shop)
                    {
                        shop.update(app_data.get_shop_data());
                    }
                    break;
                }
                case ApplicationFacade.DISPLAY_SHOP:
                {
                    sendNotification(ApplicationFacade.SHOW_OVERLAY);
                    shop.visible = true;
                    alignShop();
                    body = value.getBody() as Number;
                    if (body)
                    {
                        shop.goTo(body);
                    }
                    break;
                }
                case ApplicationFacade.ESCAPE_PRESSED:
                {
                    sendNotification(ApplicationFacade.HIDE_OVERLAY);
                    shop.visible = false;
                    break;
                }
                case ApplicationFacade.HIDE_SHOP:
                {
                    sendNotification(ApplicationFacade.HIDE_OVERLAY);
                    shop.visible = false;
                    break;
                }
                case ApplicationFacade.SHOW_SHOP_AND_ADD_PLANT:
                {
                    sendNotification(ApplicationFacade.SHOW_OVERLAY);
                    shop.select_tab("Seeds");
                    alignShop();
                    shop.visible = true;
                    break;
                }
                case ApplicationFacade.STAGE_RESIZE:
                {
                    alignShop();
                    break;
                }
                default:
                {
                    break;
                }
            }
        }

        private function closeShop(event:Event) : void
        {
            shop.visible = false;
            sendNotification(ApplicationFacade.HIDE_OVERLAY);
            sendNotification(ApplicationFacade.REFRESH_TOOLBAR);
        }

        private function addNeighbors(event:Event) : void
        {
            app_data.navigate_to("neighbors");
        }

        protected function get shop() : Shop
        {
            return viewComponent as Shop;
        }

        private function sendGift(event:Event) : void
        {
            closeShop(event);
            sendNotification(ApplicationFacade.SHOW_NEIGHBORS_LIST_POPUP, event.target.item_clicked.id);
        }

        private function useItem(event:Event) : void
        {
            if (!app_data.can_buy(event.target.item_clicked.id))
            {
                return;
            }
            if (app_data.can_close_shop(event.target.item_clicked.id))
            {
                closeShop(null);
            }
            app_data.gift_mode = false;
            sendNotification(ApplicationFacade.REFRESH_TOOLBAR);
            var item:Object = app_data.get_item_data(event.target.item_clicked.id);
            if (item.map_object)
            {
                sendNotification(ApplicationFacade.PLACE_MAP_OBJECT, {flipped:event.target.item_clicked.is_flipped, item:event.target.item_clicked.id});
            }
            else if (app_data.map_can_use_shop_item(event.target.item_clicked.id))
            {
                trace("USE SHOP ITEM");
                sendNotification(ApplicationFacade.USE_SHOP_ITEM, item);
            }
            else if (item.rp_price > 0)
            {
                sendNotification(ApplicationFacade.SPEND_RP, event.target.item_clicked.id);
            }
            else
            {
                sendNotification(ApplicationFacade.BUY_ITEM, event.target.item_clicked.id);
            }
        }

        private function alignShop() : void
        {
            shop.x = int((shop.stage.stageWidth - shop.width) / 2);
            shop.y = int((shop.stage.stageHeight - shop.height) / 2);
        }

    }
}
