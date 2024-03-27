using System.Collections.Generic;
using Godot;
using Godot.Collections;

namespace Core.Types
{
	public sealed class GodotPropertyList
	{
		private List<GodotProperty> properties = new List<GodotProperty>();

		public void AddProperty(GodotProperty property) => properties.Add(property);

		public void RemoveProperty(GodotProperty property) => properties.Remove(property);

		public void ReplaceProperty(string propertyName, GodotProperty newProperty)
		{
			for (int i = 0; i < properties.Count; i++)
				if (properties[i].name == propertyName)
				{
					properties[i] = newProperty;
					break;
				}
		}

		public Array<Dictionary> ToArrayOfDictionary()
		{
			Array<Dictionary> array = new Array<Dictionary>();
			properties.ForEach((property) => array.Add(property.ToDictionary()));
			return array;
		}

		public static GodotPropertyList CreateFromArrayOfDictionary(Array<Dictionary> array)
		{
			GodotPropertyList newPropertyList = new();
			foreach (Dictionary dict in array)
			{
				string name = (string)dict["name"];
				Variant.Type type = (Variant.Type)(uint)dict["type"];
				PropertyHint hint = (PropertyHint)(uint)dict["hint"];
				string hintString = (string)dict["hint_string"];
				GodotProperty property = new(name, type, hint, hintString);
				newPropertyList.AddProperty(property);
			}
			return newPropertyList;
		}
	}
}