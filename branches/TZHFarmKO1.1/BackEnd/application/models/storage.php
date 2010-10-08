<?php
defined('SYS_PATH') OR die('No direct access allowed.');

/**
 * 仓库模块
 *
 * @package Hello
 * @version $Id: storage.php 232 2010-08-04 11:32:01Z wangzh $
 */
class StorageModel extends Model
{
    /**
     * 数据表名
     *
     * @var string
     */
    protected $_name = 'storage';
    
    /**
     * 获得仓库物品数量
     *
     * @param array $where
     * @return int
     */
    public function getUserStorageCount($uid)
    {
        return $this->count('uid', $uid);
    }
    
    /**
     * 获得某个用户的仓库列表
     *
     * @param int $uid
     * @return Object
     */
    public function getUserStoragesByUid($uid)
    {
        return $this->getSelectObj('itemid, num')->where('uid', $uid)
                                                 ->where('num > 0')
                                                 ->fetchObject();
    }
    
    /**
     * 获得用户仓库中某产品的数量
     * @param $uid
     * @param $itemid
     */
    public function getItemNumByUidAndItemid($uid, $itemid)
    {
        $row = $this->getSelectObj('num')->where('uid', $uid)
                                         ->where('itemid', $itemid)
                                         ->fetchRow();
        return $row ? $row->num : false;                                           
    }
    
    /**
     * 清空用户仓库中的某产品
     * @param $uid
     * @param $itemid
     */
    public function deleteItemByUidAndItemid($uid, $itemid)
    {
        return parent::delete($this->getAdapter()->bind('uid = ? and itemid = ?', array($uid, $itemid)));
    }
    
    /**
     * 更新仓库信息
     *
     * @param int $uid
     * @param array $setdata
     * @return bool
     */
    public function addItemNumByUidAndItemid($uid, $itemid, $num)
    {
        if (($numNow = $this->getItemNumByUidAndItemid($uid, $itemid)) !== false) {
            return $this->updateItemNumByUidAndItemid($uid, $itemid, $numNow + $num);
        }
        else {                                 
            $storage = array(
                'uid'          => $uid,
                'itemid'       => $itemid,
                'num'          => $num,
            );
            return parent::insert($storage);
        }    	
    }
    
    /**
     * 更新仓库信息
     *
     * @param int $uid
     * @param array $setdata
     * @return bool
     */
    public function updateItemNumByUidAndItemid($uid, $itemid, $num)
    {
        $where = $this->getAdapter()->bind('uid = ? and itemid = ?', array($uid, $itemid));
        return parent::update(array('num' => $num), $where);
    }
    
    /**
     * 根据用户uid更新仓库数据
     *
     * @param  array $uid
     */
    public function updateStorageByUid($uid, $setdata)
    {
    	$where = $this->getAdapter()->bind('uid = ?', $uid);
        return parent::update($setdata, $where);
    }
    
    /**
     * 删除一个仓库
     *
     * @param  array $uids
     */
    public function deleteStorageByUid($uids)
    {
        return parent::delete($this->getAdapter()->bind('uid IN (?)', $uids));
    }
 
}
