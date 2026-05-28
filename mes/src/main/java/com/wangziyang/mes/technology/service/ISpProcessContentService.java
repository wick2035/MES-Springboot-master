package com.wangziyang.mes.technology.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.wangziyang.mes.technology.entity.SpProcessContent;
import com.wangziyang.mes.technology.entity.SpProcessEquipmentRel;
import com.wangziyang.mes.technology.entity.SpProcessFile;
import com.wangziyang.mes.technology.entity.SpProcessMaterialRel;

import java.util.List;
import java.util.Map;

/**
 * 工艺内容编制服务（7步向导）
 */
public interface ISpProcessContentService extends IService<SpProcessContent> {

    /** 获取或创建工艺内容主表 */
    SpProcessContent getOrCreateByRoute(String routeId);

    /** 保存工序内容(step2) + 上传图片 */
    void saveStep2Content(String routeId, String contentText, List<Map<String, Object>> imgs);

    /** 保存工序要求(step3) */
    void saveStep3Require(String routeId, String requireText, String needCheck, List<Map<String, Object>> imgs);

    /** 保存注意事项(step4) */
    void saveStep4Precaution(String routeId, String precautionText, List<Map<String, Object>> imgs);

    /** 保存工装设备(step5) */
    void saveStep5Equipments(String routeId, List<SpProcessEquipmentRel> rels);

    /** 保存技术文档(step6) */
    void saveStep6TechDoc(String routeId, String desc, List<Map<String, Object>> imgs, List<Map<String, Object>> attachs);

    /** 保存备料清单(step7) */
    void saveStep7Materials(String routeId, List<SpProcessMaterialRel> rels);

    /** 标记工艺内容已完成 */
    void completeEdit(String routeId);

    /** 查询所有文件 */
    List<SpProcessFile> listFiles(String routeId, String fileType);

    /** 查询工装设备 */
    List<SpProcessEquipmentRel> listEquipments(String routeId);

    /** 查询备料清单 */
    List<SpProcessMaterialRel> listMaterials(String routeId);

    /** 删除单个文件 */
    void deleteFile(String fileId);
}
