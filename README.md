# MES 制造执行系统

基于 Spring Boot 的 MES（制造执行系统），单模块项目，全部代码位于 `mes/` 目录。前端采用 layui + 自封装 `sp*` 组件，整体为**浅色精密工业风（Industrial Light）**视觉风格。

> 二次开发务必先阅读 [开发规范](docs/开发规范.md) 与 [CLAUDE.md](CLAUDE.md)，避免破坏既有 UI / 架构风格。

---

## 一、技术栈

| 分类 | 选型 | 版本 |
| --- | --- | --- |
| 语言 / 运行时 | Java | 8（`java.version=1.8`） |
| 框架 | Spring Boot | 2.1.7.RELEASE |
| ORM | MyBatis-Plus | 3.1.2 |
| 连接池 | Druid | 1.1.9 |
| 数据库 | MySQL | 8.0（`utf8mb4` / `utf8mb4_0900_ai_ci`） |
| 缓存 / 会话 | Redis（Jedis 2.9.0）、EhCache | — |
| 安全鉴权 | Apache Shiro | 1.4.0 |
| 模板引擎 | FreeMarker（`.ftl`） | — |
| 前端 | layui + 自封装 `sp*` 组件（`spTable`/`spLayer`/`spUtil`） | — |
| 其他 | EasyExcel 3.3.4、Hutool 5.1.5、Swagger2 2.9.2 | — |

---

## 二、环境要求

- **JDK 8+**（`java -version` 确认）
- **Maven 3.6+**（构建必须使用项目内的 `.codex-maven-settings.xml`，见下）
- **MySQL 8.0**，字符集 `utf8mb4`，排序规则 `utf8mb4_0900_ai_ci`
- **Redis**（开发环境默认 `127.0.0.1:6379`，无密码）
- 操作系统不限（项目在 Windows 上开发，默认上传目录为 `D:/mes/upload`）

---

## 三、从 0 部署

### ① 创建数据库

```sql
CREATE DATABASE sparchetype CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
```

### ② 导入数据（全量初始化脚本）

全新部署只需执行整合后的单一脚本 `scripts/sql/init-all.sql`（已按正确顺序拼接基础库 + 全部升级脚本，内容幂等）：

```powershell
mysql --default-character-set=utf8mb4 -u root -p sparchetype < scripts/sql/init-all.sql
```

