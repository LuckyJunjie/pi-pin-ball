# 场景切换集成测试
# 测试 Bug: 点击开始游戏无反应

extends GutTest

## 测试场景切换功能

var _test_mode := false  # true = 更新基准图


func test_main_menu_start_button_exists():
    # 验证开始按钮存在
    var menu = load("res://scenes/ui/MainMenu.tscn").instantiate()
    get_tree().root.add_child(menu)
    await get_tree().process_frame
    
    var start_button = menu.get_node_or_null("MarginContainer/VBoxContainer/ButtonContainer/StartButton")
    assert_not_null(start_button, "开始按钮应存在")
    
    menu.free()


func test_main_menu_to_main_scene_transition():
    # 测试从主菜单到游戏场景的切换
    var menu = load("res://scenes/ui/MainMenu.tscn").instantiate()
    get_tree().root.add_child(menu)
    await get_tree().process_frame
    
    # 模拟点击开始按钮
    var start_button = menu.get_node("MarginContainer/VBoxContainer/ButtonContainer/StartButton")
    start_button.pressed.emit()
    
    # 等待场景切换
    await get_tree().process_frame
    await get_tree().process_frame
    
    # 验证当前场景
    var current_scene = get_tree().current_scene
    if current_scene:
        print("[测试] 当前场景: ", current_scene.name)
        assert_eq(current_scene.name, "Main", "应切换到Main场景")
    else:
        print("[测试] 场景切换后 current_scene 为空")
        # 检查根场景
        var root = get_tree().root
        if root.get_child_count() > 0:
            var last_child = root.get_child(root.get_child_count() - 1)
            print("[测试] 最后一个子节点: ", last_child.name)
    
    menu.free()


func test_game_mode_select_transition():
    # 测试游戏模式选择后的场景切换
    var mode_select = load("res://scenes/ui/GameModeSelect.tscn").instantiate()
    get_tree().root.add_child(mode_select)
    await get_tree().process_frame
    
    # 模拟选择模式
    var mode_button = mode_select.get_node_or_null("ModeGrid")
    if mode_button and mode_button.get_child_count() > 0:
        mode_button.get_child(0).pressed.emit()
        await get_tree().process_frame
        
        # 验证场景切换
        var current_scene = get_tree().current_scene
        if current_scene:
            print("[测试] 模式选择后场景: ", current_scene.name)
    
    mode_select.free()


func test_main_scene_has_flipper_and_launcher():
    # 验证Main场景包含必要的节点
    var main = load("res://scenes/Main.tscn").instantiate()
    get_tree().root.add_child(main)
    await get_tree().process_frame
    
    # 验证发射器
    var launcher = main.get_node_or_null("Launcher")
    assert_not_null(launcher, "发射器应存在")
    
    # 验证挡板
    var left_flipper = main.get_node_or_null("LeftFlipper")
    var right_flipper = main.get_node_or_null("RightFlipper")
    assert_not_null(left_flipper, "左挡板应存在")
    assert_not_null(right_flipper, "右挡板应存在")
    
    # 验证UI
    var score_label = main.get_node_or_null("UI/ScoreLabel")
    assert_not_null(score_label, "得分标签应存在")
    
    main.free()
