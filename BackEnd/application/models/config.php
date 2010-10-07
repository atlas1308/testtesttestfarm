<?php
defined('SYS_PATH') OR die('No direct access allowed.');

/**
 * Config class.
 *
 * @package    Hello
 * @version    $Id: config.php 719 2010-09-12 09:18:08Z dabin $
 */
class ConfigModel
{
    public function getConfig($lang='en-US')
    {
    	
    	if($lang == 'de-DE') 
    	{
	        return self::__set_state(array(
	            'store_tabs_new' => array (
	        0 => 'gear',
	        ),
	            'work_area' => self::__set_state(array(
	        2 => self::__set_state(array(
	                    'rp_price' => 20,
	                    'size' => 2,
	                    'log_id' => 1000,
	                    'price' => 1000,
	        )),
	        3 => self::__set_state(array(
	                    'rp_price' => 30,
	                    'size' => 3,
	                    'log_id' => 1001,
	                    'price' => 3000,
	        )),
	        )),
	            'ask_for_help_stories' => array (
	        0 => 'help_friend',
	        1 => 'help_friend_well',
	        ),
	            'story_patterns' => self::__set_state(array(
	                'send_materials' => self::__set_state(array(
	                    'action_link' => 'Werkstoffe senden',
	                    'name' => '{actor}baut jetzt %s im Landleben!',
	                    'description' => '{actor} baut jetzt %s und bittet Freunden um mehrere Baustoffe.',
	        )),
	                'help_friend_well' => self::__set_state(array(
	                    'action_link' => 'helfe {actor}',
	                    'name' => '{actor} baut jetzt %s im Landleben!',
	                    'description' => '{actor} baut jetzt %s und bittet um Hilfe über %m .',
	        )),
	                'sprinkler' => self::__set_state(array(
	                    'action_link' => 'Werkstoffe senden',
	                    'name' => '{actor} baut jetzt eine Beregnungsanlage im Landleben!',
	                    'description' => '{actor} baut jetzt eine Beregnungsanlage und bittet Freunden um mehrere Sprengapparate.',
	        )),
	                'help_friend' => self::__set_state(array(
	                    'action_link' => 'helfe {actor}',
	                    'name' => '{actor} baut jetzt %s im Landleben!',
	                    'description' => '{actor} s building %s and needs help mounting the heavy %m.',
	        )),
	                'inform_friend' => self::__set_state(array(
	                    'image' => 'wall_gift',
	                    'action_link' => 'Jetzt spiele im Landleben',
	                    'name' => '{actor} at gerade andir ein besonderes Geschenk im Landleben gesendet!',
	                    'description' => 'Nett von ihm!',
	        )),
	                'send_materials_upgrade' => self::__set_state(array(
	                    'action_link' => 'Werkstoffe senden',
	                    'name' => '{actor} baut jetzt %s zur Stufe %l im Landleben aus!',
	                    'description' => '{actor} baut jetzt %s aus und bittet Freunden um mehrere Baustoffe.',
	        )),
	        )),
	            'gift_received_exp' => 10,
	        
	        
	        /* 临时屏蔽换英文，待前端处理
	            'store_tabs' => array (
	        0 => 'samen',
	        1 => 'B盲ume',
	        2 => 'Tiere',
	        3 => 'Anlage',
	        // 4 => 'Geb盲ude',
	        5 => 'Werkstoffe',
	        6 => 'Dekors',
	        7 => 'special_events',
	        8 => 'expand_ranch',
	        9 => 'Automation',
	        ),
	            'ask_for_materials_stories' => array (
	        0 => 'send_materials',
	        1 => 'share_materials_upgrade',
	        2 => 'Sprengapparat',
	        ),
	        */
	            'store_tabs' => array (
			        0 => 'seeds',
			        1 => 'trees',
			        2 => 'animals',
			        3 => 'gear',
			        4 => 'buildings',
			        5 => 'materials',
			        6 => 'decorations',
			        7 => 'special_events',
			        8 => 'expand_ranch',
			        9 => 'automation',
			        ),
			            'ask_for_materials_stories' => array (
			        0 => 'send_materials',
			        1 => 'share_materials_upgrade',
			        2 => 'sprinkler',
	        	),
	        
	        ));
	       
    	}
    	else {

	        return self::__set_state(array(
	            'store_tabs_new' => array (
	        0 => 'gear',
	        ),
	            'work_area' => self::__set_state(array(
	        2 => self::__set_state(array(
	                    'rp_price' => 20,
	                    'size' => 2,
	                    'log_id' => 1000,
	                    'price' => 1000,
	        )),
	        3 => self::__set_state(array(
	                    'rp_price' => 30,
	                    'size' => 3,
	                    'log_id' => 1001,
	                    'price' => 3000,
	        )),
	        )),
	            'ask_for_help_stories' => array (
	        0 => 'help_friend',
	        1 => 'help_friend_well',
	        ),
	            'story_patterns' => self::__set_state(array(
	                'send_materials' => self::__set_state(array(
	                    'action_link' => 'Send Materials',
	                    'name' => '{actor} is building %s in Country Life!',
	                    'description' => '{actor} is building %s and needs their friends to send them more construction materials.',
	        )),
	                'help_friend_well' => self::__set_state(array(
	                    'action_link' => 'Help {actor}',
	                    'name' => '{actor} is building %s in Country Life!',
	                    'description' => '{actor} is building %s and needs help with the %m.',
	        )),
	                'sprinkler' => self::__set_state(array(
	                    'action_link' => 'Send Materials',
	                    'name' => '{actor} is building an irrigation system in Country Life!',
	                    'description' => '{actor} is building an irrigation system and needs their friends to send them more sprinklers.',
	        )),
	                'help_friend' => self::__set_state(array(
	                    'action_link' => 'Help {actor}',
	                    'name' => '{actor} is building %s in Country Life!',
	                    'description' => '{actor} s building %s and needs help mounting the heavy %m.',
	        )),
	                'inform_friend' => self::__set_state(array(
	                    'image' => 'wall_gift',
	                    'action_link' => 'Play Country Life now',
	                    'name' => '{actor} just sent you a very special gift in Country Life!',
	                    'description' => 'How very thoughtful of them!',
	        )),
	                'send_materials_upgrade' => self::__set_state(array(
	                    'action_link' => 'Send Materials',
	                    'name' => '{actor} is upgrading %s to level %l in Country Life!',
	                    'description' => '{actor} is upgrading %s and needs their friends to send them more construction materials.',
	        )),
	        )),
	            'gift_received_exp' => 10,
	            'store_tabs' => array (
			        0 => 'seeds',
			        1 => 'trees',
			        2 => 'animals',
			        3 => 'gear',
			        4 => 'buildings',
			        5 => 'materials',
			        6 => 'decorations',
			        7 => 'special_events',
			        8 => 'expand_ranch',
			        9 => 'automation',
			        ),
			            'ask_for_materials_stories' => array (
			        0 => 'send_materials',
			        1 => 'share_materials_upgrade',
			        2 => 'sprinkler',
			        ),
	        ));
    		
    	}


    }

    public static function __set_state($an_array)
    {
        $obj = new stdClass();
        foreach ($an_array as $key => $val) $obj->$key = $val;
        return $obj;
    }

}


?>