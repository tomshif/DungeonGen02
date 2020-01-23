//
//  EarthMapClass.swift
//  DungeonGen02
//
//  Created by 5 - Game Design on 1/23/20.
//  Copyright © 2020 LCS Game Design. All rights reserved.
//

import Foundation
import SpriteKit

class EarthMapClass:MapClass
{
    override init(width:Int, height:Int, theScene: GameScene)
    {
        super.init(width: width, height: height, theScene: theScene)
        
        ROOMDISTANCE=3
        MINNUMROOMS=4
        MAXNUMROOMS=7
        
        createLevel()
        drawGrid()
    }
    
    
    override func drawGrid()
    {
    for y in 0..<mapHeight
           {
               for x in 0..<mapWidth
               {
                   switch mapGrid[x+y*mapHeight]
                   {
                       
                   case 1: // blocked grid
                       let tempFloor=SKSpriteNode(imageNamed: "desertWall00")
                       tempFloor.setScale(8.0)
                       tempFloor.position.x = (CGFloat(x)*tempFloor.size.width) - (CGFloat(mapWidth)*tempFloor.size.width)/2
                       tempFloor.position.y = (CGFloat(y)*tempFloor.size.height) - (CGFloat(mapHeight)*tempFloor.size.width)/2
                       tempFloor.name="dngBlock"
                       tempFloor.texture!.filteringMode=SKTextureFilteringMode.nearest
                       
                       tempFloor.physicsBody=SKPhysicsBody(rectangleOf: tempFloor.size)
                       tempFloor.physicsBody!.isDynamic=false
                       tempFloor.physicsBody!.affectedByGravity=false
                       scene!.addChild(tempFloor)
                       TILESIZE=tempFloor.size.width
                       
                   case 2: // room floor
                       
                       let tempFloor=SKSpriteNode(imageNamed: "earthFloor00")
                       tempFloor.setScale(8.0)
                       tempFloor.position.x = (CGFloat(x)*tempFloor.size.width) - (CGFloat(mapWidth)*tempFloor.size.width)/2
                       tempFloor.position.y = (CGFloat(y)*tempFloor.size.height) - (CGFloat(mapHeight)*tempFloor.size.width)/2
                       tempFloor.name="dngFloor"
                       tempFloor.texture!.filteringMode=SKTextureFilteringMode.nearest

                       scene!.addChild(tempFloor)
                       TILESIZE=tempFloor.size.width
                   default:
                       break
                       
                   } // switch
               } // for x
           } // for y
    }
    

    
    
}
