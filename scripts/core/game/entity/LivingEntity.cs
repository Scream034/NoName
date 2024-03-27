using Godot;

using Core.Game.Controllers;
using Core.Types;
using Godot.Collections;
using System.Linq;
using System;
using System.Reflection;
using System.Text.RegularExpressions;

namespace Core.Game
{

	// [Tool]
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
			// if (!ggset.Set(property, value))
			// 	return base._Set(property, value);

			string _property = property.ToString();
			if (_property.StartsWith("_movement/"))
			{
				_property = _property.Replace("_movement/", "");
				_movement.Set(_property, value);

				return true;
			}
			else
				return base._Set(property, value);
		}

		public override Array<Dictionary> _GetPropertyList()
		{
			GodotPropertyList properties = new GodotPropertyList();

			properties.AddProperty(new(name: "_movement/MaxSpeed", Variant.Type.Float, PropertyHint.Range, "-1000, 1000"));

			return properties.ToArrayOfDictionary();
		}

		public override void _Ready()
		{
			GD.Print(Get("_i/RangeValues/_minValue"));
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

	public CustomGGSet(GodotObject parent)
	{
		owner = parent;
	}

	public Variant? Get(in string property)
	{
		if (property.Find('/', 1) == -1)
			return null;
		return GetPropertyValue(property);
	}

	public bool? Set(StringName property, Variant value)
	{

		return null;
	}

	private Variant? GetPropertyValue(in string name)
	{
		string[] parts = name.Split(separator: '/');

		object lastObject = owner;
		for (int i = 0; i < parts.Length; i++)
		{
			string part = parts[i];

			FieldInfo[] fields = lastObject.GetType().GetRuntimeFields().ToArray();
			FieldInfo? field = fields.FirstOrDefault(x => CompareRuntimeStringNames(part, x.Name));
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

			if (i == parts.Length)
			{
				Variant? result = ToVariant(obj);
				if (result is not null)
					return ToVariant(obj);
			}

			lastObject = obj;
		}

		return null;
	}

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

	private static Variant? ToVariant(object? value)
	{
		Type type = value.GetType();

		if (type == typeof(int))
			return Variant.From((int)value);
		else if (type == typeof(float))
			return Variant.From((float)value);
		else if (type == typeof(double))
			return Variant.From(from: (double)value);
		else if (type == typeof(Vector2))
			return Variant.From((Vector2)value);
		else if (type == typeof(Vector3))
			return Variant.From((Vector3)value);
		else if (type == typeof(System.Array))
			return Variant.From((System.Array)value);
		else if (type == typeof(Godot.Collections.Array))
			return Variant.From((Godot.Collections.Array)value);
		
		return null;
	}

}