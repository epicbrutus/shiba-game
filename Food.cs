using Godot;
using System;

public partial class Food : Area2D
{
    public override void _Ready()
    {
        BodyEntered += OnBodyEntered;
    }

    private void OnBodyEntered(Node2D body)
    {
        // Check if the body that entered is the player
        if (body is CharacterBody2d player)
        {
            // Call the player's eat food method
            player.eatFood(10);
            
            // Make the food disappear
            GetParent().QueueFree();
        }
    }
}
