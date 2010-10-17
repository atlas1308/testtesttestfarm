<?php
/**
 * AMF DataHandler Service.
 * @author Eric
 * @version $Id: DataHandle.php 189 2010-07-21 13:36:27Z wangzh $
 */

class DataHandler
{
	private $input;

	private $uid;
	private $lang;

	protected $data_hash;
	protected $timestamp;

	/**
	 * 是否输出调试信息  上线时应该关闭
	 * @var array
	 */
	protected $debug = true;
	protected $demsg = array();

	const MAX_PRODUCTS = 3;    // 最大产品数
	const HELP_COINS = 20;     // 帮邻居浇地的奖励
	const HELP_XP = 5;
	const HELP_TIME = 86400;  //帮助时间间隔
	
	const EVERY_DAY_LOGIN_IN_AWARD = 150;      // 每日登陆奖励
	const EVERY_DAY_LOGIN_DIFF_TIME = 86400;   // 每日登陆的相差的时间
	
	const UPGRADE_ADD_COIN = 150;      // 升级时增加的金币
	const UPGRADE_ADD_CASH = 1;        // 升级时增加的cash
	
	const INIT_COINS = 500;// 初始化时的金币
	const INIT_RC = 1;// 初始化时的RC
	
    protected $support_langs = array('en-US', 'ko-KR','de-DE');     //支持的语言包

	/**
	 * AMF DataHandler.
	 *
	 * @param string $method
	 * @param object $data
	 * @param string $channel
	 */
	public function handle($method, $input, $channel){
		$this->input = $input;
		$this->timestamp = time();
		$this->uid = isset($this->input->fb_sig_user) ? (string) $this->input->fb_sig_user : '';// : '703118330';
		$this->lang = isset($this->input->lang) && in_array($this->input->lang, $this->support_langs) ? $this->input->lang : 'en-US';
		
		if( $this->uid == '') {
			return array (
				'channel' => $channel,
				'time' => $this->timestamp,
				'retrieve_error' => true,
			);
		}
		
		switch ($method) {
			case 'retrieve_data':
				return $this->retrieveData($channel);
				break;

			case 'execute_batch':
				return $this->executeBatch($channel);
				break;

			case 'load_farm':
				return $this->loadFarm($channel);
				break;
				
			case 'purchase_gift':
				return $this->purchaseGift($channel);
				break;
		}
		return null;
	}

	/**
	 * 获取数据
	 * @param $channel
	 */
	private function retrieveData($channel = null)
	{
		$ret = array (
			'channel' => $channel,
			'time' => $this->timestamp,
		);
		// Load config
		$config = new ConfigModel();
		$ret['config'] = $config->getConfig($this->lang);
		unset($config);

		// Load levels
		$level = new LevelModel();
		$levels = array();
		foreach($level->getAllLevels() as $level) {
			$levels[$level->level] = array('min' => $level->min_exp, 'max' => $level->max_exp);
		}
		$ret['config']->levels = (object) $levels;
		unset($level, $levels);

		// Load Store Data
		$store = new StoreModel($this->lang);
		$ret['config']->store = $store->getData();
		unset($store);

		$ret['data'] = new stdClass;
		$ret['data']->state = 'ok';
		$ret['data']->call_id = isset($this->input->call_id) ? substr($this->input->call_id, 4) : microtime();
		$ret['data']->data_hash = md5(rand(100, 10000));
		Session::instance()->set('data_hash', $ret['data']->data_hash);

		$ret['data']->swf_version = isset($this->input->swf_version) ? $this->input->swf_version : 85;
		$ret['data']->map = array();
		$ret['data']->storage = array();
		$ret['data']->gifts = array();
		$ret['data']->neighbors = array();
		$ret['data']->all_neighbors = array();

		// Check User wether inited.
		$user = new UserModel();
		$userinfo =  $user->getUserById($this->uid);
		if ($userinfo) {
			$diff_time = $this->timestamp - strtotime($userinfo->logintime);// 用户每天登陆的奖励
			if($diff_time > self::EVERY_DAY_LOGIN_DIFF_TIME){// 更新用户的钱
				$this->debugMsg("diff_time=".$diff_time); 
				$userinfo->lottery_coins = self::EVERY_DAY_LOGIN_IN_AWARD;
				$updateData = array('coins' => ($userinfo->coins + self::EVERY_DAY_LOGIN_IN_AWARD),'logintime'=> date('Y-m-d H:i:s'));
				$user->updateUser($this->uid,$updateData);//更新用户的金币
			}else {
				$updateData = array('logintime'=> date('Y-m-d H:i:s'));
				$user->updateUser($this->uid,$updateData);//更新用户的logintime
			}
			
			// Load User Maps
			$ret['data']->map = $this->getUserMaps($this->uid);

			// Load User storage
			$storage = new StorageModel();
			$ret['data']->storage = (object) $storage->getUserStoragesByUid($this->uid);
			unset($storage);

			// Load User Gifts
			$gift = new GiftsModel();
			$gifts_list = $gift->getNewGiftByUidForRetrieve($this->uid);
			$gifts_list_re = array();
			foreach($gifts_list as $k => $v){
				$gifts_list_re[$v->itemid] = $v->qty;
			}
			$this->debugMsg($gifts_list);
			$ret['data']->gifts = (Object)$gifts_list_re;
			$this->debugMsg($gift->getLastQuery());
			
			unset($gift);

			// Load User Neighbors
            $ret['data']->all_neighbors[] = $this->syncUserNeighbors($this->input->fids);
            $neighbor = new NeighborsModel();
            $ret['data']->neighbors = $neighbor->getNeighborsByUid($this->uid);
            unset($neighbor);
            
			$ret['data']->show_tutorial = 1;

			//TODO
			$ret['data']->items = array();
			 
			$ret['data']->coins = $userinfo->coins;
			$ret['data']->level = $userinfo->level;
			$ret['data']->experience = $userinfo->experience;
			$ret['data']->size_x = $userinfo->size_x;
			$ret['data']->size_y = $userinfo->size_x;
			$ret['data']->reward_points = $userinfo->reward_points;
			$ret['data']->op = $userinfo->op;
			$ret['data']->top_map_size = $userinfo->top_map_size;
			$ret['data']->max_work_area_size = $userinfo->max_work_area_size;
			$ret['data']->work_area_size = $userinfo->work_area_size;
			$ret['data']->lottery_coins = $userinfo->lottery_coins;
			$ret['data']->feed_data = false;
			$ret['data']->news = false;
			$ret['data']->show_gifts_page = false;
			$ret['data']->stories = array();

			$ret['data']->items_received = array();
			$ret['data']->ask_for_materials = array();
			$ret['data']->ask_for_help = array();
			$ret['data']->friend_helped =  false;
			$ret['data']->gifts_received = array();
		} else {
			$data = array(
        	   'uid'           => $this->uid,
        	   'email'         => '',
        	   'level'         => 1,
        	   'experience'    => 0,
        	   'coins'         => self::INIT_COINS, //500, 
        	   'op'            => 0,
        	   'reward_points' => self::INIT_RC,  //1,
        	   'logintime'     => date('Y-m-d H:i:s'),
        	   'loginip'       => '',
        	   'status'        => 1,
			);
			$user->add($data);
			$ret['data']->show_tutorial = 0;
			//TODO
			$ret['data']->coins = self::INIT_COINS;
			$ret['data']->items = array();
			$ret['data']->level = 1;
			$ret['data']->experience = 0;
			$ret['data']->size_x = 60;
			$ret['data']->size_y = 60;
			$ret['data']->reward_points = self::INIT_RC;
			$ret['data']->op = 0;
			$ret['data']->top_map_size = 0;
			$ret['data']->max_work_area_size = 1;
			$ret['data']->work_area_size = 1;
			$ret['data']->lottery_coins = 0;
			$ret['data']->feed_data = false;
			$ret['data']->news = false;
			$ret['data']->show_gifts_page = false;
			$ret['data']->stories = array();

			$ret['data']->items_received = array();
			$ret['data']->ask_for_materials = array();
			$ret['data']->ask_for_help = array();
			$ret['data']->friend_helped = false;
			$ret['data']->gifts_received = array();
			$ret['data']->storage = (Object) array(15 => '5', 16 => '5');  
				
		    // 将平台好友导入为邻居
            $ret['data']->all_neighbors[] = $this->syncUserNeighbors($this->input->fids, true);
            $neighbor = new NeighborsModel();
            $ret['data']->neighbors = $neighbor->getNeighborsByUid($this->uid);
            unset($neighbor);
			//
			$mapData = $this->initUserMapData();
			$ret['data']->map = $mapData;
		}

		unset($model);
		if($this->debug) $ret['demsg'] = $this->demsg;
		return $ret;
	}

