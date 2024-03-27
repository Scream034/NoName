using Core.Types;

namespace Core.Game.Interfaces
{

  /// <summary>
  /// Интерфейс, определяющий поля скорости движения.
  /// </summary>
  public interface IMovementSpeed
  {
	/// <summary>
	/// Максимальная скорость.
	/// </summary>
	public abstract float MaxSpeed { get; set; }

	/// <summary>
	/// Скорость ходьбы.
	/// </summary>
	public abstract float WalkingSpeed { get; set; }

	/// <summary>
	/// Скорость бега.
	/// </summary>
	public abstract float RunningSpeed { get; set; }

	/// <summary>
	/// Значение интерполяции.
	/// </summary>
	public InterpolationFloatValue InterpolationSpeed { get; set; }
  }

}
