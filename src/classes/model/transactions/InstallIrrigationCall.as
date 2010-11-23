package classes.model.transactions
{
    import classes.model.*;

    public class InstallIrrigationCall extends TransactionBody
    {

        public function InstallIrrigationCall(value:Object, is_gift:Boolean = false)
        {
            var params:Object = new Object();
            params.id = value.target.id;
            params.x = value.target.grid_x;
            params.y = value.target.grid_y;
            params.water_pipe = value.water_pipe;
            params.is_gift = is_gift ? (1) : (0);
            super("install_irrigation", "save_data", params);
        }

    }
}
