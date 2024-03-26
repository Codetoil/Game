//  Game is a multiplayer fantasy platformer-MMO written using Swift, Godot, and MMHMSSE.
//
//  Copyright (C) 2023-2024 Anthony Michalek
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU Lesser General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU Lesser General Public License for more details.

//  You should have received a copy of the GNU Lesser General Public License
//  along with this program.  If not, see <https://www.gnu.org/licenses/>.

import SwiftGodot;
import MMHMSSE;

@Godot
class WindowPlayer: CharacterBody3D, PlayerProtocol {
    private final var fallAcceleration: Float = 9.8;
    private var controller: PlayerControllerProtocol?;
    private var mesh: Mesh?;
    private var materialized: Bool = true;
    
    override func _ready() {
        super._ready();
        // dematerialize();
        controller = WindowPlayerController(windowPlayer: self);

    }
    
    override func _process(delta: Double) {
        super._process(delta: delta);
        controller?.processMovementControls();
    }
    
    override func _physicsProcess(delta: Double) {
        if Engine.isEditorHint() { return }
        if (materialized && isOnFloor())
        {
            velocity.y -= fallAcceleration * Float(delta);
        }
        
        moveAndSlide();
        super._physicsProcess(delta: delta);
        
    }
    
    override func _input(event: InputEvent) {
        super._input(event: event);
        controller?.processMouseControls(event: event);
    }
    
    func materialize() {
        materialized = true;
        (getNode(path: "CollisionShape3D") as! CollisionShape3D).disabled = false;
        (getNode(path: "Pivot/MeshInstance3D") as! MeshInstance3D).mesh = mesh;
        Input.mouseMode = Input.MouseMode.captured;
    }
    
    func dematerialize() {
        materialized = false;
        (getNode(path: "CollisionShape3D") as! CollisionShape3D).disabled = true;
        mesh = (getNode(path: "Pivot/MeshInstance3D") as! MeshInstance3D).mesh;
        (getNode(path: "Pivot/MeshInstance3D") as! MeshInstance3D).mesh = nil;
        Input.mouseMode = Input.MouseMode.visible;
    }
    
    func isMaterialized() -> Bool {
        return materialized;
    }
    
    func getController() -> PlayerControllerProtocol {
        return controller!;
    }
    
}
