<?php
defined('SYS_PATH') OR die('No direct access allowed.');

/**
 * 商店模块
 *
 * @package Hello
 * @version $Id: store.php 265 2010-08-07 16:58:18Z wangzh $
 */
class StoreModel
{
    /**
     * 数据
     *
     * @var string
     */
    protected $data = array();
    
    /**
     * 
     * @param $lang
     */
    public function __construct($lang='en-US')
    {
        static $data;
        if (!isset($data[$lang])) {
        	$stores = (array) Ko::config('store');
        	
        	$lang = str_replace(array(' ', '_'), '-', $lang);
        	if($lang !== 'en-US') {
        	   $langData = Ko::lang('store', $lang);
        	   foreach ($stores as & $store) {
        	       if(isset($store->name))
        	           $store->name = $langData[$store->id]['name'];
        	       if(isset($store->desc))
        	           $store->desc = $langData[$store->id]['desc'];
        	   }
        	   unset($stores, $langData);
        	}
        	
            $data[$lang] = (array) Ko::config('store');
        }
        $this->data = $data[$lang];
    }
    
    /**
     * 获得所有商品
     *
     * @return Object
     */
    public function getData()
    {
    	return (object) $this->data;
    }

    /**
     * 获得某个商品信息
     *
     * @param  str $id
     * @return Object
     */
    public function getStoreById($id)
    {
    	return isset($this->data[$id]) ? $this->data[$id] : null;
    }
    
    /**
     * 获得多个商品信息
     *
     * @param  str $id
     * @return Object
     */
    public function getStoresByIds($ids)
    {
        $ret = array();
        foreach ((array) $ids as $id) {
        	if( ! isset($this->data[$id])) continue;
        	$ret[$id] = $this->data[$id];
        }
        return $ret;
    }
    
    /**
     * 获得某个商品的二代商品（产物）
     *
     * @param  str $id
     * @return Object
     */
    public function getProductsById($id)
    {
    	$store = $this->getStoreById($id);
    	if(!$store || !isset($store->product)) 
    	   return false;
    	   
    	return $this->getStoresByIds((array) $store->product);
    }
}
