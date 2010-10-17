<?php
defined('SYS_PATH') OR die('No direct access allowed.');

/**
 * 仓库模块
 *
 * @package Hello
 * @version $Id: storage.php 769 2010-09-18 16:14:36Z wangzh $
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
     * Cache 配置文件的 KEY
     * 
     * OVERLOAD
     * @var string 
     */
    protected $cacheConfig = 'mc_farm';
        
    /**
     * 获得某个用户的仓库列表
     *
     * @param int $uid
     * @return Object
     */
    public function getUserStoragesByUid($uid)
    {
    	$cacheKey = $this->getUserStorageCacheKey($uid);
    	if(($data = $this->getCache($cacheKey)) != false) {
            return $data;
    	}
        $data = $this->getSelectObj('itemid, num')->where('uid', $uid)
                                                  ->where('num > 0')
                                                  ->fetchObject();
        $storages = array();                                                  
        foreach($data as $storage) {
            $storages[$storage->itemid] = $storage->num;
        }
        $this->updateCache($cacheKey, $storages);
        return $storages;                                             
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
            $insertid = parent::insert($storage);
            if($insertid) {
            	$this->deleteCache($this->getUserStorageCacheKey($uid));
            }
            return $insertid;
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
        $ret = parent::update(array('num' => $num), $where);
        if($ret) {
        	$this->deleteCache($this->getUserStorageCacheKey($uid));
        }
        return $ret;
    }
    
    /**
     * 根据用户uid更新仓库数据
     *
     * @param  array $uid
     */
    public function updateStorageByUid($uid, $setdata)
    {
    	$where = $this->getAdapter()->bind('uid = ?', $uid);
    	$ret = parent::update($setdata, $where);
    	if($ret) {
    		$this->deleteCache($this->getUserStorageCacheKey($uid));
    	}
    	return $ret;
    }
    
    /**
     * 生成用户仓库的cache key
     * 
     * @param $uid
     */
    private function getUserStorageCacheKey($uid)
    {
        return sprintf('UserStorages_%s', $uid);
    }
}
