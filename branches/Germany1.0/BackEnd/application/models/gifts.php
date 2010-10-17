<?php
defined('SYS_PATH') OR die('No direct access allowed.');

/**
 * 礼物模块
 *
 * @package Hello
 * @version $Id: gift.php 131 2010-07-17 06:52:54Z wangzh $
 */
class GiftsModel extends Model
{
    /**
     * 数据表名
     *
     * @var string
     */
    protected $_name = 'gifts';
    
    /**
     * 检查是否可以给某个用户发送礼物
     * @param $uid  当前用户ID
     * @param $touid  接受礼物的用户ID
     */
    public function checkCanSendGift($uid, $touid)
    {
        $row = $this->getSelectObj('id')->where('uid', $uid)
                                        ->where('touid', $touid)
                                        ->where('sendtime > \'' . date('Y-m-d') . '\'')
                                        ->fetchObject();
                                        
        return $row ? false : true;
    }

    /**
     * 获得某个用户的最新礼物
     *
     * @param  int $uid
     * @return Object
     */
    public function getNewGiftByUid($uid)
    {
        return $this->getSelectObj()->where('touid', $uid)
                                    ->where('received', 0)
                                    ->fetchObject();
    }
    
	public function getNewGiftByUidForRetrieve($uid)
    {
        $sqlQuery = "SELECT `itemid`, COUNT(*) as qty
        			FROM ".$this->getTableName()." 
        			WHERE `touid`='".$uid."' 
        			AND `received`=0
        			GROUP BY `itemid` ";
        return $this->getAdapter()->query($sqlQuery, intval($uid))->fetchObject();
    }
        
    /**
     * 接受礼物
     * @param $id
     */
    public function receiveGift($id)
    {
       return $this->updateGift($id, array('received' => 1));
    }
        
    /**
     * 获得礼物数量
     *
     * @param array $where
     * @return int
     */
    public function getGiftCount($where = array())
    {
        return $this->count($where);
    }
    
    /**
     * 新增一个礼物
     *
     * @param  array $data
     * @return int
     */
    public function add($data)
    {
        $Gift = array(
            'uid'        => $data['uid'],
            'touid'        => $data['touid'],
            'itemid'      => $data['itemid'],
            'sendtime'        => date('Y-m-d H:i:s'),
            'received'        => 0
        );
        if(isset($data['message'])){
        	$Gift['message'] = $data['message'];
        }
        return parent::insert($Gift);
    }

    /**
     * 通过Gift ID得到一条礼物对象信息
     *
     * @param  int
     * @return Object
     */
    public function getGiftById($id)
    {
        return $this->getSelectObj()->where('id', $id)
                                    ->fetchRow();
    }
    
	public function getGiftByItemId($uid,$id)
    {
        return $this->getSelectObj()->where('itemid', $id)
        							->where('touid', $uid)
        							->limit(1)
                                    ->fetchRow();
    }

    /**
     * 更新礼物信息
     *
     * @param int $id
     * @param array $setdata
     * @return bool
     */
    public function updateGift($id, $setdata)
    {
    	$updata = array();
        foreach ($setdata as $key => $val) {
           $updata[$key] = addslashes(trim($val)); 
        }
        unset($setdata);
        $where = $this->getAdapter()->bind('id=?', $id);
        return parent::update($updata, $where);
    }
    
    /**
     * 删除一个礼物
     *
     * @param  array $ids
     * @return bool
     */
    public function deleteGiftById($ids)
    {
        return parent::delete($this->getAdapter()->bind('id IN (?)', $ids));
    }
    
}
