//
//  ColorPanel.swift
//  Menubar Colors
//
//  Created by Nikolai Vazquez on 7/20/15.
//  Copyright (c) 2015 Nikolai Vazquez. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Cocoa

class ColorPanel: NSColorPanel {
    
    // MARK: Variables
    
    private var framePadding: CGFloat {
        return SystemInfo.ScreenSize.width / 160 * self.backingScaleFactor
    }
    
    // MARK: Methods
    
    override func awakeFromNib() {
        self.hidesOnDeactivate = false
        self.title = AppInfo.AppName
        self.level = Int(CGWindowLevelForKey(CGWindowLevelKey.DockWindowLevelKey) * 5 / 2)
        self.collectionBehavior = self.collectionBehavior.union(.CanJoinAllSpaces)
    }
    
    func moveToScreenLocation(location: Location) {
        
        func newFrameOrigin() -> NSPoint? {
            let screenBounds = SystemInfo.ScreenBounds
            switch location {
            case .TopLeft:
                return NSMakePoint(
                    screenBounds.minX + framePadding,
                    screenBounds.maxY - framePadding - frame.height
                )
            case .TopRight:
                return NSMakePoint(
                    screenBounds.maxX - frame.width - framePadding,
                    screenBounds.maxY - framePadding - frame.height
                )
            case .None:
                return nil
            }
        }
        
        if let newOrigin = newFrameOrigin() {
            let newFrame = NSMakeRect(
                newOrigin.x,
                newOrigin.y,
                self.frame.width,
                self.frame.height
            )
            self.setFrame(newFrame, display: self.visible, animate: self.visible)
        }
        
    }
    
    // MARK: IB Methods
    
    @IBAction func open(sender: AnyObject?) {
        let location = Preferences.sharedPreferences().resetLocation
        self.moveToScreenLocation(location)
        self.makeKeyAndOrderFront(sender)
    }
    
    @IBAction func toggleAlpha(sender: AnyObject?) {
        self.showsAlpha = !self.showsAlpha
        if let sender = sender as? NSMenuItem {
            sender.state = self.showsAlpha ? NSOnState : NSOffState
        }
        Preferences.sharedPreferences().showsAlpha = self.showsAlpha
    }

}
