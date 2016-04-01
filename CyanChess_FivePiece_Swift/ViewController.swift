//
//  ViewController.swift
//  CyanChess_FivePiece_Swift
//
//  Created by licaiDev on 16/2/4.
//  Copyright © 2016年 licaiDev. All rights reserved.
//


import UIKit

class ViewController: UIViewController {
    
    let successMax = 32
    var gap:CGFloat = 0.0
    var btnLenth:CGFloat = 0.0
    var LABELWIDTH:CGFloat = 0.0
    var LABELHEIGHT:CGFloat = 0.0
    var BGWIDTH:CGFloat = 0.0
    var BGHEIGHT:CGFloat = 0.0
    
    var backView:CyanBackView = CyanBackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1)
        
        enum GSGDeviceType{
            
            case GSGPad
            case GSGPhone
        }
        
        //用 枚举 区分变量值
        func someValue(index:GSGDeviceType){
            
            if(index == GSGDeviceType.GSGPad){
                
                gap = 2
                btnLenth = 150
                LABELWIDTH = 100
                LABELHEIGHT = 30
                BGWIDTH = 610
                BGHEIGHT = 610
                
            }else{
                gap = 2
                btnLenth = 60
                LABELWIDTH = 100
                LABELHEIGHT = 30
                BGWIDTH = 250
                BGHEIGHT = 250
                
            }
        }
        
        //这里 设置 设备 类型
        someValue(GSGDeviceType.GSGPhone)
        print(BGHEIGHT)
        
        //初始化UI
        initUI()
        
        //开始游戏
        self.startGame()
    }
    
    func initUI(){
        
        let textLabel:UILabel = UILabel(frame: CGRectMake(20, 80, LABELWIDTH, LABELHEIGHT))
        textLabel.textColor = UIColor.cyanColor()
        textLabel.textAlignment = NSTextAlignment.Center
        textLabel.text = "2048"
        self.view.addSubview(textLabel)
      
        backView = CyanBackView(frame: CGRectMake(0,0,BGWIDTH,BGHEIGHT))
        backView.center = self.view.center
        backView.backgroundColor = UIColor.grayColor()
        backView.userInteractionEnabled = true
        backView.tag = 10000
        backView.addObserver(self, forKeyPath: "tag", options: NSKeyValueObservingOptions.New, context: nil)
        self.view.addSubview(backView)
        
        let pan:UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action:("pan:"))
        backView.addGestureRecognizer(pan)

//        //创建16个 会移动的btn
//        //  btn.mark  标记 其上的数字 0 代表无值 btn 应该隐藏
        for index:NSInteger in 0...15{
            
            let btn:CyanButton = CyanButton(type: UIButtonType.RoundedRect)
            btn.tag = index+100
            btn.directionTag = index
            btn.mark = 0
            btn.coverd = false
            btn.backgroundColor = UIColor.grayColor()
            btn.frame = CGRectMake(gap+CGFloat(index%4)*(btnLenth+gap), gap+CGFloat(index/4)*(btnLenth+gap), btnLenth, btnLenth)
            btn.addObserver(self, forKeyPath:"mark", options: NSKeyValueObservingOptions.New, context: nil)
            
            backView.addSubview(btn)
        }
    }

//    //每一动一步 都会怎加一个按钮
    func addOneMoreStep(){
        
        let arr:NSArray = resetBlankArr()
        
        if arr.count == 0{
            
            return;
        }else{
            
            let num:NSInteger = getRandomNum(arr)
            
            let btn:CyanButton = backView.viewWithTag(num+100) as! CyanButton
            
            let num1:NSInteger = getTwoOrFourRandom()

            btn.mark = num1
            
            btn.backgroundColor = UIColor.lightGrayColor()
        }
        
    }
    
//    //随机得到白块区域的某个位置
//    //随机得到2 或4
    func getTwoOrFourRandom()->NSInteger{
        
        return  Int((rand()%2)+1)*2
    }
    func getRandomNum(arr:NSArray)->NSInteger{
        
        let index:NSInteger = Int(rand())%arr.count
        return arr.objectAtIndex(index).integerValue
    }
    
