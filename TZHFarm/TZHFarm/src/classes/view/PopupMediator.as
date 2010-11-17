package classes.view
{
    import classes.*;
    import classes.model.*;
    import classes.view.components.map.*;
    import classes.view.components.popups.*;
    
    import flash.events.*;
    
    import mx.resources.ResourceManager;
    
    import org.puremvc.as3.multicore.interfaces.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    
    import tzh.core.FeedData;
    import tzh.core.JSDataManager;

    public class PopupMediator extends Mediator implements IMediator
    {
        public static const NAME:String = "PopupMediator";

        public function PopupMediator(value:Object)
        {
            super(NAME, value);
        }

        override public function listNotificationInterests() : Array
        {
            return [ApplicationFacade.ESCAPE_PRESSED,ApplicationFacade.CLOSE_UNDERCONSTRUCTIONPOPUP,ApplicationFacade.UPDATE_UNDERCONSTRUCTIONPOPUP, ApplicationFacade.STAGE_RESIZE, ApplicationFacade.CLOSE_NETWORK_DELAY_POPUP];
        }

        protected function get popup() : IPopup
        {
            return viewComponent as IPopup;
        }

        protected function get app_data() : AppDataProxy
        {
            return facade.retrieveProxy(AppDataProxy.NAME) as AppDataProxy;
        }

        override public function onRegister() : void
        {
            if (popup as ComplexPopup)
            {
                popup.addEventListener(ComplexPopup.ITEM_CLICKED, onItemClicked);
                if (popup as UnderConstructionPopup)
                {
                    popup.addEventListener(UnderConstructionPopup.LINK_CLICKED, onLinkClicked);
                    popup.addEventListener(PopupItem.ITEM_CLICKED,itemClickHandler);
                }
            }
            if (popup as NeighborsListPopup)
            {
                popup.addEventListener(NeighborsListPopup.NEXT_CLICKED, onNextClicked);
            }
            popup.addEventListener(DynamicPopup.ON_CLOSE, onClose);
            popup.addEventListener(DynamicPopup.ON_ACCEPT, onAccept);
        }
        
        private function itemClickHandler(event:Event):void {
        	sendNotification(ApplicationFacade.BUY_ITEM_NOT_IN_SHOP,event.target.item);
        }

        protected function get snapshot_proxy() : SnapshotProxy
        {
            return facade.retrieveProxy(SnapshotProxy.NAME) as SnapshotProxy;
        }

        private function onLinkClicked(event:Event) : void
        {
            onClose(event);
            app_data.gift_mode = true;
            sendNotification(ApplicationFacade.USE_SHOP_ITEM, app_data.get_item_data(ComplexPopup(popup).item.id));
        }

        protected function get map_proxy() : MapProxy
        {
            return facade.retrieveProxy(MapProxy.NAME) as MapProxy;
        }

        private function onItemClicked(event:Event) : void
        {
            if (popup is UnderConstructionPopup)
            {
                if (ComplexPopup(popup).item is SendGiftsPopupItem)
                {
                    sendNotification(ApplicationFacade.NAVIGATE_TO_URL, "gifts");
                }
                else
                {
                    app_data.show_ask_for_materials_feed_dialog(ComplexPopup(popup).item.id);
                }
            }
        }

        private function onAccept(event:Event) : void
        {
            var multiProcessor:MultiProcessor = null;
            if (popup as HelpPopup)
            {
                sendNotification(ApplicationFacade.WATER_PLANTS);
            }
            if (popup as RefreshPagePopup)
            {
                JSDataManager.reload();// 更新为reload方法,原来是使用的跳转的方式
            }
            if (popup as CashPopup)
            {
                JSDataManager.showPayPage();
            }
            if (popup as LevelUpPopup)
            {
                var feedData:Object = FeedData.getUpgradeLevelMessage(app_data.user_name,app_data.get_level_data()["level"]);// 获取最新的等级
                JSDataManager.getInstance().postFeed(feedData);
            }
            if (popup as AcceptSnapshotPopup)
            {
                //sendNotification(ApplicationFacade.SHOW_STREAM_PERMISSIONS);
                sendNotification(ApplicationFacade.ACTIVATE_SNAPSHOT_MODE);
            }
            if (popup as SnapshotPreviewPopup)
            {
                snapshot_proxy.publish_snapshot(DynamicPopup(popup).get_message());
            }
            if(popup is AcceptShowShopPopup){// 跳转到商店购买自动工具的那一栏
            	sendNotification(ApplicationFacade.SHOW_SHOP_BY_TITLE,ResourceManager.getInstance().getString("message","automation_type_message"));
            }
            if (popup as DynamicPopup)
            {
                switch(DynamicPopup(popup).type)
                {
                    case PopupTypes.SHOW_GIFTS_POPUP:
                    {
                        sendNotification(ApplicationFacade.NAVIGATE_TO_URL, "gifts");
                        break;
                    }
                    case PopupTypes.ACCEPT_SELECTED_GIFT:// 送礼物的功能
                    {
                        onClose();
                        sendNotification(ApplicationFacade.SEND_GIFT, DynamicPopup(popup).info);
                        break;
                    }
                    case PopupTypes.PUBLISH_GIFT_SENT_STORY:
                    {
                        app_data.post_on_friend_wall(DynamicPopup(popup).info);
                        break;
                    }
                    case PopupTypes.SHOW_GIFT_RECEIVED_POPUP:
                    {
                        app_data.show_gift_received_popup_displayed();
                        break;
                    }
                    case PopupTypes.GIFT_SENT_CONFIRMATION:
                    case PopupTypes.SUGGEST_TO_BUY_GIFT:
                    {
                        onClose();
                        sendNotification(ApplicationFacade.DISPLAY_SHOP);
                        break;
                    }
                    case PopupTypes.SELECT_RAW_MATERIAL:// 选择加工的作物
                    {
                        multiProcessor = map_proxy.get_map_object() as MultiProcessor;
                        multiProcessor.set_raw_material(SelectPopup(popup).selected_index);
                        app_data.save_selected_raw_material(SelectPopup(popup).selected_index, multiProcessor.id, multiProcessor.grid_x, multiProcessor.grid_y);
                        break;
                    }
                    case PopupTypes.SELECT_OBJECT:
                    {
                        if (app_data.gift_mode)
                        {
                            sendNotification(ApplicationFacade.USE_GIFT, {target:SelectPopup(popup).selected_data.object, item:SelectPopup(popup).selected_data.material});
                        }
                        else
                        {
                            sendNotification(ApplicationFacade.SPEND_RP, {target:SelectPopup(popup).selected_data.object, item:SelectPopup(popup).selected_data.material});
                        }
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
            }
            if (popup as SendGiftsPopup)
            {
                sendNotification(ApplicationFacade.NAVIGATE_TO_URL, "gifts");
            }
            if (popup as StoryPopup)
            {
                app_data.show_feed_dialog(StoryPopup(popup).feed_data);
            }
            if (popup as FriendHelpedPopup)
            {
                app_data.friend_helped_popup_displayed();
            }
            if (popup is NetworkDelayPopup)
            {
                JSDataManager.reload();
            } 
            onClose();
        }

        private function onClose(event:Event = null) : void
        {
            if (popup as SnapshotPreviewPopup)
            {
                sendNotification(ApplicationFacade.DEACTIVATE_SNAPSHOT_MODE);
            }
            if (popup as LotteryPopup)
            {
                app_data.add_lottery_coins();
            }
            if(popup is AcceptShowShopPopup){
            	// 所有的map里的工具 都变成手动的
            	//map_proxy.
            }
            if (popup as DynamicPopup)
            {
                switch(DynamicPopup(popup).type)
                {
                    case PopupTypes.SHOW_GIFTS_POPUP:
                    {
                        app_data.show_gifts_popup_displayed();
                        sendNotification(ApplicationFacade.HIDE_GIFT_BOX);
                        break;
                    }
                    case PopupTypes.SELECT_RAW_MATERIAL:
                    {
                        if (event && SelectPopup(popup).selected_name)
                        {
                            app_data.report_confirm_error(ResourceManager.getInstance().getString("message","no_selected_name_in_barn_message",[SelectPopup(popup).selected_name]));
                        }
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
            }
            popup.remove();
            facade.removeMediator(mediatorName);
            popup_proxy.show_next_popup();
        }

        override public function handleNotification(value:INotification) : void
        {
            switch(value.getName())
            {
                case ApplicationFacade.ESCAPE_PRESSED:
                {
                    if (popup as RefreshPagePopup)
                    {
                        return;
                    }
                    if (popup as NetworkDelayPopup)
                    {
                        return;
                    }
                    onClose(null);
                    break;
                }
                case ApplicationFacade.STAGE_RESIZE:
                {
                    popup.refresh();
                    break;
                }
                case ApplicationFacade.CLOSE_NETWORK_DELAY_POPUP:
                {
                    if (popup is NetworkDelayPopup)
                    {
                        onClose(null);
                    }
                    break;
                }
                case ApplicationFacade.UPDATE_UNDERCONSTRUCTIONPOPUP:
                {
                	// this is has a bug
                	break;
                }
                case ApplicationFacade.CLOSE_UNDERCONSTRUCTIONPOPUP:{
                	/* if(popup is UnderConstructionPopup){
                		popup.remove();
            			facade.removeMediator(mediatorName);
                	} */
                	break;
            	}
                default:
                {
                    break;
                }
            }
        }

        protected function get popup_proxy() : PopupProxy
        {
            return facade.retrieveProxy(PopupProxy.NAME) as PopupProxy;
        }

        private function onNextClicked(event:Event) : void
        {
            onClose(event);
            var info:Object = {neighbor:NeighborsListPopup(event.target).selected_neighbor, gift:event.target.info.gift,type:event.target.info.type};
            var sendData:Object = app_data.get_accept_selected_gift_popup_data(info.neighbor, info.gift,info.type);
            sendData.data = info;
            sendNotification(ApplicationFacade.SHOW_POPUP, sendData);
        }

    }
}
