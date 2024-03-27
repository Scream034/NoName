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
		private T defaultValue;
		private T currentValue;

		/// <summary>
		/// Значение по умолчанию.
		/// </summary>
		public T Default
		{
			get => defaultValue;
			set => defaultValue = value;
		}

		/// <summary>
		/// Текущее значение.
		/// </summary>
		public T Current
		{
			get => currentValue;
			set => currentValue = value;
		}


		/// <summary>
		/// Конструктор класса.
		/// </summary>
		/// <param name="defaultValue">Значение по умолчанию.</param>
		public DefaultValueClass(in T defaultValue)
		{
			this.defaultValue = defaultValue;
			currentValue = defaultValue;
		}
	}

}