	/*
	 * TODO
	 * save_data 数据临时处理
	 */
	private function executeBatch($channel = null)
	{
		$this->data_hash = Session::instance()->get('data_hash');

		$ret = new stdClass();
		$ret->channel = trim($channel);
		$ret->swf_version = $this->input->swf_version;
		if(isset($this->input->data_hash) && $this->data_hash != $this->input->data_hash) {
			$ret->state = 'not ok';
			return ;
		}
		$ret->data_hash = $this->input->data_hash;
		$ret->state = 'ok';
		$ret->call_id = isset($this->input->call_id) ? substr($this->input->call_id, 4) : microtime();
		$ret->feed_data = false;

		$objects_to_update = array();

		// 获取当前用户信息
        $user = new UserModel();
        $userinfo = $user->getUserById($this->uid);
		switch (trim($channel)) {
			case 'save_data':
				if( ! $this->input->queue || ! is_array($this->input->queue) ) break;
				
				foreach ($this->input->queue as $queue) {
					if(isset($queue->data->data_hash) && $this->data_hash != $queue->data->data_hash) {
						$ret->state = 'not ok';
						return ;
					}
					switch ($queue->method) {
						// 增加地块
						case 'add_object':
							// id=1 , y, x, flip, is_gift
							// 获得添加地块信息 价格和奖励经验
							$updata = array(
                                'id'        => $queue->data->id, 
                                'x'         => $queue->data->x, 
                                'y'         => $queue->data->y, 
                                'flip'      => $queue->data->flip,
                                'animals'   => 0
							);
							
							$store = new StoreModel($this->lang);
							$item = $store->getStoreById($queue->data->id);
							$exp = isset($item->exp) ? $item->exp : 0;
							$price = isset($item->price) ? $item->price : 0;
							$rp = isset($item->rp_price) ? $item->rp_price : 0;
							if((isset($item->type) && $item->type == "animals") || (isset($item->kind) && $item->kind == "chicken_coop")) {
								$updata['animals'] = 1;
							}
							if(isset($item->type) && $item->type == "trees") {
								$updata['start_time'] = $this->timestamp;
							}
							$updata['is_multi'] = isset($item->is_multi) ? $item->is_multi : 0;
							unset($store, $item);

							if($queue->data->is_gift){
								$gift = new GiftsModel();
								$gift_info = $gift->getGiftByItemId($this->uid,$queue->data->id);
								$gift->receiveGift($gift_info->id);
							} else {
								// 验证用户的金币和RP是否够
								if(!$user->checkUserDataEnough($this->uid, array('coins' => $price, 'reward_points' => $rp))){
									unset($user);
								    break;
								}
								$reward_points = (0 - $rp) ? 0 : (0 - $rp);
								$coins = (0 - $price) ? 0 : (0 - $price);
								$user->increaseUserData($this->uid, array('experience' => $exp, 'coins' => $coins, 'reward_points' => $reward_points ));
							}
							unset($gift, $gift_info);
							
                            // 添加地块
                            $map = new MapModel();
                            $map->addObject($this->uid, $updata);
                            unset($map);
                            							
							break;

						// 删除地块
						case 'remove_object':
							// id 种植物ID, y, x, flip, data_hash
							// 获得卖地及动物的价格，更新用户信息
							$price = $this->getMapItemSellPrice($queue->data->x, $queue->data->y);
							$map = new MapModel();
                            $return = $map->removeObject($this->uid, $queue->data->x, $queue->data->y);
                            $this->debugMsg($return);
                            unset($map);
                            
							$this->debugMsg('Sell price: ' . $price);
							if($return && $price > 0) {
								$user = new UserModel();
								$user->increaseUserData($this->uid, array('coins' => $price));
								$this->debugMsg($user->getLastQuery());
							}
							unset($user);
							break;

						// 移动地块
						case 'move_object':
							// id 种植物ID, data_hash
							// x, y, flip,
							// new_x, new_y, flipped
							$old = array(
        					   'map_x' => $queue->data->x, 
        					   'map_y' => $queue->data->y
							);
							$new = array(
        					   'map_x' => $queue->data->new_x, 
        					   'map_y' => $queue->data->new_y,
        					   'flip'  => $queue->data->flipped,
							);
							$map = new MapModel();
							$map->moveObject($this->uid, $old, $new);
							$this->debugMsg($map->getLastQuery());
							unset($map);
							break;

							// 种地
						case 'add_plant':
							// unique_id, soil_x, soil_y, plant_id 种植物ID
							// + 1xp
							$store = new StoreModel($this->lang);
							$item = $store->getStoreById($queue->data->plant_id);
							$exp = isset($item->exp) ? $item->exp : 0;
							$price = isset($item->price) ? $item->price : 0;
							
							$user = new UserModel();
                            if($price > 0 && !$user->checkUserDataEnough($this->uid, array('coins' => $price))) {
                            	break ;
							}
							unset($item);

							$map = new MapModel();
							$return = $map->addPlant($this->uid, $queue->data->soil_x, $queue->data->soil_y, $queue->data->plant_id, $this->timestamp);
							$this->debugMsg($map->getLastQuery());
							unset($map);

							// 更新用户信息
							if($return) {
								$user->increaseUserData($this->uid, array('experience' => $exp, 'coins' => (0 - $price)));
                                $this->debugMsg($user->getLastQuery());
							}
							break;

							// 收获
						case 'collect_product':
							// id 种植物ID, unique_id, x, y
							//保存产品(传递的参数为种植物ID，要转化为产品ID)
							// 如果是动物 、鸡圈、 加工厂
							$store = new StoreModel($this->lang);
                            $storeData = $store->getStoreById($queue->data->id);
							if((isset($storeData->type) && $storeData->type == "animals") || (isset($storeData->kind) && ($storeData->kind == "chicken_coop" || $storeData->type == 'gear'))) {
								// 判断是否有饲料，有则更新start_time 为当前时间，否则更新为 0
								$map = new MapModel();
								$item = $map->getMapItem($this->uid, $queue->data->x, $queue->data->y);
								
								$animals_num = isset($item->animals) && $item->animals > 0 ? $item->animals : 1;
								$collect_in = $storeData->collect_in / $animals_num;
								
								// TODO multi
                                if(!isset($item->is_multi) || $item->is_multi == 0) {
                                	// 获得产物
                                	$product = $store->getStoreById($storeData->product);
                                	$this->debugMsg($product);
                                	// 更新仓库
                                	$storage = new StorageModel();
                                	$storage->addItemNumByUidAndItemid($this->uid, $product->id, 1);
                                	unset($storage);
                                	
									$updata = array(
	                                    'products' => ($item->products > 0 ? $item->products - 1 : 0), 
	                                    'raw_materials' => ($item->products == 0 ? ($item->raw_materials - 1 >= 0 ? $item->raw_materials - 1 : 0) : $item->raw_materials) , 
	                                    'start_time' => ($item->products >= self::MAX_PRODUCTS ? $this->timestamp : ($item->products >0 && $item->products < self::MAX_PRODUCTS ? $item->start_time : $item->start_time + $collect_in))
									);
									$map->updateMapItem($this->uid, $queue->data->x, $queue->data->y, $updata);
									$this->debugMsg($map->getLastQuery());
                                } else {
                                    // TODO
                                    $complete = $this->num_complete_raw_materials(unserialize($item->raw_materials), $item->id);
                                    if($complete > 0){
                                    	$updata = $this->checkMultiProducts($item);// 先做一次检查
                                    	if($update) {
                                    		$item->start_time = isset($update['start_time']) ? $update['start_time'] : 0;
                                    		$item->products = isset($update['products']) ? $update['products'] : 0;
                                    		$item->raw_materials = isset($update['raw_materials']) ? $update['raw_materials'] : 0;
                                    	}
                                    }
                                    $item->raw_materials = unserialize($item->raw_materials) ? unserialize($item->raw_materials) : array();
                                    $item->products = unserialize($item->products) ? unserialize($item->products) : array();
                                                                                        
                                    if(count($item->products) < 1) break;
                                    $product = array_pop($item->products);
                                    $updata = array(
                                        'products' => array_shift($item->products), 
                                        'start_time' => (count($item->products) >= self::MAX_PRODUCTS ? $this->timestamp : (count($item->products) > 0 && count($item->products) < self::MAX_PRODUCTS ? $item->start_time : $item->start_time + $collect_in))
                                    );
                                    $map->updateMapItem($this->uid, $queue->data->x, $queue->data->y, $updata);
                                    $this->debugMsg($map->getLastQuery());
                                    
                                    $storage = new StorageModel();
                                    $storage->addItemNumByUidAndItemid($this->uid, $product, 1);
                                    unset($storage);
                                }
                                // 自动收获扣OP
                                if($item->automatic) {
                                	$user = new UserModel();
                                	$user->increaseUserData($this->uid, array('op' => -1));
                                	$this->debugMsg($user->getLastQuery());
                                	unset($user);
                                }
								unset($map, $item);
							}
							if(isset($storeData->type) && $storeData->type == "trees") { 
								$map = new MapModel();
								$map->updateMapItem($this->uid, $queue->data->x, $queue->data->y, array('start_time' => $this->timestamp));
								$this->debugMsg($map->getLastQuery());
								unset($map);
								$objects_to_update[$queue->data->unique_id] = array(
                                    'unique_id' => $queue->data->unique_id,
                                    'start_time' => $this->timestamp
								);
							}
							
							if(!(isset($storeData->type) && $storeData->type == 'seeds')) break; 
							
							
							//清空地块
							$map = new MapModel();
							$setdata = array(
                                'itemid' => 1,
                                'pollinated' => 0,
                                'start_time' => 0
							);
							$map->updateMapItem($this->uid, $queue->data->x, $queue->data->y, $setdata);
							$this->debugMsg($map->getLastQuery());
							unset($map);
							break;

					    // 卖出产品
						case 'sell_storage_item':
							// id:产品ID, qty:数量, data_hash
							//更新用户数据
							$storage = new StorageModel();
                            $userData = $storage->getUserStoragesByUid($this->uid);
                            $this->debugMsg($userData);
                            if(!isset($userData[$queue->data->id]))
                                break;
							$queue->data->qty = $queue->data->qty <= $userData[$queue->data->id] ? $queue->data->qty : $userData[$queue->data->id]; 
							$store = new StoreModel($this->lang);
						    $item = $store->getStoreById($queue->data->id);
							$updata = array('coins' => $item->sell_for * $queue->data->qty);
							$user = new UserModel();
							$user->increaseUserData($this->uid, $updata);
							unset($store, $user);
                            // 计算剩余数量
							$num = $userData[$queue->data->id] - $queue->data->qty;
							$storage->updateItemNumByUidAndItemid($this->uid, $queue->data->id, $num);
							unset($storage);
							break;

						// 卖出全部产品
						case 'sell_all_storage':
							// id:产品ID, qty:数量, data_hash
							// 获得仓库数据
							$storage = new StorageModel();
							$products = $storage->getUserStoragesByUid($this->uid);
							$this->debugMsg($storage->getLastQuery());
							if(!$products) break;
							
							//更新用户数据
							$store = new StoreModel($this->lang);
							$items = $store->getStoresByIds(array_keys($products));
							$updata = array('coins' => 0, 'experience' => 0 );
							foreach ($items as $item) {
								if( isset($item->sell_for) && $item->sell_for) {
									$updata['coins'] += $item->sell_for * $products[$item->id];
								}
							}
							unset($item, $items);
							$user = new UserModel();
							$user->increaseUserData($this->uid, $updata);
							$this->debugMsg($user->getLastQuery());
							unset($store, $user);

							// 清空用户仓库
							$storage->updateStorageByUid($this->uid, array('num' => 0));
							$this->debugMsg($storage->getLastQuery());
							unset($storage);
							break;

						// 添加动物
						case 'add_animal':
							// id:物品ID, x, y, is_gift, data_hash
							$map = new MapModel();							
							//获得动物个数
							$mapItem = $map->getMapItem($this->uid, $queue->data->x, $queue->data->y); 		
							$animal_num = isset($mapItem->animals) ? $mapItem->animals : 0;
							unset($mapItem,$map);
							

							// 获取添加的动物的信息（价格/经验值/最大动物数）
							$store = new StoreModel($this->lang);
							$item = $store->getStoreById($queue->data->id);
							$max_animals = isset($item->max_animals) ? $item->max_animals : 0;
                            
							if(!(isset($item->animal) && $item->animal > 0)) break;
							
							// 先判断数量   
							if($max_animals <= $animal_num) break;
							
							// 再判断是否礼物
							if($queue->data->is_gift){ //是礼物调用礼物接口
								$gift = new GiftsModel();
								$gift_info = $gift->getGiftByItemId($this->uid, $item->animal);
								$gift->receiveGift($gift_info->id);
								$this->debugMsg($gift->getLastQuery());
							} else {
								// 获得动物信息
								$animal = $store->getStoreById($item->animal);
	                            $exp = isset($animal->exp) ? $animal->exp : 0;
	                            $price = isset($animal->price) ? $animal->price : 0;
								
								// 不是礼物再判断钱									
								$user = new UserModel();
	                            if(! $user->checkUserDataEnough($this->uid, array('coins' => $price))) {
	                            	unset($user);
	                            	break;
	                            }
	                            //添加动物，Animal num 加1
                                $map = new MapModel();
								$map->addAnimals($this->uid, $queue->data->x, $queue->data->y, 1); ;
								$this->debugMsg($map->getLastQuery());
								unset($map);
								// 更新用户信息
								$user->increaseUserData($this->uid, array('experience' => $exp, 'coins' => (0 - $price)));
							}
							$this->debugMsg($user->getLastQuery());
							break;

					    // 喂养动物
						case 'feed_object':
							// id 动物ID, unique_id, x, y
							$userIncrease = array();
							$map = new MapModel();
							$mapData = $map->getMapItem($this->uid, $queue->data->x, $queue->data->y);
							if($mapData->raw_materials >= self::MAX_PRODUCTS)
                                break;
							$map->addMaterials($this->uid, $queue->data->x, $queue->data->y);

							// 如果是第一次喂养，更新start_time
							$item = $map->getMapItem($this->uid, $queue->data->x, $queue->data->y);
							if($item->start_time == 0) {
								$map->updateMapItem($this->uid, $queue->data->x, $queue->data->y, array('start_time' => $this->timestamp));
								$objects_to_update[$queue->data->unique_id] = array(
	                                'unique_id' => $queue->data->unique_id,
	                                'start_time' => $this->timestamp
								);
							}
							$this->debugMsg($map->getLastQuery());
							// 自动收获扣OP
							if($item->automatic) {
								$userIncrease['op'] = -1;
							}
							unset($map, $item);

							// 更新用户仓库
							$store = new StoreModel($this->lang);
							$item = $store->getStoreById($queue->data->id);
							$material = $item->raw_material;
							$foodItem = $store->getStoreById($material);
							$raw_material = isset($item->raw_material) ? $item->raw_material : 0;
							// add user exp by item's raw_material's exp
							$userIncrease['experience'] = isset($foodItem->exp) ? $foodItem->exp : 0;
							unset($store, $item);

							$storage = new StorageModel();
							$storage->addItemNumByUidAndItemid($this->uid, $raw_material, -1);
							unset($storage);

							// 更新用户信息 exp
							$user = new UserModel();
							$user->increaseUserData($this->uid, $userIncrease);
							unset($user);
							break;
							
                        // 为 GEAR添加原材料
                        case 'refill_object':// 这是refill里的逻辑,注意返回的数据的格式
                            //id 产品id, raw_material 原料ID, unique_id, x, y 
                            // 添加原料 更新开始时间  更新仓库 更新用户信息
                            $store = new StoreModel($this->lang);
                            $storeData = $store->getStoreById($queue->data->id);
                            if(!$storeData->is_multi || !is_array($storeData->raw_material)) // 这个原料应该在第几个索引上,需要判断
                                break;
                            $map = new MapModel();
                            $mapData = $map->getMapItem($this->uid, $queue->data->x, $queue->data->y);
                            $raw_materials = unserialize($mapData->raw_materials) ? unserialize($mapData->raw_materials) : array();
                            // 先做一次检查,如果完成可以生产产物,算出生产的时间
                            $complete = $this->num_complete_raw_materials($raw_materials, $mapData->id);
                            if($complete > 0){
                                $this->checkMultiProducts($mapData);// 先做一次检查 
                            }
                            foreach ($storeData->raw_material as $key => $val) {
                            	$raw_materials[$key] = isset($raw_materials[$key]) ? $raw_materials[$key] : array();

                            	if( count($raw_materials[$key]) >= self::MAX_PRODUCTS ) continue; //原料数不能大于 MAX_PRODUCTS

                            	if( (is_array($val) && in_array($queue->data->raw_material, $val))   ) {
                            		array_push($raw_materials[$key],$queue->data->raw_material);
                            	}
                            	elseif((is_numeric($val) && $val == $queue->data->raw_material) ) {
                            		array_push($raw_materials[$key],$queue->data->raw_material);
                            	}
                            }
                            // 添加后的原料,再进行计算是否有产物,如果有产物,则计算开始时间,如果当前时间存在 ,那么就说明是正在继续生产 
                            // 计算产物
                            $num = $this->num_complete_raw_materials($raw_materials, $mapData->id);
                           
                            //MAX判断应该放在 添加原料之后，并且 以 大于> 为准，加完之后大于 MAX_PRODUCTS 为超出
                            if( $num > self::MAX_PRODUCTS ) break; //update by dabin 0920
                            $mapUpdata = array('raw_materials' => serialize($raw_materials));
                            if(isset($mapData->start_time) && $mapData->start_time > 0){// 逻辑还是有点问题
                                $this->checkMultiProducts($mapData);
                                $this->debugMsg('has start_time');
                            }else {
                                if($num > 0){
                                    $mapUpdata['start_time'] = $mapData->start_time + $num * $storeData->collect_in;
                                }
                            }
                            
                            $map->updateMapItem($this->uid, $queue->data->x, $queue->data->y, $mapUpdata);
                            $this->debugMsg($map->getLastQuery());
                            //更新仓库
                            $storage = new StorageModel();
                            $storage->addItemNumByUidAndItemid($this->uid, $queue->data->raw_material, -1);
                            unset($storage);
                            
                            // 更新用户信息
                            $material = $store->getStoreById($queue->data->raw_material);
                            $userIncrease['experience'] = isset($material->exp) ? $material->exp : 0;
                            $user = new UserModel();
                            $user->increaseUserData($this->uid, $userIncrease);
                            unset($user);                            
                            break;
                            
					    // 给好友浇地 更新用户经验和金币，更新邻居的信息 “已浇地”
						case 'water_plants':
							// id = 1056248390 邻居的uid
							$neighbor = new NeighborsModel();
							$data = $neighbor->getNeighborByUidAndNuid($this->uid, $queue->data->id);
							$last_help_time = $data ? $data->last_help_time : $this->timestamp;
							if($this->timestamp - $last_help_time >= self::HELP_TIME) {
								$neighbor->updateNeighbour($this->uid, $queue->data->id, array('last_help_time' => $this->timestamp));
								$user = new UserModel();
                                $user->increaseUserData($this->uid, array('coins' => self::HELP_COINS, 'experience' => self::HELP_XP));
                                unset($user);
							}
							unset($neighbor);
							break;

						case 'pollinate':
							// id , plant_id, plant_x, plant_y, x, y 后两个为蜜蜂的坐标，用来更新饲料数
							$map = new MapModel();
							$item = $map->getMapItem($this->uid, $queue->data->plant_x, $queue->data->plant_y);
							//pollinate 的方法里先验证传递的几个值是否在数据库里,然后再去进行数据计算
							if($item) {
								$map->updateMapItem($this->uid, $queue->data->plant_x, $queue->data->plant_y, array('pollinated' => 1));
								$this->debugMsg($map->getLastQuery());
								$updata = array('raw_materials' => 1);
								// 如果是第一次采蜜，更新start_time
								if($item->start_time == 0) {
									$updata['start_time'] = $this->timestamp;
								}
								$this->debugMsg($map->getLastQuery());
								$map->increaseMapItem($this->uid, $queue->data->x, $queue->data->y, $updata);
								$this->debugMsg($map->getLastQuery());
							}
							unset($map);
							break;

						case 'toggle_automation':
							// id, x, y 后两个为蜜蜂的坐标，用来更新饲料数
							$map = new MapModel();
							$item = $map->getMapItem($this->uid, $queue->data->x, $queue->data->y);
							$automatic = $item->automatic ? 0 : 1;
							$map->updateMapItem($this->uid, $queue->data->x, $queue->data->y, array('automatic' => $automatic));
							$this->debugMsg($map->getLastQuery());
							unset($map, $item);
							break;

							// 批量种植  要扣op的
						case 'plant_seeds':
							$store = new StoreModel($this->lang);
							$item = $store->getStoreById($queue->data->seed);
							$exp = isset($item->exp) ? $item->exp : 0;
							$price = isset($item->price) ? $item->exp : 0;
							unset($item);

							$map = new MapModel();
							$map->batchUpdateMapItem($this->uid, $queue->data->seed, $queue->data->soil, $this->timestamp);
							$this->debugMsg($map->getLastQuery());
							unset($map);

							// 更新用户信息
							$num = count($queue->data->soil);
							$user = new UserModel();
							$user->increaseUserData($this->uid, array('experience' => $exp * $num, 'coins' => (0 - $price) * $num, 'op' => ( 0 - $num)));
							$this->debugMsg($user->getLastQuery());
							break;

							// 批量收获  要扣op的
						case 'harvest_plants':
							// 按产品规整
							$itemids = $coords = array();
							foreach ($queue->data->plants as $plant) {
								$itemids[$plant['id']] = isset($itemids[$plant['id']]) ? $itemids[$plant['id']] + 1 : 1;
								$coords[] = array(
        					       'x' => $plant['x'],
        					       'y' => $plant['y']
								);
							}
							unset($queue->data->plants, $plant);

							foreach ($itemid as $itemid => $count){
								// 收货
								$store = new StoreModel($this->lang);
								$products = $store->getProductsById($queue->data->id);
								if(!$products) break;
								$storage = new StorageModel();
								foreach ($products as $product) {
									$storage->addItemNumByUidAndItemid($this->uid, $product->id, $count);
								}
								unset($storage);
							}

							//清空地块
							$map = new MapModel();
							$map->batchUpdateMapItem($this->uid, 1, $coords);
							$this->debugMsg($map->getLastQuery());
							unset($map);
							// 更新用户
							$num = count($coords);
							$user = new UserModel();
							$user->increaseUserData($this->uid, array('op' => ( 0 - $num)));
							$this->debugMsg($user->getLastQuery());
							break;

						case 'spend_rp':
							// id
							$store = new StoreModel($this->lang);
							$item = $store->getStoreById($queue->data->id);
							$userIncrease = array();
							switch ($item->type) {
								case 'special_events':
									switch ($item->action){
										case "rain":
											// 缩短所有种子和树的成熟时间  collect_in * $item->percent
											$this->useSpendRain($item->percent);
											break;
									}
									break;

								case 'expand_ranch':
									$updata = array();
									switch ($item->action){
										case "expand":
											$updata = array(
	                                            'size_x' => $item->size,         	  
	                                            'size_y' => $item->size,         	  
											);
											break;
										case "expand_top_map":
											$updata = array(
	                                            'top_map_size' => $item->size,              
											);
											break;
										case "expand_bottom_map":
											$updata = array(
	                                            'bottom_map_size' => $item->size,              
											);
											break;
									}
									$user = new UserModel();
									$user->updateUser($this->uid, $updata);
									$this->debugMsg($user->getLastQuery());
									break;

								case 'automation':
									// TODO
									$userIncrease['op'] = $item->op;
									break;
							}
							if ($item->action == 'construction'){
								//        						$map = new MapModel();
								//        						//$map->increaseMapItem($this->uid, $queue->data->x, $queue->data->y, $setdata);
								//        						unset($map);
							}
							$userIncrease['reward_points'] = (0 - $item->rp_price);

							// 更新用户信息 rp
							$user = new UserModel();
							$user->increaseUserData($this->uid, $userIncrease);
							unset($user);
							break;

						// 施肥	减少作物的成熟等待时间，同时增加肥料使用的次数，若使用次数达到总次数则删除改肥料
						case 'fertilize':
							// data_hash, id, x, y, plant_id, plant_x, plant_y  肥料所在地块/植物
							$store = new StoreModel($this->lang);
							$items = $store->getStoresByIds(array($queue->data->id, $queue->data->plant_id));
							foreach ($items as $item) {
								if($item->id == $queue->data->id) {
									$percent = $item->percent;
									$uses = $item->uses;
								}
								if($item->id == $queue->data->plant_id)
								$collect_in = $item->collect_in;
							}
							unset($items, $item);
							// 缩短所有种子和树的成熟时间  collect_in * $item->percent
							$map = new MapModel();
							$map->increaseMapItem($this->uid, $queue->data->plant_x, $queue->data->plant_y, array('start_time' => 0 - $percent * $collect_in));
							$this->debugMsg($map->getLastQuery());
							
							$item = $map->getMapItem($this->uid, $queue->data->x, $queue->data->y);
							if($uses - $item->times_used > 1)
                                $map->increaseMapItem($this->uid, $queue->data->x, $queue->data->y, array('times_used' => 1));
							else
                                $map->removeObject($this->uid, $queue->data->x, $queue->data->y);
							$this->debugMsg($map->getLastQuery());
							unset($map);
							break;
							
						//兑换礼物
						case 'trade_item':
							$gift_id = $queue->data->id;
							$gift = new GiftsModel();
							$gift_info = $gift->getGiftByItemId($this->uid,$gift_id);

							if($gift_info && $gift_info->touid == $this->uid){
								$store = new StoreModel($this->lang);
								$item = $store->getStoreById($gift_info->itemid);
								if($item->trade_for > 0){
									$this->debugMsg('traded');
									$user = new UserModel();
									$user->increaseUserData($this->uid, array('op' => $item->trade_for));
									$gift->receiveGift($gift_info->id);
								}
							}
							break;
							
				        // 物品旋转的功能
						case 'flip_object':
							$item = $map->getMapItemByItemId($this->uid,$queue->data->id, $queue->data->grid_x, $queue->data->grid_y);
							$updata = array();
							$flipped = isset($item->flipped) ? $item->flipped : 0;
							if($flipped) {
								$flipped = 0;
							} else {
								$flipped = 1;
							}
							$updata = array(
	                            'flipped' => flipped
							);
							$map->updateMapItem($this->uid, $queue->data->x, $queue->data->y, $updata);
							$this->debugMsg($map->getLastQuery());	
							break;
							
						case 'use_gift':
							$item_id = $queue->data->id;
							$store = new StoreModel($this->lang);
							$item = $store->getStoreById($item_id);
							$gift = new GiftsModel();
							$gift_info = $gift->getGiftByItemId($this->uid,$item_id);
							if($item->type == 'automation'){
								if($item->op){
									$user = new UserModel();
									$user->increaseUserData($this->uid, array('op' => $item->op));
								}
							} elseif($item->type == 'products') {
								$storage = new StorageModel();
								$storage->addItemNumByUidAndItemid($this->uid, $item_id, 1);
								$this->debugMsg($storage->getLastQuery());
							} 
							if(isset($item->action) &&  $item->action == 'rain') {
								$this->useSpendRain($item->percent);
							}
							$gift->receiveGift($gift_info->id);
							//TODO 其他类型待处理
							break;
					}
				}
				break;
		}
		//判断是否升级
		$level = $userinfo->level;
		$upgrade_info = $this->checkUserLevel($userinfo);
		/*
		 * 如果升级，组织一个对象输出 level_up.coins,level_up.rp
		 */
		if( $upgrade_info->level!= $level ) {
			$userinfo = $upgrade_info;
			$level_up = (Object)array(
	        	   'coins'  => self::UPGRADE_ADD_COIN,
	        	   'rp'  => self::UPGRADE_ADD_CASH,
			);
			$ret->level_up = $level_up;
		}
		//update by dabin 20100904
		
		$ret->objects_to_update = array_values($objects_to_update);
		if($this->debug) $ret->demsg = $this->demsg;
		return $ret;
	}
	
	
	/**
	 * 礼物
	 *
	 * @param $channel
	 */
	private function purchaseGift($channel = 'purchase_gift')
	{
		$this->debugMsg("purchase_gift");
		$neighbor = (string) $this->input->neighbor;
		$gift_id = (string) $this->input->gift;
		$user = new UserModel();
		if($channel == 'purchase_gift'){
			$this->debugMsg("purchase_gift->purchase_gift");
			$store = new StoreModel($this->lang);
			$item = $store->getStoreById($gift_id);
			$buy_gift  = isset($item->buy_gift) ? $item->buy_gift : 0;
			$price = isset($item->price) ? $item->price : 0;
			$rp_price = isset($item->rp_price) ? $item->rp_price : 0;
			
			$gift = new GiftsModel();
			$gift_item = array('uid'=>$this->uid, 'touid'=>$neighbor, 'itemid'=>$gift_id);
			
			if($buy_gift){
				$this->debugMsg("buy_gift");
				if($rp_price){
					$this->debugMsg("rp_price->".$rp_price);
					$user->increaseUserData($this->uid, array('reward_points' => (0 - $rp_price)));
					$gift->add($gift_item);
				} elseif($price) {
					$this->debugMsg("price->".$price);
					$user->increaseUserData($this->uid, array('coins' => (0 - $price)));
					$gift->add($gift_item);
				}
			}
		}
		
		$ret = new stdClass();
		$ret->channel = trim($channel);
		$ret->state = 'ok';
		return $ret;
	}
	

