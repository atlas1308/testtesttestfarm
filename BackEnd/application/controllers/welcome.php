<?php
defined('SYS_PATH') OR die('No direct access allowed.');

/**
 * Default Ko controller. This controller should NOT be used in production.
 * It is for demonstration purposes only!
 *
 * @package    Core
 * @author     Ko Team, Eric
 * @version    $Id: welcome.php 761 2010-09-18 10:57:55Z wangzh $
 * @copyright  (c) 2008-2009 Ko Team, Eric
 * @license    http://kophp.com/license.html
 */

class WelcomeController extends Controller
{
	/**
	 * Creates a new controller instance. Each controller must be constructed
	 * with the request object that created it.
	 *
	 * @param   Request  $request
	 * @return  void
	 */
	public function __construct (Request $request)
	{
		parent::__construct($request);
			
		//  Auto render , use user defined template.
		$this->autoRender(FALSE);
	}

	public function index()
	{
		require_once '../application/services/DataHandler.php';

		$data = array(
			'id'    => '1000202555',
		    'fb_sig_user'    => '1000202555',

			'call_id'        => 'call1276839998658',
			'swf_version'    => 85,
		);
		$testcase = new DataHandler();
		$ret = $testcase->handle('retrieve_data', (object) $data, 'retrieve_data');

		echo "<br>========handle===========";
		print_r($ret);

		// $ret = $testcase->initUserMapData();
		//echo '<pre>';
		//	echo "<br>========initUserMapData===========";
		//print_r($ret);

		//		unset($ret);
		//        $ret = $testcase->getUserMaps(100020206);
		//		echo '<pre>';
		//		echo "<br>========getUserMaps===========";
		//		print_r($ret);

		echo '</pre>';
	}

	public function test()
	{
		/*	   $map = new MapModel();
		 $ret = $map->getUserPlantsByUid('703118330');
		 print_r($ret);*/
		echo '<pre>';
		$config = new StoreModel('ko-KR');
		$data = $config->getData();
		unset($config);
		
		$newconfig = array();
		foreach ($data as $key => & $config) {
			if(isset($config->name))
			     $newconfig[$key]['name'] = $config->name;
			if(isset($config->desc))
			     $newconfig[$key]['desc'] = $config->desc;
		}
		echo var_export($newconfig, true);
	}

	public function check()
	{
	   $sto = new StorageModel();
	   print_r($sto->getUserStoragesByUid('17523642'));
	   echo $sto->getLastQuery();
	}
	
	public function lang()
	{
//		$config = Ko::config('cache');
//		print_r($config);
		
        $store = Ko::lang('store', 'en_US');
        print_r($store);
        
	}
	
	public function dodo()
	{
		$file = 'data/retrieve_data.retrieve.1279381815334.response';

		$content = file_get_contents($file);

		$data = unserialize($content);
		unset($content);
		echo '<pre>';

		$store = new StoreModel();
		$tmp = $store->getData();
		foreach ($tmp as &$row) {
			// 单个产品为 数字，多个产品为 数组
			$row->raw_material = trim($row->raw_material) && !is_numeric($row->raw_material) ? unserialize($row->raw_material) : '';
			$row->product = trim($row->product) && !is_numeric($row->product) ? unserialize($row->product) : '';
			$row->materials = trim($row->materials) && !is_numeric($row->materials) ? unserialize($row->materials) : '';
			$row->upgrade_levels = trim($row->upgrade_levels) && !is_numeric($row->upgrade_levels) ? unserialize($row->upgrade_levels) : '';
			foreach ($row as $key => $val) {
				if(is_string($val) && trim($val) == '' || is_null($val)) unset($row->$key);
				unset($row->status, $row->addtime);
			}
		}
		foreach ($data->config->store as $row) {
			//echo $row->id . "\t" . count((array)$row) . "\t" . count((array)$tmp[($row->id - 1)]) . "\n";
			echo $row->id ;
			print_r(array_diff((array)$row , (array)$tmp[($row->id - 1)]));
		}
		unset($data->config);
		//echo var_export($data, true);
		echo '</pre>';
	}
	/*
	 * Default action
	 */
	public function index2 ()
	{
		// In Ko, all views are loaded and treated as objects.
		$this->view = View::factory('template');
		// You can assign anything variable to a view by using standard OOP
		// methods. In my welcome view, the $title variable will be assigned
		// the value I give it here.
		$this->view->title = 'Welcome to Ko!';

		// An array of links to display. Assiging variables to views is completely
		// asyncronous. Variables can be set in any order, and can be any type
		// of data, including objects.
		$this->view->links = array (
			'Home Page'     => 'http://kophp.com/',
			'Documentation' => 'http://docs.kophp.com/',
			'Forum'         => 'http://forum.kophp.com/',
			'License'       => 'Ko License.html',
			'Donate'        => 'http://kophp.com/donate',
		);
		$this->view->controller = $this->getRequest()->getController();
		$this->view->action = $this->getRequest()->getAction();
		$this->view->template = str_replace(DOC_ROOT, '', $this->view->getView());
		$this->view->render();
	}

	public function __call($method, $arguments)
	{
		// Disable auto-rendering
		$this->auto_render = FALSE;
		echo $method;
		print_r($arguments);
		// By defining a __call method, all pages routed to this controller
		// that result in 404 errors will be handled by this method, instead of
		// being displayed as "Page Not Found" errors.
		echo 'This text is generated by __call. If you expected the index page, you need to use: welcome/index';
		die();
	}

} // End Welcome Controller
