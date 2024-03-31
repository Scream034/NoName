using System;
using Core.Interfaces;

namespace Core.Types
{

	/// <summary>Класс для хранения только <c>float</c> интерполированного значения.</summary>
	public class InterpolationFloatValue : IInterpolationDelta
	{
		/// <summary>Диапазон значений для интерполяции.</summary>
		public ValueRange<float> RangeValues;

		public DefaultValue<float> PositiveDelta { get; set; }
		public DefaultValue<float> NegativeDelta { get; set; }

		/// <summary>Конечное значение интерполяции в текущей итерации.</summary>
		public float TargetValue { get; set; }

		/// <summary>Может ли обновляться интерполяция.</summary>
		public bool CanUpdate { get; set; }

		/// <summary>Текущее значение, ограниченное диапазоном значений.</summary>
		public float CurrentValue { get; private set; }


		/// <summary>Конструктор для создания <b>пустого</b> экземпляра InterpolationFloatValue.</summary>
		public InterpolationFloatValue()
		{
			RangeValues = new(0f, 1f);
			PositiveDelta = new ();
			NegativeDelta = new ();
			TargetValue = 0f;
			CanUpdate = true;
		}

		/// <summary>Конструктор для создания экземпляра InterpolationFloatValue.</summary>
		public InterpolationFloatValue(in ValueRange<float> rangeValues, in DefaultValue<float> positiveDelta, in DefaultValue<float> negativeDelta, in float targetValue, in bool canUpdate = true)
		{
			RangeValues = rangeValues;
			PositiveDelta = positiveDelta;
			NegativeDelta = negativeDelta;
			TargetValue = targetValue;
			CanUpdate = canUpdate;
		}

		/// <summary>Установить текущее значение интерполяции.</summary>
		/// <param name="value">Новое текущее значение интерполяции</param>
		public void SetCurrentValue(in float value) => CurrentValue = CanUpdate ? Math.Clamp(value, RangeValues.MinValue, RangeValues.MaxValue) : Math.Clamp(CurrentValue, RangeValues.MinValue, RangeValues.MaxValue);
	}

}
