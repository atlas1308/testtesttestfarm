package classes.controller
{
    import classes.*;
    import classes.model.*;
    import classes.model.transactions.*;
    import classes.view.components.map.*;
    
    import org.puremvc.as3.multicore.interfaces.*;
    import org.puremvc.as3.multicore.patterns.command.*;

    public class AddTransactionCommand extends SimpleCommand implements ICommand
    {
        private var data:Object;

        public function AddTransactionCommand()
        {
        	
        }

        override public function execute(value:INotification) : void
        {
            var transactionBody:TransactionBody = null;
            var target:Object = null;
            var item_id:Number = NaN;
            var transactionProxy:TransactionProxy = facade.retrieveProxy(TransactionProxy.NAME) as TransactionProxy;
            var result:Boolean = false;
            switch(value.getName())
            {
                case ApplicationFacade.ADD_MAP_OBJECT:
                {
                    transactionBody = new AddMapObjectCall(value.getBody() as MapObject, app_data.gift_mode);
                    result = app_data.add_map_object(value.getBody() as MapObject, transactionBody);
                    break;
                }
                case ApplicationFacade.MOVE_MAP_OBJECT:
                {
                    transactionBody = new MoveMapObjectCall(value.getBody() as MapObject);
                    result = app_data.move_map_object(value.getBody() as MapObject);
                    break;
                }
                case ApplicationFacade.REMOVE_MAP_OBJECT:
                {
                    transactionBody = new RemoveMapObjectCall(value.getBody() as MapObject);
                    result = app_data.remove_map_object(value.getBody() as MapObject);
                    break;
                }
                case ApplicationFacade.COLLECT_PRODUCT:
                {
                    transactionBody = new CollectProductCall(value.getBody() as MapObject);
                    result = app_data.collect_product(value.getBody() as MapObject, transactionBody);
                    break;
                }
                case ApplicationFacade.FEED_MAP_OBJECT:
                {
                    transactionBody = new FeedMapObjectCall(value.getBody() as MapObject);
                    result = app_data.feed_map_object(value.getBody() as MapObject, transactionBody);
                    break;
                }
                case ApplicationFacade.ADD_PLANT:
                {
                    transactionBody = new AddPlantCall(value.getBody());
                    result = app_data.add_plant(value.getBody(), transactionBody);
                    break;
                }
                case ApplicationFacade.APPLY_RAIN:
                case ApplicationFacade.SPEND_RP:
                {
                    data = value.getBody();
                    if (!(data is Number))
                    {
                        item_id = data.item;
                        target = data.target;
                    }
                    else
                    {
                        item_id = data as Number;
                    }
                    transactionBody = new SpendRPCall(item_id, target);
                    result = app_data.spend_rp(item_id, target);
                    break;
                }
                case ApplicationFacade.WATER_PLANTS:
                {
                    transactionBody = new WaterPlantsCall(app_data.friend_farm_id);
                    result = app_data.water_plants();
                    break;
                }
                case ApplicationFacade.ADD_ANIMAL:
                {
                    transactionBody = new AddAnimalCall(value.getBody() as MapObject, app_data.gift_mode);
                    result = app_data.add_animal(value.getBody() as MapObject);
                    break;
                }
                case ApplicationFacade.SELL_STORAGE_ITEM:
                {
                    transactionBody = new SellStorageItemCall(value.getBody());
                    result = app_data.sell_storage_item(value.getBody());
                    break;
                }
                case ApplicationFacade.SELL_ALL_STORAGE:
                {
                    transactionBody = new SellAllStorageCall();
                    result = app_data.sell_all_storage();
                    break;
                }
                case ApplicationFacade.USE_GIFT:
                {
                    data = value.getBody();
                    if (!(data is Number))
                    {
                        item_id = data.item;
                        target = data.target;
                    }
                    else
                    {
                        item_id = data as Number;
                    }
                    transactionBody = new UseGiftCall(item_id, target);
                    result = app_data.use_gift(item_id, target);
                    break;
                }
                case ApplicationFacade.BUY_ITEM:
                {
                    transactionBody = new BuyItemCall(value.getBody() as Number);
                    result = app_data.buy_item(value.getBody() as Number);
                    break;
                }
                case ApplicationFacade.SELL_GIFT:
                {
                    transactionBody = new TradeItemCall(value.getBody() as Number);
                    result = app_data.trade_item(value.getBody() as Number);
                    break;
                }
                case ApplicationFacade.FERTILIZE:
                {
                    transactionBody = new FertilizeCall(value.getBody());
                    result = app_data.fertilize(value.getBody());
                    break;
                }
                case ApplicationFacade.FLIP_MAP_OBJECT:
                {
                    transactionBody = new FlipMapObjectCall(value.getBody() as MapObject);
                    result = app_data.flip_map_object(value.getBody() as MapObject);
                    break;
                }
                case ApplicationFacade.POLLINATE:
                {
                    transactionBody = new PollinateCall(value.getBody());
                    result = app_data.pollinate(value.getBody());
                    break;
                }
                case ApplicationFacade.REFILL_MAP_OBJECT:
                {
                    transactionBody = new RefillMapObjectCall(value.getBody());
                    result = app_data.refill_map_object(value.getBody(), transactionBody);
                    break;
                }
                case ApplicationFacade.AUTO_REFILL:
                {
                    transactionBody = new FeedMapObjectCall(value.getBody() as MapObject);
                    result = app_data.autorefill(value.getBody() as MapObject, transactionBody);
                    break;
                }
                case ApplicationFacade.AUTO_COLLECT:
                {
                    transactionBody = new CollectProductCall(value.getBody() as MapObject);
                    result = app_data.autocollect_product(value.getBody() as MapObject, transactionBody);
                    break;
                }
                case ApplicationFacade.TOGGLE_AUTOMATION:
                {
                    transactionBody = new ToggleAutomationCall(value.getBody() as MapObject);
                    result = app_data.toggle_automation(value.getBody() as MapObject);
                    break;
                }
                case ApplicationFacade.INSTALL_IRRIGATION:
                {
                    transactionBody = new InstallIrrigationCall(value.getBody(), app_data.gift_mode);
                    result = app_data.install_irrigation(value.getBody());
                    break;
                }
                case ApplicationFacade.FERTILIZE_FRIEND_HELPED:{
                	transactionBody = new FriendFertilizeCall(value.getBody());
                    result = app_data.friendFertilize(value.getBody());
                    break;
                }
                default:
                {
                    break;
                }
            }
            if (result && transactionBody)
            {
                transactionBody.add_parameter("data_hash", app_data.data_hash);// add data_hash
                transactionProxy.set_data_hash(app_data.data_hash);
                transactionProxy.add(transactionBody, true);
            }
        }

        private function get app_data() : AppDataProxy
        {
            return facade.retrieveProxy(AppDataProxy.NAME) as AppDataProxy;
        }

    }
}
