<?php
defined('SYS_PATH') or die('No direct access allowed.');

/**
 * @author  鼹鼠
 * @package 
 * @version $Id: neighbors.php 261 2010-08-07 09:49:16Z wangzh $
 */
class NeighborsModel extends Model {
	/**
	 * table name
	 *
	 * @var string
	 */
	protected $_name = 'neighbors';
	
	/**
	 * add neighbour
	 *
	 * @param neigobour_object $data
	 */
	public function add($data)
	{
		$neighbors = array(
		   'uid'       => $data['uid'],
		   'nuid'      => $data['nuid'] ,
		   'nusername' => $data['nusername'],
		   'gid'       => isset($data['gid']) ? $data['gid'] : 0,
		   'message'   => isset($data['message']) ? $data['message'] : '',
		   'status'    => 0,
		   'datatime'  => date('Y-m-d H:i:s')
		);
		unset($data);
		return parent::insert($neighbors);
	}
	
	/**
	 * delete neighbour by id
	 *
	 * @param number $uid
	 * @return 
	 */
	public function deleteNeighborById($uid)
	{
		return parent::delete($this->getAdapter()->bind('uid = ?',$uid));
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
	 * getNeighborsByUid
	 *
	 * @param int $uid
	 * @return array
	 */
	public function getNeighborsByUid($uid) 
	{
		$result = $this->getAllNeighborIdByUid($uid);
		if(!$result) return array();
		$nuids = array();
        foreach ($result as $row) {
		  $nuids[] = $row->nuid;
		}
		if(!$nuids) return array();
		unset($result, $row);
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
        return $this->getSelectObj('nuid')
                    ->where('uid', $uid)
                    ->where('status', 1)
                    ->fetchObject();
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
}