extends BaseItem
# Абстрактный класс всех оружий
# NOTE: Этот класс находится на стадии рассмотрения геймдизайнерами и сценаристами.
class_name BaseWeapon

signal process_attack_started ## Когда оружие **начало процесс для атаки**
signal process_attack_finished ## Когда оружие **закончило процесс для атаки**
signal attacked ## Когда оружие **атакует**

@export var damage: int ## Урон оружия
@export var attack_cooldown: float ## Время между атаками


## Начать процесс атаки
func begin_attack() -> void:
    push_warning("Нет метода для начала процесса атаки!")

## Закончить процесс атаки
func end_attack() -> void:
    push_warning("Нет метода для конца процесса атаки!")

## Выполнить атаку
func execute_attack() -> void:
    _update_direction()
    call_deferred("attack_animation")

## Нейтролизовать атаку
func execute_deattack() -> void:
    push_warning("Нет метода для нейтролизации атаки!")

## Вызвать анимацию атаки
func attack_animation() -> void:
    push_warning("Нет метода для выполнения анмиации атаки!")

## Обновление направления
func _update_direction() -> void:
    rotation = owner.rotation