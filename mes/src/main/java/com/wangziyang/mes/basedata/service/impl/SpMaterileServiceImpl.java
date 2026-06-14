package com.wangziyang.mes.basedata.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.wangziyang.mes.basedata.entity.SpMaterile;
import com.wangziyang.mes.basedata.mapper.SpMaterileMapper;
import com.wangziyang.mes.basedata.service.ISpMaterileService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

/**
 * <p>
 *  服务实现类
 * </p>
 *
 * @author WangZiYang
 * @since 2020-03-19
 */
@Service
public class SpMaterileServiceImpl extends ServiceImpl<SpMaterileMapper, SpMaterile> implements ISpMaterileService {

    private static final String PREFIX = "M";

    @Override
    public String nextMaterielCode() {
        int next = currentMaxMaterielSeq() + 1;
        String code = PREFIX + String.format("%06d", next);
        // 与已有编码（含禁用/已删除）重复则自动继续往后编号，确保唯一
        while (existsMateriel(code)) {
            next++;
            code = PREFIX + String.format("%06d", next);
        }
        return code;
    }

    /**
     * 取已有「M+6位数字」规范编码中的最大序号，无则返回 0。
     * 用 REGEXP 仅匹配规范编码（排除 MB001、MEM-1 等非规范 M 编码），保证字典序即数值序、
     * 后缀必为纯数字可安全解析，避免取到非数字后缀解析失败而退回 0、与已有编码撞号。
     */
    private int currentMaxMaterielSeq() {
        QueryWrapper<SpMaterile> qw = new QueryWrapper<>();
        qw.apply("materiel REGEXP {0}", "^" + PREFIX + "[0-9]{6}$")
                .orderByDesc("materiel").last("limit 1");
        SpMaterile last = getOne(qw, false);
        if (last != null && StringUtils.isNotEmpty(last.getMateriel())) {
            try {
                return Integer.parseInt(last.getMateriel().substring(PREFIX.length()));
            } catch (NumberFormatException ignore) {
            }
        }
        return 0;
    }

    /**
     * 编码是否已被占用（不区分删除状态，避免编号被重复使用）
     */
    private boolean existsMateriel(String materiel) {
        QueryWrapper<SpMaterile> qw = new QueryWrapper<>();
        qw.eq("materiel", materiel);
        return count(qw) > 0;
    }

    @Override
    public boolean isMaterielCodeDuplicate(String materiel, String excludeId) {
        if (StringUtils.isEmpty(materiel)) {
            return false;
        }
        QueryWrapper<SpMaterile> qw = new QueryWrapper<>();
        qw.eq("materiel", materiel);
        qw.ne("is_deleted", "1");
        if (StringUtils.isNotEmpty(excludeId)) {
            qw.ne("id", excludeId);
        }
        return count(qw) > 0;
    }
}
