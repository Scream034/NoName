using System;
using Godot;
using Godot.Collections;

using Core.Types;
using Core.Interfaces;
using Core.Game.Interfaces;

namespace Core.Game.Controllers
{

	/// <summary>
	/// Класс MovementController управляет движением объекта. <br/>
	/// <b>Для работы объекта необходимо обновлять его через метод <c>UpdateMovement</c>.</b>
	/// </summary>
	public partial class MovementController : GodotObject, IMovementAcceleration, IMovementSpeed
	{
		/// <summary>
		/// Структура направления.
		/// </summary>
		public MovementDirection Direction;

		/// <summary>
		/// Двигается ли объект
		/// </summary>
		public bool IsMoving = false;

		public IDefaultValue<float> Acceleration { get; set; }
		public IDefaultValue<float> Decceleration { get; set; }
		[Export] public float MaxSpeed { get; set; } = 0f;
		public float WalkingSpeed { get; set; }
		public float RunningSpeed { get; set; }

		public InterpolationFloatValue InterpolationSpeed { get; set; }


		/// <summary>
		/// Инициализирует новый экземпляр класса MovementController.
		/// </summary>
		/// <returns>Ненастроенный экземпляр.</returns>
		public MovementController()
		{
			Direction = new();
			Acceleration = new DefaultValueClass<float>(0f);
			Decceleration = new DefaultValueClass<float>(0f);
			InterpolationSpeed = new();
		}

		/// <summary>
		/// Инициализирует новый экземпляр класса MovementController.
		/// </summary>
		/// <param name="direction">Направление движения.</param>
		/// <param name="acceleration">Положительное ускорение.</param>
		/// <param name="decceleration">Отрицательное ускорение.</param>
		/// <param name="interpolationSpeed">Интерполяция скорости.</param>
		public MovementController(MovementDirection direction, IDefaultValue<float> acceleration, IDefaultValue<float> decceleration, InterpolationFloatValue interpolationSpeed)
		{
			Direction = direction;
			Acceleration = acceleration;
			Decceleration = decceleration;
			InterpolationSpeed = interpolationSpeed;
		}

		/// <summary>
		/// Обновляет движение объекта.
		/// </summary>
		/// <param name="velocity">Текущая скорость.</param>
		/// <returns>Новое Velocity</returns>
		public Vector2 UpdateMovement(Vector2 velocity)
		{
			UpdateMovementFlags();
			UpdateMovementSpeed();

			if (IsMoving)
			{
				velocity = velocity.MoveToward(
					Direction.CurrentValue * InterpolationSpeed.CurrentValue,
					Acceleration.Current
				);
			}
			else
			{
				velocity = velocity.MoveToward(
					Vector2.Zero,
					Acceleration.Current
				);
			}

			return velocity;
		}

		/// <summary>
		/// Обновляет скорость движения объекта.
		/// </summary>
		public void UpdateMovementSpeed()
		{
			if (!InterpolationSpeed.CanUpdate) return;

			if (IsMoving)
			{
				InterpolationSpeed.SetCurrentValue(Mathf.Lerp(
						InterpolationSpeed.CurrentValue,
						// Конечное значение интерполяции умножается на угол между последним и текущим направлением движения
						InterpolationSpeed.TargetValue * GetTurnFactorFromDirection(),
						InterpolationSpeed.PositiveDelta.Current
				));
			}
			else
			{
				InterpolationSpeed.SetCurrentValue(Mathf.Lerp(
						InterpolationSpeed.CurrentValue,
						0f,
						InterpolationSpeed.NegativeDelta.Current
				));
			}
		}

		/// <summary>
		/// Обновляет флаги движения объекта.
		/// </summary>
		public void UpdateMovementFlags()
		{
			IsMoving = Direction.CurrentValue != Vector2.Zero;
		}

		/// <summary>
		/// Получает коэффициент поворота от направления.
		/// </summary>
		/// <returns>Коэффициент поворота.</returns>
		public float GetTurnFactorFromDirection()
		{
			float turnAngle = Direction.CurrentValue.AngleTo(Direction.PreviousValue);
			return Mathf.Clamp(1f - MathF.Abs(turnAngle) / MathF.PI, 1f, 0f);
		}

	}
}