	/**
	 * 加载好友农场
	 *
	 * @param $channel
	 */
	private function loadFarm($channel = 'load_farm')
	{
		// 好友ID
		$uid = (string) $this->input->id;

		$ret = new stdClass();
		$ret->channel = trim($channel);
		$ret->state = 'ok';
		$ret->farm = new stdClass();
		$ret->farm->map = $this->getUserMaps($uid);

		
		// 获得邻居个人资料
		$user = new UserModel();
		$info = $user->getUserById($uid);
		$ret->farm->size_x = isset($info->size_x) ? $info->size_x : 0;
		$ret->farm->size_y = isset($info->size_y) ? $info->size_y : 0;
		$ret->farm->top_map_size = isset($info->top_map_size) ? $info->top_map_size : 0;
		unset($user, $info);

		$ret->farm->uid = $uid;
		$ret->farm->helped = true;
		$ret->farm->has_app = true;
		$ret->farm->help_xp = self::HELP_XP;
		$ret->farm->help_coins = self::HELP_COINS;
		// 判断今天是否浇过地
		if($uid != $this->uid) {
			$neighbor = new NeighborsModel();
			$data = $neighbor->getNeighborByUidAndNuid($this->uid, $uid);
			if($data) {
				$this->debugMsg($neighbor->getLastQuery());
				if($this->timestamp - $data->last_help_time >= self::HELP_TIME) {
					$ret->farm->helped = false;
				}
				unset($neighbor);
			}
		}

		if($this->debug) $ret->demsg = $this->demsg;
		return $ret;
	}

