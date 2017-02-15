//
//  ViewController.swift
//  SwiftDemo
//
//  Created by wangjingfei on 2017/2/6.
//  Copyright © 2017年 wangXiao. All rights reserved.
//

import UIKit
//import First

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //设置背景颜色
        self.view.backgroundColor = UIColor.red
        
        //创建button
        let btn = UIButton()
        btn.frame = CGRect(x: 100,y: 100,width: 100,height: 50)
       btn.setTitle("buuton", for: UIControlState.normal)
        btn.setTitleColor(UIColor.green, for: UIControlState.normal)
        btn.setImage(UIImage(named:""), for: UIControlState.normal)
        //点击事件
        btn.addTarget(self, action:"buttonClick:", for: UIControlEvents.touchUpInside)
        self.view.addSubview(btn)
        
        print("Hello world")
        
        /********************声明常量和变量*******************/
        //常量和变量必须在使用之前声明
        //let 做常量  var做变量
        var myVar = 33
        myVar = 23
        print(myVar)
        
        //在一行中声明多个常量或多个变量，由逗号分隔：
        var x = 0.0, y = 0.0, z = 0.0
        x = 1.0
        y = 2.0
        z = 3.0
        print("x--------",x,"y----------",y,"z----------",z)
        
        let myConstant = 32
        print(myConstant)
        //若初始化时未提供足够信息（没有初始值），可以在变量后面指定类型，用冒号隔开。
        let intM:Double = 30
        print(intM)
        
        //值在转化为另一种类型时从不具有隐含性。如果需要转化值到另一种类型，请明确性地为值进行格式转换。
        let label = "The width is"
        let width = 94
        let widthLabel = label + String(width)
        print(widthLabel)
        
        //类型标注
        /*
         “冒号” 意味着“是...类型”，所以上面的代码可以解读为:
         “声明一个名称为welcomeMessage的变量，是String类型的。”
         “是String类型的”这个短语的意思是“可以存储任何字符串值。”
         */
        var welcomeMessage:String
        welcomeMessage = "Welcome to China"
        print(welcomeMessage)
        
    
        /*************命名常量和变量***********/
        //可以使用任何字符命名常量和变量名，包括Unicode(注意：1.常量与变量名不能包含数学符号、箭头、保留的（或者非法的）Unicode 码、连线与制表符。不能以数字开头，但是可以在变量名的其他地方包含数字。2.如果你需要命名一个常量或变量名称为保留关键字，你可以使用反引号(‘)包括关键字作为变量名称。当然，最好避免使用关键字作为名称，除非别无选择。 )
        /****************打印常量和变量*************/
        //使用 println 函数可以打印一个常量或变量的值:
