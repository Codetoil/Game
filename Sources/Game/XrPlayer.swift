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
class XrPlayer: Node3D, PlayerProtocol {
    private final var fallAcceleration: Float = 9.8;
    private var controller: PlayerControllerProtocol?;
    private var mesh: Mesh?;
    private var playerBody: CharacterBody3D?;
    private var materialized: Bool = true;
    
    override func _ready() {
        super._ready();
        // dematerialize();
        controller = XrPlayerController(xrPlayer: self);
        playerBody = getNode(path: "XROrigin3D/PlayerBody") as! CharacterBody3D;
    }
    
    override func _process(delta: Double) {
        super._process(delta: delta);
        controller?.processControls();
    }
    
    override func _physicsProcess(delta: Double) {
        if Engine.isEditorHint() { return }
        if (materialized && playerBody!.isOnFloor())
        {
            playerBody!.velocity.y -= fallAcceleration * Float(delta);
        }
        
        playerBody!.moveAndSlide();
        super._physicsProcess(delta: delta);
        
    }
    
    func materialize() {
        materialized = true;
        (playerBody!.getNode(path: "CollisionShape3D") as! CollisionShape3D).disabled = false;
        (playerBody!.getNode(path: "Pivot/MeshInstance3D") as! MeshInstance3D).mesh = mesh;
    }
    
    func dematerialize() {
        materialized = false;
        (playerBody!.getNode(path: "CollisionShape3D") as! CollisionShape3D).disabled = true;
        mesh = (playerBody!.getNode(path: "PlayerBody/Pivot/MeshInstance3D") as! MeshInstance3D).mesh;
        (playerBody!.getNode(path: "Pivot/MeshInstance3D") as! MeshInstance3D).mesh = nil;
    }
    
    func isMaterialized() -> Bool {
        return materialized;
    }
    
    func getController() -> PlayerControllerProtocol {
        return controller!;
    }
    
}
