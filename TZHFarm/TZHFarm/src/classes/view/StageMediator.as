﻿package classes.view
{
    import classes.*;
    import classes.model.*;
    import classes.utils.*;
    import classes.view.components.*;
    import classes.view.components.buttons.*;
    import classes.view.components.map.*;
    import classes.view.components.messages.NewsPanel;
    import classes.view.components.popups.*;
    
    import flash.display.*;
    import flash.events.*;
    import flash.external.*;
    import flash.ui.*;
    
    import mx.resources.ResourceManager;
    
    import org.puremvc.as3.multicore.interfaces.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    
    import tzh.core.Box;
    
    /**
     * 整个场景的UI,和整个场景的显示,弹出的面板,都在这里 
     */ 
    public class StageMediator extends Mediator implements IMediator
    {
        private var snapshot_viewport:SnapshotViewport;
        private var snapshot_mode:Boolean = false;
        private var friends_list:FriendsList;
        private var coins:Coins;
        private var name_bar:NameBar;
        private var level_bar:LevelBar;
        private var cancel_snapshot:GameButton;
        private var operations:Operations;
        private var reward_points:RewardPoints;
        private var save_button:SaveButton;
        private var toolbar:Toolbar;
        private var gift_box:GiftBox;
        public static const NAME:String = "StageMediator";
        public static const STAGE_WIDTH:Number = 760;
        private var messageBar:MessageBar;

        public function StageMediator(value:Object)
        {
            super(NAME, value);
        }

        private function toggle_full_screen() : void
        {
            if (stage.displayState == StageDisplayState.FULL_SCREEN){
                stage.displayState = StageDisplayState.NORMAL;
            } else {
                stage.displayState = StageDisplayState.FULL_SCREEN;
            }
        }
		
		
        private function create_objects() : void
        {
            Cursor.stage = stage;
            var my_ranch:Map = new Map(stage.stageWidth, stage.stageHeight - 40);
            my_ranch.name = "my_ranch";
            facade.registerMediator(new MapMediator(my_ranch));
            stage.addChild(my_ranch);
            var friend_farm:Map = new Map(stage.stageWidth, stage.stageHeight - 40);
            friend_farm.name = "friend_farm";
            facade.registerMediator(new FriendFarmMediator(friend_farm));
            stage.addChild(friend_farm);
            var rain:Rain = new Rain();
            facade.registerMediator(new RainMediator(rain));
            stage.addChild(rain);
            coins = new Coins();
            facade.registerMediator(new CoinsMediator(coins));
            stage.addChild(coins);
            reward_points = new RewardPoints();
            facade.registerMediator(new RewardPointsMediator(reward_points));
            stage.addChild(reward_points);
            level_bar = new LevelBar();
            facade.registerMediator(new LevelBarMediator(level_bar));
            stage.addChild(level_bar);
            name_bar = new NameBar();
            facade.registerMediator(new NameBarMediator(name_bar));
            stage.addChild(name_bar);
            friends_list = new FriendsList();
            facade.registerMediator(new FriendsListMediator(friends_list));
            friends_list.y = stage.stageHeight - 97;
            friends_list.x = 0;
            stage.addChild(friends_list);
            operations = new Operations();
            operations.name = "operations";
            facade.registerMediator(new OperationsMediator(operations));
            stage.addChild(operations);
            gift_box = new GiftBox();
            facade.registerMediator(new GiftBoxMediator(gift_box));
            stage.addChild(gift_box);
            toolbar = new Toolbar();
            facade.registerMediator(new ToolbarMediator(toolbar));
            stage.addChild(toolbar);
            toolbar.x = stage.stageWidth - 194;
            toolbar.y = stage.stageHeight - 97;
            toolbar.name = "toolbar";
            save_button = new SaveButton();
            facade.registerMediator(new SaveButtonMediator(save_button));
            stage.addChild(save_button);
            messageBar = new MessageBar();
            facade.registerMediator(new MessageBarMediator(messageBar));
            messageBar.y = 100;
            messageBar.x = 10;
            stage.addChild(messageBar);
            var overlay:Overlay = new Overlay();
            facade.registerMediator(new OverlayMediator(overlay));
            stage.addChild(overlay);
            overlay.draw(true, 16777215, 1, true);
            var shop:Shop = new Shop();
            shop.name = "shop";
            facade.registerMediator(new ShopMediator(shop));
            stage.addChild(shop);
            shop.visible = false;
            var storage:Storage = new Storage();
            facade.registerMediator(new StorageMediator(storage));
            stage.addChild(storage);
            storage.visible = false;
            var gifts:Gifts = new Gifts();
            facade.registerMediator(new GiftsMediator(gifts));
            stage.addChild(gifts);
            gifts.visible = false;
            var confirm_cont:* = new ConfirmationContainer();
            facade.registerMediator(new ConfirmationMediator(confirm_cont));
            stage.addChild(confirm_cont);
            var anim_cont:AnimationContainer = new AnimationContainer(toolbar.storage);
            facade.registerMediator(new AnimationMediator(anim_cont));
            stage.addChild(anim_cont);
            
            var fertilizeBox:Box = new Box();
            fertilizeBox.visible = false;
            fertilizeBox.show();
            fertilizeBox.x = fertilizeBox.width / 2;
            fertilizeBox.y = stage.stageHeight / 2 - 40;
            fertilizeBox.render();
            facade.registerMediator(new FertilizeBoxMediator(fertilizeBox));
            stage.addChild(fertilizeBox);
            
            
            var tooltip:classes.view.components.Tooltip = new classes.view.components.Tooltip();
            facade.registerMediator(new TooltipMediator(tooltip)); 
            stage.addChild(tooltip); 
            snapshot_viewport = new SnapshotViewport();
            snapshot_viewport.addEventListener(snapshot_viewport.TAKE_PHOTO, takePhoto);
            stage.addChild(snapshot_viewport);
            cancel_snapshot = new GameButton(ResourceManager.getInstance().getString("message","game_button_cancel_message"), 14, 1.2);
            cancel_snapshot.set_colors(11534336, 13959168, 7405568);
            cancel_snapshot.visible = false;
            cancel_snapshot.addEventListener(MouseEvent.CLICK, snapshotCanceled);
            stage.addChild(cancel_snapshot);
            stageResize();
            app_data.game_objects_created();
        }
        
        override public function handleNotification(value:INotification) : void
        {
            var body:Object = null;
            var mapObject:MapObject = null;
            var selectPopup:SelectPopup = null;
            var newsPopup:NewsPopup = null;
            var dynamicPopup:DynamicPopup = null;
            switch(value.getName())
            {
                case ApplicationFacade.CREATE_OBJECTS:
                {
                    create_objects();
                    break;
                }
                case ApplicationFacade.DISPLAY_ERROR:
                {
                    var popup:Popup = new Popup(value.getBody() as String);
                    facade.registerMediator(new PopupMediator(popup));
                    stage.addChild(popup);
                    break;
                }
                case ApplicationFacade.SHOW_CONFIRM_POPUP:
                {
                    body = value.getBody();
                    facade.removeMediator(PopupMediator.NAME);
                    var confirmPopup:ConfirmPopup = new ConfirmPopup(body.msg, body.obj);
                    facade.registerMediator(new PopupMediator(confirmPopup));
                    stage.addChild(confirmPopup);
                    break;
                }
                case ApplicationFacade.REFRESH_FOCUS:
                {
                    stage.focus = stage.getChildAt(0) as InteractiveObject;
                    break;
                }
                case ApplicationFacade.SHOW_HELP_POPUP:
                {
                	facade.removeMediator(PopupMediator.NAME);
                    var helpPopup:HelpPopup = new HelpPopup(app_data.get_help_data());
                    facade.registerMediator(new PopupMediator(helpPopup));
                    stage.addChild(helpPopup);
                    break;
                }
                case ApplicationFacade.SHOW_LEVEL_UP_POPUP:
                {
                    facade.removeMediator(PopupMediator.NAME);
                    var levelUpPopup:LevelUpPopup = new LevelUpPopup(app_data.get_level_up_data());
                    facade.registerMediator(new PopupMediator(levelUpPopup));
                    stage.addChild(levelUpPopup);
                    break;
                }
                case ApplicationFacade.SHOW_LOTTERY_POPUP:
                {
                	facade.removeMediator(PopupMediator.NAME);
                    var lotteryPopup:LotteryPopup = new LotteryPopup(app_data.lottery_message());
                    facade.registerMediator(new PopupMediator(lotteryPopup));
                    stage.addChild(lotteryPopup);
                    break;
                }
                case ApplicationFacade.SHOW_REFRESH_PAGE_POPUP:
                {
                    facade.removeMediator(PopupMediator.NAME);
                    var refreshPagePopup:RefreshPagePopup = new RefreshPagePopup(value.getBody() as String);
                    facade.registerMediator(new PopupMediator(refreshPagePopup));
                    stage.addChild(refreshPagePopup);
                    break;
                }
                case ApplicationFacade.TOGGLE_FULL_SCREEN:
                {
                    toggle_full_screen();
                    break;
                }
                case ApplicationFacade.SHOW_ADD_CASH_POPUP:
                {
                	facade.removeMediator(PopupMediator.NAME);
                    var cashPopup:CashPopup = new CashPopup();
                    facade.registerMediator(new PopupMediator(cashPopup));
                    stage.addChild(cashPopup);
                    break;
                }
                case ApplicationFacade.SHOW_ACCEPT_SNAPSHOT:
                {
                	facade.removeMediator(PopupMediator.NAME);
                    var acceptSnapshot:AcceptSnapshotPopup = new AcceptSnapshotPopup();
                    facade.registerMediator(new PopupMediator(acceptSnapshot));
                    stage.addChild(acceptSnapshot);
                    break;
                }
                case ApplicationFacade.ACTIVATE_SNAPSHOT_MODE:
                {
                    snapshot_mode = true;
                    cancel_snapshot.visible = true;
                    snapshot_viewport.start();
                    break;
                }
                case ApplicationFacade.DEACTIVATE_SNAPSHOT_MODE:
                {
                    snapshot_mode = false;
                    break;
                }
                case ApplicationFacade.SHOW_SNAPSHOT_PREVIEW:
                {
                	facade.removeMediator(PopupMediator.NAME);
                    var snapShotPreview:SnapshotPreviewPopup = new SnapshotPreviewPopup(value.getBody() as Bitmap);
                    facade.registerMediator(new PopupMediator(snapShotPreview));
                    stage.addChild(snapShotPreview);
                    cancel_snapshot.visible = false;
                    snapshot_viewport.stop();
                    break;
                }
                case ApplicationFacade.SHOW_STREAM_PERMISSIONS:
                {
                    stage.displayState = StageDisplayState.NORMAL;
                    break;
                }
                case ApplicationFacade.SHOW_SELECT_RAW_MATERIAL_POPUP:
                {
                    if (popup_proxy.can_show_popup)
                    {
                        popup_proxy.can_show_popup = false;
                        mapObject = value.getBody() as MapObject;
                        body = app_data.get_select_popup_data(mapObject);
                        if (body)
                        {
                            selectPopup = new SelectPopup(body);
                            selectPopup.type = PopupTypes.SELECT_RAW_MATERIAL;
                            facade.registerMediator(new PopupMediator(selectPopup));
                            stage.addChild(selectPopup);
                        }
                    }
                    else
                    {
                        popup_proxy.add_popup(value);
                    }
                    break;
                }
                case ApplicationFacade.SHOW_NEWS_POPUP:
                {
                    if (popup_proxy.can_show_popup)
                    {
                        popup_proxy.can_show_popup = false;
                        newsPopup = new NewsPopup(value.getBody());
                        facade.registerMediator(new PopupMediator(newsPopup));
                        stage.addChild(newsPopup);
                    }
                    else
                    {
                        popup_proxy.add_popup(value);
                    }
                    break;
                }
                case ApplicationFacade.SHOW_POPUP:
                {
                    if (popup_proxy.can_show_popup)
                    {
                        popup_proxy.can_show_popup = false;
                        body = value.getBody();
                        var w:Number = body.width ? (body.width) : (400);
                        var h:Number = body.height ? (body.height) : (190);
                        var inner_width:Number = body.inner_width ? (body.inner_width) : (300);
                        var inner_height:Number = body.inner_height ? (body.inner_height) : (110);
                        dynamicPopup = new DynamicPopup(w, h, inner_width, inner_height, body.message);
                        dynamicPopup.type = body.type;
                        if (body.data)
                        {
                            dynamicPopup.info = body.data;
                        }
                        if (body.ok_label)
                        {
                            dynamicPopup.set_ok_label(body.ok_label);
                        }
                        if (body.close_label)
                        {
                            dynamicPopup.set_close_label(body.close_label);
                        }
                        facade.registerMediator(new PopupMediator(dynamicPopup));
                        stage.addChild(dynamicPopup);
                    }
                    else
                    {
                        popup_proxy.add_popup(value);
                    }
                    break;
                }
                case ApplicationFacade.SHOW_STORY_POPUP:
                {
                    break;
                }
                case ApplicationFacade.SHOW_ITEMS_RECEIVED:
                {
                    break;
                }
                case ApplicationFacade.SHOW_SEND_GIFTS_POPUP:
                {
                    if (popup_proxy.can_show_popup)
                    {
                        popup_proxy.can_show_popup = false;
                        var sendGiftsPopup:SendGiftsPopup = new SendGiftsPopup(ResourceManager.getInstance().getString("message","send_free_gift_message"));
                        facade.registerMediator(new PopupMediator(sendGiftsPopup));
                        stage.addChild(sendGiftsPopup);
                    }
                    else
                    {
                        popup_proxy.add_popup(value);
                    }
                    break;
                }
                case ApplicationFacade.SHOW_UNDER_CONSTRUCTION_POPUP:
                {
                    facade.removeMediator(PopupMediator.NAME);
                    var underConstructionPopup:UnderConstructionPopup = new UnderConstructionPopup(app_data.get_under_construction_popup_data(value.getBody() as MapObject),value.getBody() as MapObject);
                    underConstructionPopup.name = "underConstructionPopup";
                    facade.registerMediator(new PopupMediator(underConstructionPopup));
                    stage.addChild(underConstructionPopup);
                    break;
                }
                case ApplicationFacade.SHOW_FRIEND_HELPED_POPUP:
                {
                    if (popup_proxy.can_show_popup)
                    {
                        popup_proxy.can_show_popup = false;
                        var friendHelpedPopup:FriendHelpedPopup = new FriendHelpedPopup(app_data.get_friend_helped_popup_data() as String);
                        facade.registerMediator(new PopupMediator(friendHelpedPopup));
                        stage.addChild(friendHelpedPopup);
                    }
                    else
                    {
                        popup_proxy.add_popup(value);
                    }
                    break;
                }
                case ApplicationFacade.SHOW_NETWORK_DELAY_POPUP:
                {
                    if (popup_proxy.can_show_popup)
                    {
                        popup_proxy.can_show_popup = false;
                        var networkDelayPopup:NetworkDelayPopup = new NetworkDelayPopup(ResourceManager.getInstance().getString("message","connect_server_error"));
                        facade.registerMediator(new PopupMediator(networkDelayPopup));
                        stage.addChild(networkDelayPopup);
                    }
                    else
                    {
                        popup_proxy.add_popup(value);
                    }
                    break;
                }
                case ApplicationFacade.SHOW_NEIGHBORS_LIST_POPUP:
                {
                    facade.removeMediator(PopupMediator.NAME);
                    var neighborsListPopup:NeighborsListPopup = new NeighborsListPopup(app_data.get_neighbors_list_popup_data());
                    neighborsListPopup.info = {gift:value.getBody() as Number,type:value.getType()};
                    facade.registerMediator(new PopupMediator(neighborsListPopup));// 这里注册不上了
                    stage.addChild(neighborsListPopup);
                    break;
                }
                case ApplicationFacade.SHOW_GIFT_RECEIVED_POPUP:
                {
                    if (popup_proxy.can_show_popup)
                    {
                        popup_proxy.can_show_popup = false;
                        newsPopup = new NewsPopup(value.getBody());
                        newsPopup.type = PopupTypes.SHOW_GIFT_RECEIVED_POPUP;
                        newsPopup.set_ok_label(ResourceManager.getInstance().getString("message","game_button_accept_message"));
                        facade.registerMediator(new PopupMediator(newsPopup));
                        stage.addChild(newsPopup);
                    }
                    else
                    {
                        popup_proxy.add_popup(value);
                    }
                    break;
                }
                case ApplicationFacade.SHOW_UPGRADE_POPUP:
                {
                    if (popup_proxy.can_show_popup)
                    {
                        popup_proxy.can_show_popup = false;
                        var upgradePopup:UpgradePopup = new UpgradePopup(app_data.get_upgrade_popup_data(value.getBody() as MapObject));
                        facade.registerMediator(new PopupMediator(upgradePopup));
                        stage.addChild(upgradePopup);
                    }
                    else
                    {
                        popup_proxy.add_popup(value);
                    }
                    break;
                }
                case ApplicationFacade.SHOW_SELECT_OBJECT_POPUP:
                {
                    facade.removeMediator(PopupMediator.NAME);
                    selectPopup = new SelectPopup(value.getBody());
                    selectPopup.type = PopupTypes.SELECT_OBJECT;
                    facade.registerMediator(new PopupMediator(selectPopup));
                    stage.addChild(selectPopup);
                    break;
                }
            }
        }
        
        protected function get app_data() : AppDataProxy
        {
            return facade.retrieveProxy(AppDataProxy.NAME) as AppDataProxy;
        }

        private function mouseLeaveHandler(event:Event) : void
        {
        	var transaction:TransactionProxy = facade.retrieveProxy(TransactionProxy.NAME) as TransactionProxy;
        	if(transaction.batchManager.is_busy)return;// 如果正在重新请求的话,那么不继续了
        	transaction.batchManager.save();
        }

        private function exit_full_screen() : void
        {
            stage.displayState = StageDisplayState.NORMAL;
        }

        private function mouseMoveHandler(event:MouseEvent) : void
        {
            /* if (map_proxy.mouse_shake(stage.mouseX))
            {
                if (snapshot_mode)
                {
                    return;
                }
                sendNotification(ApplicationFacade.ESCAPE_PRESSED);
                sendNotification(ApplicationFacade.REFRESH_TOOLBAR);
            } */
        }

        protected function get stage() : Stage
        {
            return viewComponent as Stage;
        }

        private function keyUpHandler(event:KeyboardEvent) : void
        {
            if (event.keyCode == Keyboard.ESCAPE)
            {
                if (snapshot_mode)
                {
                    return;
                }
                sendNotification(ApplicationFacade.ESCAPE_PRESSED);
                sendNotification(ApplicationFacade.REFRESH_TOOLBAR);
            }
        }

        protected function get map_proxy() : MapProxy
        {
            return facade.retrieveProxy(MapProxy.NAME) as MapProxy;
        }
        
        override public function listNotificationInterests() : Array
        {
            return [ApplicationFacade.CREATE_OBJECTS, ApplicationFacade.DISPLAY_ERROR, ApplicationFacade.SHOW_CONFIRM_POPUP, ApplicationFacade.SHOW_HELP_POPUP, ApplicationFacade.SHOW_LEVEL_UP_POPUP, ApplicationFacade.SHOW_REFRESH_PAGE_POPUP, ApplicationFacade.SHOW_LOTTERY_POPUP, ApplicationFacade.REFRESH_FOCUS, ApplicationFacade.UPDATE_OBJECTS, ApplicationFacade.TOGGLE_FULL_SCREEN, ApplicationFacade.SHOW_ADD_CASH_POPUP, ApplicationFacade.SHOW_FEED_DIALOG, ApplicationFacade.SHOW_ACCEPT_SNAPSHOT, ApplicationFacade.ACTIVATE_SNAPSHOT_MODE, ApplicationFacade.DEACTIVATE_SNAPSHOT_MODE, ApplicationFacade.SHOW_SNAPSHOT_PREVIEW, ApplicationFacade.SHOW_STREAM_PERMISSIONS, ApplicationFacade.SHOW_SELECT_RAW_MATERIAL_POPUP, ApplicationFacade.SHOW_NEWS_POPUP, ApplicationFacade.SHOW_POPUP, ApplicationFacade.SHOW_STORY_POPUP, ApplicationFacade.SHOW_ITEMS_RECEIVED, ApplicationFacade.SHOW_SEND_GIFTS_POPUP, ApplicationFacade.SHOW_UNDER_CONSTRUCTION_POPUP, ApplicationFacade.SHOW_FRIEND_HELPED_POPUP, ApplicationFacade.SHOW_NETWORK_DELAY_POPUP, ApplicationFacade.SHOW_NEIGHBORS_LIST_POPUP, ApplicationFacade.SHOW_GIFT_RECEIVED_POPUP, ApplicationFacade.SHOW_UPGRADE_POPUP, ApplicationFacade.SHOW_SELECT_OBJECT_POPUP];
        }

        private function stageResize(event:Event = null) : void
        {
            friends_list.x = (stage.stageWidth - friends_list.skin.bounds.width - toolbar.width) / 2;
            toolbar.x = (friends_list.x + friends_list.bounds.width);
            toolbar.y = stage.stageHeight - friends_list.bounds.height;
            friends_list.y = stage.stageHeight - friends_list.bounds.height;
            save_button.x = 493 + (stage.stageWidth - STAGE_WIDTH) / 2;
            save_button.y = 13;
            cancel_snapshot.x = stage.stageWidth - cancel_snapshot.width - 10;
            cancel_snapshot.y = stage.stageHeight - cancel_snapshot.height - 10;
            operations.x = friends_list.x + 2;
            operations.y = friends_list.y - operations.height + 9;
            sendNotification(ApplicationFacade.STAGE_RESIZE);
            var ww:Number = (stage.stageWidth - STAGE_WIDTH) / 2 + 2;
            name_bar.x = ww;
            level_bar.x = ww;
            reward_points.x = ww;
            coins.x = ww;
            gift_box.x = friends_list.x + 7;
            gift_box.y = 148;
        }

        override public function onRegister() : void
        {
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
            stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
            stage.addEventListener(Event.MOUSE_LEAVE, mouseLeaveHandler);
            stage.addEventListener(Event.RESIZE, stageResize);
        }

        protected function get popup_proxy() : PopupProxy
        {
            return facade.retrieveProxy(PopupProxy.NAME) as PopupProxy;
        }

        private function takePhoto(event:Event) : void
        {
            snapshot_viewport.stop();
            var map:Map;
            if(map_proxy.friend_mode){
            	map = stage.getChildByName("friend_farm") as Map;
            }else {
            	map = stage.getChildByName("my_ranch") as Map;
            }
            snapshot_proxy.prepare_snapshot(snapshot_viewport.rectangle, map);
        }

        protected function get snapshot_proxy() : SnapshotProxy
        {
            return facade.retrieveProxy(SnapshotProxy.NAME) as SnapshotProxy;
        }

        private function snapshotCanceled(event:MouseEvent) : void
        {
            cancel_snapshot.visible = false;
            snapshot_viewport.stop();
            sendNotification(ApplicationFacade.DEACTIVATE_SNAPSHOT_MODE);
        }

    }
}
