package classes.model.transactions
{
	import classes.model.TransactionBody;
	
	public class AddMessageCall extends TransactionBody
	{
		public function AddMessageCall(value:Object)
		{
			super("add_message", "save_data", value);
		}
		
	}
}