//        printIn(welcomeMessage)
        
        //在一行中写多个独立的语句时，分号是必需的。
        let cat = "miao";print(cat) //等价于
       /* let cat = "miao"
        print(cat)*/
        //整数范围
        
        let minValue = UInt8.min
        let maxValue = UInt8.max
        print("minValue----------",minValue,"maxValue------",maxValue)
        /*
         整数字面值可以写为：
         一个十进制数，没有前缀
         一个二进制数，前缀是 0b
         一个八进制数，前缀是 0o
         一个十六进制数，前缀是 0x
         */
        //整数和浮点数之间的转换必须显示的指定类型:
        let three = 3
        let pointFour = 0.14134
        let douP = Double(three) + pointFour
        let intP = three + Int(pointFour)
        print("douP-----------",douP,"intP---------",intP)
        
        /**************类型别名***********/
        //类型别名就是给一个类型定义一个小名，通过关键字typealias关键字进行定义（一旦定义一个类型别名，可以再热和地方使用别名来代替原来的名称）
        typealias audioSample = UInt16
        let minSample = audioSample.min
        print("minSample------------",minSample)
        
        
        /***************布尔型************/
        //布尔常量值：true ，false:
        let orangeAreOrange = true
        let turnIpsAreDelicious = false
        print("orangeAreOrange----------",orangeAreOrange,"turnIpsAreDelicious----",turnIpsAreDelicious)
        
        if turnIpsAreDelicious {
            print("Mmm,tasty turnips!")
        }else{
            print("Eww,turnips are horrie.")
        }
        
        /***********元组**********/
        //元组（tuple）是把多个数值合成一个复合值(元组可以包含任何类型，类型的顺序也是随意的)
        let http404Error = (404,"Not Found")
        print("http404Error---------",http404Error)
        
        let suiTuple = (234,true,"Hello World!",3.322)
        print("suiTuple-----------",suiTuple)
        
        //将一个元组的内容分解成单独的常量或变量
        let (statusCode,statusMessage) = http404Error
        print("statusCode----------",statusCode,"statusMessage-------",statusMessage)
        
        //如果只需要一部分的值，忽略的部分用下划线（_）标记
        let (firstStatues,_,threeStatus,_) = suiTuple
        print("The status code is \(firstStatues) \(threeStatus)")
        
        //可以使用索引访问员组中的元素，索引数字从0开始
        print("The status code is \(http404Error.1)")
        
        //可以给元组的各个元素进行命名
        let http200Stauts = (statusCode: 200,descript:"Ok")
        print("statusCode-----------",http200Stauts.statusCode,"descript-----------",http200Stauts.descript)
        print("http200Stauts---------",http200Stauts.0)
        //注意：元组在临时组织值得时候很有用，但是并不合适创建复杂的数据结构。如果你的数据结构并不是临时使用，请使用类或者结构体
        
        
        /**************可选（Optional）***********/
        //使用可选（Optional）来处理可能缺失值的情况
        //注意：C和Objective-C中没有可选这个概念。Objective-C中的一个特性与可选比较类似：一个方法要么返回一个对象，要么返回nil，nil标识“缺少一个合法的对象”
        
        let possibleNumber = "123"
        let convertedNumber = (possibleNumber as NSString).doubleValue
        print("convertNumber--------------",convertedNumber)
        
        let possibleInt = "Hello 12445"
        let convertInt = (possibleInt as NSString).intValue
        print("convertInt-----------",convertInt)
        
        /*****************If语句和强制解析*************/
        //注意：如果使用！来获取一个不存在的可选值会导致运行时错误。使用!来强制解析值之前，一定要确定可选包含一个非nil得值(if判断一下)
        let converNumber = true
        
        if converNumber {
            print("\(possibleNumber) has an integer value of \(convertedNumber)")
        }else{
            print("\(possibleNumber) could not be converted to an integer")
        }
        

        /**************断言调试***********/
        
        /*
         断言的适用情景：
         1.整数下标索引被传递一个定制的下标实现，下标索引值可能太小或者太大。
         2.给函数传入一个值，但是非法的值可能导致函数不能正常执行。
         3.可选值现在是 nil，但是后面的代码运行需要一个非nil值。
         */
        
        //注意：断言会导致应用终止运行，所以代码的设计要避免非法条件的出现。但是，在应用发布之前，非法条件的出现触发断言可以快速发现问题。
        let age = -3
        assert(age < 0,"A person's age cannot be less than zero")
        
        //更简单的方法将值转换为String：将值写在括号中，并在括号前添加一个反斜杠。
        let apples = 3
        let oranges = 5
        let appleSummary = "I have \(apples) apples."
        let orangesSummary = "I have \(apples + oranges) pieces of fruit."
        print("appleSummary---------",appleSummary,"orangesSummary-------",orangesSummary)
        
        //通过 [] 创建一个数组和字典，通过 index 和 key 获取对应的值
        var shoppingList = ["catFish","water","tulips","blue paint"]
        //插入数据
        shoppingList[1] = "bottle of water"
        print(shoppingList)
        
        var occupations = ["Malcolm":"Captain","Kaylee":"Mechanic"];
        //插入数据
        occupations["Jayne"] = "Public Relations"
        print(occupations)
        
        //创建空数组和空字典
