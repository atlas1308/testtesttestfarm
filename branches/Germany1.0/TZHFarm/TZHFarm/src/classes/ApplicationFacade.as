package classes
{
	import classes.controller.*;
	
	import flash.system.Security;
	
	import org.puremvc.as3.multicore.interfaces.IFacade;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
    public class ApplicationFacade extends Facade implements IFacade
    {
        public static const MAP_OBJECT_ADDED:String = "mapObjectAdded";
        public static const DISPLAY_ERROR:String = "displayError";
        public static const NAVIGATE_TO_URL:String = "navigateToURL";
        public static const ADD_MAP_OBJECT:String = "addMapObject";
        public static const SELL_ALL_STORAGE:String = "sellAllStorage";
        public static const HIDE_OVERLAY:String = "hideOverlay";
        public static const SHOW_LOTTERY_POPUP:String = "showLotteryPopup";
        public static const HANDLE_TRANSACTION_RESULT:String = "handleTransactionResult";
        public static const SHOW_FARM:String = "showFarm";
        public static const REFRESH_FOCUS:String = "refreshFocus";
        public static const REMOVE_MAP_OBJECT:String = "removeMapObject";
        public static const SELL_STORAGE_ITEM:String = "sellStorageItem";
        public static const INCREASE_OBTAINED_MATERIAL:String = "increaseObtainedMaterial";
        public static const AUTOMATION_TOGGLED:String = "automationToggled";
        public static const ESCAPE_PRESSED:String = "escapePressed";
        public static const BACK_TO_MY_RANCH:String = "backToMyRanch";
        public static const CENTER_MAP:String = "centerMap";
        public static const ENABLE_ZOOM_IN:String = "enableZoomIn";
        public static const DISABLE_ZOOM_OUT:String = "disableZoomOut";
        public static const MAP_REFRESH_DEPTH:String = "mapRefreshDepth";
        public static const STARTUP:String = "startup";
        public static const NEIGHBORS_LOADED:String = "neighborsLoaded";
        public static const HIDE_STORAGE:String = "hideStorage";
        public static const SHOW_STORY_POPUP:Object = "showStoryPopup";
        public static const IRRIGATION_INSTALLED:String = "irrigationInstalled";
        public static const SHOW_CONFIRM_POPUP:String = "showConfirmPopup";
        public static const USE_MOVE_TOOL:String = "useMoveTool";
        public static const CANCEL_PROCESS_LOADER:String = "cancelProcessLoader";
        public static const DISPLAY_SHOP:String = "displayShop";
        public static const HIDE_GIFT_BOX:String = "hideGiftBox";
        public static const AUTO_COLLECT:String = "autoCollect";
        public static const SHOW_ADD_CASH_POPUP:String = "showAddCashPopup";
        public static const SHOW_HELP_POPUP:String = "showHelpPopup";
        public static const TOGGLE_ALPHA:String = "toggleAlpha";
        public static const COLLECT_PRODUCT:String = "collectProduct";
        public static const FERTILIZE:String = "fertilize";
        public static const DISABLE_ZOOM_IN:String = "disableZoomIn";
        public static const SHOW_NEWS_POPUP:String = "showNewsPopup";
        public static const MAP_OBJECT_REMOVED:String = "mapObjectRemoved";
        public static const SHOW_STREAM_PERMISSIONS:String = "showStreamPermissions";
        public static const SHOW_TOOLTIP:String = "showTooltip";
        public static const CREATE_OBJECTS:String = "createObjects";
        public static const DISPLAY_CONFIRMATION:String = "displayConfirmation";
        public static const DEACTIVATE_SNAPSHOT_MODE:String = "deactivateSnapshotMode";
        public static const FLIP_MAP_OBJECT:String = "flipMapObject";
        public static const EXPAND_RANCH:String = "expandRanch";
        public static const RAIN_APPLIED:String = "rainApplied";
        public static const ZOOM_OUT:String = "zoomOut";
        public static const SHOW_FEED_DIALOG:String = "showFeedDialog";
        public static const SHOW_POPUP:String = "showPopup";
        public static const MAP_OBJECT_COLLECTED:String = "mapObjectCollected";
        public static const AUTO_REFILL:String = "autoRefill";
        public static const CHECK_AUTOMATION:String = "checkAutomation";
        public static const POLLINATE:String = "pollinate";
        public static const USE_MULTI_TOOL:String = "useMultiTool";
        public static const MOVE_MAP_OBJECT:String = "moveMapObject";
        public static const DISPLAY_BARN_CONFIRMATION:String = "displayBarnConfirmation";
        public static const SPEND_RP:String = "spendRP";
        public static const FEED_MAP_OBJECT:String = "feedMapObject";
        public static const ANIMAL_ADDED:String = "animalAdded";
        public static const USE_AUTOMATION_TOOL:String = "useAutomationTool";
        public static const TOGGLE_AUTOMATION:String = "toggleAutomation";
        public static const SHOW_FRIEND_HELPED_POPUP:String = "showFriendHelpedPopup";
        public static const SHOW_OVERLAY:String = "showOverlay";
        public static const POST_PUBLISHED:String = "postPublished";
        public static const ACTIVATE_SNAPSHOT_MODE:String = "activateSnapshotMode";
        public static const USE_GIFT:String = "useGift";
        public static const SHOW_NEIGHBORS_LIST_POPUP:String = "showNeighborsListPopup";
        public static const ADD_PLANT:String = "addPlant";
        public static const ZOOM_IN:String = "zoomIn";
        public static const CLOSE_NETWORK_DELAY_POPUP:String = "closeNetworkDelayPopup";
        public static const SHOW_UPGRADE_POPUP:String = "showUpgradePopup";
        public static const SHOW_GIFT_BOX:String = "showGiftBox";
        public static const SHOW_ITEMS_RECEIVED:String = "showItemsReceived";
        public static const SAVE_DATA:String = "saveData";
        public static const SHOW_SNAPSHOT_PREVIEW:String = "showSnapshotPreview";
        public static const STAGE_RESIZE:String = "stageResize";
        public static const USE_PLOW_TOOL:String = "usePlowTool";
        public static const DISABLE_SAVE_BUTTON:String = "disableSaveButton";
        public static const DISPLAY_GIFTS:String = "displayGifts";
        public static const MAP_OBJECT_FED:String = "mapObjectFed";
        public static const SHOW_SEND_GIFTS_POPUP:String = "showSendGiftsPopup";
        public static const REFILL_MAP_OBJECT:String = "refillMapObject";
        public static const BUY_ITEM:String = "buyItem";
        public static const INSTALL_IRRIGATION:String = "installIrrigation";
        public static const SHOW_GIFT_RECEIVED_POPUP:String = "showGiftReceivedPopup";
        public static const LOAD_DATA:String = "loadData";
        public static const START_RAIN:String = "showRain";
        public static const ENABLE_SAVE_BUTTON:String = "enableSaveButton";
        public static const ADD_ANIMAL:String = "addAnimal";
        public static const SHOW_SHOP_AND_ADD_PLANT:String = "showShopAndAddPlant";
        public static const UPDATE_OBJECTS:String = "updateObjects";
        public static const SHOW_UNDER_CONSTRUCTION_POPUP:String = "showUnderConstructionPopup";
        public static const LOAD_NEIGHBORS:String = "loadNeighbors";
        public static const SHOW_PROCESS_LOADER:String = "showProcessLoader";
        public static const SHOW_REFRESH_PAGE_POPUP:String = "showRefreshPagePopup";
        public static const SEND_GIFT:String = "sendGift";
        public static const SET_TOOLBAR_NORMAL_MODE:String = "setToolbarNormalMode";
        public static const USE_REMOVE_TOOL:String = "useRemoveTool";
        public static const DISPLAY_ACHIEVEMENTS:String = "displayAchievements";
        public static const MAP_ADD_OBJECT:String = "mapAddObject";
        public static const DEACTIVATE_MULTI_TOOL:String = "deactivateMultiTool";
        public static const SHOW_SELECT_OBJECT_POPUP:String = "showSelectObjectPopup";
        public static const WATER_PLANTS:String = "waterPlants";
        public static const TOGGLE_FULL_SCREEN:String = "toggleFullScreen";
        public static const MAP_OBJECT_MOVED:String = "mapObjectMoved";
        public static const CROPS_FERTILIZED:String = "cropsFertilized";
        public static const START_COLLECT_ANIMATION:String = "startCollectAnimation";
        public static const SHOW_NETWORK_DELAY_POPUP:String = "showNetworkDelayPopup";
        public static const DISPLAY_STORAGE:String = "displayStorage";
        public static const HIDE_SHOP:String = "hideShop";
        public static const SHOW_CHRISTMAS_PRESENTS:String = "showChristmasPresents";
        public static const SHOW_ACCEPT_SNAPSHOT:String = "showAcceptSnapshot";
        public static const APPLY_RAIN:String = "applyRain";
        public static const HIDE_TOOLTIP:String = "hideTooltip";
        public static const USE_SHOP_ITEM:String = "useShopItem";
        public static const SHOW_SELECT_RAW_MATERIAL_POPUP:String = "showSelectRawMaterialPopup";
        public static const LOAD_FARM:String = "loadFarm";
        public static const SHOW_LEVEL_UP_POPUP:String = "showLevelUpPopup";
        public static const REFRESH_TOOLBAR:String = "refreshToolbar";
        public static const PLACE_MAP_OBJECT:String = "placeMapObject";
        public static const SELL_GIFT:String = "sellGift";
        public static const ENABLE_ZOOM_OUT:String = "enableZoomOut";
        public static const PLANTS_WATERED:String = "plantsWatered";
        
        public static const TUTORIAL_COMPLETED:String = "tutorailCompleted";// 向导完成
        public static const TUTORIAL_STARTED:String = "tutorialStarted";// 向导开始

        public function ApplicationFacade(value:String)
        {
            super(value);
        }

        override protected function initializeController() : void
        {
            super.initializeController();
            registerCommand(STARTUP, StartupCommand);
            registerCommand(LOAD_DATA, LoadDataCommand);
            registerCommand(LOAD_FARM, LoadFarmCommand);
            registerCommand(LOAD_NEIGHBORS, ServerCallCommand);
            registerCommand(POST_PUBLISHED, ServerCallCommand);
            registerCommand(SEND_GIFT, ServerCallCommand);
            registerCommand(ADD_MAP_OBJECT, AddTransactionCommand);
            registerCommand(MOVE_MAP_OBJECT, AddTransactionCommand);
            registerCommand(FLIP_MAP_OBJECT, AddTransactionCommand);
            registerCommand(REMOVE_MAP_OBJECT, AddTransactionCommand);
            registerCommand(COLLECT_PRODUCT, AddTransactionCommand);
            registerCommand(FEED_MAP_OBJECT, AddTransactionCommand);
            registerCommand(REFILL_MAP_OBJECT, AddTransactionCommand);
            registerCommand(ADD_PLANT, AddTransactionCommand);
            registerCommand(APPLY_RAIN, AddTransactionCommand);
            registerCommand(SPEND_RP, AddTransactionCommand);
            registerCommand(WATER_PLANTS, AddTransactionCommand);
            registerCommand(ADD_ANIMAL, AddTransactionCommand);
            registerCommand(SELL_STORAGE_ITEM, AddTransactionCommand);
            registerCommand(SELL_ALL_STORAGE, AddTransactionCommand);
            registerCommand(USE_GIFT, AddTransactionCommand);
            registerCommand(BUY_ITEM, AddTransactionCommand);
            registerCommand(SELL_GIFT, AddTransactionCommand);
            registerCommand(FERTILIZE, AddTransactionCommand);
            registerCommand(POLLINATE, AddTransactionCommand);
            registerCommand(AUTO_COLLECT, AddTransactionCommand); 
            registerCommand(AUTO_REFILL, AddTransactionCommand);
            registerCommand(TOGGLE_AUTOMATION, AddTransactionCommand);
            registerCommand(INSTALL_IRRIGATION, AddTransactionCommand);
            registerCommand(NAVIGATE_TO_URL, NavigateCommand);
            registerCommand(SAVE_DATA, SaveDataCommand);
            registerCommand(HANDLE_TRANSACTION_RESULT, HandleTransactionResultCommand);
        }

        public function startup(body:Object) : void
        {
            Log.init(body);
            Security.allowDomain("*");
            sendNotification(STARTUP, body);
        }
		
		private static var _instance:ApplicationFacade;
        public static function getInstance(value:String) : ApplicationFacade
        {
        	if(_instance == null){
        		_instance = new ApplicationFacade(value);
        	}
        	return _instance;
        }

    }
}
