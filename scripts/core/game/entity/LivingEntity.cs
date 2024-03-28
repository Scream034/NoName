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

	public partial class LivingEntity : CharacterBody2D
	{
		// TODO: Дописать ещё компоненты.
		public readonly MovementController _movement = new();
		public readonly InterpolationFloatValue _i = new();

		[Export]
		public float DefaultAcceleration { get => _movement.Acceleration.Default; set => _movement.Acceleration.Default = value; }
		[Export]
		public float DefaultDecceleration { get => _movement.Decceleration.Default; set => _movement.Decceleration.Default = value; }
		[Export]
		public float MaxSpeed { get => _movement.MaxSpeed; set => _movement.MaxSpeed = value; }
		[Export]
		public float WalkingSpeed { get => _movement.WalkingSpeed; set => _movement.WalkingSpeed = value; }
		[Export]
		public float RunningSpeed { get => _movement.RunningSpeed; set => _movement.RunningSpeed = value; }
		[Export(PropertyHint.Range, "0, 1")]
		public float SpeedPositiveDelta { get => _movement.InterpolationSpeed.PositiveDelta.Default; set => _movement.InterpolationSpeed.PositiveDelta.Default = value; }
		[Export(PropertyHint.Range, "0, 1")]
		public float SpeedNegativeDelta { get => _movement.InterpolationSpeed.NegativeDelta.Default; set => _movement.InterpolationSpeed.NegativeDelta.Default = value; }

		#region Godot methods

		public override void _PhysicsProcess(double _delta)
		{
			Velocity = _movement.UpdateMovement(Velocity);
		}

		#endregion
	}

}