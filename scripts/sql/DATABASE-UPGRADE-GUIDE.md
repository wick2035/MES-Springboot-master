# 数据库升级指南

> **适用版本**：2026-06-08 发布  
> **数据库**：MySQL（`sparchetype`）  
> **原则**：所有脚本均可重复执行（幂等），已应用的变更不会重复执行或产生错误。

---

## 一、本次变更概览

| 序号 | 脚本文件 | 类型 | 说明 |
|------|----------|------|------|
| 1 | `order-approval-upgrade-20260608.sql` | 结构变更 | sp_order 新增设计人/审批人字段，状态注释修正 |
| 2 | `processing-unit-status-upgrade-20260608.sql` | 结构+数据 | 加工单元状态语义调整（0正常/2异常） |
| 3 | `role-upgrade-20260526.sql` * | 结构变更 | sp_sys_role.is_deleted 默认值设为 '0' |
| 4 | `oper-definition-upgrade-20260606.sql` | 索引新增 | sp_oper 新增工序编号唯一索引 |
| 5 | `component-definition-upgrade-20260606.sql` | 新表+菜单 | 新增 sp_component_def 零部件定义表 |
| 6 | `sn-process-collect-upgrade-20260608.sql` | 新表+菜单 | 新增 sp_sn_process_record SN采集记录表 |
| 7 | `material-type-raw-upgrade-20260608.sql` | 字典数据 | material_type 字典新增"原材料" |
| 8 | `product-bom-menu-upgrade-20260606.sql` | 菜单 | 工艺BOM管理→产品BOM管理 |
| 9 | `menu-order-upgrade-20260608.sql` | 菜单 | 侧边栏菜单全量排序重组 |
| 10 | `bom-menu-move-20260608.sql` | 菜单 | 产品BOM管理从产品数据中心移至工艺管理 |
| 11 | `component-product-name-normalize-20260606.sql` | 数据修正 | 零部件产品名称末尾 ? 清理 |
| 12 | `desktop-process-demo-upgrade-20260606.sql` | 演示数据 | 台式电脑主机工艺流程演示数据 |
| 13 | `warehouse-location-upgrade-20260605.sql` * | 注释修正 | 库房类型注释更新 |
| 14 | `material-info-upgrade-20260605.sql` * | 字典数据 | material_type 字典补充（含RAW） |
| 15 | `process-design-upgrade-20260528.sql` * | 结构变更 | sp_processing_unit 状态默认值修正 |

> \* 标记的脚本在之前版本已存在，本次做了小幅修正。
> 按日期排序：先执行旧脚本、再执行新脚本。

---

## 二、详细变更说明

### 2.1 生产订单：新增设计人/审批人字段

**脚本**：`order-approval-upgrade-20260608.sql`

**sp_order 表新增 5 个字段**：

| 字段 | 类型 | 说明 |
|------|------|------|
| `designer_id` | varchar(64) | 设计人用户ID |
| `designer_name` | varchar(64) | 设计人姓名 |
| `approve_user_id` | varchar(64) | 审批人用户ID |
| `approve_username` | varchar(64) | 审批人姓名 |
| `approve_time` | varchar(32) | 审批时间 |

**statue 状态注释修正**：`1已创建/待审批 → 2已审批 → 3订单结束 → 4订单终结`

**影响范围**：现有订单的 `designer_name` 会自动回填为 `create_username`。同时给库房管理员角色授权"工单下达"菜单用于审批。

---

### 2.2 加工单元：状态语义调整

**脚本**：`processing-unit-status-upgrade-20260608.sql`

status 字段含义变更：

| 旧值 | 新值 | 含义 |
|------|------|------|
| `1`（启用） | `0`（正常） | 正常运行 |
| `0`（停用） | `2`（异常） | 异常状态 |

**自动迁移逻辑**：旧数据 `1`→`0`，`0`→`2`。列注释同步更新。

---

### 2.3 角色表：is_deleted 默认值

**脚本**：`role-upgrade-20260526.sql`（本次新增 ALTER）

`sp_sys_role.is_deleted` 字段增加 `DEFAULT '0'`，与其他表的软删约定对齐。

---

### 2.4 工序信息定义：唯一索引

**脚本**：`oper-definition-upgrade-20260606.sql`

`sp_oper` 表新增唯一索引 `uk_sp_oper_oper(oper)`，防止工序编号重复。

**执行前检查**：脚本会先查询重复编号，如有输出请先人工清理后再执行。

---

### 2.5 新增表：产品零部件定义

**脚本**：`component-definition-upgrade-20260606.sql`

新建 `sp_component_def` 表，字段：

| 字段 | 说明 |
|------|------|
| product_name | 产品名称（手工输入） |
| component_code | 零部件编号（唯一） |
| component_name | 零部件名称 |
| component_type | 类型：PG=半成品 / COMP=组件 |