	/**
	 * 获得用户地图
	 * @param $uid
	 */
	public function getUserMaps($uid)
	{
		$map = new MapModel();
		$maps = $map->getUserMapsByUid($uid);
		$this->debugMsg($map->getLastQuery());
		if(!$maps) return array();
		foreach ($maps as & $map) {
			// TODO
			if($map->is_multi) {
				$update = $this->checkMultiProducts($map);
				$this->debugMsg($update);
				if($update) {
					$map->start_time = isset($update['start_time']) ? $update['start_time'] : 0;
					$map->products = isset($update['products']) ? $update['products'] : 0;
					$map->raw_materials = isset($update['raw_materials']) ? $update['raw_materials'] : 0;
				}
				$map->raw_materials = unserialize($map->raw_materials) ? unserialize($map->raw_materials) : array();
				$map->products = unserialize($map->products) ? unserialize($map->products) : array();
			} else {
				$update = $this->checkHarvestItem($map);
				if($update) {
					$map->start_time = isset($update['start_time']) ? $update['start_time'] : 0;
					$map->products += isset($update['products']) ? $update['products'] : 0;
					$map->raw_materials += isset($update['raw_materials']) ? $update['raw_materials'] : 0;
				}
			}
			if($map->start_time == 0) unset($map->start_time);
			if($map->flipped == 0) unset($map->flipped);
			if($map->animals == 0) unset($map->animals);
			if($map->products == 0) unset($map->products);
			if($map->raw_materials == 0) unset($map->raw_materials);
			if($map->pollinated == 0) unset($map->pollinated);
			if($map->automatic == 0) unset($map->automatic);
			if($map->times_used == 0) unset($map->times_used);
			if($map->is_multi == 0) unset($map->is_multi);
		}
		return $maps;
	}

