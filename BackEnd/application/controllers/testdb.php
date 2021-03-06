<?php 
defined('SYS_PATH') OR die('No direct access allowed.');

/**
 * Default Ko controller. This controller should NOT be used in production.
 * It is for demonstration purposes only!
 *
 * @package    Core
 * @author     Ko Team, Eric 
 * @version    $Id: testdb.php 131 2010-07-17 06:52:54Z wangzh $
 * @copyright  (c) 2008-2009 Ko Team, Eric 
 * @license    http://kophp.com/license.html
 */

class TestdbController extends Controller
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
    
    /*
     * Default action
     */
    public function index ()
    {
        $user = new SampleModel();
        $user->init();
        
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
