<?php 
defined('SYS_PATH') or die('No direct script access.');
/**
 * File-based configuration loader.
 *
 * @package    Ko
 * @author     Ko Team, Eric 
 * @version    $Id: file.php 46 2009-09-23 03:43:27Z eric $
 * @copyright  (c) 2009 Ko Team
 * @license    http://kophp.com/license.html
 */
class Config_File extends Config_Reader {

	// Configuration group name
	protected $_configuration_group;

	// Has the config group changed?
	protected $_configuration_modified = FALSE;

	public function __construct($directory = 'config')
	{
		// Set the configuration directory name
		$this->_directory = trim($directory, '/');

		// Load the empty array
		parent::__construct();
	}

	/**
	 * Merge all of the configuration files in this group.
	 *
	 * @param   string  group name
	 * @param   array   configuration array
	 * @return  $this   clone of the current object
	 */
	public function load($group, array $config = NULL)
	{
        if (($files = Ko::findFile($this->_directory, $group)) !== FALSE) {
			$config = array();
            foreach ($files as $file) {
                $config = Arr::merge($config, require $file);
            }
		}

		return parent::load($group, $config);
	}

} // End Config
