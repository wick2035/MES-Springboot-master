<!DOCTYPE html>
<html>
<head includeDefault="true">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0">
    <title>黑科3D数字仿真</title>
    <style>
        body {
            margin: 0;
            overflow: hidden;
        }

        #label {
            position: absolute;
            padding: 10px;
            background: rgba(255, 255, 255, 0.6);
            line-height: 1;
            border-radius: 5px;
        }

        #video {
            position: absolute;
            width: 0;
            height: 0;
        }

        #wh-selector {
            position: absolute;
            top: 10px;
            left: 50%;
            transform: translateX(-50%);
            z-index: 999;
            background: rgba(255, 255, 255, 0.85);
            padding: 6px 12px;
            border-radius: 6px;
            box-shadow: 0 1px 6px rgba(0, 0, 0, 0.2);
            font-size: 14px;
        }

        #wh-selector select {
            height: 30px;
            min-width: 220px;
            border: 1px solid #ccc;
            border-radius: 4px;
            padding: 0 6px;
        }

        #wh-empty-tip {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            z-index: 998;
            color: #fff;
            background: rgba(0, 0, 0, 0.45);
            padding: 14px 20px;
            border-radius: 6px;
            font-size: 16px;
            display: none;
        }
    </style>

    <script type="text/javascript" src="${request.contextPath}/lib/ThreeJs/js/three.js"></script>
    <script type="text/javascript" src="${request.contextPath}/lib/ThreeJs/js/stats.min.js"></script>
    <script type="text/javascript" src="${request.contextPath}/lib/ThreeJs/js/DragControls.js"></script>
    <script type="text/javascript" src="${request.contextPath}/lib/ThreeJs/js/OrbitControls.js"></script>
    <script type="text/javascript" src="${request.contextPath}/lib/ThreeJs/js/FirstPersonControls.js"></script>
    <script type="text/javascript" src="${request.contextPath}/lib/ThreeJs/js/TransformControls.js"></script>
    <script type="text/javascript" src="${request.contextPath}/lib/ThreeJs/js/dat.gui.min.js"></script>
    <script type="text/javascript" src="${request.contextPath}/lib/ThreeJs/js/EffectComposer.js"></script>
    <script type="text/javascript" src="${request.contextPath}/lib/ThreeJs/js/RenderPass.js"></script>
    <script type="text/javascript" src="${request.contextPath}/lib/ThreeJs/js/OutlinePass.js"></script>
    <script type="text/javascript" src="${request.contextPath}/lib/ThreeJs/js/FXAAShader.js"></script>
    <script type="text/javascript" src="${request.contextPath}/lib/ThreeJs/js/CopyShader.js"></script>
    <script type="text/javascript" src="${request.contextPath}/lib/ThreeJs/js/ShaderPass.js"></script>
    <script type="text/javascript" src="${request.contextPath}/lib/ThreeJs/js/ThreeBSP.js"></script>
    <script type="text/javascript" src="${request.contextPath}/lib/ThreeJs/ThreeJs_Drag.js" charset="UTF-8"></script>
    <script type="text/javascript" src="${request.contextPath}/lib/ThreeJs/ThreeJs_Composer.js"
            charset="UTF-8"></script>
    <script type="text/javascript" src="${request.contextPath}/lib/ThreeJs/Modules.js" charset="UTF-8"></script>
    <script type="text/javascript" src="${request.contextPath}/lib/ThreeJs/js/Tween.js"></script>
    <script type="text/javascript" src="${request.contextPath}/lib/jquery/jquery.min.js"></script>
    <script type="text/javascript" src="${request.contextPath}/lib/echarts/echarts.min.js"></script>
    <script type="text/javascript" src="${request.contextPath}/lib/ThreeJs/config.js"></script>
</head>

<body>
<div id="wh-selector">
    库房：
    <select id="js-wh-select"></select>
</div>
<div id="wh-empty-tip">该库房暂无库位/库存数据，或尚未选择库房</div>
<div id="label"></div>
<div id="container"></div>
<video id="video" autoplay loop muted>
    <source src="${request.contextPath}/video/videoPlane.mp4">
</video>

