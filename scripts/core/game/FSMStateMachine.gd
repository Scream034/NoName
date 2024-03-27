extends Object
## Машина состояний
class_name FSMStateMachine

var all_states: Dictionary ## Все состояния
var current_state: StringName: set = set_current_state ## Текущее состояние
var prev_state: StringName ## Предыдущее состояние

## Добавление нового состояния
func add_state(state: FSMState) -> void:
    all_states[state.name] = state

## Добавление нового состояния
func add_states(states: Array[FSMState]) -> void:
    states.make_read_only()
    states.map(func (state): add_state(state))

## Получить состояние
func get_state(state_name: StringName) -> FSMState:
    return all_states[state_name]

## Удалить состояние
func remove_state(state_name: StringName) -> void:
    get_state(state_name).free()
    all_states[state_name] = null

## Выставить значение текущему состоянию, вызвать обработчик
func set_current_state(new_state_name: StringName) -> void:
    if prev_state != current_state && current_state != new_state_name:
        prev_state = current_state

    var state: FSMState = get_state(new_state_name)
    state.handle.call_deferred()
    current_state = new_state_name