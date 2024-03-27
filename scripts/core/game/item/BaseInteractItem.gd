extends BaseItem
# NOTE: Черновик
class_name BaseInteractItem

signal process_use_started ## Когда предмет **начал процесс для использования**
signal process_use_finished ## Когда предмет **закончил процесс для использования**
signal used ## Когда предмет **использовался**