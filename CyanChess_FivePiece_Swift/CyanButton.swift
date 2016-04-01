
//
//  CyanButton.swift
//  CyanChess_FivePiece_Swift
//
//  Created by licaiDev on 16/3/17.
//  Copyright © 2016年 licaiDev. All rights reserved.
//

import UIKit

class CyanBackView:UIView {
    
    func viewWithDirectionTag(tag: Int) -> UIView? {
        
        for subView in self.subviews{
            
            if subView .isKindOfClass(CyanButton){
                
                let btn:CyanButton = subView as! CyanButton
                
                if btn.directionTag == tag{
                    
                    return btn
                }else{
                    
                    continue
                }
            }
        }
        
        return nil
    }
}

class CyanButton: UIButton {
    
    var btnMark:NSInteger?

    var mark:NSInteger{
        set{
            
            if (newValue != 0){
                
                self.setTitle("\(newValue)", forState: UIControlState.Normal)
                self.titleLabel?.font = UIFont.systemFontOfSize(25)
                self.backgroundColor = UIColor.lightGrayColor()
                
            }else{
                
                self.setTitle("", forState: UIControlState.Normal)
                self.titleLabel?.font = UIFont.systemFontOfSize(25)
                self.backgroundColor = UIColor.grayColor()
            }

            
            self.btnMark = newValue
        }
        get{
            return self.btnMark!
        }
    }
    var directionTag:NSInteger = 0
    var coverd:Bool = false
    
    
//    func resetMark(willmark:NSInteger){
//       
//        mark = willmark
//        
//        if (mark != 0){
//            
//            self.setTitle("\(mark)", forState: UIControlState.Normal)
//            self.titleLabel?.font = UIFont.systemFontOfSize(25)
//            self.backgroundColor = UIColor.lightGrayColor()
//            
//        }else{
//            
//            self.setTitle("", forState: UIControlState.Normal)
//            self.titleLabel?.font = UIFont.systemFontOfSize(25)
//            self.backgroundColor = UIColor.grayColor()
//        }
//    }
    
//    -(void)setMark:(int)mark{
//    
//    _mark = mark;
//    
//    
//    if (mark != 0)
//    {
//    [self setTitle:[NSString stringWithFormat:@"%d",mark] forState:(UIControlStateNormal)];
//    self.titleLabel.font = [UIFont systemFontOfSize:25];
//    [self setBackgroundColor:[UIColor lightGrayColor]];
//    
//    }else{
//    [self setTitle:@"" forState:(UIControlStateNormal)];
//    
//    [self setBackgroundColor:[UIColor grayColor]];
//    }
//    }
   

    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
}

//@implementation CyanButton(addCate)
//
//
//- (void)addMarkValue:(int)markValue{
//
//    self.mark = markValue;
//}
//
//@end






