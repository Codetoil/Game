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

import SwiftGodot
import MMHMSSE

@Godot
class MainNode: Node {
    private var xrInterface: XRInterface?;
    private var player: PlayerProtocol?;

    override func _ready() {
        xrInterface = XRServer.findInterface(name: "OpenXR");
        if (xrInterface != nil && xrInterface!.isInitialized()) {
            GD.print("OpenXR initialized successfully, loading XR Player");
            
            // Turn off v-sync!
            DisplayServer.windowSetVsyncMode(DisplayServer.VSyncMode.disabled);
            
            getViewport()?.useXr = true;
            
            player = createXrPlayer();
        } else if (DisplayServer.getName() == "headless") {
            GD.print("Booting in headless mode, not loading Player")
        } else {
            GD.print("OpenXR failed to initialized or is disabled, loading Window Player");

            player = createWindowPlayer();
        }
    }
    
    override func _process(delta: Double) {
        // Do nothing, for now
    }
    
    public func createXrPlayer() -> XrPlayer {
        var playerScene: PackedScene = ResourceLoader.load(path: "res://objects/XrPlayer.tscn") as! PackedScene;
        var xrPlayer: XrPlayer = playerScene.instantiate() as! XrPlayer;
        xrPlayer.position = Vector3(x: 0, y: 6, z: 0);
        addChild(node: xrPlayer);
        return xrPlayer;
    }
    
    public func createWindowPlayer() -> WindowPlayer {
        var playerScene: PackedScene = ResourceLoader.load(path: "res://objects/WindowPlayer.tscn") as! PackedScene;
        var windowPlayer: WindowPlayer = playerScene.instantiate() as! WindowPlayer;
        windowPlayer.position = Vector3(x: 0, y: 6, z: 0);
        addChild(node: windowPlayer);
        return windowPlayer;
    }
}
