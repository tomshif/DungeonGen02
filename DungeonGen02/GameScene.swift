//
//  GameScene.swift
//  DungeonGen02
//
//  Created by Tom Shiflet on 12/25/19.
//  Copyright © 2019 LCS Game Design. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var zoomInPressed:Bool=false
    var zoomOutPressed:Bool=false
    var upPressed:Bool=false
    var downPressed:Bool=false
    var leftPressed:Bool=false
    var rightPressed:Bool=false
    
    var tempMap:MapClass?

    
    var cam=SKCameraNode()
    
    override func didMove(to view: SKView) {
        
        self.backgroundColor=NSColor.black
        self.camera=cam
        addChild(cam)
        
        tempMap=EarthMapClass(width: 96, height: 96, theScene: self)
        print(tempMap!.roomPoints.count)
        print(tempMap!.roomPoints[tempMap!.startRoomIndex].x)
        print(tempMap!.roomPoints[tempMap!.startRoomIndex].y)
        cam.position.x = CGFloat(tempMap!.roomPoints[tempMap!.startRoomIndex].x)*tempMap!.TILESIZE - (CGFloat(tempMap!.mapWidth)*tempMap!.TILESIZE) / 2
        cam.position.y = CGFloat(tempMap!.roomPoints[tempMap!.startRoomIndex].y)*tempMap!.TILESIZE - (CGFloat(tempMap!.mapHeight)*tempMap!.TILESIZE)/2
    }
    
    
    func touchDown(atPoint pos : CGPoint) {

    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {

    }
    
    override func mouseDown(with event: NSEvent) {
        self.touchDown(atPoint: event.location(in: self))
    }
    
    override func mouseDragged(with event: NSEvent) {
        self.touchMoved(toPoint: event.location(in: self))
    }
    
    override func mouseUp(with event: NSEvent) {
        self.touchUp(atPoint: event.location(in: self))
    }
    
    override func keyDown(with event: NSEvent) {
        switch event.keyCode {

        case 13:
            upPressed=true
            
        case 0:
            leftPressed=true
            
        case 1:
            downPressed=true
            
        case 2:
            rightPressed=true
            
            
        case 27:
            zoomOutPressed=true
            
        case 24:
            zoomInPressed=true
            
            
        case 42: // \ - backslash - move to last room
            cam.position.x = CGFloat(tempMap!.roomPoints[tempMap!.endRoomIndex].x)*tempMap!.TILESIZE - (CGFloat(tempMap!.mapWidth)*tempMap!.TILESIZE) / 2
            cam.position.y = CGFloat(tempMap!.roomPoints[tempMap!.endRoomIndex].y)*tempMap!.TILESIZE - (CGFloat(tempMap!.mapHeight)*tempMap!.TILESIZE)/2
            
        case 44: // / - slash - move to largest room
            cam.position.x = CGFloat(tempMap!.roomPoints[tempMap!.largestRoomIndex].x)*tempMap!.TILESIZE - (CGFloat(tempMap!.mapWidth)*tempMap!.TILESIZE) / 2
            cam.position.y = CGFloat(tempMap!.roomPoints[tempMap!.largestRoomIndex].y)*tempMap!.TILESIZE - (CGFloat(tempMap!.mapHeight)*tempMap!.TILESIZE)/2
            
            
        case 49: // <space> - gen new map and move to beginning
            respawnDungeon()
            cam.position.x = CGFloat(tempMap!.roomPoints[tempMap!.startRoomIndex].x)*tempMap!.TILESIZE - (CGFloat(tempMap!.mapWidth)*tempMap!.TILESIZE) / 2
            cam.position.y = CGFloat(tempMap!.roomPoints[tempMap!.startRoomIndex].y)*tempMap!.TILESIZE - (CGFloat(tempMap!.mapHeight)*tempMap!.TILESIZE)/2
            
        default:
            print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
        }
    }

    override func keyUp(with event: NSEvent) {
        switch event.keyCode {

            
        case 13:
            upPressed=false
            
        case 0:
            leftPressed=false
            
        case 1:
            downPressed=false
            
        case 2:
            rightPressed=false
         
            
        case 27:
            zoomOutPressed=false
            
        case 24:
            
            zoomInPressed=false
            
        default:
            break
        }
    }
    
    
    func respawnDungeon()
    {
        for node in self.children
        {
            if node.name != nil
            {
                if node.name!.contains("dng")
                {
                    node.removeFromParent()
                }
            } // if not nil
        } // for each node
        
        
        
        for node in self.children
        {
            if node.name != nil
            {
                if node.name!.contains("mushroom")
                {
                    node.removeFromParent()
                }
            }
        }
        
        
        tempMap=EarthMapClass(width: 96, height: 96, theScene: self)
        
    } // respawnDungeon()
    
    
    func checkKeys()
    {
        if zoomOutPressed
        {
            cam.setScale(cam.xScale+1)
        }
        if zoomInPressed && cam.xScale > 0.01
        {
            cam.setScale(cam.xScale-0.02)
        }
        
        if upPressed
        {
            cam.position.y += 10
        }
        if downPressed
        {
            cam.position.y -= 10
        }
        if rightPressed
        {
            cam.position.x += 10
        }
        if leftPressed
        {
            cam.position.x -= 10
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        checkKeys()
    }
}
