using Godot;

/// <summary>
/// Структура, определяющая направление движения.
/// </summary>
public struct MovementDirection
{
  /// <summary>
  /// Предыдущее направление.
  /// </summary>
  public Vector2 PreviousValue = default;

  private Vector2 _currentValue;

  /// <summary>
  /// Текущее направление.
  /// </summary>
  public Vector2 CurrentValue
  {
    get => _currentValue;
    set
    {
      value = value.Snapped(new Vector2(0.1f, 0.1f));
      if (value != _currentValue)
        PreviousValue = value;
      _currentValue = value;
    }
  }

  /// <summary>
  /// Активное направление.
  /// </summary>
  public readonly Vector2? Active => _currentValue == Vector2.Zero ? null : _currentValue;

  /// <summary>
  /// Конструктор структуры направления движения сущности.
  /// </summary>
  public MovementDirection(in Vector2 currentValue)
  {
    _currentValue = currentValue;
  }
}
