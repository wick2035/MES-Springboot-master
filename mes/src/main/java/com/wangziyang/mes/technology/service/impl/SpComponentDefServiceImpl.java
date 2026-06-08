package com.wangziyang.mes.technology.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.wangziyang.mes.technology.entity.SpComponentDef;
import com.wangziyang.mes.technology.mapper.SpComponentDefMapper;
import com.wangziyang.mes.technology.service.ISpComponentDefService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Component definition service implementation.
 */
@Service
public class SpComponentDefServiceImpl extends ServiceImpl<SpComponentDefMapper, SpComponentDef>
        implements ISpComponentDefService {

    private static final String PREFIX = "BOM";

    @Override
    public String nextComponentCode() {
        QueryWrapper<SpComponentDef> qw = new QueryWrapper<>();
        qw.likeRight("component_code", PREFIX)
                .orderByDesc("component_code")
                .last("limit 1");
        SpComponentDef last = getOne(qw, false);
        int next = 1;
        if (last != null && StringUtils.isNotEmpty(last.getComponentCode())
                && last.getComponentCode().length() > PREFIX.length()) {
            try {
                next = Integer.parseInt(last.getComponentCode().substring(PREFIX.length())) + 1;
            } catch (NumberFormatException ignore) {
            }
        }
        return PREFIX + String.format("%06d", next);
    }

    @Override
    public boolean isComponentCodeDuplicate(String componentCode, String excludeId) {
        if (StringUtils.isEmpty(componentCode)) {
            return false;
        }
        QueryWrapper<SpComponentDef> qw = new QueryWrapper<>();
        qw.eq("component_code", componentCode).ne("is_deleted", "1");
        if (StringUtils.isNotEmpty(excludeId)) {
            qw.ne("id", excludeId);
        }
        return count(qw) > 0;
    }

    @Override
    public boolean isComponentNameDuplicate(String productName, String componentName, String excludeId) {
        if (StringUtils.isEmpty(productName) || StringUtils.isEmpty(componentName)) {
            return false;
        }
        QueryWrapper<SpComponentDef> qw = new QueryWrapper<>();
        qw.eq("product_name", productName)
                .eq("component_name", componentName)
                .ne("is_deleted", "1");
        if (StringUtils.isNotEmpty(excludeId)) {
            qw.ne("id", excludeId);
        }
        return count(qw) > 0;
    }

    @Override
    public List<SpComponentDef> listEnabledByProductName(String productName) {
        return listEnabledByProductName(productName, null);
    }

    @Override
    public List<SpComponentDef> listEnabledByProductName(String productName, String componentType) {
        return baseMapper.listEnabledByProductName(
                StringUtils.trimToNull(productName),
                StringUtils.trimToNull(componentType)
        );
    }

    @Override
    public boolean hasEnabledComponents(String productName) {
        if (StringUtils.isEmpty(productName)) {
            return false;
        }
        return !listEnabledByProductName(productName).isEmpty();
    }

    @Override
    public boolean isEnabledForProduct(String productName, String componentCode, String componentName) {
        if (StringUtils.isEmpty(productName)
                || (StringUtils.isEmpty(componentCode) && StringUtils.isEmpty(componentName))) {
            return false;
        }
        for (SpComponentDef def : listEnabledByProductName(productName)) {
            if (StringUtils.equals(def.getComponentCode(), componentCode)
                    || StringUtils.equals(def.getComponentName(), componentName)) {
                return true;
            }
        }
        return false;
    }
}
