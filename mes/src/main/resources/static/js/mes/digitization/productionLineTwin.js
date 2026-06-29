/**
 * 数字孪生生产线 3D 场景（浅色「棚拍」工作室风）。
 * - 传送带 + 自动化龙门工位 + 产品沿线流动；工位指标/工单达成来自后端真实数据（空数据回退演示）。
 * - 使用项目随包 Three.js（约 r92）支持的 API：MeshStandardMaterial / PCFSoftShadowMap /
 *   HemisphereLight + DirectionalLight / OrbitControls / CanvasTexture / Sprite。
 * @since 2026-06-24
 */
(function () {
    'use strict';

    var SPACING = 74;     // 工位间距
    var BELT_W = 26;      // 传送带宽
    var BELT_TOP = 20;    // 传送带上表面高度
    var PRODUCT = 12;     // 产品方块尺寸

    var scene, camera, renderer, controls;
    var clock = {last: 0};
    var beltTex = null;            // 传送带滚动纹理
    var line = null;               // 当前产线对象集合
    var products = [];             // 流动产品 {mesh, d}
    var beltLen = 0;
    var raf = null;

    function statusColor(yld) {
        if (yld >= 98) return 0x18b88a;     // 优 绿
        if (yld >= 95) return 0x2f7bff;     // 良 蓝
        if (yld >= 90) return 0xffb300;     // 注意 琥珀
        return 0xff5c5c;                     // 异常 红
    }

    /* ============================ 场景初始化 ============================ */

    function init() {
        var stage = document.getElementById('stage');

        scene = new THREE.Scene();
        scene.fog = new THREE.Fog(0xeef2f7, 420, 1100);

        camera = new THREE.PerspectiveCamera(42, window.innerWidth / window.innerHeight, 1, 5000);
        camera.position.set(260, 210, 320);

        renderer = new THREE.WebGLRenderer({antialias: true});
        renderer.setPixelRatio(window.devicePixelRatio || 1);
        renderer.setSize(window.innerWidth, window.innerHeight);
        renderer.setClearColor(0xeef2f7, 1);
        renderer.shadowMap.enabled = true;
        renderer.shadowMap.type = THREE.PCFSoftShadowMap;
        if ('gammaOutput' in renderer) { renderer.gammaOutput = true; renderer.gammaFactor = 2.2; }
        stage.appendChild(renderer.domElement);

        // 灯光：半球环境光 + 主平行光（软阴影）+ 反向补光
        scene.add(new THREE.HemisphereLight(0xffffff, 0xdde4ee, 0.95));
        var key = new THREE.DirectionalLight(0xffffff, 0.7);
        key.position.set(220, 340, 200);
        key.castShadow = true;
        key.shadow.mapSize.width = 2048;
        key.shadow.mapSize.height = 2048;
        key.shadow.bias = -0.0004;
        var c = key.shadow.camera;
        c.left = -700; c.right = 700; c.top = 400; c.bottom = -400; c.near = 1; c.far = 1400;
        c.updateProjectionMatrix();
        scene.add(key);
        var fill = new THREE.DirectionalLight(0xeaf0ff, 0.28);
        fill.position.set(-260, 180, -180);
        scene.add(fill);

        // 深色地板（浅色背景中的深色「舞台」地面）+ 发光科技网格
        var ground = new THREE.Mesh(
            new THREE.PlaneGeometry(3000, 2000),
            new THREE.MeshStandardMaterial({color: 0x1b2330, roughness: 0.82, metalness: 0.18})
        );
        ground.rotation.x = -Math.PI / 2;
        ground.receiveShadow = true;
        scene.add(ground);
        // 深色地板上的网格：中心线偏青、网格线偏蓝灰，低透明度
        var grid = new THREE.GridHelper(3000, 60, 0x4aa3e0, 0x33405a);
        grid.position.y = 0.1;
        if (grid.material) { grid.material.opacity = 0.5; grid.material.transparent = true; }
        scene.add(grid);

        // 控制器
        controls = new THREE.OrbitControls(camera, renderer.domElement);
        controls.enableDamping = true;
        controls.dampingFactor = 0.08;
        controls.maxPolarAngle = Math.PI / 2.08;
        controls.minDistance = 160;
        controls.maxDistance = 1100;
        controls.target.set(0, 22, 0);
        controls.update();

        window.addEventListener('resize', onResize, false);

        clock.last = now();
        animate();
    }

    function onResize() {
        camera.aspect = window.innerWidth / window.innerHeight;
        camera.updateProjectionMatrix();
        renderer.setSize(window.innerWidth, window.innerHeight);
    }

    function now() {
        return (typeof performance !== 'undefined' && performance.now) ? performance.now() : Date.now();
    }

    /* ============================ 传送带滚动纹理 ============================ */

    function makeBeltTexture() {
        var cv = document.createElement('canvas');
        cv.width = 64; cv.height = 64;
        var g = cv.getContext('2d');
        g.fillStyle = '#3b434e';
        g.fillRect(0, 0, 64, 64);
        // 斜向输送纹路
        g.strokeStyle = 'rgba(255,255,255,0.16)';
        g.lineWidth = 6;
        for (var i = -64; i < 128; i += 22) {
            g.beginPath();
            g.moveTo(i, 0);
            g.lineTo(i + 32, 64);
            g.stroke();
        }
        var tex = new THREE.CanvasTexture(cv);
        tex.wrapS = tex.wrapT = THREE.RepeatWrapping;
        return tex;
    }

    /* ============================ 悬浮工位标牌 ============================ */

    function roundRect(g, x, y, w, h, r) {
        g.beginPath();
        g.moveTo(x + r, y);
        g.arcTo(x + w, y, x + w, y + h, r);
        g.arcTo(x + w, y + h, x, y + h, r);
        g.arcTo(x, y + h, x, y, r);
        g.arcTo(x, y, x + w, y, r);
        g.closePath();
    }

    function makeLabel(name, yld, colorHex) {
        var cv = document.createElement('canvas');
        cv.width = 256; cv.height = 128;
        drawLabel(cv, name, yld, colorHex);
        var tex = new THREE.CanvasTexture(cv);
        var sp = new THREE.Sprite(new THREE.SpriteMaterial({map: tex, transparent: true, depthTest: false}));
        sp.scale.set(48, 24, 1);
        sp.userData.canvas = cv;
        sp.userData.tex = tex;
        return sp;
    }

    function drawLabel(cv, name, yld, colorHex) {
        var g = cv.getContext('2d');
        g.clearRect(0, 0, 256, 128);
        // 卡片底
        g.fillStyle = 'rgba(255,255,255,0.92)';
        roundRect(g, 8, 8, 240, 96, 18);
        g.fill();
        g.lineWidth = 2;
        g.strokeStyle = 'rgba(150,170,200,0.5)';
        g.stroke();
        // 顶部状态条
        g.fillStyle = '#' + ('000000' + colorHex.toString(16)).slice(-6);
        roundRect(g, 8, 8, 240, 14, 7);
        g.fill();
        // 工位名
        g.fillStyle = '#1c2b3a';
        g.font = 'bold 34px "PingFang SC","Microsoft YaHei",sans-serif';
        g.textAlign = 'center';
        g.fillText(name, 128, 62);
        // 良率
        g.fillStyle = '#' + ('000000' + colorHex.toString(16)).slice(-6);
        g.font = 'bold 26px "PingFang SC",sans-serif';
        g.fillText('良率 ' + yld + '%', 128, 92);
    }

    /* ============================ 产线建模 ============================ */

    function disposeLine() {
        if (line) { scene.remove(line); }
        line = null;
        products = [];
    }

    function buildLine(stations) {
        disposeLine();
        var grp = new THREE.Group();
        var n = stations.length;
        beltLen = (n + 1) * SPACING;
        var half = beltLen / 2;

        // —— 传送带 ——
        beltTex = makeBeltTexture();
        beltTex.repeat.set(beltLen / 20, 1);
        var belt = new THREE.Mesh(
            new THREE.BoxGeometry(beltLen, 4, BELT_W),
            new THREE.MeshStandardMaterial({map: beltTex, color: 0xffffff, roughness: 0.72, metalness: 0.1})
        );
        belt.position.y = BELT_TOP - 2;
        belt.castShadow = true;
        belt.receiveShadow = true;
        grp.add(belt);

        // 侧导轨
        var railMat = new THREE.MeshStandardMaterial({color: 0xb9c2cc, metalness: 0.6, roughness: 0.35});
        for (var sgn = -1; sgn <= 1; sgn += 2) {
            var rail = new THREE.Mesh(new THREE.BoxGeometry(beltLen, 3, 2), railMat);
            rail.position.set(0, BELT_TOP + 0.5, sgn * (BELT_W / 2 + 1));
            rail.castShadow = true;
            grp.add(rail);
        }

        // 支腿
        var legMat = new THREE.MeshStandardMaterial({color: 0x9aa6b2, metalness: 0.5, roughness: 0.5});
        for (var lx = -half + SPACING / 2; lx <= half; lx += SPACING) {
            for (var lz = -1; lz <= 1; lz += 2) {
                var leg = new THREE.Mesh(new THREE.CylinderGeometry(2, 2, BELT_TOP - 2, 12), legMat);
                leg.position.set(lx, (BELT_TOP - 2) / 2, lz * (BELT_W / 2 - 2));
                leg.castShadow = true;
                grp.add(leg);
            }
        }

        // —— 工位 ——
        grp.userData.stations = [];
        for (var i = 0; i < n; i++) {
            var st = stations[i];
            var x = -half + (i + 1) * SPACING;
            var side = (i % 2 === 0) ? 1 : -1;
            var col = statusColor(Number(st.yield) || 0);
            var node = buildStation(grp, x, side, st, col);
            grp.userData.stations.push(node);
        }

        // —— 流动产品 ——
        var pc = Math.max(6, n * 2);
        var pMat = new THREE.MeshStandardMaterial({color: 0xcfe0f5, metalness: 0.15, roughness: 0.55, emissive: 0x16314f, emissiveIntensity: 0.12});
        for (var k = 0; k < pc; k++) {
            var pm = new THREE.Mesh(new THREE.BoxGeometry(PRODUCT, PRODUCT, PRODUCT), pMat);
            pm.castShadow = true;
            grp.add(pm);
            products.push({mesh: pm, d: (beltLen / pc) * k});
        }

        scene.add(grp);
        line = grp;
        frameCamera();
    }

    function buildStation(grp, x, side, st, col) {
        var node = {x: x, phase: Math.random() * Math.PI * 2};

        // 机柜
        var cab = new THREE.Mesh(
            new THREE.BoxGeometry(36, 30, 30),
            new THREE.MeshStandardMaterial({color: 0xfdfefe, metalness: 0.2, roughness: 0.5})
        );
        cab.position.set(x, 15, side * 32);
        cab.castShadow = true;
        cab.receiveShadow = true;
        grp.add(cab);

        // 顶部状态条
        var topMat = new THREE.MeshStandardMaterial({color: col, emissive: col, emissiveIntensity: 0.4, metalness: 0.3, roughness: 0.4});
        var topBar = new THREE.Mesh(new THREE.BoxGeometry(36.4, 3, 30.4), topMat);
        topBar.position.set(x, 31, side * 32);
        grp.add(topBar);
        node.topBar = topBar;

        // 状态灯
        var lampMat = new THREE.MeshStandardMaterial({color: col, emissive: col, emissiveIntensity: 1.1});
        var lamp = new THREE.Mesh(new THREE.SphereGeometry(2.4, 14, 12), lampMat);
        lamp.position.set(x, 36, side * 32);
        grp.add(lamp);
        node.lamp = lamp;

        // 龙门：两立柱 + 横梁
        var frameMat = new THREE.MeshStandardMaterial({color: 0xc3ccd6, metalness: 0.55, roughness: 0.4});
        for (var pz = -1; pz <= 1; pz += 2) {
            var post = new THREE.Mesh(new THREE.CylinderGeometry(2, 2, 52, 14), frameMat);
            post.position.set(x, 26, pz * 36);
            post.castShadow = true;
            grp.add(post);
        }
        var beam = new THREE.Mesh(new THREE.BoxGeometry(6, 4, 78), frameMat);
        beam.position.set(x, 52, 0);
        beam.castShadow = true;
        grp.add(beam);
        // 横梁上的彩色指示带
        var beamAccent = new THREE.Mesh(new THREE.BoxGeometry(6.6, 1.6, 78), new THREE.MeshStandardMaterial({color: col, emissive: col, emissiveIntensity: 0.5}));
        beamAccent.position.set(x, 54, 0);
        grp.add(beamAccent);

        // 升降工具头（取放动作）
        var tool = new THREE.Group();
        tool.position.set(x, 44, 0);
        var head = new THREE.Mesh(new THREE.BoxGeometry(9, 16, 9), new THREE.MeshStandardMaterial({color: 0x556070, metalness: 0.6, roughness: 0.35}));
        head.castShadow = true;
        tool.add(head);
        for (var gz = -1; gz <= 1; gz += 2) {
            var grip = new THREE.Mesh(new THREE.BoxGeometry(2.4, 7, 2.4), new THREE.MeshStandardMaterial({color: 0x39424e, metalness: 0.5, roughness: 0.5}));
            grip.position.set(0, -10, gz * 3.2);
            tool.add(grip);
        }
        grp.add(tool);
        node.tool = tool;

        // 悬浮标牌
        var label = makeLabel(st.name || st.oper || ('工位' + st.seq), Number(st.yield) || 0, col);
        label.position.set(x, 72, 0);
        grp.add(label);
        node.label = label;

        return node;
    }

    function frameCamera() {
        var d = Math.max(280, beltLen * 0.62);
        camera.position.set(beltLen * 0.34, d * 0.62 + 40, d * 0.74 + 90);
        controls.minDistance = d * 0.45;
        controls.maxDistance = d * 2.4;
        controls.target.set(0, 24, 0);
        controls.update();
    }

    /* ============================ 动画 ============================ */

    function animate() {
        raf = requestAnimationFrame(animate);
        var t = now();
        var dt = (t - clock.last) / 1000;
        clock.last = t;
        if (dt > 0.1) dt = 0.1;
        var ts = t / 1000;

        // 传送带滚动
        if (beltTex) beltTex.offset.x -= dt * 0.6;

        // 产品流动
        if (line && beltLen > 0) {
            for (var i = 0; i < products.length; i++) {
                var p = products[i];
                p.d += dt * 46;
                if (p.d > beltLen) p.d -= beltLen;
                p.mesh.position.set(-beltLen / 2 + p.d, BELT_TOP + PRODUCT / 2, 0);
            }
            // 工具头取放 + 状态灯呼吸
            var sts = line.userData.stations || [];
            for (var j = 0; j < sts.length; j++) {
                var s = sts[j];
                if (s.tool) s.tool.position.y = 38 + (Math.sin(ts * 1.7 + s.phase) * 0.5 + 0.5) * 12;
                if (s.lamp) s.lamp.material.emissiveIntensity = 0.7 + (Math.sin(ts * 2.2 + s.phase) * 0.5 + 0.5) * 0.7;
            }
        }

        controls.update();
        renderer.render(scene, camera);
    }

    /* ============================ 数据 ============================ */

    function updateData(data) {
        if (!data) return;
        var stations = data.stations || [];
        var kpis = data.kpis || {};
        var orders = data.orders || [];

        // 顶部
        var nameEl = document.getElementById('lineName');
        if (nameEl && data.lineName) nameEl.textContent = data.lineName;
        var badge = document.getElementById('demoBadge');
        if (badge) badge.style.display = data.demo ? 'inline-block' : 'none';

        // KPI
        setText('kpiYield', (kpis.yieldRate != null ? kpis.yieldRate : 0), '%');
        setText('kpiWip', (kpis.wip != null ? kpis.wip : 0));
        setText('kpiTakt', (kpis.takt != null ? kpis.takt : 0), 's');
        setText('kpiOutput', (kpis.dayOutput != null ? kpis.dayOutput : 0));

        // 工单达成
        var html = '';
        for (var i = 0; i < orders.length; i++) {
            var o = orders[i];
            var rate = Math.max(0, Math.min(100, Number(o.rate) || 0));
            html += '<div class="row">'
                + '<div class="t"><b>' + esc(o.orderCode || '') + '</b>'
                + '<span>' + esc(o.desc || '') + '</span>'
                + '<span class="pct">' + rate + '%</span></div>'
                + '<div class="bar"><i style="width:' + rate + '%"></i></div>'
                + '</div>';
        }
        var ol = document.getElementById('orderList');
        if (ol) ol.innerHTML = html || '<div class="row"><div class="t"><span>暂无工单</span></div></div>';

        // 产线：工位数变化则重建，否则只更新标牌/状态色
        if (!line || (line.userData.stations || []).length !== stations.length) {
            buildLine(stations);
        } else {
            var nodes = line.userData.stations;
            for (var k = 0; k < nodes.length; k++) {
                var st = stations[k];
                var col = statusColor(Number(st.yield) || 0);
                var node = nodes[k];
                node.topBar.material.color.setHex(col);
                node.topBar.material.emissive.setHex(col);
                node.lamp.material.color.setHex(col);
                node.lamp.material.emissive.setHex(col);
                drawLabel(node.label.userData.canvas, st.name || st.oper || ('工位' + st.seq), Number(st.yield) || 0, col);
                node.label.userData.tex.needsUpdate = true;
            }
        }

        var loading = document.getElementById('loading');
        if (loading) loading.classList.add('hide');
    }

    function setText(id, val, unit) {
        var el = document.getElementById(id);
        if (!el) return;
        el.innerHTML = val + (unit ? '<span class="u">' + unit + '</span>' : '');
    }

    function esc(s) {
        return String(s).replace(/[&<>"]/g, function (c) {
            return {'&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;'}[c];
        });
    }

    function loadData() {
        $.ajax({
            url: window.PRODUCTION_LINE_DATA_URL,
            type: 'POST',
            dataType: 'json',
            success: function (res) {
                if (res && res.code === 0 && res.data) {
                    try { updateData(res.data); } catch (e) { if (window.console) console.error(e); }
                }
            },
            error: function () {
                var loading = document.getElementById('loading');
                if (loading) loading.textContent = '数据接口不可用，请重启应用后重试';
            }
        });
    }

    /* ============================ 时钟 ============================ */

    function tickClock() {
        var el = document.getElementById('clock');
        if (!el) return;
        var d = new Date();
        function p(n) { return (n < 10 ? '0' : '') + n; }
        el.textContent = d.getFullYear() + '-' + p(d.getMonth() + 1) + '-' + p(d.getDate())
            + ' ' + p(d.getHours()) + ':' + p(d.getMinutes()) + ':' + p(d.getSeconds());
    }

    /* ============================ 启动 ============================ */

    function start() {
        try {
            init();
            loadData();
            tickClock();
            setInterval(tickClock, 1000);
            setInterval(loadData, 30000);
        } catch (e) {
            if (window.console) console.error('生产线 3D 初始化失败：', e);
            var loading = document.getElementById('loading');
            if (loading) loading.textContent = '3D 初始化失败：' + (e && e.message ? e.message : e);
        }
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', start);
    } else {
        start();
    }
})();
