### CSLCommonLibrary
一些常用工具库，基于基础库封装，方便调用。同时解决了`delegate`需要`weak`引用的问题，也就是说现在你可以放心的`strong`去修饰你的`delegate`了。同时也解决了`kvo`,`notification`的手动移除问题

也不需要在你的类中去实现你需要的任务协议和协议对应的方法。仅仅通过一下几步：
#### CSLDelegateProxy
1、将你需要实现的协议名称传递过去 
`- (instancetype)initWithDelegateProxy:(Protocol *)protocol`
2、添加你需要实现的协议方法名，例如(`alertView:clickedButtonAtIndex:`)，block回调中的参数包括协议调用方所传递的所有参数。当然这个类使用的场景多半是自定义协议
`- (void)addSelector:(SEL)selector callback:(void(^)(id))callback`

对于常见组件，例如`UIAlertView`，他的协议已经被封装到了
##### UIAlertView+DelegateProxy
这时候`UIAlertView`的初始化就不需要指定`delegate`了
`[[UIAlertView alloc]initWithTitle:@"title" message:@"message" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:@"ok", nil]`

除了协议之外，像触摸响应控件如：`UIControl`
平常我们都会这样使用`[control addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];`
这样我们不的不写一个新的方法`-(void)click:(UIControl *)control`
代码会很分散。但饿哦们可以这样使用：
##### UIControl+Events
`- (void)onEventChange:(NSObject *)target event:(UIControlEvents)event change:(void(^)(UIControl *))changeBlock`

这时候你的代码可能会更加紧凑，这都得感谢block这个东西。

更多的基础库的封装大家可以去我的代码中查找，后续我会继续和完善这里的东西。


