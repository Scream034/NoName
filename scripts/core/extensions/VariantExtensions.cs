using System;
using Godot;

public static class VariantExtensions
{
	public static object? ConvertToConcreteValue(this Variant variant)
	{
		object? obj = variant.Obj;
		switch (variant.VariantType)
		{
			case Variant.Type.Float:
				return (float)Convert.ToDouble(obj);
			case Variant.Type.NodePath:
				return variant.AsString();
			case Variant.Type.StringName:
				return variant.AsString();
			default:
				return obj;
		}
	}
}
