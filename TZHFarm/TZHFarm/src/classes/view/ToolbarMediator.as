package classes.view
{
    import classes.*;
    import classes.model.*;
    import classes.utils.*;
    import classes.view.components.*;
    
    import flash.events.*;
    import flash.geom.Point;
    
    import org.puremvc.as3.multicore.interfaces.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    
    import classes.model.confirmation.Confirmation;

    public class ToolbarMediator extends Mediator implements IMediator
    {
        public static const NAME:String = "ToolbarMediator";

        public function ToolbarMediator(value:Object)
        {
            super(NAME, value);
        }

        private function giftsOn(event:Event) : void
        {
            sendNotification(ApplicationFacade.ESCAPE_PRESSED);
            sendNotification(ApplicationFacade.DISPLAY_GIFTS);
        }

        private function removeOn(event:Event) : void
        {
            sendNotification(ApplicationFacade.ESCAPE_PRESSED);
            sendNotification(ApplicationFacade.USE_REMOVE_TOOL);
        }

        private function showTooltip(event:Event) : void
        {
            sendNotification(ApplicationFacade.SHOW_TOOLTIP, event.target.message);
        }

        protected function get app_data() : AppDataProxy
        {
            return facade.retrieveProxy(AppDataProxy.NAME) as AppDataProxy;
        }

        protected function get toolbar() : Toolbar
        {
            return viewComponent as Toolbar;
        }

        private function toggleFullScreen(event:Event) : void
        {
            sendNotification(ApplicationFacade.TOGGLE_FULL_SCREEN);
        }

        private function moveOn(event:Event) : void
        {
            sendNotification(ApplicationFacade.ESCAPE_PRESSED);
            sendNotification(ApplicationFacade.USE_MOVE_TOOL);
        }

        override public function handleNotification(value:INotification) : void
        {
            var body:Object = null;
            var confirmation:classes.model.confirmation.Confirmation = null;
            var point:Point = null;
            switch(value.getName())
            {
                case ApplicationFacade.SHOW_FARM:
                {
                    toolbar.set_friend_view_mode();
                    break;
                }
                case ApplicationFacade.REFRESH_TOOLBAR:
                {
                    toolbar.refresh();
                    break;
                }
                case ApplicationFacade.UPDATE_OBJECTS:
                {
                    body = value.getBody();
                    if (body.gifts)
                    {
                        toolbar.updateGiftsQty(app_data.gifts_qty);
                    }
                    break;
                }
                case ApplicationFacade.ENABLE_ZOOM_IN:
                {
                    toolbar.enable_zoom_in();
                    break;
                }
                case ApplicationFacade.ENABLE_ZOOM_OUT:
                {
                    toolbar.enable_zoom_out();
                    break;
                }
                case ApplicationFacade.DISABLE_ZOOM_IN:
                {
                    toolbar.disable_zoom_in();
                    break;
                }
                case ApplicationFacade.DISABLE_ZOOM_OUT:
                {
                    toolbar.disable_zoom_out();
                    break;
                }
                case ApplicationFacade.DISPLAY_BARN_CONFIRMATION:
                {
                    confirmation = value.getBody() as classes.model.confirmation.Confirmation;
                    point = Algo.localToGlobal(toolbar.storage);
                    confirmation.set_coords(point.x, point.y);
                    sendNotification(ApplicationFacade.DISPLAY_CONFIRMATION, confirmation.get_data());
                    break;
                }
                case ApplicationFacade.ACTIVATE_SNAPSHOT_MODE:
                {
                    toolbar.visible = false;
                    break;
                }
                case ApplicationFacade.DEACTIVATE_SNAPSHOT_MODE:
                {
                    toolbar.visible = true;
                    break;
                }
                case ApplicationFacade.SET_TOOLBAR_NORMAL_MODE:
                {
                    toolbar.set_normal_mode();
                    break;
                }
                case ApplicationFacade.DEACTIVATE_MULTI_TOOL:
                {
                    toolbar.deactivate_multi_tool();
                    break;
                }
                default:
                {
                    break;
                }
            }
        }

        private function backToMyRanch(event:Event) : void
        {
            sendNotification(ApplicationFacade.LOAD_FARM, app_data.user_id);
        }

        private function zoomIn(event:Event) : void
        {
            sendNotification(ApplicationFacade.ZOOM_IN);
        }

        override public function listNotificationInterests() : Array
        {
            return [ApplicationFacade.SHOW_FARM, ApplicationFacade.REFRESH_TOOLBAR, ApplicationFacade.UPDATE_OBJECTS, ApplicationFacade.DISABLE_ZOOM_IN, ApplicationFacade.DISABLE_ZOOM_OUT, ApplicationFacade.ENABLE_ZOOM_IN, ApplicationFacade.ENABLE_ZOOM_OUT, ApplicationFacade.DISPLAY_BARN_CONFIRMATION, ApplicationFacade.ACTIVATE_SNAPSHOT_MODE, ApplicationFacade.DEACTIVATE_SNAPSHOT_MODE, ApplicationFacade.SET_TOOLBAR_NORMAL_MODE, ApplicationFacade.DEACTIVATE_MULTI_TOOL];
        }

        private function hideTooltip(event:Event) : void
        {
            sendNotification(ApplicationFacade.HIDE_TOOLTIP);
        }

        private function plowOn(event:Event) : void
        {
            sendNotification(ApplicationFacade.ESCAPE_PRESSED);
            sendNotification(ApplicationFacade.USE_PLOW_TOOL);
        }

        override public function onRegister() : void
        {
            toolbar.addEventListener(toolbar.SHOP_ON, shopOn);
            toolbar.addEventListener(toolbar.MOVE_ON, moveOn);
            toolbar.addEventListener(toolbar.REMOVE_ON, removeOn);
            toolbar.addEventListener(toolbar.PLOW_ON, plowOn);
            toolbar.addEventListener(toolbar.MULTI_TOOL_ON, multiToolOn);
            toolbar.addEventListener(toolbar.STORAGE_ON, storageOn);
            toolbar.addEventListener(toolbar.GIFTS_ON, giftsOn);
            toolbar.addEventListener(toolbar.ACHIEVEMENTS_ON, achievementsOn);
            toolbar.addEventListener(toolbar.ZOOM_IN, zoomIn);
            toolbar.addEventListener(toolbar.ZOOM_OUT, zoomOut);
            toolbar.addEventListener(toolbar.TOGGLE_FULL_SCREEN, toggleFullScreen);
            toolbar.addEventListener(toolbar.BACK_TO_MY_RANCH, backToMyRanch);
            toolbar.addEventListener(toolbar.SHOW_TOOLTIP, showTooltip);
            toolbar.addEventListener(toolbar.HIDE_TOOLTIP, hideTooltip);
            toolbar.addEventListener(toolbar.TOGGLE_ALPHA, toggleAlpha);
            toolbar.addEventListener(toolbar.TAKE_SNAPSHOT, takeSnapshot);
        }

        private function achievementsOn(event:Event) : void
        {
            sendNotification(ApplicationFacade.ESCAPE_PRESSED);
            sendNotification(ApplicationFacade.DISPLAY_ACHIEVEMENTS);
        }
        
        private function multiToolOn(event:Event) : void
        {
            sendNotification(ApplicationFacade.USE_MULTI_TOOL);
        }

        private function toggleAlpha(event:Event) : void
        {
            sendNotification(ApplicationFacade.TOGGLE_ALPHA);
        }

        private function takeSnapshot(event:Event) : void
        {
            sendNotification(ApplicationFacade.SHOW_ACCEPT_SNAPSHOT);
        }

        private function shopOn(event:Event) : void
        {
            sendNotification(ApplicationFacade.ESCAPE_PRESSED);
            sendNotification(ApplicationFacade.DISPLAY_SHOP);
        }

        private function storageOn(event:Event) : void
        {
            sendNotification(ApplicationFacade.ESCAPE_PRESSED);
            sendNotification(ApplicationFacade.DISPLAY_STORAGE);
        }

        private function zoomOut(event:Event) : void
        {
            sendNotification(ApplicationFacade.ZOOM_OUT);
        }

    }
}
