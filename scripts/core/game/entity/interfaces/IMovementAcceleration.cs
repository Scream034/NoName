using Core.Types;

namespace Core.Game.Interfaces
{

  /// <summary>
  /// Интерфейс, определяющий поля ускорения движения.
  /// </summary>
  public interface IMovementAcceleration
  {
	/// <summary>
	/// Значение положительного ускорения по умолчанию.
	/// </summary>
	public DefaultValue<float> Acceleration { get; set; }

	/// <summary>
	/// Значение отрительного ускорения по умолчанию.
	/// </summary>
	public DefaultValue<float> Decceleration { get; set; }
  }

}
