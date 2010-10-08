package classes.view
{
    import classes.*;
    import classes.model.*;
    import classes.view.components.*;
    import flash.events.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;

    public class AchievementsMediator extends Mediator implements IMediator
    {
        public static const NAME:String = "AchievementsMediator";

        public function AchievementsMediator(param1:Object)
        {
            super(NAME, param1);
            return;
        }

        override public function listNotificationInterests() : Array
        {
            return [ApplicationFacade.UPDATE_OBJECTS, ApplicationFacade.DISPLAY_ACHIEVEMENTS, ApplicationFacade.ESCAPE_PRESSED, ApplicationFacade.STAGE_RESIZE];
        }

        protected function get achievements() : Achievements
        {
            return viewComponent as Achievements;
        }

        private function align() : void
        {
            achievements.x = (achievements.stage.stageWidth - achievements.width) / 2;
            achievements.y = (achievements.stage.stageHeight - achievements.height) / 2;
            return;
        }

        private function close(event:Event) : void
        {
            achievements.visible = false;
            sendNotification(ApplicationFacade.HIDE_OVERLAY);
            sendNotification(ApplicationFacade.REFRESH_TOOLBAR);
            return;
        }

        override public function onRegister() : void
        {
            achievements.addEventListener(achievements.ON_CLOSE, close);
            return;
        }

        override public function handleNotification(value:INotification) : void
        {
            var _loc_2:Object = null;
            switch(value.getName())
            {
                case ApplicationFacade.UPDATE_OBJECTS:
                {
                    _loc_2 = value.getBody();
                    if (_loc_2.achievements)
                    {
                        achievements.update(app_data.get_achievements_data());
                    }
                    break;
                }
                case ApplicationFacade.DISPLAY_ACHIEVEMENTS:
                {
                    sendNotification(ApplicationFacade.SHOW_OVERLAY);
                    achievements.visible = true;
                    align();
                    break;
                }
                case ApplicationFacade.ESCAPE_PRESSED:
                {
                    sendNotification(ApplicationFacade.HIDE_OVERLAY);
                    achievements.visible = false;
                    break;
                }
                case ApplicationFacade.STAGE_RESIZE:
                {
                    align();
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }

        protected function get app_data() : AppDataProxy
        {
            return facade.retrieveProxy(AppDataProxy.NAME) as AppDataProxy;
        }

    }
}
