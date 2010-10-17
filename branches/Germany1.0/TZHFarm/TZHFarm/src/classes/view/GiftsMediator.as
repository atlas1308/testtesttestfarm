package classes.view
{
    import classes.*;
    import classes.model.*;
    import classes.view.components.*;
    
    import flash.events.*;
    
    import org.puremvc.as3.multicore.interfaces.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;

    public class GiftsMediator extends Mediator implements IMediator
    {
        public static const NAME:String = "GiftsMediator";

        public function GiftsMediator(value:Object)
        {
            super(NAME, value);
        }

        override public function listNotificationInterests() : Array
        {
            return [ApplicationFacade.UPDATE_OBJECTS, ApplicationFacade.STAGE_RESIZE,ApplicationFacade.DISPLAY_GIFTS, ApplicationFacade.ESCAPE_PRESSED];
        }

        protected function get gifts() : Gifts
        {
            return viewComponent as Gifts;
        }

        private function sellItem(event:Event) : void
        {
            sendNotification(ApplicationFacade.SELL_GIFT, event.target.item_clicked.id);
        }

        protected function get app_data() : AppDataProxy
        {
            return facade.retrieveProxy(AppDataProxy.NAME) as AppDataProxy;
        }

        override public function onRegister() : void
        {
            gifts.addEventListener(gifts.USE_ITEM, useItem);
            gifts.addEventListener(gifts.TRADE_ITEM, sellItem);
            gifts.addEventListener(gifts.ON_CLOSE, closeGifts);
        }

        override public function handleNotification(useItem:INotification) : void
        {
            var body:Object = null;
            switch(useItem.getName())
            {
                case ApplicationFacade.UPDATE_OBJECTS:
                {
                    body = useItem.getBody();
                    if (body.gifts)
                    {
                        gifts.update(app_data.get_gifts_data());
                    }
                    break;
                }
                case ApplicationFacade.DISPLAY_GIFTS:
                {
                    sendNotification(ApplicationFacade.SHOW_OVERLAY);
                    gifts.visible = true;
                    alignGifts();
                    var page:Number = useItem.getBody() as Number;
                    if (page)
                    {
                        gifts.goTo(page);
                    }
                    break;
                }
                case ApplicationFacade.ESCAPE_PRESSED:
                {
                    if (gifts.visible)
                    {
                        closeGifts(null);
                    }
                    break;
                }
                case ApplicationFacade.STAGE_RESIZE:{
                	this.alignGifts();
                	break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }

        private function closeGifts(event:Event) : void
        {
            gifts.visible = false;
            sendNotification(ApplicationFacade.HIDE_OVERLAY);
            sendNotification(ApplicationFacade.REFRESH_TOOLBAR);
        }

        private function useItem(event:Event) : void
        {
            if (!app_data.can_use_gift(event.target.item_clicked.id))
            {
                return;
            }
            app_data.gift_mode = true;
            var item:Object = app_data.get_item_data(event.target.item_clicked.id);
            if (item.map_object)
            {
                closeGifts(event);
                sendNotification(ApplicationFacade.PLACE_MAP_OBJECT, {flipped:event.target.item_clicked.is_flipped, item:event.target.item_clicked.id});
            }
            else if (app_data.map_can_use_shop_item(event.target.item_clicked.id))
            {
                closeGifts(event);
                sendNotification(ApplicationFacade.USE_SHOP_ITEM, item);
            }
            else
            {
                sendNotification(ApplicationFacade.USE_GIFT, event.target.item_clicked.id);
            }
        }

        private function alignGifts() : void
        {
        	gifts.center();
        }

    }
}
