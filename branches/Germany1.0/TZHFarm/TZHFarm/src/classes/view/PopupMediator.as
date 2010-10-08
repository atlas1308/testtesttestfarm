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
            return [ApplicationFacade.ESCAPE_PRESSED, ApplicationFacade.STAGE_RESIZE, ApplicationFacade.CLOSE_NETWORK_DELAY_POPUP];
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
                }
            }
            if (popup as NeighborsListPopup)
            {
                popup.addEventListener(NeighborsListPopup.NEXT_CLICKED, onNextClicked);
            }
            popup.addEventListener(DynamicPopup.ON_CLOSE, onClose);
            popup.addEventListener(DynamicPopup.ON_ACCEPT, onAccept);
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
            if (popup as ConfirmPopup)
            {
                sendNotification(ConfirmPopup(popup).notif_name, ConfirmPopup(popup).notif_body);
            }
            if (popup as HelpPopup)
            {
                sendNotification(ApplicationFacade.WATER_PLANTS);
            }
            if (popup as RefreshPagePopup)
            {
                sendNotification(ApplicationFacade.NAVIGATE_TO_URL, "");
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
                        onClose(null);
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
                        onClose(null);
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
                            trace("USE GIFT");
                            sendNotification(ApplicationFacade.USE_GIFT, {target:SelectPopup(popup).selected_data.object, item:SelectPopup(popup).selected_data.material});
                        }
                        else
                        {
                            trace("SPEND RP");
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
                app_data.navigate_to("");
            }
            onClose(null);
        }

        private function onClose(event:Event) : void
        {
            trace("popup onClose");
            if (popup as SnapshotPreviewPopup)
            {
                sendNotification(ApplicationFacade.DEACTIVATE_SNAPSHOT_MODE);
            }
            if (popup as LotteryPopup)
            {
                app_data.add_lottery_coins();
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
                    trace("popup mediator close network delay popup", popup);
                    if (popup is NetworkDelayPopup)
                    {
                        onClose(null);
                    }
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
            var info:Object = {neighbor:NeighborsListPopup(event.target).selected_neighbor, gift:event.target.info.gift};
            var sendData:Object = app_data.get_accept_selected_gift_popup_data(info.neighbor, info.gift);
            sendData.data = info;
            sendNotification(ApplicationFacade.SHOW_POPUP, sendData);
        }

    }
}
