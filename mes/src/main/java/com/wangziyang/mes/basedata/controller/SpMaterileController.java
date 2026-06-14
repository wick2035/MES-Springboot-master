package com.wangziyang.mes.basedata.controller;


import cn.hutool.core.util.StrUtil;
import com.alibaba.excel.EasyExcel;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.wangziyang.mes.basedata.common.entity.SpSysDict;
import com.wangziyang.mes.basedata.common.service.ISpSysDictService;
import com.wangziyang.mes.basedata.dto.SpMaterileImportDTO;
import com.wangziyang.mes.basedata.entity.SpMaterile;
import com.wangziyang.mes.basedata.request.spMaterileReq;
import com.wangziyang.mes.basedata.service.ISpMaterileService;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.technology.entity.SpFlow;
import com.wangziyang.mes.technology.service.ISpFlowService;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletResponse;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

/**
 * <p>
 * 物料控制器
 * </p>
 *
 * @author WangZiYang
 * @since 2020-03-19
 */
@Controller
@RequestMapping("/basedata/materile")
public class SpMaterileController extends BaseController {

    /**
     * 物料服务
     *
     * @date 2020-07-07
     */
    @Autowired
    private ISpMaterileService iSpMaterileService;
    /**
     * 流程服务
     */
    @Autowired
    private ISpFlowService iSpFlowService;
    /**
     * 字典服务（导入时中文名→value 反查）
     */
    @Autowired
    private ISpSysDictService iSpSysDictService;

    /**
     * 物料管理界面
     *
     * @param model 模型
     * @return 物料管理界面
     */
    @ApiOperation("物料管理界面UI")
    @ApiImplicitParams({@ApiImplicitParam(name = "model", value = "模型", defaultValue = "模型")})
    @GetMapping("/list-ui")
    public String listUI(Model model) {
        return "basedata/materile/list";
    }

    @ApiOperation("物料选择弹窗")
    @GetMapping("/select-ui")
    public String selectUI() {
        return "basedata/materile/select";
    }


    /**
     * 物料管理修改界面
     *
     * @param model  模型
     * @param record 平台表对象
     * @return 更改界面
     */
    @ApiOperation("物料管理修改界面")
    @GetMapping("/add-or-update-ui")
    public String addOrUpdateUI(Model model, SpMaterile record) {
        if (StringUtils.isNotEmpty(record.getId())) {
            SpMaterile spMaterile = iSpMaterileService.getById(record.getId());
            model.addAttribute("result", spMaterile);
        } else {
            // 新增模式：预生成物料编码并填充默认值
            SpMaterile init = new SpMaterile();
            init.setMateriel(iSpMaterileService.nextMaterielCode());
            init.setLeadTime(1);
            init.setSafetyStock(0);
            init.setDeleted("0");
            model.addAttribute("result", init);
        }
        return "basedata/materile/addOrUpdate";
    }


    /**
     * 物料管理界面分页查询
     *
     * @param req 请求参数
     * @return Result 执行结果
     */
    @ApiOperation("物料管理界面分页查询")
    @ApiImplicitParams({@ApiImplicitParam(name = "req", value = "请求参数", defaultValue = "请求参数")})
    @PostMapping("/page")
    @ResponseBody
    public Result page(spMaterileReq req) {
        QueryWrapper<SpMaterile> queryWrapper = new QueryWrapper<>();
        // 默认排除已删除
        if (StringUtils.isNotEmpty(req.getDeleted())) {
            queryWrapper.eq("is_deleted", req.getDeleted());
        } else {
            queryWrapper.ne("is_deleted", "1");
        }
        if (StringUtils.isNotEmpty(req.getMaterielLike())) {
            queryWrapper.like("materiel", req.getMaterielLike());
        }
        if (StringUtils.isNotEmpty(req.getMaterielDescLike())) {
            queryWrapper.like("materiel_desc", req.getMaterielDescLike());
        }
        if (StringUtils.isNotEmpty(req.getMatType())) {
            queryWrapper.eq("mat_type", req.getMatType());
        } else if (StringUtils.isNotEmpty(req.getMatTypes())) {
            List<String> matTypes = new ArrayList<>();
            for (String matType : Arrays.asList(req.getMatTypes().split(","))) {
                if (StringUtils.isNotEmpty(matType)) {
                    matTypes.add(matType.trim());
                }
            }
            if (!matTypes.isEmpty()) {
                queryWrapper.in("mat_type", matTypes);
            }
        }
        if (StringUtils.isNotEmpty(req.getMatSource())) {
            queryWrapper.eq("mat_source", req.getMatSource());
        }
        queryWrapper.orderByDesc("update_time");
        IPage result = iSpMaterileService.page(req, queryWrapper);
        return Result.success(result);
    }

