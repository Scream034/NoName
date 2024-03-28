using Core.Interfaces;

namespace Core.Types
{

	/// <summary>
	/// Нужен для хранения текущего и дефолтного значения. <br/>
	/// <b>Рекомендуется для больших данных.</b> или используйте <c>DefaultValueStruct</c> <br/>
	/// Может использоваться, как хранение текущего значения и конечного.
	/// </summary>
	/// <typeparam name="T">notnull</typeparam>
	public class DefaultValueClass<T> : IDefaultValue<T> where T : struct
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
		/// Конструктор класса.
		/// </summary>
		/// <param name="defaultValue">Значение по умолчанию.</param>
		public DefaultValueClass(in T defaultValue)
		{
			_default = _current = defaultValue;
		}
	}

}
