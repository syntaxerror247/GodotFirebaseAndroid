extends ScrollContainer

var swiping = false
var swipe_start: Vector2
var swipe_mouse_start: Vector2
var is_enabled: bool = true

func _input(ev):
	if is_enabled:
		if self.get_global_rect().has_point(get_global_mouse_position()):
			if ev is InputEventMouseButton:
				if ev.pressed:
					swip_controller(true)
					swipe_start = Vector2(get_h_scroll(), get_v_scroll())
					swipe_mouse_start = ev.position
				else:
					swip_controller(false)
			elif swiping and ev is InputEventMouseMotion:
				var delta = ev.position - swipe_mouse_start
				if horizontal_scroll_mode != ScrollMode.SCROLL_MODE_DISABLED:
					set_h_scroll(swipe_start.x - delta.x)
				if vertical_scroll_mode != ScrollMode.SCROLL_MODE_DISABLED:
					set_v_scroll(swipe_start.y - delta.y)
		else:
			swip_controller(false)

func swip_controller(is_swiping) -> void:
	swiping = is_swiping

func swip_enabler(p_is_enabled: bool) -> void:
	mouse_filter = Control.MOUSE_FILTER_PASS
	vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	is_enabled = p_is_enabled
	swip_controller(false)
	if not is_enabled:
		vertical_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_NEVER
		mouse_filter = Control.MOUSE_FILTER_IGNORE
