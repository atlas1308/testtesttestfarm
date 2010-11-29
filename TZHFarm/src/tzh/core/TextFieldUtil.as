package tzh.core
{
	import flash.text.TextField;
	
	public class TextFieldUtil
	{
		public static const TEXT_WIDTH_PADDING:Number = 5;
		public function TextFieldUtil()
		{
		}
		
		public static function truncateToFit(textField:TextField,maxWidth:Number):Boolean
		{
		    var originalText:String = textField.text;
		
		    var untruncatedText:String = originalText;
		
		    var w:Number = maxWidth;
		    if (originalText != "" && textField.textWidth + TEXT_WIDTH_PADDING > w + 0.00000000000001)
		    {
		        var s:String = textField.text = originalText;
		            originalText.slice(0,
		                Math.floor((w / (textField.textWidth + TEXT_WIDTH_PADDING)) * originalText.length));
		
		        while (s.length > 1 && textField.textWidth + TEXT_WIDTH_PADDING > w)
		        {
		            s = s.slice(0, -1);
		            textField.text = s + "..";
		        }
		        
		        return true;
		    }
		    return false;
		} 
	}
}