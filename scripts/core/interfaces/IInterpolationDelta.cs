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
	  public IDefaultValue<float> PositiveDelta { get; set; }

	  /// <summary>
	  /// Отрицательное значение дельты.
	  /// </summary>
	  public IDefaultValue<float> NegativeDelta { get; set; }
	}

  }
}
