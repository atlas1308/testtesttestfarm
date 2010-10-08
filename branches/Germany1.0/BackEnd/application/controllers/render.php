<?php
defined('SYS_PATH') OR die('No direct access allowed.');

/**
 * Render page!
 *
 * @package    Render
 * @author     Ko Team, Eric 
 * @version    $Id: render.php 131 2010-07-17 06:52:54Z wangzh $
 * @copyright  (c) 2008-2009 Ko Team, Eric 
 * @license    http://kophp.com/license.html
 */

class RenderController extends Controller
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
         
         //  Auto render , use default template (controller/action.EXT).
        $this->autoRender(TRUE);
    }
    
    /*
     * Default action
     */
    public function index ()
    {
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
	}
	
	public function after()
	{
	    $this->view->controller = $this->getRequest()->getController();
        $this->view->action = $this->getRequest()->getAction();
        $this->view->template = str_replace(DOC_ROOT, '', $this->view->getView());
        
        // Load parent::after to render this controller.
        parent::after();
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
