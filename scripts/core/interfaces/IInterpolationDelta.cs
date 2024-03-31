using Core.Types;

namespace Core
{
  namespace Interfaces
  {

	/// <summary>
	/// Структура для хранения дельты интерполяции.
	/// </summary>
	public interface IInterpolationDelta
	{
	  /// <summary>
	  /// Положительное значение дельты.
	  /// </summary>
	  public DefaultValue<float> PositiveDelta { get; set; }

	  /// <summary>
	  /// Отрицательное значение дельты.
	  /// </summary>
	  public DefaultValue<float> NegativeDelta { get; set; }
	}

  }
}
