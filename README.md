# MES 制造执行系统（JAVA）

基于 Spring Boot 的 MES（制造执行系统），单模块项目，全部代码位于 `mes/` 目录。前端采用 layui + 自封装 `sp*` 组件，整体为**浅色精密工业风（Industrial Light）**视觉风格。覆盖基础数据 → 产品/BOM/工艺 → 生产计划/订单 → 派工执行 → 库房 → 在制品/SN 采集 → 工作流，并内置数字孪生 3D 大屏与通义千问 AI 助手。

> 二次开发务必先阅读 [开发规范](docs/开发规范.md) ，避免破坏既有 UI / 架构风格。

---

## 一、技术栈


| 分类       | 选型                                                 | 版本                                    |
| -------- | -------------------------------------------------- | ------------------------------------- |
| 语言 / 运行时 | Java                                               | 8（`java.version=1.8`）                 |
| 框架       | Spring Boot                                        | 2.1.7.RELEASE                         |
| ORM      | MyBatis-Plus                                       | 3.1.2                                 |
| 连接池      | Druid                                              | 1.1.9                                 |
| 数据库      | MySQL                                              | 8.0（`utf8mb4` / `utf8mb4_0900_ai_ci`） |
| 缓存 / 会话  | Redis（Jedis 2.9.0）、EhCache                         | —                                     |
| 安全鉴权     | Apache Shiro                                       | 1.4.0                                 |
| 模板引擎     | FreeMarker（`.ftl`）                                 | —                                     |
| 前端       | layui + 自封装 `sp`* 组件（`spTable`/`spLayer`/`spUtil`） | —                                     |
| AI 大模型   | 通义千问 DashScope（OpenAI 兼容接口）                        | —                                     |
| 其他       | EasyExcel 3.3.4、Hutool 5.1.5、Swagger2 2.9.2        | —                                     |


---

## 二、环境要求（前置安装）

在一台全新电脑上，先装好以下四样：


| 组件        | 版本 / 要求 | 校验命令              | 备注                                                          |
| --------- | ------- | ----------------- | ----------------------------------------------------------- |
| **JDK**   | 8+      | `java -version`   | 项目 `java.version=1.8`                                       |
| **Maven** | 3.6+    | `mvn -v`          | 构建**必须**带项目内 `.codex-maven-settings.xml`（见第四节⑥）             |
| **MySQL** | 8.0     | `mysql --version` | 字符集 `utf8mb4`，排序规则 `utf8mb4_0900_ai_ci`；默认 `127.0.0.1:3306` |
| **Redis** | 任意稳定版   | `redis-cli ping`  | 开发环境默认 `127.0.0.1:6379`，无密码                                 |


- 操作系统不限（项目在 Windows 上开发，默认上传目录为 `D:/mes/upload`）。
- MySQL 安装后确认服务端默认字符集为 utf8mb4：
  ```sql
  SHOW VARIABLES LIKE 'character_set_server';   -- 期望 utf8mb4
  ```

---

## 三、从 0 部署（一条命令建库 + 建表 + 演示数据）

### ① 导入数据库（全量演示一键安装包）

全新部署只需执行整合后的**单一安装包** `scripts/sql/full-install-demo-20260625.sql`。它**自带建库语句**（`CREATE DATABASE` + `USE`），并按正确顺序拼接了「基础库 + 截至 2026-06-24 的全部结构/菜单升级 + 0614 优化版演示数据」，内容幂等、可重复执行：

```powershell
mysql --default-character-set=utf8mb4 -u root -p < scripts/sql/full-install-demo-20260625.sql
```

> ⚠️ 三个必须：
>
> 1. **必须**加 `--default-character-set=utf8mb4`，否则导入的中文会乱码。
> 2. **必须**用 `mysql` 命令行客户端导入（安装包含 `DELIMITER` 存储过程段，Navicat/部分 GUI 的「多语句执行」会解析失败）。
> 3. 无需先手动建库、无需指定库名——文件内已 `CREATE DATABASE IF NOT EXISTS` 目标库并 `USE` 之。
>
> 该安装包目标库为 `**sparchetype-test`**（dev 默认 profile 连接此库）。生产 `pro` profile 用 `sparchetype`，部署生产时把文件顶部建库/`USE` 的库名改掉即可。

安装包内置内容（演示数据 = 0614 优化版）：

