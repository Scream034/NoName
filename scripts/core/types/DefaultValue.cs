using Core.Interfaces;
using System;

namespace Core.Types
{
	/// <summary>
	/// Хранит текущее и дефолтное значение.
	/// </summary>
	/// <typeparam name="T">Тип данных для хранения.</typeparam>
	public class DefaultValue<T> : IDefaultValue<T> where T : struct, IComparable
	{
		private T _default;
		private T _current;

		/// <summary>
		/// Значение по умолчанию.
		/// </summary>
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
		public DefaultValue(T defaultValue)
		{
			_default = defaultValue;
			_current = defaultValue;
		}

		public DefaultValue() : this(default(T)) { }
	}
}