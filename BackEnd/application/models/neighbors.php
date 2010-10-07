<?php
defined('SYS_PATH') or die('No direct access allowed.');

/**
 * 邻居管理 请求加邻居时添加一条A-B的记录，状态为0； 
 * 请求通过时更新 A-b的状态为1 ，同时添加B-A的记录； 
 * 请求拒绝时更新 A-B的记录状态为3；
 * 
 * @author  鼹鼠
 * @package 
 * @version $Id: neighbors.php 706 2010-09-11 10:10:08Z wangzh $
 */
class NeighborsModel extends Model {
	/**
	 * table name
	 *
	 * @var string
	 */
	protected $_name = 'neighbors';

	/**
	 * Add records
	 * 
	 * @param $data
	 * @param $replace 是否替换原有数据
	 */
    public function add($data, $replace=false)
    {
        $neighbors = array(
           'uid'       => $data['uid'],
           'nuid'      => $data['nuid'] ,
           'message'   => isset($data['message']) ? $data['message'] : '',
           'status'    => isset($data['status']) ? $data['status'] : 0,
           'datetime'  => date('Y-m-d H:i:s')
        );
        unset($data);
        return $replace ? parent::replace($neighbors) : parent::insert($neighbors);
    }
    	
	/**
	 * 删除某人的邻居关系
	 *
	 * @param $uid
	 * @return 
	 */
	public function deleteNeighborById($uid)
	{
		return parent::delete($this->getAdapter()->bind('uid = ? OR nuid = ?', $uid));
	}
    	
	/**
	 * 删除一条邻居关系
	 *
	 * @param $uid
	 * @param $nuid
	 * @return 
	 */
	public function deleteNeighborByUidAndNuid($uid, $nuid)
	{
		return parent::delete($this->getAdapter()->bind('uid = ? AND nuid = ?', array($uid, $nuid)));
	}
	
	/**
	 * 更新邻居用户数据
	 *
	 * @param number $uid
	 * @param number $nuid
	 * @param object $setdata
	 * @return 
	 */
	public function updateNeighbour($uid, $nuid, $setdata)
	{
		$where = $this->getAdapter()->bind('uid = ? and nuid = ?', array($uid, $nuid));
		return parent::update($setdata, $where);
	}
	
	/**
	 * 专为客户端传fids获取好友信息
	 *
	 * @param $userinfo（对象） $nuids
	 * @return array
	 */
	public function getNeighborsByNuids($userinfo,$nuids) 
	{
		$user = new UserModel();
		//$userinfo = $user->getUserById($uid);
		$result = $user->getSelectObj('level, coins, experience as exp, experience, uid, uid as id')
		               ->where('uid', $nuids)
		               ->fetchObject();
		//foreach ($result as  &$row) { 
		foreach ($result as $key => & $item){
			$item->experience = $userinfo->experience;
			$item->id = $userinfo->uid;
            $result[$key] = $item;
		}
		return $result;
	}
	
	
	/**
	 * getNeighborsByUid
	 *
	 * @param int $uid
	 * @return array
	 */
	public function getNeighborsByUid($uid) 
	{
		$nuids = $this->getAllNeighborIdByUid($uid);
		if(!$nuids) return array();
		$user = new UserModel();
		$result = $user->getSelectObj('level, coins, experience as exp, experience, uid, uid as id')
		               ->where('uid', $nuids)
		               ->fetchObject();
		foreach ($result as &$row) {
            $row->id = $uid;
		}
		return $result;
	}
	
	/**
	 * Get ALl Neighbors ID
	 * @param $uid
	 */
	public function getAllNeighborIdByUid($uid)
	{
		$data = $this->getSelectObj('nuid')
					->where('uid', $uid)
					->where('status', 1)
					->fetchObject();
		if(!$data)
            return array();
		$ret = array();
		foreach ($data as $row) {
			$ret[] = $row->nuid;
		}
		return $ret;
	}
	
	/**
	 * 获得某用户的一个好友信息
	 * @param $uid
	 * @param $nuid
	 */
	public function getNeighborByUidAndNuid($uid, $nuid)
	{
        return $this->getSelectObj()->where('uid', $uid)
                                    ->where('nuid', $nuid)
                                    ->where('status', 1)
                                    ->fetchRow();
	}
    
    /**
     * 添加邻居请求
     * 
     * @param $uid
     * @param $nuid
     * @param $message
     */
    public function addNeighbourRequest($uid, $nuid, $message = '')
    {
        $neighbors = array(
           'uid'       => $uid,
           'nuid'      => $nuid,
           'message'   => $message,
           'status'    => 0,
           'datetime'  => date('Y-m-d H:i:s')
        );
        $this->add($neighbors, true);
    }
    
    /**
     * 回应邻居请求 同意OR拒绝 (支持批量)
     * @param $uid     A
     * @param $nuids   B
     * @param $agree
     */
    public function answerNeighbourRequest($uid, $nuids, $agree = true)
    {
        // 更新 A-B 状态为 1
        $setdata = array(
            'status' => $agree ? 1 : 3
        );
        $where = $this->getAdapter()->bind('nuid = ? and uid in (?)', array($uid, $nuids));
        parent::update($setdata, $where);

        // 添加 B-A 记录
        if ($agree) {
            foreach ($nuids as $nuid) {
                $neighbors = array(
                   'uid'       => $uid,
                   'nuid'      => $nuid,
                   'status'    => 1,
                );
                $this->add($neighbors);
            }     
        }
        return ;
    }
    
    /**
     * 批量加为邻居
     * 
     * @param $uid
     * @param $nuids
     */
    public function batchAddNeighbours($uid, $nuids)
    {
        if(!$uid || !$nuids || !is_array($nuids)) 
            return;
            
        foreach ($nuids as $nuid) {
        	if($uid == $nuid) continue;
            $neighbors = array(
               'uid'       => $uid,
               'nuid'      => $nuid,
               'status'    => 1,
            );
            $this->add($neighbors, true);   
                
            $neighbors = array(
               'uid'       => $nuid,
               'nuid'      => $uid,
               'status'    => 1,
            );
            $this->add($neighbors, true);       
        }
        return true;
    }
    	
    /**
     * 批量解除邻居
     * 
     * @param $uid
     * @param $nuids
     */
    public function batchRemoveNeighbours($uid, $nuids)
    {
        if(!$uid || !$nuids || !is_array($nuids)) 
            return;
            
        foreach ($nuids as $nuid) {
            $this->deleteNeighborByUidAndNuid($uid, $nuid);   
            $this->deleteNeighborByUidAndNuid($nuid, $uid);   
        }
        return true;
    }
    	
}