    /**
     * 物料管理修改、新增
     *
     * @param record 物料实体类
     * @return 执行结果
     */
    @ApiOperation("物料管理修改、新增")
    @PostMapping("/add-or-update")
    @ResponseBody
    public Result addOrUpdate(SpMaterile record) {
        boolean isNew = StringUtils.isEmpty(record.getId());
        if (isNew) {
            // 新增：编码为空或与已有重复，自动生成并继续往后编号
            if (StringUtils.isEmpty(record.getMateriel())
                    || iSpMaterileService.isMaterielCodeDuplicate(record.getMateriel(), null)) {
                record.setMateriel(iSpMaterileService.nextMaterielCode());
            }
        } else if (iSpMaterileService.isMaterielCodeDuplicate(record.getMateriel(), record.getId())) {
            // 编辑：编码重复给出提示
            return Result.failure("物料编码已存在，请更换编码");
        }
        // 物料需求提前期不可为0，至少为1天
        if (record.getLeadTime() == null || record.getLeadTime() < 1) {
            return Result.failure("物料需求提前期不可为0，至少为1天");
        }
        if (record.getSafetyStock() == null || record.getSafetyStock() < 0) {
            record.setSafetyStock(0);
        }
        // 兼容旧逻辑：回填工艺流程描述
        if (StrUtil.isNotBlank(record.getFlowId())) {
            SpFlow spflow = iSpFlowService.getById(record.getFlowId());
            if (Objects.nonNull(spflow)) {
                record.setFlowDesc(spflow.getFlowDesc());
            }
        }
        if (StringUtils.isEmpty(record.getDeleted())) {
            record.setDeleted("0");
        }
        iSpMaterileService.saveOrUpdate(record);
        return Result.success();
    }


    /**
     * 删除物料信息（软删，避免破坏 BOM/工艺引用）
     *
     * @param req 请求参数
     * @return Result 执行结果
     */
    @ApiOperation("删除物料信息")
    @ApiImplicitParams({@ApiImplicitParam(name = "req", value = "物料实体", defaultValue = "物料实体")})
    @PostMapping("/delete")
    @ResponseBody
    public Result deleteByTableNameId(SpMaterile req) {
        SpMaterile exist = iSpMaterileService.getById(req.getId());
        if (exist == null) {
            return Result.failure("数据不存在");
        }
        exist.setDeleted("1");
        iSpMaterileService.updateById(exist);
        return Result.success();
    }

