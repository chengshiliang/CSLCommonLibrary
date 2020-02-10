//
//  UITextView+Util.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/12/19.
//

#import "UITextView+Util.h"
#import <CSLCommonLibrary/NSString+Util.h>
#import <objc/runtime.h>
@interface SLTextViewAgent :NSObject
@property(assign, nonatomic)BOOL isFirst;
@property(copy, nonatomic)NSString *lastString;
@property(assign, nonatomic)BOOL disableEmoji;
@end
@implementation SLTextViewAgent

@end


@implementation UITextView (Utils)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self exchangeOriginalMethod:@selector(setText:) swizzledSelector:@selector(het_setText:)];
        [self exchangeOriginalMethod:NSSelectorFromString(@"dealloc") swizzledSelector:@selector(het_dealloc)];
    });
}
+(void)exchangeOriginalMethod:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector{
    Class class = [self class];
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(class,originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }

}


-(SLTextViewAgent *)agent{
    return objc_getAssociatedObject(self, @selector(setAgent:));
}
-(void)setAgent:(SLTextViewAgent *)agent{
    objc_setAssociatedObject(self, @selector(setAgent:), agent, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
#pragma mark ------
- (void)het_setText:(NSString *)text {
    [self het_setText:text];
    if (!self.agent) {
        self.agent = [SLTextViewAgent new];
    }
    if (self.agent.isFirst && !self.agent.lastString) {
        self.agent.isFirst = NO;
        self.agent.lastString = text;
    }
}
- (void)het_dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self het_dealloc];
}


-(void)disableEmoji{
    if (!self.agent) {
        self.agent = [SLTextViewAgent new];
    }
    self.agent.disableEmoji = YES;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged) name:UITextViewTextDidChangeNotification object:self];
}

-(void)textFieldChanged{
    if (self.text.length != 0){
        [self setNeedsDisplay];
    }
    
    NSString *lang = [[[UIApplication sharedApplication] textInputMode] primaryLanguage];// 键盘输入模式
    if([lang isEqualToString:@"zh-Hans"]) { //简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [self markedTextRange];
        //获取高亮部分
        UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
        if (position) {
            return;
        }
    }
    
    if (self.agent.disableEmoji) {
        [self deleteEmojiText];
    }
    self.agent.lastString = self.text;
}

-(void)deleteEmojiText{
    UITextPosition* beginning = self.beginningOfDocument;
    UITextRange* selectedRange = self.selectedTextRange;
    UITextPosition* selectionStart = selectedRange.start;
    UITextPosition* selectionEnd = selectedRange.end;
    const NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
    const NSInteger length = [self offsetFromPosition:selectionStart toPosition:selectionEnd];
    NSRange range;
    if([[NSString removeEmojiString:self.text] length]<self.text.length){
        range = NSMakeRange(location-(self.text.length-self.agent.lastString.length), length);
    }else{
        range = NSMakeRange(location, length);
    }
    [self setText:[NSString removeEmojiString:self.text]];
    beginning = self.beginningOfDocument;
    UITextPosition* startPosition = [self positionFromPosition:beginning offset:range.location];
    UITextPosition* endPosition = [self positionFromPosition:beginning offset:range.location + range.length];
    UITextRange* selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    [self setSelectedTextRange:selectionRange];
}
@end
