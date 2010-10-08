package classes.model.err
{
	import mx.resources.ResourceManager;
	

    public class Err extends Object
    {
        public static const JSON_PARSING:Object = 4002;
        public static const CALL_DELAY:String = ResourceManager.getInstance().getString("message","call_delay");
        public static const DATA_HASH:Object = 4003;
        public static const NO_PLANTS_TO_FERTILIZE:String = ResourceManager.getInstance().getString("message","no_plants_to_fertilize");
        public static const AMF_DELAY:Object = 4007;
        public static const GAME_UPDATED:String = ResourceManager.getInstance().getString("message","game_updated");
        public static const AMF_NET_STATUS:Object = 4008;
        public static const LOCAL_CONNECTION:Object = 4001;
        public static const REFRESH_PAGE:String = ResourceManager.getInstance().getString("message","refresh_page");
        public static const EXPAND_LEVEL_TOO_BIG:String = ResourceManager.getInstance().getString("message","expand_level_too_big");
        public static const CALL_DELAY_CODE:Number = 4011;
        public static const SWF_VERSION:Object = 4005;
        public static const AMF_FAULT:Object = 4006;
        public static const NO_OP:String = ResourceManager.getInstance().getString("message","no_op");
        public static const AMF_IO_ERROR:Object = 4009;
        public static const NO_COINS:String = ResourceManager.getInstance().getString("message","cannot_use_coin_buy_message");
        public static const NO_PLANTS:String = ResourceManager.getInstance().getString("message","no_plants_to_water_message");
        public static const TIME_DELAY:Number = 4004;
        public static const AMF_ASYNC:Object = 4010;
        public static const INIT_DATA:Object = ResourceManager.getInstance().getString("message","cannot_initialized_message");
        public static const EXPAND_YARD_LEVEL_TOO_BIG:String = ResourceManager.getInstance().getString("message","expand_yard_level_too_big");
        public static const NO_RP:String = ResourceManager.getInstance().getString("message","get_more_cash_message");

        public function Err()
        {
            return;
        }

    }
}