    /**
     * Excel 导入物料
     *
     * @param file Excel 文件
     * @return 成功/失败行数
     */
    @ApiOperation("Excel导入物料")
    @PostMapping("/import")
    @ResponseBody
    public Result importExcel(@RequestParam("file") MultipartFile file) {
        if (file == null || file.isEmpty()) {
            return Result.failure("请选择要导入的Excel文件");
        }
        List<SpMaterileImportDTO> rows;
        try {
            rows = EasyExcel.read(file.getInputStream())
                    .head(SpMaterileImportDTO.class).sheet().doReadSync();
        } catch (Exception e) {
            return Result.failure("Excel解析失败：" + e.getMessage());
        }
        if (rows == null || rows.isEmpty()) {
            return Result.failure("Excel中没有可导入的数据");
        }

        // 中文名→value 反查映射
        Map<String, String> typeMap = dictNameToValue("material_type");
        Map<String, String> sourceMap = dictNameToValue("material_source");
        Map<String, String> textureMap = dictNameToValue("material_texture");
        Map<String, String> unitMap = dictNameToValue("ORDER_UNIT");

        List<SpMaterile> toSave = new ArrayList<>();
        List<String> errors = new ArrayList<>();
        int rowNum = 1; // 表头为第1行，数据从第2行起
        for (SpMaterileImportDTO dto : rows) {
            rowNum++;
            if (StringUtils.isEmpty(dto.getMaterielDesc())) {
                errors.add("第" + rowNum + "行：物料名称为空，已跳过");
                continue;
            }
            if (StringUtils.isEmpty(dto.getMatType())) {
                errors.add("第" + rowNum + "行：物料类型为空，已跳过");
                continue;
            }
            Integer leadTime = dto.getLeadTime();
            if (leadTime == null || leadTime < 1) {
                errors.add("第" + rowNum + "行：物料需求提前期不可为0(至少1天)，已跳过");
                continue;
            }
            SpMaterile m = new SpMaterile();
            m.setMateriel(iSpMaterileService.nextMaterielCode());
            m.setMaterielDesc(dto.getMaterielDesc());
            m.setMatType(resolveDict(typeMap, dto.getMatType()));
            m.setUnit(resolveDict(unitMap, dto.getUnit()));
            m.setModel(dto.getModel());
            m.setTexture(resolveDict(textureMap, dto.getTexture()));
            m.setLeadTime(leadTime);
            m.setSafetyStock(dto.getSafetyStock() == null || dto.getSafetyStock() < 0 ? 0 : dto.getSafetyStock());
            m.setMatSource(resolveDict(sourceMap, dto.getMatSource()));
            m.setRemark(dto.getRemark());
            m.setDeleted("0");
            // 立即保存以保证下一行编码连续唯一
            iSpMaterileService.save(m);
        }
        String msg = "成功导入 " + (rows.size() - errors.size()) + " 条";
        if (!errors.isEmpty()) {
            msg += "，失败 " + errors.size() + " 条：" + String.join("；", errors);
        }
        return Result.success(null, msg);
    }

    /**
     * 下载导入模板
     */
    @ApiOperation("下载物料导入模板")
    @GetMapping("/import-template")
    public void importTemplate(HttpServletResponse response) throws Exception {
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setCharacterEncoding("utf-8");
        String fileName = URLEncoder.encode("物料导入模板", "UTF-8").replaceAll("\\+", "%20");
        response.setHeader("Content-disposition", "attachment;filename*=utf-8''" + fileName + ".xlsx");

        // 示例行
        List<SpMaterileImportDTO> sample = new ArrayList<>();
        SpMaterileImportDTO demo = new SpMaterileImportDTO();
        demo.setMaterielDesc("内存条");
        demo.setMatType("零件");
        demo.setUnit("个");
        demo.setModel("8G");
        demo.setTexture("其他");
        demo.setLeadTime(5);
        demo.setSafetyStock(100);
        demo.setMatSource("外购");
        demo.setRemark("示例行，可删除");
        sample.add(demo);

        EasyExcel.write(response.getOutputStream(), SpMaterileImportDTO.class)
                .sheet("物料导入模板").doWrite(sample);
    }

    /**
     * 构建某字典类型的「中文名→value」映射
     */
    private Map<String, String> dictNameToValue(String type) {
        QueryWrapper<SpSysDict> qw = new QueryWrapper<>();
        qw.eq("type", type);
        List<SpSysDict> list = iSpSysDictService.list(qw);
        Map<String, String> map = new HashMap<>();
        if (list != null) {
            for (SpSysDict d : list) {
                if (StringUtils.isNotEmpty(d.getName())) {
                    map.put(d.getName().trim(), d.getValue());
                }
            }
        }
        return map;
    }

    /**
     * 中文名→value，找不到则原样返回（容错）
     */
    private String resolveDict(Map<String, String> map, String name) {
        if (StringUtils.isEmpty(name)) {
            return null;
        }
        String v = map.get(name.trim());
        return v != null ? v : name.trim();
    }
}
