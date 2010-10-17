package classes.view
{
    import classes.*;
    import classes.model.*;
    import classes.view.components.*;
    
    import flash.events.*;
    
    import mx.resources.ResourceManager;
    
    import org.puremvc.as3.multicore.interfaces.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;

    public class StorageMediator extends Mediator implements IMediator
    {
        private var reset_page:Boolean = true;
        public static const NAME:String = "StorageMediator";

        public function StorageMediator(value:Object)
        {
            super(NAME, value);
        }

        override public function listNotificationInterests() : Array
        {
            return [ApplicationFacade.UPDATE_OBJECTS, ApplicationFacade.DISPLAY_STORAGE, ApplicationFacade.HIDE_STORAGE, ApplicationFacade.ESCAPE_PRESSED, ApplicationFacade.STAGE_RESIZE];
        }

        private function closeStorage(event:Event) : void
        {
            reset_page = true;
            storage.visible = false;
            sendNotification(ApplicationFacade.UPDATE_OBJECTS, {storage:true});
            sendNotification(ApplicationFacade.HIDE_OVERLAY);
            sendNotification(ApplicationFacade.REFRESH_TOOLBAR);
        }

        private function sellItem(event:Event) : void
        {
            sendNotification(ApplicationFacade.SELL_STORAGE_ITEM, event.target.data);
        }

        protected function get app_data() : AppDataProxy
        {
            return facade.retrieveProxy(AppDataProxy.NAME) as AppDataProxy;
        }

        override public function onRegister() : void
        {
            storage.addEventListener(storage.ON_CLOSE, closeStorage);
            storage.addEventListener(storage.SELL_ITEM, sellItem);
            storage.addEventListener(storage.SELL_ALL, sellAll);
        }

        private function sellAll(event:Event) : void
        {
        	var msg:String = ResourceManager.getInstance().getString("message","sell_all_message");
            sendNotification(ApplicationFacade.SHOW_CONFIRM_POPUP, {msg:msg, obj:{notif:ApplicationFacade.SELL_ALL_STORAGE, data:null}});
        }

        private function alignStorage() : void
        {
        	storage.center();
        }

        override public function handleNotification(closeStorage:INotification) : void
        {
            var body:Object = null;
            switch(closeStorage.getName())
            {
                case ApplicationFacade.UPDATE_OBJECTS:
                {
                    body = closeStorage.getBody();
                    if (body.storage)
                    {
                        storage.update(app_data.get_storage_data(), reset_page);
                    }
                    break;
                }
                case ApplicationFacade.DISPLAY_STORAGE:
                {
                    sendNotification(ApplicationFacade.SHOW_OVERLAY);
                    storage.visible = true;
                    reset_page = false;
                    alignStorage();
                    break;
                }
                case ApplicationFacade.ESCAPE_PRESSED:
                case ApplicationFacade.HIDE_STORAGE:
                {
                    sendNotification(ApplicationFacade.HIDE_OVERLAY);
                    storage.visible = false;
                    break;
                }
                case ApplicationFacade.STAGE_RESIZE:
                {
                    alignStorage();
                    break;
                }
                default:
                {
                    break;
                }
            }
        }

        protected function get storage() : Storage
        {
            return viewComponent as Storage;
        }

    }
}
