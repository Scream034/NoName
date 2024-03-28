using Godot;

using Core.Game.Controllers;
using Core.Types;
using Godot.Collections;
using System.Linq;
using System;
using System.Reflection;
using System.Text.RegularExpressions;
using Microsoft.VisualBasic;

namespace Core.Game
{

	[Tool]
	public partial class LivingEntity : CharacterBody2D
	{
		private CustomGGSet ggset;
		// TODO: Дописать ещё компоненты.
		public readonly MovementController _movement;
		public readonly InterpolationFloatValue _i;

		// [Export]
		// public float DefaultAcceleration { get => _movement.Acceleration.Default; set => _movement.Acceleration.Default = value; }
		// [Export]
		// public float DefaultDecceleration { get => _movement.Decceleration.Default; set => _movement.Decceleration.Default = value; }
		// [Export]
		// public float MaxSpeed { get => _movement.MaxSpeed; set => _movement.MaxSpeed = value; }
		// [Export]
		// public float WalkingSpeed { get => _movement.WalkingSpeed; set => _movement.WalkingSpeed = value; }
		// [Export]
		// public float RunningSpeed { get => _movement.RunningSpeed; set => _movement.RunningSpeed = value; }
		// [Export(PropertyHint.Range, "0, 1")]
		// public float SpeedPositiveDelta { get => _movement.InterpolationSpeed.PositiveDelta.Default; set => _movement.InterpolationSpeed.PositiveDelta.Default = value; }
		// [Export(PropertyHint.Range, "0, 1")]
		// public float SpeedNegativeDelta { get => _movement.InterpolationSpeed.NegativeDelta.Default; set => _movement.InterpolationSpeed.NegativeDelta.Default = value; }
		public float Kak { get; set; }

		#region Godot methods

		public LivingEntity()
		{
			ggset = new(this);
			_movement = new();
			_i = new();
		}

		public override Variant _Get(StringName property)
		{
			Variant? result = ggset.Get(property);
			return result is null ? base._Get(property) : (Variant)result;
		}

		public override bool _Set(StringName property, Variant value)
		{
			bool? result = ggset.Set(property, value);
			return result is null ? base._Set(property, value) : (bool)result;
		}

		public override Array<Dictionary> _GetPropertyList()
		{
			GodotPropertyList properties = new GodotPropertyList();

			properties.AddProperties(new GodotProperty[]
			{
				new(name: "_movement/Acceleration/Default", Variant.Type.Float, PropertyHint.Range, ""),
				new(name: "_movement/Decceleration/Default", Variant.Type.Float, PropertyHint.Range, "")
			});

			return properties.ToArrayOfDictionary();
		}

		public override void _PhysicsProcess(double _delta)
		{
			Velocity = _movement.UpdateMovement(Velocity);
		}

		#endregion
	}

}

/// <summary>
/// CustomGodotGetterSetter
/// </summary>
public sealed class CustomGGSet
{
	private readonly GodotObject owner;

	/// <summary>
	/// Конструктор класса
	/// </summary>
	/// <param name="parent">От кого он начинает работать</param>
	public CustomGGSet(GodotObject parent)
	{
		owner = parent;
	}

	/// <summary>
	/// Обработчик Getter-а
	/// </summary>
	/// <returns><c>null</c> если безуспешно, иначе результат</returns>
	public Variant? Get(in string property)
	{
		if (!IsValid(property))
			return null;
		return GetPropertyValue(property);
	}

	/// <summary>
	/// Обработчик Setter-а
	/// </summary>
	/// <returns><c>null</c> если безуспешно, иначе результат</returns>
	public bool? Set(in StringName property, in Variant value)
	{
		if (!IsValid(property))
			return null;
		return SetPropertyValue(property, value);
	}

	/// <summary>
	/// Может ли это свойство использоваться
	/// </summary>
	/// <returns><c>true</c> если правилен, иначе <c>false</c></returns>
	private bool IsValid(in string property) => property.Find('/', 1) != -1;

	/// <summary>
	/// Получение значения <b>через рефлексию</b> по-переданному пути<br/>
	/// <b>Обязательно:</b> передавать непереходные переменные!
	/// </summary>
	/// <param name="name">Путь до значени</param>
	/// <returns>Значение переменной</returns>
	private Variant? GetPropertyValue(in string name)
	{
		string[] parts = name.Split(separator: '/');

		object lastObject = owner;
		for (int i = 0; i < parts.Length; i++)
		{
			string part = parts[i];

			FieldInfo? field = GetField(lastObject, part);
			if (field is null)
			{
				GD.PushError(new NullReferenceException($"A field named {name} was not found in object."));
				return null;
			}

			object? obj = field.GetValue(lastObject);
			if (obj is null)
			{
				GD.PushError(new NullReferenceException($"The value is null."));
				return null;
			}

			if (i == parts.Length - 1)
			{
				Variant? result = obj.ToVariant();
				if (result is not null)
					return result;
			}

			lastObject = obj;
		}

		return null;
	}

	public bool SetPropertyValue(in string name, in Variant value)
	{
		string[] parts = name.Split(separator: '/');

		object lastObject = owner;
		for (int i = 0; i < parts.Length; i++)
		{
			string part = parts[i];

			FieldInfo? field = GetField(lastObject, part);
			if (field is null)
			{
				GD.PushError(new NullReferenceException($"A field named {name} was not found in object."));
				return false;
			}

			object? obj = field.GetValue(lastObject);
			if (obj is null)
			{
				GD.PushError(new NullReferenceException($"The value is null."));
				return false;
			}

			if (i == parts.Length - 1)
			{
				if (lastObject.GetType().BaseType.Name is nameof(GodotObject))
				{
					GodotObject godotObject = lastObject as GodotObject;
					godotObject.Set(part, value);
					return true;
				}

				field.SetValue(lastObject, value.ConvertToConcreteValue());
				return true;
			}

			lastObject = obj;
		}

		return false;
	}

	/// <summary>
	/// Получить поле с помощью рефлексии
	/// </summary>
	/// <param name="obj">В чём мы ищем</param>
	/// <param name="name">Имя использованной переменной</param>
	/// <returns><c>null</c> если не найден, иначе результат</returns>
	private FieldInfo? GetField(in object obj, string name) => obj.GetType().GetRuntimeFields().FirstOrDefault(x => CompareRuntimeStringNames(name, x.Name));

	/// <summary>
	/// Сравнивает две строки специальным способом
	/// </summary>
	/// <param name="from">Из строки</param>
	/// <param name="with">Со строкой</param>
	/// <returns>Если равны то <c>true</c>, иначе <c>false</c></returns>
	private static bool CompareRuntimeStringNames(in string from, in string with)
	{
		if (from == with)
			return true;

		Regex regex = new(@"<(\w+)>k__BackingField");
		Group match = regex.Match(with).Groups.Values.LastOrDefault();

		if (!match.Success)
			return false;

		return from == match.Value;
	}

}