package com.wangziyang.mes.technology.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.wangziyang.mes.technology.entity.SpComponentDef;

import java.util.List;

/**
 * Component definition service.
 */
public interface ISpComponentDefService extends IService<SpComponentDef> {

    String nextComponentCode();

    boolean isComponentCodeDuplicate(String componentCode, String excludeId);

    boolean isComponentNameDuplicate(String productName, String componentName, String excludeId);

    List<SpComponentDef> listEnabledByProductName(String productName);

    List<SpComponentDef> listEnabledByProductName(String productName, String componentType);

    boolean hasEnabledComponents(String productName);

    boolean isEnabledForProduct(String productName, String componentCode, String componentName);
}
