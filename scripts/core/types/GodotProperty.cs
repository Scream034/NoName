using Godot;
using Godot.Collections;

namespace Core.Types
{
	public sealed class GodotProperty
	{
		public readonly StringName name;
		public readonly uint type;
		public readonly uint hint;
		public readonly string hint_string;

		public GodotProperty(StringName name, Variant.Type type, PropertyHint hint, string hint_string = "")
		{
			this.name = name;
			this.type = (uint)type;
			this.hint = (uint)hint;
			this.hint_string = hint_string;
		}

		public Dictionary ToDictionary()
		{
			Dictionary dict = new Dictionary()
			{
				{"name", name},
				{"type", type},
				{"hint", hint},
				{"hint_string", hint_string}
			};
			dict.MakeReadOnly();
			return dict;
		}
	}
}