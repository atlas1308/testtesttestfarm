<?php
defined('SYS_PATH') OR die('No direct access allowed.');

/**
 * Config class.
 *
 * @package    Hello
 * @version    $Id: config.php 387 2010-08-27 10:51:30Z hcj $
 */
class ConfigModel
{
    public function getConfig()
    {
        return self::__set_state(array(
            'store_tabs_new' => array (
        0 => '기계',
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
                    'action_link' => '재료 선물하기',
                    'name' => '{actor} 님이 컨츄리라이프에서 %s을 짓고 있습니다!',
                    'description' => '{actor} 님이 %s을 짓는데 친구들의 재료 선물이 필요합니다.',
        )),
                'help_friend_well' => self::__set_state(array(
                    'action_link' => ' {actor}님 도와주기',
                    'name' => '{actor} 님이 컨츄리라이프에서 %s을 짓고 있습니다!',
                    'description' => '{actor} 님이 %s을 짓는데 친구들의 %m 도움이 필요합니다.',
        )),
                'sprinkler' => self::__set_state(array(
                    'action_link' => '재료 선물하기',
                    'name' => '{actor} 님이 컨츄리라이프에서 관개시설을 짓고 있습니다!',
                    'description' => '{actor}  님이 관개시설을 짓는데 친구들의 스프링클러 선물이 필요합니다.',
        )),
                'help_friend' => self::__set_state(array(
                    'action_link' => '{actor}님 도와주기',
                    'name' => '{actor} 님이 컨츄리라이프에서 %s을 짓고 있습니다!',
                    'description' => '{actor}님이 %s를 짓는데 무거운 %m 드는 도움이 필요합니다.',
        )),
                'inform_friend' => self::__set_state(array(
                    'image' => 'wall_gift',
                    'action_link' => '컨츄리라이프 지금 시작하기',
                    'name' => '{actor} 님이 컨츄리라이프에서 특별한 선물을 주셨어요!',
                    'description' => '너그러운 마음씨 감사해요!',
        )),
                'send_materials_upgrade' => self::__set_state(array(
                    'action_link' => '재료 선물하기',
                    'name' => '{actor} 님이 컨츄리라이프에서 %s를 레벨 %l로 업그레이드 중입니다!',
                    'description' => '{actor} 님이 %s를 업그레이드 하는데 친구들의 재료 선물이 필요합니다.',
        )),
        )),
            'gift_received_exp' => 10,
            'store_tabs' => array (
  	  	0 => '씨앗',
  	  	1 => '나무',
    	2 => '동물',
 	  	3 => '기계',
 	   	4 => '건물',
  	  	5 => '재료',
    	6 => '장식품',
        7 => '특수효과',
        8 => '토지확장',
        9 => '자동수확',
        ),
            'ask_for_materials_stories' => array (
        0 => '재료 보내기',
        1 => '재료 조르기',
        2 => '스프링클러',
        ),
        ));

    }

    public static function __set_state($an_array)
    {
        $obj = new stdClass();
        foreach ($an_array as $key => $val) $obj->$key = $val;
        return $obj;
    }

}

?>