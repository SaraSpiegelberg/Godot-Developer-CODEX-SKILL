# Phaser to Godot Mapping

Use this file when a request is written with Phaser terminology.

## Lifecycle mapping

- Phaser `preload()` -> Godot resource setup via exported vars, preload(), or scene/resource loading before use.
- Phaser `create()` -> Godot `_ready()`.
- Phaser `update(time, delta)` -> Godot `_process(delta)` for frame logic, `_physics_process(delta)` for physics logic.
- Phaser scene transitions -> Godot `SceneTree.change_scene_to_file()` or scene instancing via nodes.

## Core object mapping

- Phaser `GameObject` -> Godot `Node` / `Node2D` / `Control` depending on domain.
- Phaser `Sprite` -> Godot `Sprite2D` (or `AnimatedSprite2D` when needed).
- Phaser `Container` -> Godot parent node hierarchy.
- Phaser `Group` -> Godot node groups (`add_to_group`) or managed child collections.
- Phaser `Tilemap` -> Godot `TileMap` / `TileMapLayer` setup per docs version.
- Phaser `Text` -> Godot `Label`, `RichTextLabel`, or `TextMesh` in 3D.

## Input mapping

- Phaser keyboard polling -> Godot InputMap actions (`Input.is_action_pressed`, events in `_input`).
- Phaser pointer events -> Godot input events, raycasts, `Area2D`/`CollisionObject2D` pickable patterns.

## Motion and timing

- Phaser tweens -> Godot `Tween` / `SceneTreeTween`.
- Phaser timers -> Godot `Timer` node or `SceneTree.create_timer()`.

## Physics mapping

- Phaser Arcade physics -> Godot `CharacterBody2D`, `RigidBody2D`, `Area2D` with collision layers/masks.
- Phaser overlap/collider callbacks -> Godot signals (`body_entered`, `area_entered`) and collision checks.

## Audio and assets

- Phaser asset keys -> Godot resource references (`preload`, exported resources, `.tscn` composition).
- Phaser sound manager -> Godot `AudioStreamPlayer` and bus routing.

## Practical migration rule

Do not keep Phaser API shape in Godot code. Keep gameplay intent, then re-express behavior using Godot node graph, signals, and scene composition.
