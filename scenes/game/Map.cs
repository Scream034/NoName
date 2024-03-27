using Godot;
using System;

public partial class Map : Node2D
{
  private float _quarks;
  public float Quarks
  {
	get
	{
	  return _quarks;
	}
	set
	{
	  _quarks = value;
	}
  }
  public double time;

  public override void _Ready()
  {
	Quarks = 100f;
  }

  public override void _PhysicsProcess(double delta)
  {
	time += delta;
  }
}