> ⚠️ **必须**加 `--default-character-set=utf8mb4`，否则导入的中文会乱码。
>
> 已有库做版本升级时**不要**执行 `init-all.sql`，请改为按文件名日期顺序执行 `scripts/sql/*-upgrade-*.sql` 增量脚本（见 [第六节](#六数据库脚本说明)）。

### ③ 准备 Redis

启动一个 Redis 实例（开发环境默认无密码，`127.0.0.1:6379`）。

### ④ 创建文件上传目录

应用的图片 / Excel 上传落盘目录由 `mes.file.upload-path` 指定，默认 `D:/mes/upload`，**首次运行前需手动创建**：

```powershell
New-Item -ItemType Directory -Force D:/mes/upload
```

### ⑤ 修改连接配置

默认激活 `dev` profile（见 [application.yml](mes/src/main/resources/application.yml)）。按需修改 [application-dev.yml](mes/src/main/resources/application-dev.yml)：

- 数据源：默认 `jdbc:mysql://127.0.0.1:3306/sparchetype`，用户 `root`，密码 `20041118`
- Redis：默认 `localhost:6379`，无密码
- 文件上传目录：`mes.file.upload-path`（在 [application.yml](mes/src/main/resources/application.yml)）

生产环境配置见 `application-pro.yml`（通过 `spring.profiles.active=pro` 切换）。

### ⑥ 编译与运行

构建**必须**带 `-s .\.codex-maven-settings.xml`（指定阿里云镜像 + 项目内本地仓库 `.m2/repository`），否则会因镜像 / 离线问题失败。

```powershell
# 仅编译验证
mvn -s .\.codex-maven-settings.xml -f .\mes\pom.xml -DskipTests compile

# 启动应用（推荐方式，跳过测试）
mvn -s .\.codex-maven-settings.xml -f .\mes\pom.xml -DskipTests spring-boot:run
```

> 说明：当前 `pom.xml` 仅配置了 docker-maven-plugin，**未**配置 `spring-boot-maven-plugin` 的 `repackage`，因此 `mvn package` 产出的 `mes-1.0.0.jar` 是普通瘦 jar，**不能**直接 `java -jar` 运行。若需以可执行 jar 部署，请先在 `pom.xml` 的 `<build><plugins>` 中加入 `spring-boot-maven-plugin` 并执行 `repackage`。日常开发与运行请使用 `spring-boot:run`。

---

## 四、访问系统

- 地址：<http://localhost:9090>（端口 `9090`，无 context-path）
- 默认账号：`admin`
- 默认密码：`123`
  - 密码哈希算法为 `Md5Hash(密码, 盐=用户名, 迭代3次)`；库内 admin 的哈希为 `9d7281eeaebded0b091340cfa658a7e8`。
  - **生产环境务必登录后立即修改密码。**
- 接口文档（Swagger）：<http://localhost:9090/swagger-ui.html>

---

## 五、关键配置一览

| 配置项 | 值 | 位置 |
| --- | --- | --- |
| 服务端口 | `9090` | application-dev.yml |
| 激活 profile | `dev`（默认） | application.yml |
| 数据库 | `sparchetype` | application-dev.yml |
| 文件上传目录 | `D:/mes/upload` | application.yml（`mes.file.upload-path`） |
| 上传访问前缀 | `/upload` | application.yml（`mes.file.access-prefix`） |
| 会话超时 | 1800 秒（30 分钟） | application.yml |
| 单文件上传上限 | 20MB | application.yml |
| 单请求上传上限 | 50MB | application.yml |
| Druid 连接池 | initial 8 / min-idle 5 / max-active 10 | application-dev.yml |
| Maven 设置 | 阿里云镜像 + 项目内 `.m2/repository` | .codex-maven-settings.xml |

---

## 六、数据库脚本说明

脚本位于 `scripts/sql/`，**手动执行**（无 Flyway / Liquibase），全部幂等、可重复执行。

- **全新部署**：执行 `scripts/sql/init-all.sql`（已整合下列全部脚本）。
- **已有库升级**：按下表日期顺序执行对应增量脚本。

| 顺序 | 文件 | 用途 |
| --- | --- | --- |
| 0 | `MySQL-20210225.sql` | 全量基础库：表结构 + 种子数据（工厂 / 工序 / 物料 / 用户 / 角色 / 菜单） |
| 1 | `role-upgrade-20260526.sql` | 角色权限增强 + 7 个预置 MES 角色 |
| 2 | `bom-hierarchy-upgrade-20260526.sql` | BOM 三层层级结构 |
| 3 | `bom-lock-upgrade-20260526.sql` | BOM 版本锁定 / 有效性 |
| 4 | `process-design-upgrade-20260528.sql` | 工艺 / 设备 / 加工单元（7 张表） |
| 5 | `banzu-upgrade-20260604.sql` | 班组 + 班组员工 |
| 6 | `bianzu-upgrade-20260604.sql` | 编组设备 |
| 7 | `jiagong-unit-banzu-upgrade-20260604.sql` | 加工单元绑定班组 + 产能 / 边库标识 |
| 8 | `warehouse-location-upgrade-20260605.sql` | 库房 + 库位（按规格自动生成库位） |
| 9 | `material-info-upgrade-20260605.sql` | 物料信息增强（来源 / 材质 / 安全库存 / 多图等） |
| 10 | `component-definition-upgrade-20260606.sql` | 产品零部件定义 + 产品 BOM 前置组件清单 |
| 11 | `product-bom-menu-upgrade-20260606.sql` | 原工艺BOM管理入口替换为产品BOM管理 |
| 12 | `component-product-name-normalize-20260606.sql` | 修正零部件定义产品名称末尾误带问号的数据 |
| 13 | `processing-unit-status-upgrade-20260608.sql` | 加工单元状态调整为正常 / 异常 |
| 14 | `order-approval-upgrade-20260608.sql` | 工单设计人 + 库房管理员审批流 |

新增脚本命名约定：`{feature}-upgrade-YYYYMMDD.sql`，并务必保持幂等（详见 [开发规范](docs/开发规范.md)）。

---

## 七、常见问题排查

| 现象 | 原因 / 处理 |
| --- | --- |
| 导入后中文乱码 | 导入时漏加 `--default-character-set=utf8mb4`；删库重建后重新导入 |
| Maven 构建报镜像 / 离线错误 | 漏带 `-s .\.codex-maven-settings.xml` |
| 启动报上传目录不存在 / 上传失败 | 未创建 `D:/mes/upload`（或与 `application.yml` 中路径不一致） |
| 启动连接失败 | MySQL / Redis 未启动，或 `application-dev.yml` 连接配置与本机不符 |
| 菜单 / 模块打不开 | 数据库脚本未执行完整，或菜单未授权给管理员角色（role code `888888`） |
| `java -jar` 报 no main manifest | 当前未配置 `spring-boot-maven-plugin` 的 repackage，请用 `spring-boot:run`（见第三节⑥） |
| 切换生产环境 | 将 `spring.profiles.active` 改为 `pro`，并核对 `application-pro.yml` |

---

## 八、开发约定

二次开发前必读：

- [docs/开发规范.md](docs/开发规范.md) —— UI / 设计规范（重点）、后端 CRUD 范式、SQL 与命名 / 提交规范。
- [CLAUDE.md](CLAUDE.md) —— 构建运行、目录约定、CRUD 模块范式速查。
