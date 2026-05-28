package com.wangziyang.mes.technology.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.wangziyang.mes.common.BaseEntity;

/**
 * 工艺内容编制主表
 *
 * @author Claude
 * @since 2026-05-28
 */
@TableName(value = "sp_process_content")
public class SpProcessContent extends BaseEntity {

    private static final long serialVersionUID = 1L;

    private String routeId;
    private String contentText;
    private String requireText;
    private String needCheck;
    private String precautionText;
    private String techDocDesc;

    public String getRouteId() { return routeId; }
    public void setRouteId(String routeId) { this.routeId = routeId; }

    public String getContentText() { return contentText; }
    public void setContentText(String contentText) { this.contentText = contentText; }

    public String getRequireText() { return requireText; }
    public void setRequireText(String requireText) { this.requireText = requireText; }

    public String getNeedCheck() { return needCheck; }
    public void setNeedCheck(String needCheck) { this.needCheck = needCheck; }

    public String getPrecautionText() { return precautionText; }
    public void setPrecautionText(String precautionText) { this.precautionText = precautionText; }

    public String getTechDocDesc() { return techDocDesc; }
    public void setTechDocDesc(String techDocDesc) { this.techDocDesc = techDocDesc; }
}
