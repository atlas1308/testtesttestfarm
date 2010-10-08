<?php
defined('SYS_PATH') OR die('No direct access allowed.');

/**
 * 用户模块
 *
 * @package Hello
 * @version $Id: user.php 325 2010-08-21 10:36:19Z wangzh $
 */
class UserModel extends Model
{
    /**
     * 数据表名
     *
     * @var string
     */
    protected $_name = 'user';
    
    /**
     * 加密算法
     */
    public static function hash($passwd)
    {
        return md5($passwd);
    }
    
    /**
     * 获得用户数量
     *
     * @param array $where
     * @return int
     */
    public function getUserCount($where = array())
    {
        return $this->count($where);
    }
    
    /**
     * 获得当前页的用户列表
     *
     * @param int $page
     * @param int $perpage
     * @return array
     */
    public function getCurrentPageUsers($where = array(), $page = 1, $perpage = 10)
    {
        $page = (int) $page < 1 ? 1 : (int) $page;
        $perpage = (int) $perpage < 1 ? 10 : (int) $perpage;
        $offset = ($page - 1) * $perpage;
        
        return $this->getSelectObj()
                       ->where($where)
                       ->order('uid', 'DESC')
                       ->limit($perpage, $offset)
                       ->fetchObject();
    }
    /**
     * 新增一个用户
     *
     * @param  array $data
     * @return int
     */
    public function add($data)
    {
        $user = array(
            'uid'           => $data['uid'],
            'uname'         => $data['uname'],
            'email'         => $data['email'],
            'plat_uid'      => $data['plat_uid'],
            'coins'         => $data['coins'],
            'level'         => $data['level'],
            'experience'    => $data['experience'],
            'reward_points' => $data['reward_points'],
            'loginip'       => $data['loginip'],
            'status'        => 1,
            'logintime'	    => date('Y-m-d H:i:s'),
            'addtime'	    => date('Y-m-d H:i:s'),
            'addtime'	    => date('Y-m-d H:i:s'),
        );
        return parent::insert($user);
    }

    /**
     * 通过USER ID得到一条用户对象信息
     *
     * @param  int
     * @return array
     */
    public function getUserById($uid)
    {
        return $this->getSelectObj()->where('uid', $uid)
                                    ->fetchRow();
    }

    /**
     * 根据平台PUid获得用户信息
     *
     * @param  str $platuid
     * @return array
     */
    public function getUserByPUid($platuid)
    {
        return $this->getSelectObj()->where('plat_uid', $platuid)
                                    ->fetchRow();
    }
    
    /**
     * 更新用户信息
     *
     * @param int $uid
     * @param array $setdata
     * @return bool
     */
    public function updateUser($uid, $setdata)
    {
    	$updata = array();
        foreach ($setdata as $key => $val) {
           $updata[$key] = addslashes(trim($val)); 
        }
        unset($setdata);
        $where = $this->getAdapter()->bind('uid = ?', $uid);
        return parent::update($updata, $where);
    }
    
    /**
     * 删除一个用户
     *
     * @param  array $uids
     * @return int 一般情况下是1
     */
    public function deleteUserById($uids)
    {
        return parent::delete($this->getAdapter()->bind('uid IN (?)', $uids));
    }
    
    /**
     * 验证用户是否存在,是返回用户信息,否则返回false
     *
     * @param  string $platuid
     * @return array | false
     */
    public function checkUser($platuid)
    {
        $where = array(
            'plat_uid' => $platuid,
        );
        $row = $this->getSelectObj('uid')->where($where)->fetchRow();
        if($row && $row->uid) {
            return $row;
        } else {
            return false;
        }
    }
 
    /**
     * 增加用户数据（将用户表中的统计数据递增/递减）
     * 
     * @param $uid
     * @param $data = array('coins' => 10, 'experience' => 25) 
     */
    public function increaseUserData($uid, $data)
    {
    	if(!is_array($data)) return false;
    	$updata = array();
    	foreach ($data as $filed => $val) {
    	   $updata[] = '`' . $filed . '`=`' . $filed . '`+\'' . $val . '\''; 
    	}
        $sql = 'UPDATE `' . $this->getTableName() . '` SET ' . implode(',', $updata) . ' WHERE uid = \'' . $uid . '\'';
        return $this->getAdapter()->query($sql);        
    }
    
    
}
