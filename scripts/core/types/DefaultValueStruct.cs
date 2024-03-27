using System;
using Core.Interfaces;

namespace Core.Types
{

  /// <summary>
  /// Нужен для хранения текущего и дефолтного значения. <br/>
  /// <b>Рекомендуется для небольших данных.</b> или используйте <c>DefaultValueClass</c>
  /// </summary>
  /// <typeparam name="T">notnull</typeparam>
  public struct DefaultValueStruct<T> : IDefaultValue<T> where T : struct
  {
	private T defaultValue;
	private T currentValue;

	public T Default
	{
	  get => defaultValue;
	  set => defaultValue = value;
	}

	public T Current
	{
	  get => currentValue;
	  set => currentValue = value;
	}


	public DefaultValueStruct(T defaultValue)
	{
	  this.defaultValue = defaultValue;
	  currentValue = defaultValue;
	}
  }

}