- 台式电脑主机 **DPC_HOST** 的一条完整三阶段制造流程（草稿 / 已审待下发 / 已下发开工），覆盖 BOM→工艺→生产订单→工序排产→设备派工+员工派工→MRP→库房单据→SN 采集→工作流；
- 工业采集终端 **IOT_TERMINAL** 的整套主数据（BOM 仍为草稿，仅演示草稿录入）。

### ② 准备 Redis

启动一个 Redis 实例（开发环境默认无密码，`127.0.0.1:6379`）。

### ③ 创建文件上传目录

图片 / Excel 上传落盘目录由 `mes.file.upload-path` 指定，默认 `D:/mes/upload`，**首次运行前需手动创建**：

```powershell
New-Item -ItemType Directory -Force D:/mes/upload
```

### ④ 核对连接配置

默认激活 `dev` profile（见 [application.yml](mes/src/main/resources/application.yml)）。按需核对 [application-dev.yml](mes/src/main/resources/application-dev.yml)：

- 数据源：默认 `jdbc:mysql://127.0.0.1:3306/sparchetype-test`，用户 `root`，密码 `20041118`
- Redis：默认 `localhost:6379`，无密码
- 文件上传目录：`mes.file.upload-path`（在 [application.yml](mes/src/main/resources/application.yml)）

生产环境配置见 `application-pro.yml`（库名 `sparchetype`，通过 `spring.profiles.active=pro` 切换）。

### ⑤（可选）配置 AI 大模型 Key