同时新增菜单"零部件定义"（产品数据中心下），并为管理员和工艺员授权。

---

### 2.6 新增表：SN 通用过程采集记录

**脚本**：`sn-process-collect-upgrade-20260608.sql`

新建 `sp_sn_process_record` 表，字段：

| 字段 | 说明 |
|------|------|
| sn | SN 编号 |
| order_id / order_code | 关联生产订单 |
| flow_id | 工艺路线ID |
| oper_id / oper / oper_desc | 工序信息 |
| step_no | 路线步序 |
| status | OK / NG |
| remark | 备注 |

原有菜单 `generalSnProcess` 的 URL 从 `/rrr` 更新为 `/wip/sn-process/list-ui`，图标和名称同步修正。数字化平台菜单 code 规范化为 `Digitalplatform`。

---

### 2.7 字典：material_type 新增 "原材料"

**脚本**：`material-type-raw-upgrade-20260608.sql`

物料类型字典新增 `RAW` (原材料) 项，sort_num=9。

现有的 material_type 枚举完整列表：成品FG / 半成品PG / 组件COMP / 零件PART / 产品PRODUCT / 标准件STD / 其他OTHER / **原材料RAW（新增）**

---

### 2.8 菜单重组：侧边栏排序

**脚本**：`menu-order-upgrade-20260608.sql`

整个左侧菜单按 MES 业务流程重新排序：

```
常规管理 (id=1) ── sort=1
├── 基础数据中心 (base_data_center) ── sort=1
│   ├── 班组定义    sort=1
│   ├── 编组定义    sort=2
│   ├── 库房库位定义 sort=3
│   ├── 设备管理    sort=4
│   └── 字段管理    sort=5
├── 产品数据中心 (prod_data_center) ── sort=2  ← 新增分组
│   ├── 物料信息定义 sort=1
│   ├── 零部件定义  sort=2
│   └── 产品BOM管理 sort=3
├── 工艺管理 (id=15) ── sort=3
│   ├── 工序信息定义 sort=1
│   ├── 工艺路线管理 sort=2
│   ├── 工艺流程管理 sort=3
│   ├── 工艺内容编制 sort=4
│   └── 产品工艺查询 sort=5
├── 生产计划管理 ── sort=4
├── 在制品管理   ── sort=5
├── 数字化平台   ── sort=6
├── 黑科数字孪生 ── sort=7
└── 系统管理     ── sort=99
```

历史遗留的空根节点（OPC操作、其他管理）移至末尾，旧的物料菜单目录隐藏。

**注意**：该脚本同时批量为超级管理员（admin/888888）补全所有菜单授权。

---

### 2.9 BOM 菜单迁移

**脚本**：`bom-menu-move-20260608.sql`

将"产品BOM管理"(id=152) 从产品数据中心移至工艺管理，位于工序信息定义之下。工艺管理下其余子菜单排序顺延。

**最终工艺管理结构**：
1. 工序信息定义 (153)
2. 产品BOM管理 (152) ← 移入
3. 工艺路线管理 (151)
4. 工艺流程管理 (154)
5. 工艺内容编制 (155)
6. 产品工艺查询 (156)

---

### 2.10 数据修正：零部件产品名称

**脚本**：`component-product-name-normalize-20260606.sql`

清理 `sp_component_def.product_name` 末尾误带的 `?` / `？` 字符（编码问题导致）。

---

### 2.11 演示数据：台式电脑主机工艺流程

**脚本**：`desktop-process-demo-upgrade-20260606.sql`

插入台式电脑主机装配的完整演示数据：

- **9 条物料**：台式电脑主机(成品) → 主机半成品(半成品) → 主板单元/机箱单元(组件) → 主板电路板/CPU/内存条/电源/机箱(零件)
- **3 条工序**：主板装配作业、机箱组装作业、主机装配作业
- **3 条零部件定义**
- **4 个 BOM**（含层级关系，全部已锁定/审核通过/有效）
- **8 条 BOM 子件行**

所有 INSERT 使用 `ON DUPLICATE KEY UPDATE`，重复执行不会报错。

---

## 三、升级步骤（推荐）

### 方式一：全新部署

如果是全新数据库，直接执行 `init-all.sql`，已内置本次所有变更。

```bash
mysql -u root -p sparchetype < scripts/sql/init-all.sql
```

### 方式二：增量升级（已有数据库）

**按日期顺序**依次执行以下脚本。所有脚本均可重复执行。

