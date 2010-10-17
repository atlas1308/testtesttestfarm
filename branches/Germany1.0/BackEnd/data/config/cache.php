<?php defined('SYS_PATH') or die('No direct script access.');

return array (
	'default'	=> array(
		'driver'   => 'file',
		'path'     => DATA_PATH. 'cache',
		'lifetime'    => 3600 * 24,
	),
/*	
	'xcache'	=> array(
		'driver'   => 'xcache',
        'auth_uset' => 'ko',
		'auth_pass' => 'ko',
	),
	
	'memcache'	=> array(
		'driver'   => 'memcache',
        'servers'	=> array(
			array(
				'host' 		  => '127.0.0.1',
				'port' 		  => 11211,
				'persistent'  => false,
			),
		),
		'compression' => false,
		'lifetime'    => 3600,     // s
	),
*/
    
    // 农场Cache
    'mc_farm' => array(
        'driver'   => 'memcache',
        'servers'   => array (
            array (
                'host'        => '127.0.0.1',
                'port'        => 11211,
                'persistent'  => false,
            ),
        ),
        'compression' => false,
        'lifetime'    => 3600,     // 默认1小时
    ),
);
