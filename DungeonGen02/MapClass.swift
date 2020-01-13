//
//  MapClass.swift
//  DungeonGen02
//
//  Created by Tom Shiflet on 12/25/19.
//  Copyright © 2019 LCS Game Design. All rights reserved.
//

import Foundation
import SpriteKit

class MapClass
{
    var mapGrid=[Int]()
    var scene:GameScene?
    
    var mapWidth:Int=0
    var mapHeight:Int=0
    
    var roomPoints=[(x: Int,y: Int)]()
    
    var startRoomIndex:Int=0
    var endRoomIndex:Int=0
    var largestRoomIndex:Int=0
    
    var TILESIZE:CGFloat=0
    
    let ROOMDISTANCE:Int=12
    
    init(width:Int, height:Int, theScene: GameScene)
    {
        scene=theScene
        
        mapWidth=width
        mapHeight=height
        
        
        
        for y in 0..<height
        {
            for x in 0..<width
            {
                
                mapGrid.append(0)
            } // for x
        } // for y
        
        print("Test \(mapGrid[5*height+3])")
        
        // choose number of rooms
        let roomNum=Int(random(min:5, max: 10.9999999999))
        
        // pick the location for the rooms
        
        
        for i in 1...roomNum
        {
            var goodSpot:Bool=false
            
            var roomX:Int=0
            var roomY:Int=0
            while (!goodSpot)
            {
                goodSpot=true
                roomX=Int(random(min: 4, max: CGFloat(width)-4))
                roomY=Int(random(min: 4, max: CGFloat(height)-4))
                print( "Last Line")
                // check for rooms nearby
                if roomPoints.count > 0
                {
                    for room in roomPoints
                    {
                        let dx = room.x - roomX
                        let dy = room.y - roomY
                        let dist=Int(hypot(CGFloat(dy), CGFloat(dx)))
                        print("Room Distance = \(dist)")
                        
                        if dist <= ROOMDISTANCE
                        {
                            goodSpot=false

                        }
                    } // for each room that already exists
                } // if we have rooms to compare to

            } // while we are still looking for a good spot
            
            mapGrid[roomX+roomY*width]=2
            roomPoints.append((x: roomX, y: roomY))
            
            
        } // for each room that we're spawning
        
        // Next we need to build out rooms of different sizes
        var largestSize:Int=0
        for i in 0..<roomPoints.count
        {
            let roomWidth:Int=Int(random(min:4, max: 10))
            let roomHeight:Int=Int(random(min:4, max: 10))
            
            if i > 0
            {
                let size=roomWidth*roomHeight
                if size > largestSize
                {
                    largestSize=size
                    largestRoomIndex=i
                }
            }

            // adjust the grid to show room floors
            for y in 0..<roomHeight
            {
                for x in 0..<roomWidth
                {
                    
                    let dx=roomPoints[i].x + x
                    let dy=roomPoints[i].y + y
                    if dy < height-1 && dx < width-1
                    {
                        mapGrid[dy*width+dx]=2
                    } // This is a messy way to avoid a crash. Needs to be cleaner by choosing rooms that are NOT right next to the edge
                } // for x
            } // for y
            
            
        } // for each room
        
        
        // Next we draw the connecting paths to room to room
        print("Room Points = \(roomPoints.count)")
        for i in 0..<roomPoints.count-1
        {
            // compute variances
            let dy = roomPoints[i].y - roomPoints[i+1].y
            let dx = roomPoints[i].x - roomPoints[i+1].x
            print("room num = \(i)")
            // choose to draw vertical or horizontal path first
            let choice=random(min:0, max: 1)
            if choice < 1   // TEST -- Forcing vertical first
            {
                if dy > 0
                {
                    // draw vertical path first
                    for yPath in 0..<dy
                    {

                        mapGrid[(roomPoints[i].y-yPath)*width+roomPoints[i].x]=2
                    } // for each y difference
                } // if drawing up
                else if dy < 0
                {
                    for yPath in 0 ..< (-dy)
                    {

                        mapGrid[(roomPoints[i].y+yPath)*width+roomPoints[i].x]=2
                    } // for each y difference
                } // else if drawing down
                
                // next draw horizontal
                
                // TEST - Breaking the midpoint of line in half and offsetting the horizontal if the dx is positive
                if dx > 0
                {
                    var midpoint:Int=0
                    var offset:Int=0
                    var currentOffset:Int=0
                    if dx > 10
                    {
                        midpoint=dx/2
                        let offChance=random(min: 0, max: 1)
                        if offChance > 0.65
                        {
                            offset=Int(random(min: 0, max: 12))
                        }
                        
                        let chance=random(min: 0, max: 1)
                        if chance > 0.5
                        {
                            offset = -offset
                        }
                    } // if dx > 10
                    
                    for xPath in 0..<dx
                    {
                        
                        

                        mapGrid[(roomPoints[i].y-dy-currentOffset)*width+roomPoints[i].x-xPath]=2
                        
                        print("xPath = \(xPath)")
                        print("midpoint = \(midpoint)")
                        print("currentOffset = \(currentOffset)")
                        print("offset = \(offset)")
                        
                        if offset >= 0
                        {
                            if xPath < midpoint && currentOffset < offset
                            {
                                if (roomPoints[i].y-dy-currentOffset-2)*width+roomPoints[i].x-xPath > 2 && (roomPoints[i].y-dy-currentOffset-2)*width+roomPoints[i].x-xPath < mapGrid.count-2
                                {
                                    
                                    currentOffset += 1
                                    print((roomPoints[i].y-dy-currentOffset)*width+roomPoints[i].x-xPath)
                                    mapGrid[(roomPoints[i].y-dy-currentOffset)*width+roomPoints[i].x-xPath]=2
                                } // if within bounds
                            } // if xPath && currentOffset
                        } // if offset is positive
                        else
                        {
                            if xPath < midpoint && currentOffset > offset
                            {
                                if (roomPoints[i].y-dy-currentOffset+2)*width+roomPoints[i].x-xPath > 3 && (roomPoints[i].y-dy-currentOffset+2)*width+roomPoints[i].x-xPath < mapGrid.count-3
                                {
                                    
                                    currentOffset -= 1
                                    print((roomPoints[i].y-dy-currentOffset)*width+roomPoints[i].x-xPath)
                                    mapGrid[(roomPoints[i].y-dy-currentOffset)*width+roomPoints[i].x-xPath]=2
                                } // if within bounds
                            } // if xPath && currentOffset
                            
                        } // else if offset is negative
                        
                        if xPath > midpoint && currentOffset > 0 && offset >= 0
                        {
                            currentOffset -= 1
                            mapGrid[(roomPoints[i].y-dy-currentOffset)*width+roomPoints[i].x-xPath]=2
                        }
                        if xPath > midpoint && currentOffset < 0 && offset < 0
                        {
                            currentOffset += 1
                            mapGrid[(roomPoints[i].y-dy-currentOffset)*width+roomPoints[i].x-xPath]=2
                        }
                    } // for each y difference
                }
                else if dx < 0
                {
                    for xPath in 0 ..< -dx
                    {

                        
                       print("dx = \(dx)")
                        print("xPath= \(xPath)")
                        mapGrid[(roomPoints[i].y-dy)*width+roomPoints[i].x+xPath]=2
                    } // for each y difference
                }
                
                
            } // if vertical first
            else
            {
                // draw horizontal path first
                
                if dx > 0
                {
                    for xPath in 0..<dx
                    {
                            print("dx = \(dx)")
                        mapGrid[(roomPoints[i].y)*width+roomPoints[i].x-xPath]=2
                    } // for each y difference
                } // if dx is positive
                else if dx < 0
                {
                    for xPath in 0 ..< -dx
                    {

                        
                       print("dx = \(dx)")
                        print("xPath= \(xPath)")
                        mapGrid[(roomPoints[i].y)*width+roomPoints[i].x+xPath]=2
                    } // for each y difference
                } // else
                
                if dy > 0
                 {
                     // draw vertical path
                     for yPath in 0..<dy
                     {

                         mapGrid[(roomPoints[i].y-yPath)*width+roomPoints[i].x-dx]=2
                     } // for each y difference
                 } // if drawing up
                 else if dy < 0
                 {
                     for yPath in 0 ..< (-dy)
                     {

                         mapGrid[(roomPoints[i].y+yPath)*width+roomPoints[i].x-dx]=2
                     } // for each y difference
                 } // else if drawing down
                 
                 // next draw horizontal
                 

                 
                
                
                
            } // if horizontal
            
        } // for each room
        
        
        // mark off walls
        for y in 0..<height
        {
            for x in 0..<width
            {
                if mapGrid[convertXY(x: x, y: y)] != 2
                {
                    // check above
                    if y < height-1
                    {
                        if mapGrid[convertXY(x: x, y: y+1)] == 2
                        {
                            mapGrid[convertXY(x: x, y: y)] = 1
                        }
                    }
                    // check right
                    if x < width-1
                    {
                        if mapGrid[convertXY(x: x+1, y: y)] == 2
                        {
                            mapGrid[convertXY(x: x, y: y)] = 1
                        }
                    }
                    // check left
                    if x > 0
                    {
                        if mapGrid[convertXY(x: x-1, y: y)] == 2
                        {
                            mapGrid[convertXY(x: x, y: y)] = 1
                        }
                    }
                    
                    if y > 0
                    {
                        if mapGrid[convertXY(x: x, y: y-1)] == 2
                        {
                            mapGrid[convertXY(x: x, y: y)] = 1
                        }
                    }
                    
                    if y > 0 && x > 0
                    {
                        if mapGrid[convertXY(x: x-1, y: y-1)] == 2
                        {
                            mapGrid[convertXY(x: x, y: y)] = 1
                        }
                    }
                    if y < height-1 && x < width-1
                    {
                        if mapGrid[convertXY(x: x+1, y: y+1)] == 2
                        {
                            mapGrid[convertXY(x: x, y: y)] = 1
                        }
                    }
                    
                    if y > 0 && x < width-1
                    {
                        if mapGrid[convertXY(x: x+1, y: y-1)] == 2
                        {
                            mapGrid[convertXY(x: x, y: y)] = 1
                        }
                    }
                    if y < height-1 && x > 0
                    {
                        if mapGrid[convertXY(x: x-1, y: y+1)] == 2
                        {
                            mapGrid[convertXY(x: x, y: y)] = 1
                        }
                    }
                } // if not a floor tile
            } // for x
        } // for y
        
        
        // draw grid
        for y in 0..<height
        {
            for x in 0..<width
            {
                switch mapGrid[x+y*height]
                {
                    
                case 1: // blocked grid
                    let tempFloor=SKSpriteNode(imageNamed: "walls")
                    tempFloor.setScale(8.0)
                    tempFloor.position.x = (CGFloat(x)*tempFloor.size.width) - (CGFloat(width)*tempFloor.size.width)/2
                    tempFloor.position.y = (CGFloat(y)*tempFloor.size.height) - (CGFloat(height)*tempFloor.size.width)/2
                    tempFloor.name="dngBlock"
                    tempFloor.texture!.filteringMode=SKTextureFilteringMode.nearest
                    
                    tempFloor.physicsBody=SKPhysicsBody(rectangleOf: tempFloor.size)
                    tempFloor.physicsBody!.isDynamic=false
                    tempFloor.physicsBody!.affectedByGravity=false
                    scene!.addChild(tempFloor)
                    TILESIZE=tempFloor.size.width
                    
                case 2: // room floor
                    
                    let tempFloor=SKSpriteNode(imageNamed: "floor")
                    tempFloor.setScale(8.0)
                    tempFloor.position.x = (CGFloat(x)*tempFloor.size.width) - (CGFloat(width)*tempFloor.size.width)/2
                    tempFloor.position.y = (CGFloat(y)*tempFloor.size.height) - (CGFloat(height)*tempFloor.size.width)/2
                    tempFloor.name="dngFloor"
                    tempFloor.texture!.filteringMode=SKTextureFilteringMode.nearest

                    scene!.addChild(tempFloor)
                    TILESIZE=tempFloor.size.width
                default:
                    break
                    
                } // switch
            } // for x
        } // for y
        
        startRoomIndex=0
        endRoomIndex=roomPoints.count-1
        
    } // init()
    
    private func convertXY(x: Int, y:Int) -> Int
    {
        return y*mapWidth+x
    }
    
} // MapClass
