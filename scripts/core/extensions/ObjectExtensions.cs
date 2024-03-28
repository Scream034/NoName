using System;
using Godot;

public static class ObjectExtensions
{
	/// <summary>
	/// Конвертирует <c><see cref="System.Object"/></c> в <c><see cref="Godot.Variant"/></c> 
	/// </summary>
	/// <param name="value">Объект для конвертации</param>
	/// <returns>Тоже значение, но в виде <c><see cref="Godot.Variant"/></c>, <c>null</c> если не найден доступный тип</returns>
	public static Variant? ToVariant(this object value)
	{
		Type type = value.GetType();

		if (type == typeof(int))
			return Variant.From((int)value);
		else if (type == typeof(float))
			return Variant.From((float)value);
		else if (type == typeof(double))
			return Variant.From((double)value);
		else if (type == typeof(Vector2))
			return Variant.From((Vector2)value);
		else if (type == typeof(Vector3))
			return Variant.From((Vector3)value);
		else if (type == typeof(Array))
			return Variant.From((Array)value);
		else if (type == typeof(Godot.Collections.Array))
			return Variant.From((Godot.Collections.Array)value);
		else if (type == typeof(GodotObject))
			return Variant.From((GodotObject)value);

		return null;
	}
}
