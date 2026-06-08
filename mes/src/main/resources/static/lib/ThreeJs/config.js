/**
 * 模型静态常量配置 + 货架配置。
 * 货架/层数/列数原为写死的演示数据，现改为可由后端库房数据动态填充：
 * 页面加载时调用 SET_SCENE_CONFIG(layer, column, shelfList) 注入真实库房规格。
 * @author 谢宁, Created on 2020-01-07；2026-06-08 改造为数据驱动
 */
/** ***************************************************************** */

var PLANE_LENGTH = 24;  //货架板面长度
var PLANE_WIDTH = 55;   //货架板面宽度
var PLANE_HEIGHT = 2;   //货架板面高度
var HOLDER_LENGTH = 2;  //支架长度
var HOLDER_WIDTH = 2;   //支架宽度
var HOLDER_HEIGHT = 25; //支架高度
var LAYER_NUM = 1;      //货架层数（运行时由库房规格-层 注入）
var COLUMN_NUM = 1;     //货架每层列数（运行时由库房规格-列 注入）
var BOX_SIZE = 16;      //货物的大小(立方体)

//货架数组（运行时由库房 组×排 生成）
var shelf_list = new Array();

/**
 * 由后端库房数据注入场景配置
 * @param layer    库房规格-层
 * @param column   库房规格-列
 * @param shelfList 货架数组，元素形如 {StorageZoneId, shelfId, shelfName, x, y, z}
 */
function SET_SCENE_CONFIG(layer, column, shelfList) {
  LAYER_NUM = (layer && layer > 0) ? layer : 1;
  COLUMN_NUM = (column && column > 0) ? column : 1;
  shelf_list = shelfList || [];
}

function GET_PLANE_LENGTH(){
  return PLANE_LENGTH;
}

function GET_PLANE_WIDTH(){
  return PLANE_WIDTH;
}

function GET_PLANE_HEIGHT(){
  return PLANE_HEIGHT;
}

function GET_HOLDER_LENGTH(){
  return HOLDER_LENGTH;
}

function GET_HOLDER_WIDTH(){
  return HOLDER_WIDTH;
}

function GET_HOLDER_HEIGHT(){
  return HOLDER_HEIGHT;
}

function GET_LAYER_NUM(){
  return LAYER_NUM;
}

function GET_COLUMN_NUM(){
  return COLUMN_NUM;
}

function GET_BOX_SIZE(){
  return BOX_SIZE;
}

function GET_SHELF_LIST(){
  return shelf_list;
}
