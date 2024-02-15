//
//  Symbol.swift
//  Flashword
//
//  Created by Alessio Mason on 14/02/24.
//

import Foundation

enum Symbol: String, CaseIterable, Codable {
    // MARK: Weather
    case sunMax = "sun.max"
    case sunHorizon = "sun.horizon"
    case moon = "moon"
    case sparkles = "sparkles"
    case cloud = "cloud"
    case cloudBolt = "cloud.bolt"
    case bolt = "bolt"
    case flame = "flame"
    case drop = "drop"
    case snowflake = "snowflake"
    case rainbow = "rainbow"
    case mountain2 = "mountain.2"
    case leaf = "leaf"
    case tree = "tree"
    case dog = "dog"
    case cat = "cat"
    case bird = "bird"
    case ladybug = "ladybug"
    case fish = "fish"
    case atom = "atom"
    
    // MARK: Maps and transports
    case mappin = "mappin"
    case map = "map"
    case signpostRightAndLeft = "signpost.right.and.left"
    case binoculars = "binoculars"
    case bicycle = "bicycle"
    case car = "car"
    case truckBox = "truck.box"
    case airplane = "airplane"
    case sailboat = "sailboat"
    
    // MARK: Objects
    case pencilLine = "pencil.line"
    case eraserLineDashed = "eraser.line.dashed"
    case folder = "folder"
    case trayFull = "tray.full"
    case archiveBox = "archivebox"
    case clipboard = "clipboard"
    case calendar = "calendar"
    case booksVertical = "books.vertical"
    case bookmark = "bookmark"
    case graduationCap = "graduationcap"
    case pencilAndRuler = "pencil.and.ruler"
    case backpack = "backpack"
    case paperclip = "paperclip"
    case link = "link"
    case flag = "flag"
    case camera = "camera"
    case gameController = "gamecontroller"
    case paintbrush = "paintbrush"
    case hammer = "hammer"
    case stethoscope = "stethoscope"
    case printer = "printer"
    case lightbulb = "lightbulb"
    case key = "key"
    case eyeglasses = "eyeglasses"
    case clock = "clock"
    case hourglass = "hourglass"
    case gift = "gift"
    
    // MARK: Devices
    case laptopComputer = "laptopcomputer"
    case smartphone = "smartphone"
    case headphones = "headphones"
    case tv = "tv"
    case network = "network"
    
    // MARK: People
    case person = "person"
    case figureWalk = "figure.walk"
    case faceSmiling = "face.smiling"
    case handThumbsUp = "hand.thumbsup"
    case heart = "heart"
    
    // MARK: Sports
    case trophy = "trophy"
    case medal = "medal"
    case soccerball = "soccerball"
    case baseball = "baseball"
    case basketball = "basketball"
    case football = "football"
    case cricketBall = "cricket.ball"
    case tennisball = "tennisball"
    case volleyball = "volleyball"
    case skateboard = "skateboard"
    case skis = "skis"
    case snowboard = "snowboard"
    case surfboard = "surfboard"
    
    static let suggested = [
        Symbol.sunMax,
        .sparkles,
        .bolt,
        .rainbow,
        .leaf,
        .map,
        .signpostRightAndLeft,
        .binoculars,
        .graduationCap,
        .camera,
        .booksVertical,
        .lightbulb,
        .key,
        .clock,
        .headphones,
        .tv,
        .heart,
        .trophy
    ]
    
    static let weather = [
        Symbol.sunMax,
        .sunHorizon,
        .moon,
        .sparkles,
        .cloud,
        .cloudBolt,
        .bolt,
        .flame,
        .drop,
        .snowflake,
        .rainbow,
        .mountain2,
        .leaf,
        .tree,
        .dog,
        .cat,
        .bird,
        .ladybug,
        .fish,
        .atom
    ]
    
    static let transports = [
        Symbol.mappin,
        .map,
        .signpostRightAndLeft,
        .binoculars,
        .bicycle,
        .car,
        .truckBox,
        .airplane,
        .sailboat
    ]
    
    static let objects = [
        Symbol.pencilLine,
        .eraserLineDashed,
        .folder,
        .trayFull,
        .archiveBox,
        .clipboard,
        .calendar,
        .booksVertical,
        .bookmark,
        .graduationCap,
        .pencilAndRuler,
        .backpack,
        .paperclip,
        .link,
        .flag,
        .camera,
        .gameController,
        .paintbrush,
        .hammer,
        .stethoscope,
        .printer,
        .lightbulb,
        .key,
        .eyeglasses,
        .clock,
        .hourglass,
        .gift
    ]
    
    static let devices = [
        Symbol.laptopComputer,
        .smartphone,
        .headphones,
        .tv,
        .network
    ]
    
    static let people = [
        Symbol.person,
        .figureWalk,
        .faceSmiling,
        .handThumbsUp,
        .heart
    ]
    
    static let sports = [
        Symbol.trophy,
        .medal,
        .soccerball,
        .baseball,
        .basketball,
        .football,
        .cricketBall,
        .tennisball,
        .volleyball,
        .skateboard,
        .skis,
        .snowboard,
        .surfboard,
    ]
}
