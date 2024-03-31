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
		if (value == null)
			return null;

		if (value is int i)
			return Variant.From(i);
		else if (value is float f)
			return Variant.From(f);
		else if (value is double d)
			return Variant.From(d);
		else if (value is bool b)
			return Variant.From(b);
		else if (value is string s)
			return Variant.From(s);
		else if (value is Vector2 v2)
			return Variant.From(v2);
		else if (value is Vector3 v3)
			return Variant.From(v3);
		else if (value is Array a)
			return Variant.From(a);
		else if (value is Godot.Collections.Array ga)
			return Variant.From(ga);
		else if (value is Godot.Collections.Dictionary gd)
			return Variant.From(gd);
		else if (value is GodotObject go)
			return Variant.From(go);
		else if (value is IConvertible c)
			return Variant.From(c.ToDouble(null));

		return null;
	}
}