	/**
	 * 初始化用户地块信息
	 */
	public function initUserMapData()
	{
		$initMap = array();
		$initMap = (Array)Ko::config('initmap');
		
		if(empty($initMap)) return;
		$map = new MapModel();
		// 使用AS脚本里生成的代码,放到initmap类里,然后判断是否有start_time,
		foreach ($initMap as $key => $value) {
			//@todo 临时加入start_time
			$model = new StoreModel($this->lang);
			if(isset($initMap[$key]['start_time']) ){// 如果有start_time的话,那么就是作物,计算一下成熟的时间即可
				$item_id = $initMap[$key]['id'];
				$item = $model->getStoreById($item_id);
				if($item && isset($item->collect_in)) {
					$initMap[$key]['start_time'] = $this->timestamp - $item->collect_in;
				}
			}
		}

		foreach ($initMap as $map_item) {
			$map->add(array(
                'uid'       =>  $this->uid,
                'itemid'    =>  isset($map_item['id']) ? $map_item['id'] : 0,
                'map_x'     =>  isset($map_item['x']) ? $map_item['x'] : 0,
                'map_y'     =>  isset($map_item['y']) ? $map_item['y'] : 0,
                'flipped'   =>  isset($map_item['flipped']) ?  $map_item['flipped'] : 0, //反向的参数// 默认的参数不用处理
			    'products'     =>  isset($map_item['products']) ? $map_item['products'] : 0,
                'start_time'    => isset($map_item['start_time']) ? $map_item['start_time'] : 0,
			    'times_used'    => isset($map_item['times_used']) ? $map_item['times_used'] : 0,  
			));
		}
		
		//输出转对象数组
	    foreach ($initMap as $key => $value) {
			$initMap[$key] = (Object)$value;
	    }
		return $initMap;
	}

