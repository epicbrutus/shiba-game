using Godot;
using System;
using System.Collections.Generic;

public partial class CharacterBody2d : CharacterBody2D
{
    public enum MovementPreset
    {
        Skinny,
        Normal,
        Overweight,
        Fat,
        Obese
    }

    public struct MovementData
    {
        public float Speed;
        public float Friction;
        public float Acceleration;

        public MovementData(float speed, float friction, float acceleration)
        {
            Speed = speed;
            Friction = friction;
            Acceleration = acceleration;
        }
    }
    

    private Dictionary<MovementPreset, MovementData> movementPresets = new Dictionary<MovementPreset, MovementData>
    {
        { MovementPreset.Skinny, new MovementData(600f, 600f, 1500f) },
        { MovementPreset.Normal, new MovementData(500f, 300f, 1000f) },
        { MovementPreset.Overweight, new MovementData(400f, 100f, 700f) },
        { MovementPreset.Fat, new MovementData(600f, 0f, 500f) },
        { MovementPreset.Obese, new MovementData(800f, 0f, 300f) }
    };

    [Export] public MovementPreset CurrentPreset = MovementPreset.Normal;

    [Export] public float Speed = 300.0f;
    [Export] public float Friction = 0f;
    [Export] public float Acceleration = 1500.0f;

    [Export] public RichTextLabel WeightLabel;

    private int foodEaten = 0;

    public void eatFood(int num)
    {
        foodEaten = Math.Min(foodEaten + num, 80);
        MovementPreset toChangeTo = (MovementPreset)(foodEaten / 20);

        WeightLabel.Text = toChangeTo.ToString();
        SetMovementPreset(toChangeTo);
    }

    public void loseFood()
    {
        foodEaten = Math.Max(foodEaten - 1, 0);
        MovementPreset toChangeTo = (MovementPreset)(foodEaten / 2);

        SetMovementPreset(toChangeTo);
    }

    public void SetMovementPreset(MovementPreset preset)
    {
        if (movementPresets.ContainsKey(preset))
        {
            var data = movementPresets[preset];
            Speed = data.Speed;
            Friction = data.Friction;
            Acceleration = data.Acceleration;
            CurrentPreset = preset;
        }
    }


    public override void _PhysicsProcess(double delta)
    {
        Vector2 inputVector = GetInputVector();

        if (inputVector != Vector2.Zero)
        {
            // Apply acceleration towards input direction
            Velocity = Velocity.MoveToward(inputVector * Speed, Acceleration * (float)delta);
        }
        else
        {
            // Apply friction when no input
            Velocity = Velocity.MoveToward(Vector2.Zero, Friction * (float)delta);
        }

        MoveAndSlide();

        if (IsOnWall())
        {
            for (int i = 0; i < GetSlideCollisionCount(); i++)
            {
                KinematicCollision2D collision = GetSlideCollision(i);
                Vector2 normal = collision.GetNormal();

                // Reduce velocity component along the normal
                Velocity = Velocity - normal * Velocity.Dot(normal);
            }
        }
    }

    private Vector2 GetInputVector()
    {
        Vector2 inputVector = Vector2.Zero;
        
        inputVector.X = Input.GetActionStrength("move_right") - Input.GetActionStrength("move_left");
        inputVector.Y = Input.GetActionStrength("move_down") - Input.GetActionStrength("move_up");
        
        return inputVector.Normalized();
    }
}