智能助手 / AI 建模等功能调用通义千问，需要 DashScope API Key（见[第十节](#十ai--大模型通义千问说明)）。**不配置也不影响其余模块**，仅 AI 按钮会报错。

### ⑥ 编译与运行

构建**必须**带 `-s .\.codex-maven-settings.xml`（指定阿里云镜像 + 项目内本地仓库 `.m2/repository`），否则会因镜像 / 离线问题失败。

```powershell
# 仅编译验证
mvn -s .\.codex-maven-settings.xml -f .\mes\pom.xml -DskipTests compile

# 启动应用（推荐方式，跳过测试）
mvn -s .\.codex-maven-settings.xml -f .\mes\pom.xml -DskipTests spring-boot:run
```

> 说明：当前 `pom.xml` 仅配置了 docker-maven-plugin，**未**配置 `spring-boot-maven-plugin` 的 `repackage`，因此 `mvn package` 产出的 jar 是普通瘦 jar，**不能**直接 `java -jar` 运行。日常开发与运行请使用 `spring-boot:run`。

---

## 四、访问系统

- 地址：[http://localhost:9090](http://localhost:9090)（端口 `9090`，无 context-path）
- 默认账号：`admin`
- 默认密码：`123`
  - 密码哈希算法为 `Md5Hash(密码, 盐=用户名, 迭代3次)`；库内 admin 的哈希为 `9d7281eeaebded0b091340cfa658a7e8`。
  - **生产环境务必登录后立即修改密码。**
- 接口文档（Swagger）：[http://localhost:9090/swagger-ui.html](http://localhost:9090/swagger-ui.html)

> 安装包已自动为 `admin` 补建并归属「系统管理员」角色（role code `888888`），登录后即可看到包括生产订单中心、库存管理、已交付订单、智能制造数据中心、智能助手中心、数字孪生产线在内的**全部功能菜单**（原因见[第十一节 FAQ](#十一常见问题排查)）。

---

## 五、项目结构

```
MES-Springboot-master/
├── mes/                              # 唯一业务模块（全部代码在此）
│   ├── pom.xml
│   └── src/main/
│       ├── java/com/wangziyang/mes/
│       │   ├── SparchetypeApplication.java   # 启动类（@MapperScan("com.wangziyang.mes.**.mapper*")）
│       │   ├── common/               # 基类与通用：BaseEntity/BaseController/BasePageReq/Result、异常处理、自动填充
│       │   ├── basedata/             # 基础数据域（设备/物料/库房/加工单元/班组…）
│       │   ├── technology/           # 工艺域（BOM/工序/工艺路线/工艺内容/零部件）
│       │   ├── productionorder/      # 生产计划与订单（生产订单/MRP/排产/派工/计划中心）
│       │   ├── order/                # 销售工单（工单/审批/交付）
│       │   ├── warehouse/            # 库房单据（出入库申请/流水/分配）
│       │   ├── wip/                  # 在制品（SN 通用过程采集）
│       │   ├── workflow/             # 工作流引擎（定义/实例/任务/表单/事件）
│       │   ├── llm/                  # AI 大模型（智能助手 / AI BOM 生成 / 建模向导）
│       │   ├── digitization/         # 数字化平台（数据大屏 / 数字孪生产线）
│       │   ├── dst/                  # 数字仿真孪生（3D 仿真）
│       │   └── system/               # 系统管理（用户/角色/菜单/部门/字典/登录鉴权）
│       └── resources/
│           ├── application.yml / application-dev.yml / application-pro.yml
│           ├── ehcache.xml / logback.xml / banner.txt
│           ├── mapper/{域}/XxxMapper.xml         # MyBatis 联表查询 XML（按业务域分目录）
│           ├── templates/{域}/{模块}/*.ftl        # FreeMarker 模板（list/addOrUpdate/select…）
│           └── static/                           # 前端静态资源
│               ├── js/layuimodule/sp/            # 自封装组件 spTable/spLayer/spLayui/spSearchPanel…
│               ├── js/{spConfig,spUtil,spDataBus}.js
│               └── lib/                          # echarts / gantt / font-awesome / wangEditor …
├── scripts/sql/                      # 数据库脚本（手动执行，幂等，命名 {feature}-upgrade-YYYYMMDD.sql）
│   ├── full-install-demo-20260625.sql   # ★ 全新部署一键安装包（建库+全部表结构+演示数据）
│   ├── MySQL-20210225.sql               # 基础库（表结构 + 用户/角色/菜单种子）
│   ├── *-upgrade-YYYYMMDD.sql            # 各功能增量升级脚本
│   ├── demo-data-optimized-manufacturing-20260614.sql  # 0614 优化版演示数据
│   └── DATABASE-UPGRADE-GUIDE.md         # 早期(至 06-08)升级说明
├── docs/                             # 开发规范、用户手册、技术指南
├── .codex-maven-settings.xml         # 项目内 Maven 设置（阿里云镜像 + 项目内 .m2/repository）
├── CLAUDE.md                         # 协作/构建/目录约定速查
└── README.md
```

**单模块 CRUD 内部分层**（每个业务域内一致）：`controller` / `entity` / `mapper` / `request` / `service` / `service.impl`。

**通用基类**（`com.wangziyang.mes.common`）：


| 类                | 作用                                                                       |
| ---------------- | ------------------------------------------------------------------------ |
| `BaseEntity`     | `id`（雪花串）+ `createTime/createUsername/updateTime/updateUsername` 自动填充    |
| `BaseController` | `getSysUser()` 取当前登录用户（Shiro）                                            |
| `BasePageReq`    | 分页请求基类（`current`/`size`/`orderBy`）                                       |
| `Result`         | 统一响应体（`code`/`data`/`msg`，`Result.success(...)` / `Result.failure(...)`） |


---

## 六、组织结构（业务域与功能清单）

### 业务域职责


| 业务域（包）                 | 职责                                | 代表实体 / 控制器                                                                                       |
| ---------------------- | --------------------------------- | ------------------------------------------------------------------------------------------------ |
| **system**             | 用户 / 角色 / 菜单 / 部门 / 字典 / 登录鉴权     | SysUser、SysRole、SysMenu、SysDepartment、SysDict                                                    |
| **basedata**           | 设备、设备编组、物料、库存、加工单元、班组、库房库位        | SpEquipment、SpMaterile、SpProcessingUnit、SpTeam、SpWarehouse、SpInventory                           |
| **technology**         | BOM（三层层级 + 锁定）、工序、工艺路线、工艺内容、零部件定义 | SpBom、SpOper、SpProcessRoute、SpProcessContent、SpComponentDef                                      |
| **productionorder**    | 生产订单、工序排产、设备/员工派工、MRP、生产计划中心      | SpProductionOrder、SpProductionOrderOperPlan、SpMaterialRequirementPlan、SpOrderOperEquipmentAssign |
| **order**              | 销售工单、订单审批、已交付订单                   | SpOrder、SpOrderOperAssign                                                                        |
| **warehouse**          | 库房请求、库房流水、配套分配                    | SpWarehouseRequest、SpWarehouseTransaction、SpWarehouseRequestAllocation                           |
| **wip**                | 在制品 SN 通用过程采集                     | SpSnProcessRecord                                                                                |
| **workflow**           | 工作流引擎（定义 / 实例 / 任务 / 表单 / 事件日志）   | SpWorkflowDefinition、SpWorkflowInstance、SpWorkflowTask、SpWorkflowForm                            |
| **llm**                | AI 智能助手对话、AI BOM 生成、AI 建模向导       | SpLlmConversation、SpLlmMessage                                                                   |
| **digitization / dst** | 智能制造数据大屏、数字孪生产线、3D 数字仿真           | DashboardController、ProductionLineTwinController、DigitalSimulationController                     |


### 主要功能清单

- **基础数据**：设备 / 编组、物料 / 库存、库房库位、加工单元、班组与员工。
- **产品与工艺**：产品 BOM（三层层级、版本锁定）、零部件定义、工序、工艺路线、工艺内容编制、产品工艺查询。
- **生产计划与执行**：生产订单中心（草稿→审批→下发三阶段）、MRP 物料需求计划、工序排产、设备派工 / 员工派工、生产计划下发、已下达工单变更。
- **销售与交付**：销售工单、设计人 / 审批流、已交付订单。
- **库房管理中心**：入库申请、手工/计划出入库、库房流水与配套分配。
- **在制品**：SN 通用过程采集（OK/NG 过程追溯）。
- **工作流引擎**：流程定义 / 表单设计 / 实例 / 任务办理 / 事件日志。
- **数字化平台**：智能制造数据大屏（真实数据）、数字孪生产线 3D、数字仿真 3D 仓库。
- **AI 大模型**：智能数据助手（SSE + 工具调用）、AI 辅助 BOM 生成、AI 智能建模四步向导。
- **系统管理**：用户 / 角色 / 菜单 / 部门 / 字典、权限与数据范围、个人资料与改密、代码生成器、文件上传、Swagger 文档。

---

## 七、关键配置一览


| 配置项            | 值                                   | 位置                                        |
| -------------- | ----------------------------------- | ----------------------------------------- |
| 服务端口           | `9090`                              | application-dev.yml                       |
| 激活 profile     | `dev`（默认）                           | application.yml                           |
| 数据库（dev / pro） | `sparchetype-test` / `sparchetype`  | application-dev.yml / application-pro.yml |
| 数据库账号          | `root` / `20041118`                 | application-dev.yml                       |
| 文件上传目录         | `D:/mes/upload`                     | application.yml（`mes.file.upload-path`）   |
| 上传访问前缀         | `/upload`                           | application.yml（`mes.file.access-prefix`） |
| 会话超时           | 1800 秒（30 分钟）                       | application.yml                           |
| 单文件 / 单请求上传上限  | 20MB / 50MB                         | application.yml                           |
| AI 大模型         | 通义千问 DashScope，`model=qwen3.6-plus` | application.yml（`llm.`*）                  |
| Maven 设置       | 阿里云镜像 + 项目内 `.m2/repository`        | .codex-maven-settings.xml                 |


---

## 八、数据库脚本说明

脚本位于 `scripts/sql/`，**手动执行**（无 Flyway / Liquibase），全部幂等、可重复执行。

- **全新部署（推荐）**：执行单一安装包 `full-install-demo-20260625.sql`（建库 + 全部表结构 + 0614 演示数据，已含所有升级，见[第三节](#三从-0-部署一条命令建库--建表--演示数据)）。
- **已有库版本升级**：**不要**执行安装包，按文件名日期顺序执行各 `*-upgrade-*.sql` 增量脚本。
- ⚠️ 旧的 `init-all.sql` **已过期**（只拼接到 2026-06-08，缺失之后约 14 个模块），**请勿再用于新部署**，已被 `full-install-demo-20260625.sql` 取代。

安装包按以下顺序拼接（节选关键里程碑）：


| 阶段        | 代表脚本                                                                                                                                       | 内容                                              |
| --------- | ------------------------------------------------------------------------------------------------------------------------------------------ | ----------------------------------------------- |
| 基础库       | `MySQL-20210225.sql`                                                                                                                       | 表结构 + 用户/角色/菜单种子                                |
| 角色/基础数据   | `role-upgrade-20260526` … `material-info-upgrade-20260605`                                                                                 | 7 个 MES 角色、BOM 层级/锁定、工艺/设备/加工单元、班组/编组、库房库位、物料增强 |
| 产品/工艺/菜单  | `component-definition…` `menu-order-upgrade-20260608` `order-approval…`                                                                    | 零部件定义、SN 采集、库存、字典、侧边栏重排、工单审批流                   |
| 数字化/AI    | `dashboard-screen-20260609` `llm-assistant-20260609` `ai-bom-wizard-20260610`                                                              | 数据大屏、AI 助手、AI 建模向导                              |
| 生产/工作流/库房 | `production-order-center-20260611` `workflow-*-20260611` `material-requirement-plan-20260612-fixed` `warehouse-management-center-20260612` | 生产订单中心、工作流引擎、MRP、库房管理中心、工单变更、交付                 |
| 孪生/演示     | `production-order-leadtime-20260613` `digital-production-line-20260624` `demo-data-optimized-manufacturing-20260614`                       | 提前期、数字孪生产线、0614 演示数据                            |


> 安装包另在「基础库之后、各升级脚本之前」注入了一小段**幂等修复**：补建 `code=888888` 的「系统管理员」角色并把 `admin` 用户归属其下——因为基础库 `MySQL-20210225.sql` 不含该角色，而后续各功能脚本一律把新菜单授权给 `888888`，缺失则新功能菜单无人可见。

新增脚本命名约定：`{feature}-upgrade-YYYYMMDD.sql`，务必保持幂等（`IF NOT EXISTS` / `INFORMATION_SCHEMA` 判存 / `INSERT IGNORE` / `NOT EXISTS` 子查询）。

---

## 九、AI / 大模型（通义千问）说明

- 提供方：阿里云 **DashScope**（OpenAI 兼容接口），配置在 [application.yml](mes/src/main/resources/application.yml) 的 `llm.`*：`base-url`、`model=qwen3.6-plus`、`timeout`。
- **API Key**：`llm.api-key`。配置注释要求**通过环境变量 `DASHSCOPE_API_KEY` 注入，切勿硬编码进仓库**；当前 yml 中存有一个明文 key，建议改为：
  ```yaml
  llm:
    api-key: ${DASHSCOPE_API_KEY:}
  ```
  并在运行环境设置：
  ```powershell
  $env:DASHSCOPE_API_KEY = "sk-你的key"
  ```
- 涉及功能：智能助手中心（对话）、AI 辅助 BOM 生成、AI 智能建模向导。**未配置可用 Key 时，仅这些 AI 入口报错，不影响其余模块**。

---

## 十、常见问题排查


| 现象                             | 原因 / 处理                                                                                                             |
| ------------------------------ | ------------------------------------------------------------------------------------------------------------------- |
| 导入后中文乱码                        | 导入时漏加 `--default-character-set=utf8mb4`；删库重建后重新导入                                                                   |
| 导入到一半报 `DELIMITER`/语法错误        | 用了 Navicat/GUI 的多语句执行；安装包含存储过程段，**必须**用 `mysql` 命令行客户端导入                                                            |
| 启动连接失败                         | MySQL / Redis 未启动，或库名不符——dev 连的是 `**sparchetype-test`**（不是 `sparchetype`）                                           |
| 登录后看不到新功能菜单                    | 旧库用了过期的 `init-all.sql`，或 `888888` 角色缺失 / `admin` 未归属；改用 `full-install-demo-20260625.sql`（已内置修复）                     |
| 物料/BOM 等老页面混入个别旧样例             | 0614 演示只清自己 `demo_` 前缀数据，不清 2021 基础库的旧样例；属正常并存，新表（生产订单/派工/MRP/库房/工作流/SN）页面是干净的                                      |
| Maven 构建报镜像 / 离线错误             | 漏带 `-s .\.codex-maven-settings.xml`                                                                                 |
| 启动报上传目录不存在 / 上传失败              | 未创建 `D:/mes/upload`（或与 `application.yml` 中路径不一致）                                                                    |
| AI 助手 / AI BOM 报错              | 未配置可用的 `DASHSCOPE_API_KEY`（见第九节），不影响其余模块                                                                            |
| `java -jar` 报 no main manifest | 未配置 `spring-boot-maven-plugin` 的 repackage，请用 `spring-boot:run`（见第三节⑥）                                              |
| 切换生产环境                         | 将 `spring.profiles.active` 改为 `pro`，核对 `application-pro.yml`（库名 `sparchetype`），并把安装包顶部建库/`USE` 改成 `sparchetype` 后导入 |


---

## 十一、开发约定

二次开发前必读：

- [docs/开发规范.md](docs/开发规范.md) —— UI / 设计规范（重点）、后端 CRUD 范式、SQL 与命名 / 提交规范。