	/**
	 * 检查地块上物品是否成熟（比如鸡蛋、牛奶等）
	 * @param $uid
	 * @param $data Map record
	 */
	private function checkHarvestItem($data)
	{
		if(!$data || !$data->raw_materials) {
			return;
		}
		$store = new StoreModel($this->lang);
		$item = $store->getStoreById($data->id);
		if(!$item || !isset($item->collect_in) || !$item->collect_in)
            return;
		$collect_in = $item->collect_in / ( $data->animals ? $data->animals : 1);
		$num = min(self::MAX_PRODUCTS - $data->products, min($data->raw_materials, floor(($this->timestamp - $data->start_time) / $collect_in)));
		$this->debugMsg('New Products: ' . $num);
		if ($num <= 0) return;

		// 没有饲料了 或者 存储位已满 开始时间为 0
		if($data->raw_materials == $num || $num + $data->products >= self::MAX_PRODUCTS) {
			$updata = array('products' => $num, 'raw_materials' => (0 - $num), 'start_time' => (0 - $data->start_time));
		}
		// 否则 开始时间为增加已用时间
		else {
			$updata = array('products' => $num, 'raw_materials' => (0 - $num), 'start_time' => $num * $collect_in);
		}

		// 更新地图
		$map = new MapModel();
		$ret = $map->increaseMapItem($this->uid, $data->x, $data->y, $updata);
		$this->debugMsg($map->getLastQuery());
		return $ret;
	}