//    //计算白块区域  将其btn.tag值放入数组中
    func resetBlankArr()->NSArray{
        
        let arr:NSMutableArray = NSMutableArray()
        
        for i in 0...15{
            
            let btn:CyanButton = backView.viewWithTag(i+100) as! CyanButton
            
            if btn.mark == 0{
                
                arr.addObject("\(i)")
            }
        }
        
        return arr.copy() as! NSArray
    }
    
    func reStartGame(){
        
        for index in 0...15{
            
             let btn:CyanButton = backView.viewWithTag(index+100) as! CyanButton
            btn.mark = 0
        }
        
        self.startGame()
    }
    
    //开始游戏...
    func startGame(){
        
        for _ in 0...1{
            self.addOneMoreStep()
        }
        
        for index:NSInteger in 0...15{
            
            let btn:CyanButton = backView.viewWithTag(index+100) as! CyanButton
            
            if btn.mark == 0{
                
                btn.backgroundColor = UIColor.grayColor()
                
            }else{
                
                btn.backgroundColor = UIColor.lightGrayColor()
            }
        }
    }
    
    //开始手势操作 ⬇️
    func pan(panGes:UIPanGestureRecognizer){
        
        if panGes.state == UIGestureRecognizerState.Ended {
            
            let translacation:CGPoint = panGes.translationInView(self.view)
            
            var direction = 0
            
            if abs(translacation.x) > abs(translacation.y){
                
                if translacation.x > 0 {
                    
                    direction = 3
                }else{
                    direction = 2
                }
            }else{
                
                if translacation.y > 0 {
                    direction = 1
                }else {
                    direction = 0
                }
            }
            self.panDirection(direction)
        }
    }

    func resetDirectionTagByDirection(direction:NSInteger){
        
        var a0 = Array<Array<Int>>()
        var a1 = Array<Array<Int>>()
        var a2 = Array<Array<Int>>()
        var a3 = Array<Array<Int>>()

        var b = Array<Array<Int>>()
        var c = Array<Array<Int>>()
        
        a0 = [
            [0, 1, 2,  3],
            [4, 5, 6,  7],
            [8, 9, 10, 11],
            [12,13,14, 15]
        ]
        
        a1 = [
            
            [15, 14, 13,  12],
            [11, 10, 9,   8],
            [7,  6,  5,   4],
            [3,  2,  1,   0]
        ]
        
         a2 = [
            
            [3, 7,  11, 15],
            [2, 6,  10, 14],
            [1, 5,  9,  13],
            [0, 4,  8,  12]
        ]
    
        a3 = [
            
            [12, 8,  4, 0],
            [13, 9,  5, 1],
            [14, 10, 6, 2],
            [15, 11, 7, 3]
        ]

        b = [
            [1,1,1,1],
            [1,1,1,1],
            [1,1,1,1],
            [1,1,1,1],
        ]
        
        c = [
            [0,0,0,0],
            [0,0,0,0],
            [0,0,0,0],
            [0,0,0,0]
        ]
        
        var lSum:NSInteger = 0
        
        for index_i:NSInteger in 0...3{
            
            for index_j:NSInteger in 0...3{
                
                lSum = 0
                
                for index_k:NSInteger in 0...3{
                    
                    lSum += a1[index_i][index_k]*b[index_k][index_j]
                    
                    c[index_j][index_i] = lSum
                }
            }
        }
        
        //完成四个方向的操作 0 1 下上 2 3 左右
        switch (direction) {
            
        case 0:
            
            for i:NSInteger in 0...15 {
                
                let btn:CyanButton = backView.viewWithTag(i+100) as! CyanButton
                btn.directionTag = a0[i/4][i%4]
            }
            
            break;
        case 1:
            
            for i:NSInteger in 0...15 {
                
                let btn:CyanButton = backView.viewWithTag(i+100) as! CyanButton
                btn.directionTag = a1[i/4][i%4]
            }
            break;
            
        case 2:
            
            for i:NSInteger in 0...15 {
                
                let btn:CyanButton = backView.viewWithTag(i+100) as! CyanButton
                btn.directionTag = a2[i/4][i%4]
            }
            
            break;
            
        case 3:
            
            for i:NSInteger in 0...15 {
                
                let btn:CyanButton = backView.viewWithTag(i+100) as! CyanButton
                btn.directionTag = a3[i/4][i%4]
            }
            
            
        default:
            break;

        }
    }
    func panDirection(direction:NSInteger){
        
        //根据direction重置direction tag值  方便取到btn
        resetDirectionTagByDirection(direction)
        
        var isMoved = false
        
        for verticle in 0...3{
            
            for horticle in 0...3{
                
                let btn = backView.viewWithDirectionTag(horticle*4+verticle) as! CyanButton
                btn.coverd = false
            }
            
            for cuurent in 1...3{
                
                var beforeBtn:CyanButton = CyanButton()
               
                
                for var blank = cuurent-1; blank >= 0; blank-- {
                
                    beforeBtn = backView.viewWithDirectionTag(blank*4+verticle) as! CyanButton
                    
                    if blank == 0 {
                        
                        break
                    }else{
                        
                        if beforeBtn.mark > 0 {
                            break
                        }else{
                            continue
                        }

                    }
                    
                }
                
                let currentBtn:CyanButton = backView.viewWithDirectionTag(cuurent*4+verticle) as! CyanButton
                
                if currentBtn.mark > 0{
                    
                    
                    if beforeBtn.mark > 0 {
                        
                        if currentBtn.mark == beforeBtn.mark && beforeBtn.coverd == false {
                            
                            beforeBtn.mark = 2*beforeBtn.mark
                            beforeBtn.coverd = true;
                            
                            currentBtn.mark = 0
                            isMoved = true;
                            
                            //判断 是否赢取比赛
                            if beforeBtn.mark == successMax{
                                
                                if #available(iOS 8.0, *) {
                                
                                    let alerController = UIAlertController.init(title: "you win" , message: "我的2048", preferredStyle: UIAlertControllerStyle.Alert)
                                    
                                    alerController.addAction(UIAlertAction.init(title: "确定", style: UIAlertActionStyle.Default, handler: {
                                        
                                        (alerts: UIAlertAction!) -> Void in
                                        
                                        //do nothing
                                    }))
                                    
                                    alerController.addAction(UIAlertAction.init(title: "重玩", style: UIAlertActionStyle.Default, handler: {
                                        
                                        (alerts: UIAlertAction!) -> Void in
                                        
                                        self.reStartGame()
                                    }))
                                    
                                    self.presentViewController(alerController, animated: true, completion: nil)
                                }else{
                                    
                                    self.reStartGame()

                                }
                                
                            }
                            
                        }else{
                            
                            let beforeDirectionTag = beforeBtn.directionTag
                            
                            if currentBtn.directionTag == beforeDirectionTag+4 {
                                
                                //do nothing
                            }else{
                                
                                let beforeLastBtn:CyanButton = backView.viewWithDirectionTag(beforeDirectionTag+4) as! CyanButton
                                
                                let currentCenterRemember = currentBtn.center
                                let beforeCenterRemember = beforeLastBtn.center
                                
                                UIView.animateWithDuration(0.3, animations: { () -> Void in
                                    
                                    currentBtn.center = beforeCenterRemember;
                                    beforeLastBtn.center = currentCenterRemember;
                                })
                                
                                let sam = currentBtn.directionTag;
                                currentBtn.directionTag = beforeLastBtn.directionTag;
                                beforeLastBtn.directionTag = sam;
                                
                                
                                let sam1 = currentBtn.tag;
                                currentBtn.tag = beforeLastBtn.tag;
                                beforeLastBtn.tag = sam1;
                                
                                isMoved = true;
                            }

                        }
                    }else{
                        
//                        let currentCenterRemember = currentBtn.center;
//                        currentBtn.center = beforeBtn.center;
//                        beforeBtn.center = currentCenterRemember;
                        
                        let currentCenterRemember = currentBtn.center
                        let beforeCenterRemember = beforeBtn.center
                        
                        UIView.animateWithDuration(0.3, animations: { () -> Void in
                            
                            currentBtn.center = beforeCenterRemember;
                            beforeBtn.center = currentCenterRemember;
                        })
                        
                        let sam = currentBtn.directionTag;
                        currentBtn.directionTag = beforeBtn.directionTag;
                        beforeBtn.directionTag = sam;
                        
                        
                        let sam1 = currentBtn.tag;
                        currentBtn.tag = beforeBtn.tag;
                        beforeBtn.tag = sam1;
                        
                        isMoved = true;
                        
                    }
                }else{
                    
                    //do nithing
                }
                
            }
        }
        
        
        if isMoved {
    
//           self.performSelector(Selector(addOneMoreStep()), withObject:nil, afterDelay: 0.3)
            
            let delay = 0.3 * Double(NSEC_PER_SEC)
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            
            dispatch_after(time, dispatch_get_main_queue(), {
               
                self.addOneMoreStep()
            })
      
        }else{
            
            for i in 0...15 {
                
                let btn:CyanButton = backView.viewWithTag(100+i) as! CyanButton
                
                if btn.mark > 0 {
                    
                    if i == 15 {
                        
                        if #available(iOS 8.0, *) {
                            
                            let alerController = UIAlertController.init(title: "you fail" , message: "我的2048", preferredStyle: UIAlertControllerStyle.Alert)
                            
                            alerController.addAction(UIAlertAction.init(title: "确定", style: UIAlertActionStyle.Default, handler: {
                                
                                (alerts: UIAlertAction!) -> Void in
                                
                                //do nothing
                            }))
                            
                            alerController.addAction(UIAlertAction.init(title: "重玩", style: UIAlertActionStyle.Default, handler: {
                                
                                (alerts: UIAlertAction!) -> Void in
                                
                                self.reStartGame()
                            }))
                            
                            self.presentViewController(alerController, animated: true, completion: nil)
                            
                            
                        }else {

                            self.reStartGame()

                        }
                        
                        break;
                    }
                }else{
                    
                    
                    break;
                }
                
            }
            
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

