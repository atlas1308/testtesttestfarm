package classes.view
{
    import classes.*;
    import classes.model.*;
    import classes.utils.*;
    import classes.view.components.*;
    import classes.view.components.buttons.*;
    import classes.view.components.map.*;
    import classes.view.components.popups.*;
    
    import flash.display.*;
    import flash.events.*;
    import flash.external.*;
    import flash.ui.*;
    
    import mx.resources.ResourceManager;
    
    import org.puremvc.as3.multicore.interfaces.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    
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
            Log.add("stage width " + stage.stageWidth);
            Log.add("stage height " + stage.stageHeight);
            save_button = new SaveButton();
            facade.registerMediator(new SaveButtonMediator(save_button));
            stage.addChild(save_button);
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
            var achievements:Achievements = new Achievements();
            facade.registerMediator(new AchievementsMediator(achievements));
            stage.addChild(achievements);
            achievements.visible = false;
            var confirm_cont:* = new ConfirmationContainer();
            facade.registerMediator(new ConfirmationMediator(confirm_cont));
            stage.addChild(confirm_cont);
            var anim_cont:* = new AnimationContainer(toolbar.storage);
            facade.registerMediator(new AnimationMediator(anim_cont));
            stage.addChild(anim_cont);
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
            try
            {
                if (ExternalInterface.available)
                {
                    Log.add("EI add callback");
                    ExternalInterface.addCallback("onMouseWheel", onExternalMouseWheel);
                    //ExternalInterface.addCallback("publishedToStream", onPublishedToStream);
                    //ExternalInterface.addCallback("permissionDialogClosed", permissionDialogClosed);
                }
                else
                {
                    Log.add("External interface unavailable");
                }
            }
            catch (e:Error)
            {
            }
            stageResize(null);
            app_data.game_objects_created();
        }
        
        override public function handleNotification(value:INotification) : void
        {
            var body:Object = null;
            var mapObject:MapObject = null;
            var selectPopup:SelectPopup = null;
            var newsPopup:NewsPopup = null;
            var _loc_15:Number = NaN;
            var _loc_16:Number = NaN;
            var _loc_17:Number = NaN;
            var _loc_18:Number = NaN;
            var dynamicPopup:DynamicPopup = null;
            var _loc_20:Object = null;
            var _loc_22:Object = null;
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
                    if (popup_proxy.can_show_popup)
                    {
                        popup_proxy.can_show_popup = false;
                        var helpPopup:HelpPopup = new HelpPopup(app_data.get_help_data());
                        facade.registerMediator(new PopupMediator(helpPopup));
                        stage.addChild(helpPopup);
                    }
                    else
                    {
                        popup_proxy.add_popup(value);
                    }
                    break;
                }
                case ApplicationFacade.SHOW_LEVEL_UP_POPUP:
                {
                    if (popup_proxy.can_show_popup)
                    {
                        popup_proxy.can_show_popup = false;
                        var levelUpPopup:LevelUpPopup = new LevelUpPopup(app_data.get_level_up_data());
                        facade.registerMediator(new PopupMediator(levelUpPopup));
                        stage.addChild(levelUpPopup);
                    }
                    else
                    {
                        popup_proxy.add_popup(value);
                    }
                    break;
                }
                case ApplicationFacade.SHOW_LOTTERY_POPUP:
                {
                    if (popup_proxy.can_show_popup)
                    {
                        popup_proxy.can_show_popup = false;
                        var lotteryPopup:LotteryPopup = new LotteryPopup(app_data.lottery_message());
                        facade.registerMediator(new PopupMediator(lotteryPopup));
                        stage.addChild(lotteryPopup);
                    }
                    else
                    {
                        popup_proxy.add_popup(value);
                    }
                    break;
                }
                case ApplicationFacade.SHOW_REFRESH_PAGE_POPUP:
                {
                    if (popup_proxy.can_show_popup)
                    {
                        popup_proxy.can_show_popup = false;
                        var refreshPagePopup:RefreshPagePopup = new RefreshPagePopup(value.getBody() as String);
                        facade.registerMediator(new PopupMediator(refreshPagePopup));
                        stage.addChild(refreshPagePopup);
                    }
                    else
                    {
                        popup_proxy.add_popup(value);
                    }
                    break;
                }
                case ApplicationFacade.TOGGLE_FULL_SCREEN:
                {
                    toggle_full_screen();
                    break;
                }
                case ApplicationFacade.SHOW_ADD_CASH_POPUP:
                {
                    if (popup_proxy.can_show_popup)
                    {
                        popup_proxy.can_show_popup = false;
                        var cashPopup:CashPopup = new CashPopup();
                        facade.registerMediator(new PopupMediator(cashPopup));
                        stage.addChild(cashPopup);
                    }
                    else
                    {
                        popup_proxy.add_popup(value);
                    }
                    break;
                }
                case ApplicationFacade.SHOW_FEED_DIALOG:
                {
                	try {
	                    Log.add("showFeedDialog called");
	                    exit_full_screen();
	                    ExternalInterface.call("streamPublish", value.getBody());
                    }catch(error:Error){
                    	
                    }
                    break;
                }
                case ApplicationFacade.SHOW_ACCEPT_SNAPSHOT:
                {
                    if (popup_proxy.can_show_popup)
                    {
                        popup_proxy.can_show_popup = false;
                        var acceptSnapshot:AcceptSnapshotPopup = new AcceptSnapshotPopup();
                        facade.registerMediator(new PopupMediator(acceptSnapshot));
                        stage.addChild(acceptSnapshot);
                    }
                    else
                    {
                        popup_proxy.add_popup(value);
                    }
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
                    if (popup_proxy.can_show_popup)
                    {
                        popup_proxy.can_show_popup = false;
                        var snapShotPreview:SnapshotPreviewPopup = new SnapshotPreviewPopup(value.getBody() as Bitmap);
                        facade.registerMediator(new PopupMediator(snapShotPreview));
                        stage.addChild(snapShotPreview);
                        cancel_snapshot.visible = false;
                        snapshot_viewport.stop();
                    }
                    else
                    {
                        popup_proxy.add_popup(value);
                    }
                    break;
                }
                case ApplicationFacade.SHOW_STREAM_PERMISSIONS:
                {
                    Log.add("show stream permissions");
                    stage.displayState = StageDisplayState.NORMAL;
                    //ExternalInterface.call("showStreamPermissions");
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
                        _loc_15 = body.width ? (body.width) : (400);
                        _loc_16 = body.height ? (body.height) : (190);
                        _loc_17 = body.inner_width ? (body.inner_width) : (300);
                        _loc_18 = body.inner_height ? (body.inner_height) : (110);
                        dynamicPopup = new DynamicPopup(_loc_15, _loc_16, _loc_17, _loc_18, body.message);
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
                    if (popup_proxy.can_show_popup)
                    {
                        _loc_20 = app_data.get_story_popup_data();
                        if (_loc_20)
                        {
                            popup_proxy.can_show_popup = false;
                            var storyPopup:StoryPopup = new StoryPopup(_loc_20);
                            facade.registerMediator(new PopupMediator(storyPopup));
                            stage.addChild(storyPopup);
                        }
                    }
                    else
                    {
                        popup_proxy.add_popup(value);
                    }
                    break;
                }
                case ApplicationFacade.SHOW_ITEMS_RECEIVED:
                {
                    if (popup_proxy.can_show_popup)
                    {
                        popup_proxy.can_show_popup = false;
                        _loc_22 = app_data.get_items_received_data();
                        var itemsReceivedPopup:ItemsReceivedPopup = new ItemsReceivedPopup(_loc_22);
                        facade.registerMediator(new PopupMediator(itemsReceivedPopup));
                        stage.addChild(itemsReceivedPopup);
                    }
                    else
                    {
                        popup_proxy.add_popup(value);
                    }
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
                    if (popup_proxy.can_show_popup)
                    {
                        popup_proxy.can_show_popup = false;
                        var underConstructionPopup:UnderConstructionPopup = new UnderConstructionPopup(app_data.get_under_construction_popup_data(value.getBody() as MapObject));
                        facade.registerMediator(new PopupMediator(underConstructionPopup));
                        stage.addChild(underConstructionPopup);
                    }
                    else
                    {
                        popup_proxy.add_popup(value);
                    }
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
                        var networkDelayPopup:NetworkDelayPopup = new NetworkDelayPopup(app_data.get_network_delay_popup_data());
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
                    if (popup_proxy.can_show_popup)
                    {
                        popup_proxy.can_show_popup = false;
                        var neighborsListPopup:NeighborsListPopup = new NeighborsListPopup(app_data.get_neighbors_list_popup_data());
                        //var neighborsListPopup:NeighborsListPopup = new NeighborsListPopup(app_data.get_neighbors_data());
                        neighborsListPopup.info = {gift:value.getBody() as Number};
                        facade.registerMediator(new PopupMediator(neighborsListPopup));
                        stage.addChild(neighborsListPopup);
                    }
                    else
                    {
                        popup_proxy.add_popup(value);
                    }
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
                    if (popup_proxy.can_show_popup)
                    {
                        popup_proxy.can_show_popup = false;
                        selectPopup = new SelectPopup(value.getBody());
                        selectPopup.type = PopupTypes.SELECT_OBJECT;
                        facade.registerMediator(new PopupMediator(selectPopup));
                        stage.addChild(selectPopup);
                    }
                    else
                    {
                        popup_proxy.add_popup(value);
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
        }

        private function mouseWheelHandler(event:MouseEvent) : void
        {
            if (event.delta > 0)
            {
                sendNotification(ApplicationFacade.ZOOM_IN);
            }
            else
            {
                sendNotification(ApplicationFacade.ZOOM_OUT);
            }
        }

        private function onExternalMouseWheel(value:int) : void
        {
            mouseWheelHandler(new MouseEvent(MouseEvent.MOUSE_WHEEL, true, false, 0, 0, null, false, false, false, false, value));
        }

        protected function get app_data() : AppDataProxy
        {
            return facade.retrieveProxy(AppDataProxy.NAME) as AppDataProxy;
        }

        private function mouseLeaveHandler(event:Event) : void
        {
            return;
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
            if (event.keyCode == 76)
            {
                if (event.shiftKey)
                {
                    Log.toggle();
                }
            }
        }

        private function onPublishedToStream() : void
        {
            Log.add("stream published");
            sendNotification(ApplicationFacade.POST_PUBLISHED, app_data.last_feed_data);
        }

        protected function get map_proxy() : MapProxy
        {
            return facade.retrieveProxy(MapProxy.NAME) as MapProxy;
        }

        private function permissionDialogClosed() : void
        {
            //fb_proxy.check_permissions();
        }

        override public function listNotificationInterests() : Array
        {
            return [ApplicationFacade.CREATE_OBJECTS, ApplicationFacade.DISPLAY_ERROR, ApplicationFacade.SHOW_CONFIRM_POPUP, ApplicationFacade.SHOW_HELP_POPUP, ApplicationFacade.SHOW_LEVEL_UP_POPUP, ApplicationFacade.SHOW_REFRESH_PAGE_POPUP, ApplicationFacade.SHOW_LOTTERY_POPUP, ApplicationFacade.REFRESH_FOCUS, ApplicationFacade.UPDATE_OBJECTS, ApplicationFacade.TOGGLE_FULL_SCREEN, ApplicationFacade.SHOW_ADD_CASH_POPUP, ApplicationFacade.SHOW_FEED_DIALOG, ApplicationFacade.SHOW_ACCEPT_SNAPSHOT, ApplicationFacade.ACTIVATE_SNAPSHOT_MODE, ApplicationFacade.DEACTIVATE_SNAPSHOT_MODE, ApplicationFacade.SHOW_SNAPSHOT_PREVIEW, ApplicationFacade.SHOW_STREAM_PERMISSIONS, ApplicationFacade.SHOW_SELECT_RAW_MATERIAL_POPUP, ApplicationFacade.SHOW_NEWS_POPUP, ApplicationFacade.SHOW_POPUP, ApplicationFacade.SHOW_STORY_POPUP, ApplicationFacade.SHOW_ITEMS_RECEIVED, ApplicationFacade.SHOW_SEND_GIFTS_POPUP, ApplicationFacade.SHOW_UNDER_CONSTRUCTION_POPUP, ApplicationFacade.SHOW_FRIEND_HELPED_POPUP, ApplicationFacade.SHOW_NETWORK_DELAY_POPUP, ApplicationFacade.SHOW_NEIGHBORS_LIST_POPUP, ApplicationFacade.SHOW_GIFT_RECEIVED_POPUP, ApplicationFacade.SHOW_UPGRADE_POPUP, ApplicationFacade.SHOW_SELECT_OBJECT_POPUP];
        }

        private function stageResize(event:Event) : void
        {
            Log.add("stage resize");
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
            stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
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
            snapshot_proxy.prepare_snapshot(snapshot_viewport.rectangle, stage);
        }

        protected function get fb_proxy() : JSProxy
        {
            return facade.retrieveProxy(JSProxy.NAME) as JSProxy;
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