<script>

    // 全局错误捕获：把任何脚本错误显示到页面中央，便于排查 3D 不显示问题
    window.onerror = function (msg, src, line, col) {
        var tip = document.getElementById('wh-empty-tip');
        if (tip) {
            tip.style.display = 'block';
            tip.textContent = '脚本错误：' + msg + ' @' + (src || '') + ':' + line;
        }
    };

    var stats = initStats();
    var scene, camera, renderer, controls, light, composer, transformControls, options;
    var matArrayA = []; //内墙
    var matArrayB = []; //外墙
    var wallTex; //墙面工业墙板纹理（程序化生成）
    var group = new THREE.Group();

    // 初始化场景
    function initScene() {
        scene = new THREE.Scene();
    }

    // 初始化相机
    function initCamera() {
        camera = new THREE.PerspectiveCamera(45, window.innerWidth / window.innerHeight, 0.1, 10000);
        camera.position.set(0, 50, 200);
    }

    // 初始化灯光
    function initLight() {
        var directionalLight = new THREE.DirectionalLight(0xffffff, 0.3); //模拟远处类似太阳的光源
        directionalLight.color.setHSL(0.1, 1, 0.95);
        directionalLight.position.set(0, 200, 0).normalize();
        scene.add(directionalLight);

        var ambient = new THREE.AmbientLight(0xffffff, 1); //AmbientLight,影响整个场景的光源
        ambient.position.set(0, 0, 0);
        scene.add(ambient);
    }

    // 初始化性能插件
    function initStats() {
        var stats = new Stats();

        stats.domElement.style.position = 'absolute';
        stats.domElement.style.left = '0px';
        stats.domElement.style.top = '0px';

        document.body.appendChild(stats.domElement);
        return stats;
    }

    // 初始化GUI
    function initGui() {
        options = new function () {
            this.matName = '';
            this.batchNo = '';
            this.qty = '';
            this.qtyUom = '';
        };
        var gui = new dat.GUI();
        gui.domElement.style = 'position:absolute;top:10px;right:0px;height:600px';
        gui.add(options, 'matName').name("物料名称：").listen();
        gui.add(options, 'batchNo').name("批号：").listen();
        gui.add(options, 'qty').name("数量：").listen();
        gui.add(options, 'qtyUom').name("单位：").listen();
    }

    // 初始化渲染器
    function initRenderer() {
        renderer = new THREE.WebGLRenderer({
            antialias: true
        });
        renderer.setSize(window.innerWidth, window.innerHeight);
        renderer.setClearColor(0x4682B4, 1.0);
        document.body.appendChild(renderer.domElement);
    }

    //创建地板
    function createFloor() {
        var loader = new THREE.TextureLoader();
        loader.load("/lib/ThreeJs/images/floor.jpg", function (texture) {
            texture.wrapS = texture.wrapT = THREE.RepeatWrapping;
            texture.repeat.set(10, 10);
            var floorGeometry = new THREE.BoxGeometry(2600, 1400, 1);
            var floorMaterial = new THREE.MeshBasicMaterial({
                map: texture,
            });
            var floor = new THREE.Mesh(floorGeometry, floorMaterial);
            floor.rotation.x = -Math.PI / 2;
            floor.name = "地面";
            scene.add(floor);
        });
    }

    //创建墙
    function createCubeWall(width, height, depth, angle, material, x, y, z, name) {
        var cubeGeometry = new THREE.BoxGeometry(width, height, depth);
        var cube = new THREE.Mesh(cubeGeometry, material);
        cube.position.x = x;
        cube.position.y = y;
        cube.position.z = z;
        cube.rotation.y += angle * Math.PI; //-逆时针旋转,+顺时针
        cube.name = name;
        scene.add(cube);
    }

    //创建门_左侧
    function createDoor_left(width, height, depth, angle, x, y, z, name) {
        var loader = new THREE.TextureLoader();
        loader.load("/lib/ThreeJs/images/door_left.png", function (texture) {
            var doorgeometry = new THREE.BoxGeometry(width, height, depth);
            doorgeometry.translate(50, 0, 0);
            var doormaterial = new THREE.MeshBasicMaterial({
                map: texture,
                color: 0xffffff
            });
            doormaterial.opacity = 1.0;
            doormaterial.transparent = true;
            var door = new THREE.Mesh(doorgeometry, doormaterial);
            door.position.set(x, y, z);
            door.rotation.y += angle * Math.PI; //-逆时针旋转,+顺时针
            door.name = name;
            scene.add(door);
        });
    }

    //创建门_右侧
    function createDoor_right(width, height, depth, angle, x, y, z, name) {
        var loader = new THREE.TextureLoader();
        loader.load("/lib/ThreeJs/images/door_right.png", function (texture) {
            var doorgeometry = new THREE.BoxGeometry(width, height, depth);
            doorgeometry.translate(-50, 0, 0);
            var doormaterial = new THREE.MeshBasicMaterial({
                map: texture,
                color: 0xffffff
            });
            doormaterial.opacity = 1.0;
            doormaterial.transparent = true;
            var door = new THREE.Mesh(doorgeometry, doormaterial);
            door.position.set(x, y, z);
            door.rotation.y += angle * Math.PI; //-逆时针旋转,+顺时针8
            door.name = name;
            scene.add(door);
        });
    }

    //创建窗户
    function createWindow(width, height, depth, angle, x, y, z, name) {
        var loader = new THREE.TextureLoader();
        loader.load("/lib/ThreeJs/images/window.png", function (texture) {
            var windowgeometry = new THREE.BoxGeometry(width, height, depth);
            var windowmaterial = new THREE.MeshBasicMaterial({
                map: texture,
                color: 0xffffff
            });
            windowmaterial.opacity = 1.0;
            windowmaterial.transparent = true;
            var windows = new THREE.Mesh(windowgeometry, windowmaterial);
            windows.position.set(x, y, z);
            windows.rotation.y += angle * Math.PI; //-逆时针旋转,+顺时针
            windows.name = name;
            scene.add(windows);
        });
    }

    //返回墙对象
    function returnWallObject(width, height, depth, angle, material, x, y, z, name) {
        var cubeGeometry = new THREE.BoxGeometry(width, height, depth);
        var cube = new THREE.Mesh(cubeGeometry, material);
        cube.position.x = x;
        cube.position.y = y;
        cube.position.z = z;
        cube.rotation.y += angle * Math.PI;
        cube.name = name;
        return cube;
    }

    //墙上挖门，通过两个几何体生成BSP对象
    function createResultBsp(bsp, objects_cube) {
        var material = new THREE.MeshPhongMaterial({
            color: 0xffffff,
            map: wallTex,
            specular: 0x9cb2d1,
            shininess: 30,
            transparent: true,
            opacity: 1
        });
        var BSP = new ThreeBSP(bsp);
        for (var i = 0; i < objects_cube.length; i++) {
            var less_bsp = new ThreeBSP(objects_cube[i]);
            BSP = BSP.subtract(less_bsp);
        }
        var result = BSP.toMesh(material);
        result.material.flatshading = THREE.FlatShading;
        result.geometry.computeFaceNormals(); //重新计算几何体侧面法向量
        result.geometry.computeVertexNormals();
        result.material.needsUpdate = true; //更新纹理
        result.geometry.buffersNeedUpdate = true;
        result.geometry.uvsNeedUpdate = true;
        scene.add(result);
    }

    //程序化生成工业墙板纹理：浅色底 + 面板接缝 + 企业蓝横向饰带
    function createWallTexture() {
        var c = document.createElement('canvas');
        c.width = 512;
        c.height = 512;
        var ctx = c.getContext('2d');
        //底色
        ctx.fillStyle = '#c2d0da';
        ctx.fillRect(0, 0, 512, 512);
        //竖向面板接缝
        ctx.strokeStyle = 'rgba(120,140,155,0.55)';
        ctx.lineWidth = 3;
        for (var x = 0; x <= 512; x += 64) {
            ctx.beginPath();
            ctx.moveTo(x, 0);
            ctx.lineTo(x, 512);
            ctx.stroke();
        }
        //横向面板接缝
        ctx.strokeStyle = 'rgba(120,140,155,0.30)';
        ctx.lineWidth = 2;
        for (var y = 0; y <= 512; y += 128) {
            ctx.beginPath();
            ctx.moveTo(0, y);
            ctx.lineTo(512, y);
            ctx.stroke();
        }
        //企业蓝横向饰带
        ctx.fillStyle = '#2f6fb0';
        ctx.fillRect(0, 232, 512, 48);
        ctx.fillStyle = 'rgba(255,255,255,0.25)';
        ctx.fillRect(0, 232, 512, 6);
        var tex = new THREE.CanvasTexture(c);
        tex.wrapS = tex.wrapT = THREE.RepeatWrapping;
        tex.repeat.set(6, 1); //横向平铺，纵向保留单条饰带
        return tex;
    }

    //创建墙纹理
    function createWallMaterail() {
        wallTex = createWallTexture();
        matArrayA.push(new THREE.MeshPhongMaterial({color: 0xafc0ca}));  //前  0xafc0ca :灰色
        matArrayA.push(new THREE.MeshPhongMaterial({color: 0xafc0ca}));  //后
        matArrayA.push(new THREE.MeshPhongMaterial({color: 0xd6e4ec}));  //上  0xd6e4ec： 偏白色
        matArrayA.push(new THREE.MeshPhongMaterial({color: 0xd6e4ec}));  //下
        matArrayA.push(new THREE.MeshPhongMaterial({color: 0xafc0ca}));  //左    0xafc0ca :灰色
        matArrayA.push(new THREE.MeshPhongMaterial({color: 0xafc0ca}));  //右

        matArrayB.push(new THREE.MeshPhongMaterial({color: 0xafc0ca}));  //前  0xafc0ca :灰色
        matArrayB.push(new THREE.MeshPhongMaterial({color: 0x9cb2d1}));  //后  0x9cb2d1：淡紫
        matArrayB.push(new THREE.MeshPhongMaterial({color: 0xd6e4ec}));  //上  0xd6e4ec： 偏白色
        matArrayB.push(new THREE.MeshPhongMaterial({color: 0xd6e4ec}));  //下
        matArrayB.push(new THREE.MeshPhongMaterial({color: 0xafc0ca}));  //左   0xafc0ca :灰色
        matArrayB.push(new THREE.MeshPhongMaterial({color: 0xafc0ca}));  //右

        //为各面挂上墙板纹理，色调改为白色让纹理(含企业色饰带)正常呈现
        var allMats = matArrayA.concat(matArrayB);
        for (var i = 0; i < allMats.length; i++) {
            allMats[i].map = wallTex;
            allMats[i].color.set(0xffffff);
            allMats[i].needsUpdate = true;
        }
    }

    //踢脚线 + 顶部饰条（沿房间内周）
    function addTrimRing(yy, hh, col, includeFront) {
        var mat = new THREE.MeshPhongMaterial({color: col});
        var geoX = new THREE.BoxGeometry(2590, hh, 6);
        var back = new THREE.Mesh(geoX, mat);
        back.position.set(0, yy, -695);
        back.name = '装饰条';
        scene.add(back);
        if (includeFront) {
            var front = new THREE.Mesh(geoX, mat);
            front.position.set(0, yy, 695);
            front.name = '装饰条';
            scene.add(front);
        }
        var geoZ = new THREE.BoxGeometry(6, hh, 1390);
        var left = new THREE.Mesh(geoZ, mat);
        left.position.set(-1290, yy, 0);
        left.name = '装饰条';
        scene.add(left);
        var right = new THREE.Mesh(geoZ, mat);
        right.position.set(1290, yy, 0);
        right.name = '装饰条';
        scene.add(right);
    }

    function createWallTrim() {
        addTrimRing(12, 24, 0x37474f, false);  //踢脚线（深色，前墙有门洞故省略前侧）
        addTrimRing(188, 16, 0x2f6fb0, true);  //顶部饰条（企业蓝，四面齐全）
    }

    //墙面标牌（库房名 + 安全标语）
    function createWallSign(text, x, y, z, rotY) {
        var c = document.createElement('canvas');
        c.width = 1024;
        c.height = 256;
        var ctx = c.getContext('2d');
        ctx.fillStyle = '#1f3a5f';
        ctx.fillRect(0, 0, 1024, 256);
        ctx.strokeStyle = '#ffd54f';
        ctx.lineWidth = 12;
        ctx.strokeRect(10, 10, 1004, 236);
        ctx.fillStyle = '#ffffff';
        ctx.font = 'bold 76px "Microsoft YaHei", SimHei, sans-serif';
        ctx.textAlign = 'center';
        ctx.textBaseline = 'middle';
        ctx.fillText(text, 512, 132);
        var tex = new THREE.CanvasTexture(c);
        var mat = new THREE.MeshBasicMaterial({map: tex, transparent: true, side: THREE.DoubleSide});
        var mesh = new THREE.Mesh(new THREE.PlaneGeometry(400, 100), mat);
        mesh.position.set(x, y, z);
        mesh.rotation.y = rotY;
        mesh.name = '标牌';
        scene.add(mesh);
    }


    // 初始化模型
    function initContent() {
        createFloor();
        createWallMaterail();
        createCubeWall(10, 200, 1400, 0, matArrayB, -1295, 100, 0, "墙面");
        createCubeWall(10, 200, 1400, 1, matArrayB, 1295, 100, 0, "墙面");
        createCubeWall(10, 200, 2600, 1.5, matArrayB, 0, 100, -700, "墙面");
        //创建挖了门的墙
        var wall = returnWallObject(2600, 200, 10, 0, matArrayB, 0, 100, 700, "墙面");
        var door_cube1 = returnWallObject(200, 180, 10, 0, matArrayB, -600, 90, 700, "前门1");
        var door_cube2 = returnWallObject(200, 180, 10, 0, matArrayB, 600, 90, 700, "前门2");
        var window_cube1 = returnWallObject(100, 100, 10, 0, matArrayB, -900, 90, 700, "窗户1");
        var window_cube2 = returnWallObject(100, 100, 10, 0, matArrayB, 900, 90, 700, "窗户2");
        var window_cube3 = returnWallObject(100, 100, 10, 0, matArrayB, -200, 90, 700, "窗户3");
        var window_cube4 = returnWallObject(100, 100, 10, 0, matArrayB, 200, 90, 700, "窗户4");
        var objects_cube = [];
        objects_cube.push(door_cube1);
        objects_cube.push(door_cube2);
        objects_cube.push(window_cube1);
        objects_cube.push(window_cube2);
        objects_cube.push(window_cube3);
        objects_cube.push(window_cube4);
        createResultBsp(wall, objects_cube);
        //为墙面安装门
        createDoor_left(100, 180, 2, 0, -700, 90, 700, "左门1");
        createDoor_right(100, 180, 2, 0, -500, 90, 700, "右门1");
        createDoor_left(100, 180, 2, 0, 500, 90, 700, "左门2");
        createDoor_right(100, 180, 2, 0, 700, 90, 700, "右门2");
        //为墙面安装窗户
        createWindow(100, 100, 2, 0, -900, 90, 700, "窗户");
        createWindow(100, 100, 2, 0, 900, 90, 700, "窗户");
        createWindow(100, 100, 2, 0, -200, 90, 700, "窗户");
        createWindow(100, 100, 2, 0, 200, 90, 700, "窗户");

        //墙面设计增强：踢脚线/顶部饰条 + 滚动标语横幅 + 库房名标牌
        createWallTrim();
        addRollPlane(scene);
        var signName = (window.sceneWarehouse && window.sceneWarehouse.warehouseName) ? window.sceneWarehouse.warehouseName : '智能仓库';
        createWallSign(signName + ' · 安全生产 重地', -1289, 150, 0, Math.PI / 2);
    }

    // 初始化轨迹球控件
    function initControls() {
        controls = new THREE.OrbitControls(camera, renderer.domElement);
        controls.enableDamping = true;
        controls.dampingFactor = 0.5;
        // 视角最小距离
        controls.minDistance = 100;
        // 视角最远距离
        controls.maxDistance = 1000;
        // 最大角度
        controls.maxPolarAngle = Math.PI / 2.2;
        controls.target = new THREE.Vector3(50, 50, 0);
    }

    //按物料(品类)汇总真实库存数量，降序；超过 topN 合并为"其他"
    function computeMaterielStat(topN) {
        var invs = window.sceneInventories || [];
        var sums = {};
        for (var i = 0; i < invs.length; i++) {
            var nm = invs[i].materielDesc || invs[i].materielCode || '未知物料';
            sums[nm] = (sums[nm] || 0) + (Number(invs[i].qty) || 0);
        }
        var arr = [];
        for (var k in sums) {
            if (sums.hasOwnProperty(k)) arr.push({name: k, value: sums[k]});
        }
        arr.sort(function (a, b) {
            return b.value - a.value;
        });
        if (topN && arr.length > topN) {
            var top = arr.slice(0, topN);
            var other = 0;
            for (var r = topN; r < arr.length; r++) other += arr[r].value;
            if (other > 0) top.push({name: '其他', value: other});
            return top;
        }
        return arr;
    }

    //大屏风格调色板
    var CHART_PALETTE = ['#00d4ff', '#37e0a0', '#ffd166', '#ff7b9c', '#a78bfa', '#5b9bff', '#ff9f43', '#4dd0e1', '#f78fb3', '#9ccc65'];

    function initEcharts() {
        var matStat = computeMaterielStat(8);
        var whName = (window.sceneWarehouse && window.sceneWarehouse.warehouseName) ? window.sceneWarehouse.warehouseName : '';
        var hasData = matStat.length > 0;

        //柱状图：各物料(品类)库存 Top —— 横向条形，长中文名也能完整显示
        pieChart = echarts.init($("<canvas width='1024' height='1024'></canvas>")[0]);
        var barNames = hasData ? matStat.map(function (d) { return d.name; }) : ['暂无库存'];
        var barVals = hasData ? matStat.map(function (d) { return d.value; }) : [0];
        option = {
            backgroundColor: 'rgba(8,20,38,0.82)',
            color: CHART_PALETTE,
            title: {
                text: (whName ? whName + ' · ' : '') + '物料库存 Top',
                left: 'center',
                top: 20,
                textStyle: {color: '#e6f3ff', fontSize: 34, fontWeight: 'bold'}
            },
            grid: {left: '4%', right: '14%', top: '15%', bottom: '4%', containLabel: true},
            tooltip: {trigger: 'axis', axisPointer: {type: 'shadow'}},
            xAxis: {
                type: 'value',
                axisLabel: {color: '#bcd6ef', fontSize: 16},
                axisLine: {show: false},
                splitLine: {lineStyle: {color: 'rgba(120,160,200,0.15)'}}
            },
            yAxis: {
                type: 'category',
                inverse: true,
                data: barNames,
                axisLabel: {color: '#dbe9f7', fontSize: 19},
                axisLine: {lineStyle: {color: 'rgba(140,180,220,0.4)'}},
                axisTick: {show: false}
            },
            series: [
                {
                    name: '库存数量',
                    type: 'bar',
                    barWidth: '58%',
                    itemStyle: {
                        borderRadius: [0, 8, 8, 0],
                        color: new echarts.graphic.LinearGradient(0, 0, 1, 0, [
                            {offset: 0, color: '#1f6feb'},
                            {offset: 1, color: '#00d4ff'}
                        ])
                    },
                    label: {show: true, position: 'right', color: '#e6f3ff', fontSize: 18},
                    data: barVals
                }
            ]
        };
        pieChart.setOption(option);

        pieChart.on('finished', function () {
            var infoEchart = new THREE.TextureLoader().load(pieChart.getDataURL());

            var infoEchartMaterial = new THREE.MeshBasicMaterial({
                transparent: true,
                map: infoEchart,
                side: THREE.DoubleSide
            });

            var echartPlane = new THREE.Mesh(new THREE.PlaneGeometry(100, 100), infoEchartMaterial);
            echartPlane.position.set(100, 150, 0);
            scene.add(echartPlane);

        });

        //饼图：各物料(品类)库存占比 —— 环形 + 名称/百分比标签
        pieChart2 = echarts.init($("<canvas width='1024' height='1024'></canvas>")[0]);
        var pieData = hasData ? matStat : [{value: 0, name: '暂无库存'}];
        var pieNames = hasData ? matStat.map(function (d) { return d.name; }) : ['暂无库存'];
        option2 = {
            backgroundColor: 'rgba(8,20,38,0.82)',
            color: CHART_PALETTE,
            title: {
                text: (whName ? whName + ' · ' : '') + '物料库存占比',
                left: 'center',
                top: 20,
                textStyle: {color: '#e6f3ff', fontSize: 34, fontWeight: 'bold'}
            },
            tooltip: {trigger: 'item', formatter: '{b}<br/>{c} ({d}%)'},
            legend: {
                type: 'scroll',
                bottom: 16,
                left: 'center',
                textStyle: {color: '#bcd6ef', fontSize: 16},
                pageTextStyle: {color: '#bcd6ef'},
                data: pieNames
            },
            series: [
                {
                    name: '库存占比',
                    type: 'pie',
                    radius: ['34%', '58%'],
                    center: ['50%', '47%'],
                    avoidLabelOverlap: true,
                    itemStyle: {borderColor: 'rgba(8,20,38,0.82)', borderWidth: 3},
                    label: {color: '#e6f3ff', fontSize: 17, formatter: '{b}\n{d}%'},
                    labelLine: {length: 14, length2: 14, lineStyle: {color: 'rgba(180,210,240,0.55)'}},
                    data: pieData
                }
            ]
        };
        pieChart2.setOption(option2);

        pieChart2.on('finished', function () {
            var spriteMap = new THREE.TextureLoader().load(pieChart2.getDataURL());

            var spriteMaterial = new THREE.SpriteMaterial({
                transparent: true,
                map: spriteMap,
                side: THREE.DoubleSide
            });

            var sprite = new THREE.Sprite(spriteMaterial);
            sprite.scale.set(150, 150, 1)
            sprite.position.set(-100, 180, 0);
            scene.add(sprite);

        });
    }

    // 初始化
    function init() {
        initMat();
        initScene();
        addSkybox(10000, scene);
        addVideoPlane(0, 60, -690, 200, 100, scene, 'video');
        initCamera();
        initRenderer();
        initContent();
        initLight();
        initControls();
        initGui();
        initEcharts();

        addArea(0, 0, 1000, 500, scene, "ID1$库区1号", "FF0000", 20, "左对齐");

        //按真实库房规格生成货架（组×排），无库房数据则不生成
        if (GET_SHELF_LIST().length > 0) {
            addShelf(scene);

            //按真实库存数据放置货物（仅有库存的库位放盒子）
            var invs = window.sceneInventories || [];
            for (var n = 0; n < invs.length; n++) {
                var it = invs[n];
                var shelfId = 'G' + it.groupNo + 'R' + it.rowNo;
                // 库位坐标须落在当前库房规格内，否则跳过
                if (getStorageUnitById(shelfId, it.layerNo, it.columnNo)) {
                    addOneUnitCargos(shelfId, it.layerNo, it.columnNo, scene);
                }
            }
        }

        //添加选中时的蒙版
        composer = new THREE.ThreeJs_Composer(renderer, scene, camera, options);

        //添加拖动效果
        // 过滤不是 Mesh 的物体,例如辅助网格
        var objects = [];
        for (var i = 0; i < scene.children.length; i++) {
            var Msg = scene.children[i].name.split("$");
            if (scene.children[i].isMesh && Msg[0] == "货物") {
                objects.push(scene.children[i]);
            }
        }

        var dragControls = new THREE.DragControls(objects, camera, renderer.domElement);
        dragControls.addEventListener('dragstart', function (event) {
            controls.enabled = false;
            isPaused = true;
        });
        dragControls.addEventListener('dragend', function (event) {
            controls.enabled = true;
            isPaused = false;
        });

        document.addEventListener('resize', onWindowResize, false);
    }

    // 窗口变动触发的方法
    function onWindowResize() {
        camera.aspect = window.innerWidth / window.innerHeight;
        camera.updateProjectionMatrix();
        renderer.setSize(window.innerWidth, window.innerHeight);
    }

    function animate() {
        requestAnimationFrame(animate);
        renderer.render(scene, camera);
        composer.render();
        update();
    }

    // 更新控件
    function update() {
        stats.update();
        controls.update();
        TWEEN.update();
        RollTexture.offset.x += 0.001;
    }

    // ======================= 数据驱动启动 =======================
    var WAREHOUSE_ID = '${warehouseId!""}';
    window.inventoryMap = {};
    window.sceneInventories = [];

    // 由库房规格(组×排)生成货架列表
    function buildShelfList(wh) {
        var groups = (wh.specGroup && wh.specGroup > 0) ? wh.specGroup : 1;
        var rows = (wh.specRow && wh.specRow > 0) ? wh.specRow : 1;
        var spacingX = 120, spacingZ = 140;
        var list = [];
        for (var g = 1; g <= groups; g++) {
            for (var r = 1; r <= rows; r++) {
                list.push({
                    StorageZoneId: 'Z1',
                    shelfId: 'G' + g + 'R' + r,
                    shelfName: '货架' + g + '-' + r,
                    x: (r - (rows + 1) / 2) * spacingX,
                    y: 27,
                    z: (g - (groups + 1) / 2) * spacingZ
                });
            }
        }
        return list;
    }

    // 用场景数据初始化并启动渲染
    function startScene(sceneData) {
        var wh = sceneData.warehouse;
        var invs = sceneData.inventories || [];
        // 暴露给图表/标牌使用（两个图表与墙面标牌均从这里取真实数据）
        window.sceneWarehouse = wh || {};
        window.sceneLocations = sceneData.locations || [];
        window.sceneInventories = invs;
        if (!wh) {
            $('#wh-empty-tip').show();
            SET_SCENE_CONFIG(1, 1, []);
        } else {
            var shelfList = buildShelfList(wh);
            SET_SCENE_CONFIG(wh.specLayer, wh.specColumn, shelfList);
            window.sceneInventories = invs;
            // 构建库存映射，键 = shelfId$层$列
            window.inventoryMap = {};
            for (var i = 0; i < invs.length; i++) {
                var it = invs[i];
                var key = 'G' + it.groupNo + 'R' + it.rowNo + '$' + it.layerNo + '$' + it.columnNo;
                window.inventoryMap[key] = it;
            }
            if (shelfList.length === 0) {
                $('#wh-empty-tip').show();
            }
        }
        try {
            init();
            animate();
        } catch (e) {
            $('#wh-empty-tip').css('display', 'block').text('3D 初始化失败：' + (e && e.message ? e.message : e));
            if (window.console) console.error('3D init error:', e);
        }
    }

    // 切换库房 -> 整页重载（规避 Three.js 重建复杂度）
    $('#js-wh-select').on('change', function () {
        var id = $(this).val();
        window.location.href = '${request.contextPath}/digital/simulation/list-ui?warehouseId=' + encodeURIComponent(id);
    });

    // 加载库房下拉，再拉取所选库房场景数据
    function loadWarehousesAndStart() {
        $.post('${request.contextPath}/digital/simulation/warehouse-list', {}, function (res) {
            var list = (res && res.code === 0 && res.data) ? res.data : [];
            var selectedId = WAREHOUSE_ID || (list.length > 0 ? list[0].id : '');
            var html = '';
            if (list.length === 0) {
                html = '<option value="">（暂无库房）</option>';
            }
            for (var i = 0; i < list.length; i++) {
                var w = list[i];
                var sel = (w.id === selectedId) ? ' selected' : '';
                html += '<option value="' + w.id + '"' + sel + '>' + w.warehouseCode + ' ' + w.warehouseName + '</option>';
            }
            $('#js-wh-select').html(html);

            if (!selectedId) {
                startScene({});
                return;
            }
            $.post('${request.contextPath}/digital/simulation/scene', {warehouseId: selectedId}, function (sres) {
                var sceneData = (sres && sres.code === 0 && sres.data) ? sres.data : {};
                startScene(sceneData);
            }).fail(function () {
                startScene({});
            });
        }).fail(function () {
            // 接口不可用（如应用未重启）：仍渲染空建筑并提示
            $('#js-wh-select').html('<option value="">（库房接口不可用，请重启应用）</option>');
            startScene({});
        });
    }

    loadWarehousesAndStart();
</script>
</body>

</html>
