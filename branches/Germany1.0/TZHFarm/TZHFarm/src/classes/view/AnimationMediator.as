package classes.view
{
    import classes.*;
    import classes.model.*;
    import classes.view.components.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;

    public class AnimationMediator extends Mediator implements IMediator
    {
        public static const NAME:String = "AnimationMediator";

        public function AnimationMediator(value:Object)
        {
            super(NAME, value);
        }

        override public function listNotificationInterests() : Array
        {
            return [ApplicationFacade.START_COLLECT_ANIMATION];
        }

        protected function get anim() : AnimationContainer
        {
            return viewComponent as AnimationContainer;
        }

        protected function get app_data() : AppDataProxy
        {
            return facade.retrieveProxy(AppDataProxy.NAME) as AppDataProxy;
        }

        override public function onRegister() : void
        {
            return;
        }

        override public function handleNotification(value:INotification) : void
        {
            switch(value.getName())
            {
                case ApplicationFacade.START_COLLECT_ANIMATION:
                {
                    anim.show(value.getBody());
                    break;
                }
                default:
                {
                    break;
                }
            }
        }

    }
}
