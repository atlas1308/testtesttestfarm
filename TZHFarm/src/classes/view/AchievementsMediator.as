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

        public function AchievementsMediator(value:Object)
        {
            super(NAME, value);
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
        }

        private function close(event:Event) : void
        {
            achievements.visible = false;
            sendNotification(ApplicationFacade.HIDE_OVERLAY);
            sendNotification(ApplicationFacade.REFRESH_TOOLBAR);
        }

        override public function onRegister() : void
        {
            achievements.addEventListener(achievements.ON_CLOSE, close);
        }

        override public function handleNotification(value:INotification) : void
        {
            var body:Object = null;
            switch(value.getName())
            {
                case ApplicationFacade.UPDATE_OBJECTS:
                {
                    body = value.getBody();
                    if (body.achievements)
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
        }

        protected function get app_data() : AppDataProxy
        {
            return facade.retrieveProxy(AppDataProxy.NAME) as AppDataProxy;
        }

    }
}
