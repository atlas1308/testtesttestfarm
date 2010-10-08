<?php
/**
 * AMF DataHandler Service. 
 * @author Eric
 * @version $Id: DataQuery.php 131 2010-07-17 06:52:54Z wangzh $
 */

class DataQuery
{
	/**
	 * Recieve & Save Falsh Request.
	 * @param $channel String 
	 * @param $method String
	 * @param $callid String
	 * @param $data Objcet
	 */
	public function requestData($channel, $method, $callid, $data=null){
/*		$data = 'channel = ' . $channel . "\n"
				. 'method = ' . $method . "\n"
				. 'params = ' . var_export($data, true) . "\n\n";
*/
		file_put_contents('data' . DIRECTORY_SEPARATOR . $channel. '.' . $method . '.' . $callid . '.request', serialize($data));
		return 'ok';
	}

	/**
	 * Recieve & Save Falsh Response.
     * @param $channel String 
     * @param $method String
     * @param $callid String
     * @param $data Objcet
	 */
	public function responseData($channel, $method, $callid, $data=null){
/*		$data = 'channel = ' . $channel . "\n"
				. 'method = ' . $method . "\n"
				. 'response = ' . var_export($data, true) . "\n\n";
*/
		file_put_contents('data' . DIRECTORY_SEPARATOR . $channel. '.' . $method . '.' . $callid . '.response', serialize($data));
		return 'ok';
	}
	
}