	/**
	 * 获得物品的卖出价格
	 */
	private function getMapItemSellPrice($map_x, $map_y)
	{
		$map = new MapModel();
		$item = $map->getMapItem($this->uid, $map_x, $map_y);
		if(!$item) return 0;
		$store = new StoreModel($this->lang);
		$storeData = $store->getStoreById($item->id);
		if(!$storeData) return 0;

		if( isset($storeData->sell_price) ){
			$price = $storeData->sell_price;
		} else 
		    $price = 0;
		    
		if( isset($storeData->need_animals) ) {
			$animal = $store->getStoreById($storeData->animal);
			$price = $storeData->sell_price + ($animal->sell_price * $item->animals);
		}
		return $price;
	}

	/**
	 * 检查用户是否升级
	 * 升级时加150金币coins 1个购买的币reward_points
	 * @param $userinfo 
	 */
	private function checkUserLevel($userinfo)
	{
		if(!$userinfo) return ;
		
		$level = $userinfo->level;
		$experience = $userinfo->experience;
		$model = new LevelModel();
		$new_level = $model->getLevelByExp($experience);
		if($new_level != $level) {
			$coins = $userinfo->coins + self::UPGRADE_ADD_COIN;
			$reward_points = $userinfo->reward_points + self::UPGRADE_ADD_CASH;
			
			$user = new UserModel();
			$user->updateUser($this->uid, array('level' => $new_level,'coins' => $coins,'reward_points' => $reward_points));

			$userinfo->level = $new_level;
			$userinfo->coins = $coins;
			$userinfo->reward_points = $reward_points;
			unset($user);
		}
		return $userinfo;
	}

