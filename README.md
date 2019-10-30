### CSLCommonLibrary
一些常用工具库，基于基础库封装，方便调用。

#### NSNotificationCenter+Base
解决了`kvo`,`notification`的手动移除问题
使用`- (void)addTarget:(NSObject *)target noidtificationName:(NSString *)notificationName object:(id)object block:(NotificationReturnBlock)block`即可

#### CSLDelegateProxy
解决了`delegate`需要`weak`引用的问题，现在你可以放心的用`strong`去修饰你的`delegate`。同时在你的类中不需要实现任何协议和协议对应的方法
1、将你需要实现的协议名称传递过去 
`- (instancetype)initWithDelegateProxy:(Protocol *)protocol`
2、添加你需要实现的协议方法名，例如(`alertView:clickedButtonAtIndex:`)，block回调中的参数包括协议调用方所传递的所有参数。当然这个类使用的场景多半是自定义协议
`- (void)addSelector:(SEL)selector callback:(void(^)(id))callback`


对于系统的常见组件。
##### UIAlertView+DelegateProxy
例如`UIAlertView`，他的`delegate`已经进行了封装
`UIAlertView`的初始化就不需要对delegate进行赋值了。
`[[UIAlertView alloc]initWithTitle:@"title" message:@"message" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:@"ok", nil]`
其中`- (void)buttonClicked:(void(^)(UIAlertView *actionView, int clickIndex))clickBlock`就提供了`UIAlertView`的点击回调

##### UITextView+DelegateProxy
再比如`UITextView`
`- (void)didChangeSelection:(void(^)(UITextView *textView))didChangeSelectionBlock`
在block回调中就包含了textview的值

##### UIControl+Events
除了协议之外，所有继承自`UIControl`的触摸响应组件，我们可以使用
`- (void)onEventChange:(NSObject *)target event:(UIControlEvents)event change:(void(^)(UIControl *))changeBlock`
传递你需要监听的触摸事件`UIControlEvents`,在block回调中就会拿到你需要的组件对应的值

##### UITableViewHeaderFooterView+DelegateProxy
##### UITableViewCell+DelegateProxy
##### UICollectionReusableView+DelegateProxy
`- (void)reusableCallback:(void(^)(id))callback`
表示即将重用的回调。如果平常有用他的`prepareForReuse`的方法，那么这里就可以替换成上面的方法了。

整个库的整体结构都包含了`block`回调，这时候你的代码看上去会比较紧凑。更加容易分析。当然记得不要有循环引用的问题 `__weak` 和 `__strong`很有必要。

更多的基础库的封装大家可以去我的代码中查找，后续我会继续和完善这里的东西。


