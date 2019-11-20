### CSLCommonLibrary
一些常用工具库，基于基础库封装，方便调用。

### NSObject+Base
处理了`targe`的`dealloc`方法，方便这个库中其他的类对`kvo`,`notification`,`timer`的手动移除。
`- (void)swizzDeallocMethod:(NSObject *)target callback:(void(^)(__unsafe_unretained NSObject *deallocObj))callback;`
处理了`targe`的`viewWillDisappear:`方法，方便这个库中其他的类对`kvo`,`notification`,`timer`的手动移除。
`- (void)swizzDisappearMethod:(NSObject *)target callback:(void(^)(__unsafe_unretained NSObject *disappearObj))callback;`
当然调用者也可调用这两个方法，例如对`delegate`进行回调等。

#### SLTimer
继承`NSTimer`,内部自动处理`invalidate`方法。也自动防止循环引用问题，避免手动置`nil`的操作。当然调用者也可手动对SLTimer对象调用`invalidate`方法来停止计时器。
`+ (instancetype)sl_timerWithTimeInterval:(NSTimeInterval)timeInterval target:(id)aTarget userInfo:(nullable id)userInfo repeats:(BOOL)repeat mode:(NSRunLoopMode)mode callback:(void(^)(NSArray *array))timerCallback`

#### NSNotificationCenter+Base
解决了`notification`的手动移除问题
使用`- (void)addTarget:(NSObject *)target noidtificationName:(NSString *)notificationName object:(id)object block:(NotificationReturnBlock)block`即可

#### BaseObserver
解决了`kvo`的手动移除问题
使用`- (instancetype)initWithTarget:(NSObject *)target keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options block:(ObserverReturnBlock)block`即可

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
封装UITextView的全部代理回调。自动设置delegate。
代理方法太多，这里不进行举例。

##### UIControl+Events
除了协议之外，所有继承自`UIControl`的触摸响应组件，我们可以使用
`- (void)onEventChange:(NSObject *)target event:(UIControlEvents)event change:(void(^)(UIControl *))changeBlock`
传递你需要监听的触摸事件`UIControlEvents`,在block回调中就会拿到你需要的组件对应的值

##### CAAnimation+DelegateProxy
对CAAnimation的两个回调进行了封装处理。自动设置delegate
`- (void)animationDidStartBlock:(void(^)(CAAnimation *anim))animationDidStartBlock;`
`- (void)animationDidStopBlock:(void(^)(CAAnimation *animm,BOOL finished))animationDidStopBlock;`

##### UITableViewHeaderFooterView+DelegateProxy
##### UITableViewCell+DelegateProxy
##### UICollectionReusableView+DelegateProxy
`- (void)reusableCallback:(void(^)(id))callback`
表示即将重用的回调。如果平常有用他的`prepareForReuse`的方法，那么这里就可以替换成上面的方法了。

整个库的整体结构都包含了`block`回调，这时候你的代码看上去会比较紧凑。更加容易分析。当然记得不要有循环引用的问题 `__weak` 和 `__strong`很有必要。

更多的基础库的封装大家可以去我的代码中查找，后续我会继续和完善这里的东西。


