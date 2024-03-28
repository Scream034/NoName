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
		private T _default;
		private T _current;

		/// <summary>
		/// Значение по умолчанию.
		/// </summary>ы
		public T Default
		{
			get => _default;
			set => _default = value;
		}

		/// <summary>
		/// Текущее значение.
		/// </summary>
		public T Current
		{
			get => _current;
			set => _current = value;
		}


		/// <summary>
		/// Конструктор структуры.
		/// </summary>
		/// <param name="defaultValue">Значение по умолчанию.</param>
		public DefaultValueStruct(in T defaultValue)
		{
			_default = _current = defaultValue;
		}
	}

}