```bash
# 进入 scripts/sql 目录
cd scripts/sql

# 按日期顺序执行（从旧到新，本次发布涉及的脚本）
mysql -u root -p sparchetype < role-upgrade-20260526.sql
mysql -u root -p sparchetype < process-design-upgrade-20260528.sql
mysql -u root -p sparchetype < material-info-upgrade-20260605.sql
mysql -u root -p sparchetype < warehouse-location-upgrade-20260605.sql
mysql -u root -p sparchetype < component-definition-upgrade-20260606.sql
mysql -u root -p sparchetype < component-product-name-normalize-20260606.sql
mysql -u root -p sparchetype < desktop-process-demo-upgrade-20260606.sql
mysql -u root -p sparchetype < oper-definition-upgrade-20260606.sql
mysql -u root -p sparchetype < product-bom-menu-upgrade-20260606.sql
mysql -u root -p sparchetype < bom-menu-move-20260608.sql
mysql -u root -p sparchetype < material-type-raw-upgrade-20260608.sql
mysql -u root -p sparchetype < menu-order-upgrade-20260608.sql
mysql -u root -p sparchetype < order-approval-upgrade-20260608.sql
mysql -u root -p sparchetype < processing-unit-status-upgrade-20260608.sql
mysql -u root -p sparchetype < sn-process-collect-upgrade-20260608.sql
```

### 方式三：一键执行

```bash
# 按顺序执行全部升级脚本
for f in \
  role-upgrade-20260526.sql \
  process-design-upgrade-20260528.sql \
  material-info-upgrade-20260605.sql \
  warehouse-location-upgrade-20260605.sql \
  component-definition-upgrade-20260606.sql \
  component-product-name-normalize-20260606.sql \
  desktop-process-demo-upgrade-20260606.sql \
  oper-definition-upgrade-20260606.sql \
  product-bom-menu-upgrade-20260606.sql \
  bom-menu-move-20260608.sql \
  material-type-raw-upgrade-20260608.sql \
  menu-order-upgrade-20260608.sql \
  order-approval-upgrade-20260608.sql \
  processing-unit-status-upgrade-20260608.sql \
  sn-process-collect-upgrade-20260608.sql; do
  echo "=== 执行: $f ==="
  mysql -u root -p sparchetype < "$f"
  echo ""
done
```

---

## 四、验证清单

升级完成后，逐项确认以下内容：

- [ ] `sp_order` 表存在 `designer_id`, `designer_name`, `approve_user_id`, `approve_username`, `approve_time` 字段
- [ ] `sp_processing_unit` 表 `status` 默认值为 `'0'`，注释为"状态 0正常 2异常"
- [ ] `sp_sys_role` 表 `is_deleted` 默认值为 `'0'`
- [ ] `sp_oper` 表存在 `uk_sp_oper_oper` 唯一索引
- [ ] `sp_component_def` 表存在
- [ ] `sp_sn_process_record` 表存在
- [ ] `sp_sys_dict` 表中 `material_type` 类型包含 `RAW` (原材料)
- [ ] 菜单 `generalSnProcess`(id=161) URL 为 `/wip/sn-process/list-ui`
- [ ] 菜单 `Digitalplatform`(id=14) code 为 `Digitalplatform`
- [ ] 侧边栏一级菜单排序正确（基础数据中心→产品数据中心→工艺管理→...→系统管理）
- [ ] 台式电脑主机演示数据可正常查看（物料定义、BOM、零部件定义等模块）

---

## 五、回滚说明

本次升级主要涉及：
- **新增表**：删除 `sp_component_def` 和 `sp_sn_process_record` 即可
- **新增字段**：删除 `sp_order` 的 5 个审批相关字段
- **状态值迁移**：加工单元 status 做了映射（1→0, 0→2），纯回滚需手动反向映射回旧语义
- **菜单排序**：菜单排序为纯展示层变更，不影响数据，无需回滚
- **字典数据**：新增的 RAW 字典项如不需要可标记 `is_deleted='1'`
- **索引**：删除 `uk_sp_oper_oper` 索引即可

**建议**：升级前备份数据库。

```bash
mysqldump -u root -p sparchetype > sparchetype_backup_20260608.sql
```

---

## 六、常见问题

**Q: 执行 `oper-definition-upgrade-20260606.sql` 时报错？**  
A: 该脚本会先检查 `sp_oper.oper` 是否存在重复值。如有重复，先手动清理后再执行。

**Q: 执行 `processing-unit-status-upgrade-20260608.sql` 后状态值没变？**  
A: 脚本仅在列注释仍为旧语义（"1启用 0停用"）时才做映射转换。如果之前已执行过，注释已更新，则只将 NULL/空值统一为 '0'。

**Q: `menu-order-upgrade-20260608.sql` 和 `bom-menu-move-20260608.sql` 有冲突吗？**  
A: 无冲突。`menu-order` 先设置初始排序，`bom-menu-move` 在此基础上微调 BOM 菜单位置。两者都幂等，按日期顺序执行即可。

**Q: 演示数据不想导入怎么办？**  
A: 跳过 `desktop-process-demo-upgrade-20260606.sql` 即可。演示数据使用了稳定主键 + `ON DUPLICATE KEY UPDATE`，不影响系统功能。