//        let emptyArray = String[]()
        
        var emptyDictionary = Dictionary<String, Float>()
        
        emptyDictionary["First"] = 0.0
        print("emptyDictionary--------",emptyDictionary)
        //为了防止类型信息被更改，空数组列用[]，空字典用[:]进行初始化 - 例如，为变量赋新值和给函数传递参数的时候。
        shoppingList = []
        print("bArray---------",shoppingList)
        
        /********************流程控制**************/
        
        //使用if和switch判断条件，使用for-in、for 、while和do-while处理循环。条件和循环变量的括号可以省略，语句体的大括号是必须的。
        let indeividualScore = [75,43,103,87]
        var teamScore = 0
        for score in indeividualScore {
            if score > 50 {
                teamScore += 3
            }else{
                teamScore += 1
            }
        }
        print(teamScore)
        
        /*在 if 语句中，条件必须是一个布尔表达式 —— 这意味着像 if score { ... } 这样的代码将报错，而不会隐形地与 0 做对比。你可以一起使用 if 和 let 来处理条件值缺失的情况。有些变量的值是可选的。一个可选的值如果是一个具体的值或者是 nil ，那表明这个值缺失。在类型后面加一个 ? 来标记这个变量的值是可选的。*/
        //如果变量的可选值是 nil ，条件会判断为 false ，并且大括号中的代码会被跳过。如果不是nil，会将值赋给let后面的常量，这样代码块中就可以使用这个值了。
        var optionalString: String? = "Hello"
        optionalString = nil
        print("optionalString------------",optionalString)
        var optionalName: String? = "John"
        var greeting = "Hello!"
        if let name = optionalName {
            greeting = "Hello,\(name)"
        }
        print("greeting----------",greeting)
        
        //使用switch支持任意类型的数据以及各种比较操作——不仅仅是整数以及测试相等。
        //运行 switch 中匹配到的子句之后，程序会退出switch语句，并不会继续向下运行，所以不需要在每个子句结尾写break。
        let vegetable = "red pepper"
        switch vegetable {
        case "celery":
            let vegetableComment = "Add some raisins and mask ants on a log."
            print("vegetableComment-----------",vegetableComment)
        case "cucumber", "watercress":
            let vegetableComment = "That would make a good tea sandwich."
            print("vegetableComment-----------",vegetableComment)

        case let x where x.hasSuffix("pepper"):
            let vegetableComment = "Is it a spicy \(x)?"
            print("vegetableComment-----------",vegetableComment)
        default:
            let vegetableComment = "Everything tastes good in soup."
            print("vegetableComment-----------",vegetableComment)

        }
        
        //使用 while 来重复运行一段代码直到不满足条件。循环条件可以在开头也可以在结尾。
        var n = 2
        while n < 100 {
            n = n * 2
        }
        print("n---------",n)
        
        var m = 2
        repeat{
            m = m * 2
        }while m < 100
        print("m----------",m)
        
        //你可以在循环中使用 ... 来表示范围，也可以使用传统的写法，两者是等价的：(使用 .. 表示的范围不包括上界，如果想包括的话需要使用 ...)
        var firstForLoop = 0
        for i in 0...3 {
            firstForLoop += i
        }
        print("firstForLoop----",firstForLoop)
        
        
        var secondForLoop = 0
        for _ in 0 ..< 3{
            secondForLoop += 1;
        }
        print("secondForLoop-----------",secondForLoop)
        
        /*****************函数和闭包***************/
        //使用 func 来声明一个函数，通过函数的名字和参数来调用函数。使用 -> 指定函数返回值（分离了返回值和参数）
        let str = greet(name: "Bob", day: "Tuesday")
        print(" str--------------", str)
        
        //使用元组定义函数的多个返回值
        let dd = getGasPrices()
        print("dd-------",dd)
        
        //传递可变数量的参数，通过数组获取参数
        let sum = sumOf(numbers: 10,11)
        print("sum----------",sum)
        
        //函数可以嵌套，被嵌套的函数可以访问外部函数的变量。可以通过函数的嵌套来重构太长或者太复杂的函数。
        let result = returnFifteen()
        print("result------------",result)
        
        //函数是一级类型，这意味着函数可以使用另一个函数作为返回值
        let increment = makeIncrementer()
        
        print("---------------",increment(7))
        
        
    }
    func greet(name : String , day : String) -> String {
        return "Hello \(name),today is \(day)."
    }
    func getGasPrices() -> (Double,Double,Double) {
        return (3.55,3.44,3.66)
    }
    func sumOf(numbers: Int...) -> Int {
        var sum = 0
        for number in numbers {
            sum += number
        }
        return sum
    }
    func returnFifteen() -> Int {
        var y = 10
        func add(){
            y += 5
        }
        add()
        return y
    }
    func makeIncrementer() -> ((Int) -> Int) {
        func addOne(number: Int) -> Int{
            return 1 + number
        }
        return addOne
    }
    //UIButton后面的“！”表示sender可以是由UIButton继承来的任意子类
    func buttonClick(sender:UIButton!){
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

