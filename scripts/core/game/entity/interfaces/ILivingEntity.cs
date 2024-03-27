using Godot;

namespace Core.Game.Interfaces
{

  public interface ILivingEntity
  {
	[Export] public abstract float DefaultAcceleration { get; set; }
	[Export] public abstract float DefaultDecceleration { get; set; }
	[Export] public abstract float MaxSpeed { get; set; }
	[Export] public abstract float WalkingSpeed { get; set; }
	[Export] public abstract float RunningSpeed { get; set; }
  }

}
