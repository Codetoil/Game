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

class XrPlayerController: PlayerControllerProtocol {
    private final var speed: Float = 5.0;
    private final var friction: Double = 5.0;
    private final var jumpImpulse: Float = 5.0;
    private final var xrPlayer: XrPlayer;
    
    init(xrPlayer: XrPlayer)
    {
        self.xrPlayer = xrPlayer;
    }
    
    func processControls() {
        var playerBody: CharacterBody3D = xrPlayer.getNode(path: "XROrigin/PlayerBody") as! CharacterBody3D;
        var xrCamera: XRCamera3D = xrPlayer.getNode(path: "XROrigin3D/XRCamera3D") as! XRCamera3D;
        
        var xMovement: Float = Float(Input.getJoyAxis(device: 0, axis: JoyAxis.leftX));
        var yMovement: Float = xrPlayer.isMaterialized() ? 0 : Float(Input.getAxis(negativeAction: "move_down",
        positiveAction: "move_up"));
        var zMovement: Float = Float(Input.getJoyAxis(device: 0, axis: JoyAxis.leftY));
        var direction: Vector3 = (xrPlayer.transform.basis * Vector3(x: xMovement, y: yMovement, z: zMovement));
        if (direction != .zero)
        {
            playerBody.velocity.x = direction.x * speed;
            playerBody.velocity.z = direction.z * speed;
            if (!xrPlayer.isMaterialized())
            {
                playerBody.velocity.y = direction.y * speed;
            }
        }
        else
        {
            playerBody.velocity.moveToward(to: Vector3(x: 0, y: yMovement, z: 0), delta: friction);
        }
        if (xrPlayer.isMaterialized() && playerBody.isOnFloor() && Input.isActionJustPressed(action: "move_up"))
        {
            playerBody.velocity.y = jumpImpulse;
        }
    }
    
}
