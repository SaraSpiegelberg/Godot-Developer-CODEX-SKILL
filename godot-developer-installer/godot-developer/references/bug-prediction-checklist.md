# Bug Prediction Checklist (Godot)

Run this checklist before finalizing any implementation.

## 1) Scene tree and node wiring

- Confirm every `get_node()` path is valid in the final scene.
- Confirm `@onready` fields are not accessed before `_ready()`.
- Confirm autoload singletons exist and names match project settings.

## 2) Signal timing and duplication

- Confirm signals are connected once (avoid duplicate connections in re-entered scenes).
- Confirm callbacks still exist after refactor/rename.
- Confirm one-shot behavior where required.

## 3) Frame vs physics consistency

- Put physics movement in `_physics_process`.
- Use `delta` correctly; avoid mixed fixed/frame-step updates.
- Verify deterministic behavior under low FPS.

## 4) Input conflicts

- Check InputMap actions for missing bindings.
- Prevent UI and gameplay input from firing simultaneously unless intended.
- Verify gamepad + keyboard behavior.

## 5) Resource and memory safety

- Avoid repeated resource loads in hot paths.
- Free temporary nodes or use lifecycle-safe ownership.
- Check large texture/audio imports for platform limits.

## 6) Multiplayer/state sync (if applicable)

- Validate authority rules and RPC mode.
- Ensure state replication order cannot apply stale data.
- Add guards for disconnect/reconnect flows.

## 7) Export/runtime environment

- Check file path assumptions between editor and exported builds.
- Verify platform permissions and window/input behavior.
- Run smoke test on target export platform, not editor only.

## Reporting format

For each detected risk, report:

- Symptom
- Root cause
- Prevention
- Fast verification