	/**
	 * 使用下雨工具
	 * 
	 * 获取所有植物 ，得到未成熟的植物品种（ID）,批量更新
	 */
	private function useSpendRain($percent)
	{
		$map = new MapModel();
		$plants = $map->getUserPlantsByUid($this->uid);
		$updata = array();
		foreach ($plants as $plant) {
			if($this->timestamp - $plant->start_time >= $plant->collect_in) 
                continue;
			$updata[$plant->itemid] = $plant->collect_in * $percent;
		}
		$this->debugMsg($updata);
		if(!$updata) return;
		foreach ($updata as $itemid => $increase) {
            $map->increaseMapItemByUidAndItemid($this->uid, $itemid, array('start_time' => (0 - $increase)));
            $this->debugMsg($map->getLastQuery());
		} 
		return array_keys($updata);
	}
	
	/**
	 * 同步平台的好友到邻居
	 * @param $fids
	 * @param $register 是否新注册用户
	 */
	private function syncUserNeighbors($fids, $register = false)
	{
		$neighbor = new NeighborsModel();
		$platNuids = $fids ? explode(",", $fids) : array();
        if($register == false) {
            $myNuids = $neighbor->getAllNeighborIdByUid($this->uid);
            $nuidAdd = array_diff($platNuids, $myNuids);
            $nuidRemove = array_diff($myNuids, $platNuids);
            $neighbor->batchRemoveNeighbours($this->uid, $nuidRemove);            
		} else {
			$nuidAdd = $platNuids;
		}
		$neighbor->batchAddNeighbours($this->uid, $nuidAdd);
        
		return $platNuids;
	}

	/**
     * 初始化和收获,已经refill都要调用这个方法来验证
     * @param $item 数据库里的具体对象
     */
    function checkMultiProducts($item)
    {
        if(!$item)return;
        if(isset($item->start_time) && $item->start_time > 0){// 这样才可以产出物品,如果没有这个值说明现在没有正在产出东西
            $prodcuts = $this->num_complete_raw_materials(unserialize($item->raw_materials),$item->id);
            $dbProducts = unserialize($item->products) ? unserialize($item->products) : array();
            $storeModel = new StoreModel($this->lang);
            $storeItem = $storeModel->getStoreById($item->id);// storeItem里的信息
            $collect_in = $storeItem->collect_in;// 收获的时间
            $num = min(self::MAX_PRODUCTS - count($dbProducts), min($prodcuts, floor((time() - $item->start_time) / $collect_in)));
            $decreaseMaterials = null;
            $this->debugMsg("this can product $num");
            if($num <= 0) {// 能生产出来的最大的数量
                $num = 0;
            }else {
                $decreaseMaterials = $this->decreaseMaterials($item,$num);
            }
            $item->start_time += $num * $collect_in;
            $nowProducts = $this->num_complete_raw_materials($item->raw_materials,$item->id);
            if(count($dbProducts) == self::MAX_PRODUCTS) {//$nowProducts == 0 || 
                $item->start_time = 0;// 不能再生产了,如果当前已经是产到最大了,那么就不能再生产了,
                                        //当收获之后去验证这个,这样就可以生产了
                $this->debugMsg('不能再继续生产了');
            }
            $this->debugMsg("执行中..$item->start_time");
            $change = array('start_time' => $item->start_time);
            if($decreaseMaterials){
                $updata = array_merge($decreaseMaterials,$change);
                $map = new MapModel();
                $map->updateMapItem($this->uid, $item->x, $item->y, $updata);// 这个不知道是不是更新到数据库里了
                return $updata;
            }
        }
        return;
    }
    
    /**
     * 减少原料,增加产物
     * @param Object $item 数据库里的对象
     * @param int $length 代表的产物是几个,如果是1个,
     *                      就删除1次,如果是2个就删除2次
     * @param boolean $harvestabled 是否是收获
     *                  如果是收获的话,那返回的数据不一样
     * 这个方法还得调整一下
     */
    function decreaseMaterials($item,$length = 1,$harvestabled = false)
    {
        $storeModel = new StoreModel($this->lang);
        $storeItem = $storeModel->getStoreById($item->id);
        $dbProducts = array();
        $raw_materials = array();
        for($k = 0; $k < $length; $k++) {
            for($i = 0; $i < count($storeItem->raw_material); $i++){// 这里可能会出异常
                $raw_materials = unserialize($item->raw_materials) ? unserialize($item->raw_materials) : array();
                if(isset($raw_materials[$i])){// 可能为空的
                    $id = array_shift($raw_materials[$i]);
                    $this->debugMsg("已经删除id : $id");
                    if(!$harvestabled) {// 如果是收获的话,那数据就不应该添加了,应该是减少了
                        if($i == 0){
                            $dbProducts = unserialize($item->products) ? unserialize($item->products) : array();
                            $raw_material = $storeItem->raw_material;
                            for($j = 0; $j < count($raw_material[0]); $j++){// $raw_material[0] 为产物的列表
                            	if($id == $raw_material[0][$j]){// 获取产物
                            		$this->debugMsg("已经把" . $id . "加入到products里了");
                            		$storeProduct = $storeItem->product;
                            		$product = $storeProduct[$j];
                                    array_push($dbProducts, $product);
                            		break;
                            	}
                            }
                        }
                    }
                }
            }
        }
        if($harvestabled){
            $updateMapData = array('raw_materials' => serialize($raw_materials),'product' => $id);
        }else {
            $updateMapData = array('raw_materials' => serialize($raw_materials),'products' => serialize($dbProducts));
        }
        return $updateMapData;
    }
    
    /**
     * 获取可以生产多少个产物products
     * 
     * @param $raw_materials Map数据库里存的已添加的原料信息
     * @param $id 当前的物品
     */
    private function num_complete_raw_materials($raw_materials, $itemId) 
    {
        if(!$raw_materials || !isset($itemId))return 0;
        $length  = 100; // 这个值是定值,如果没有变化的话,说明没有产物的
        $storeModel = new StoreModel($this->lang);
        $storeItem = $storeModel->getStoreById($itemId);
        $raw_material = $storeItem->raw_material;// store 里的信息// 先取出来
        $raw_materials = $raw_materials ? $raw_materials : array();// 数据库里存的信息
        for($i = 0; $i < count($raw_material); $i++){
        	if(!isset($raw_materials[$i]) || !is_array($raw_materials[$i])){
        		return 0;
        	}
        	if($length > count($raw_materials[$i])){
        		$length = count($raw_materials[$i]);
        	}
        }
        if($length == 100){
            return 0;
        }
        return $length;
    }
    
	/**
	 * 记录调试信息
	 * @param $msg
	 */
	protected function debugMsg($msg = '')
	{
		if($this->debug == false) 
            return;
            
        if(!is_string($msg))
            $msg = var_export($msg, true);

        $this->demsg[] = $msg;
            return;
	}
	
} //End class
