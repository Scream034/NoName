using System;
using System.Collections.Generic;

namespace Core.Types
{

	/// <summary>
	/// Класс хранения значения в заданном диапазоне.
	/// </summary>
	/// <typeparam name="T">Тип значения.</typeparam>
	public class ValueRange<T> where T : IComparable
	{
		private static readonly IComparer<T> _comparer = Comparer<T>.Default;

		private T _minValue = default;
		/// <summary>
		/// Минимальное значение.
		/// </summary>
		public T MinValue
		{
			get { return _minValue; }
			set
			{
				if (_comparer.Compare(value, _maxValue) < 0)
					_minValue = value;
				else
					throw new ArgumentException("Minimum value must be less than the maximum value");
			}
		}

		private T _maxValue = default;
		/// <summary>
		/// Максимальное значение.
		/// </summary>
		public T MaxValue
		{
			get { return _maxValue; }
			set
			{
				if (_comparer.Compare(value, _minValue) > 0)
					_maxValue = value;
				else
					throw new ArgumentException("Maximum value must be greater than the minimum value");
			}
		}
		private T _currentValue = default;
		/// <summary>
		/// Текущее значение.
		/// </summary>
		public T CurrentValue
		{
			get { return _currentValue; }
			set
			{
				if (_comparer.Compare(value, _minValue) >= 0 && _comparer.Compare(value, _maxValue) <= 0)
					_currentValue = value;
				else
					throw new ArgumentException("Value must be within the range");
			}
		}


		public ValueRange(in T minValue, in T maxValue)
		{
			_minValue = minValue;
			_maxValue = maxValue;
			_currentValue = minValue;
		}
	}

}