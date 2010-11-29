package classes.view
{
    import classes.*;
    import org.puremvc.as3.multicore.interfaces.*;

    public class CoinsMediator extends NumericBarMediator
    {

        public function CoinsMediator(value:Object)
        {
            NAME = "CoinsMediator";
            super(value);
        }

        override public function handleNotification(value:INotification) : void
        {
            var obj:Object = null;
            switch(value.getName())
            {
                case ApplicationFacade.UPDATE_OBJECTS:
                {
                    obj = value.getBody();
                    if (obj.coins)
                    {
                        bar.update(app_data.coins);
                    }
                    break;
                }
                default:
                {
                    super.handleNotification(value);
                    break;
                }
            }
        }
    }
}
