//
//  OACallBack.m
//  ipadOA
//
//  Created by zrz on 11-1-5.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OACallBack.h"

#ifndef sp_weak
    #if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_5_0
        #define sp_weak  weak
    #else
        #define sp_weak  unsafe_unretained
    #endif
#endif  //sp_weak

#ifndef __sp_weak
    #if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_5_0
        #define __sp_weak  __weak
    #else
        #define __sp_weak  __unsafe_unretained
    #endif
#endif  //__sp_weak

@interface OACallBackElement : NSObject
{
	__sp_weak id    _object;
}

@property (nonatomic,sp_weak)	id	object;

- (void)call;
- (void)call:(id)object;

@end

@implementation OACallBackElement

@synthesize object = _object ;

- (void)call
{
}

- (void)call:(id)tobject
{
	self.object = tobject;
	[self call];
}

@end

@interface OACallBackSelecterElement : OACallBackElement
{
	__sp_weak id    _delegate;
	SEL		_function;
}

@property (nonatomic,sp_weak)	id	delegate;
@property (nonatomic,readonly)	SEL	function;

- (id)initWithTarget:(id)target Function:(SEL)tfunction withObject:(id)tobject;

+ (id)callBackElementWithTarget:(id)target Function:(SEL)tfunction withObject:(id)tobject;

@end

@implementation OACallBackSelecterElement

@synthesize delegate = _delegate , function = _function;

- (id)initWithTarget:(id)target Function:(SEL)tfunction withObject:(id)tobject
{
	if (self = [super init]) {
		_delegate	=	target;
		_function	=	tfunction;
		self.object =	tobject;
	}
	return self;
}

+ (id)callBackElementWithTarget:(id)target Function:(SEL)tfunction withObject:(id)tobject
{
	OACallBackElement *element=[[OACallBackSelecterElement alloc] 
                                 initWithTarget:target 
                                 Function:tfunction
                                 withObject:tobject];
	return element;
}

- (void)call
{
	[_delegate performSelector:_function withObject:self.object];
}

@end

@interface OACallBackBlockElement : OACallBackElement
{
    CallBackBlock   _block;
}

@property (nonatomic, copy) CallBackBlock   block;

- (id)initWithBlock:(CallBackBlock)block;
+ (id)callBackElementWithBlock:(CallBackBlock)block;

@end

@implementation OACallBackBlockElement

@synthesize block = _block;

- (id)initWithBlock:(CallBackBlock)block
{
    self = [self init];
    if (self) {
        _block = [block copy];
    }
    return self;
}

+ (id)callBackElementWithBlock:(CallBackBlock)block
{
    return [[self alloc] initWithBlock:block];
}

- (void)call
{
    if (_block) {
        _block(self.object);
    }
}

@end

@implementation OACallBack

- (void)addTarget:(id)target Function:(SEL)function
{
	OACallBackElement *newElement = [OACallBackSelecterElement callBackElementWithTarget:target 
																		Function:function 
																	  withObject:nil];
	if (!_elements) {
		_elements = [[NSMutableArray alloc] init];
	}
	[_elements addObject:newElement];
}

- (void)addBlock:(CallBackBlock)block
{
    OACallBackElement *newElement = [OACallBackBlockElement callBackElementWithBlock:block];
    if (!_elements) {
		_elements = [[NSMutableArray alloc] init];
    }
    [_elements addObject:newElement];
}

- (void)call:(id)object
{
	for (int n = 0 ; n<self.count ; n++ ) {
		OACallBackElement *theTarget=[_elements objectAtIndex:n];
		[theTarget call:object];
	}
}

- (void)call
{
	for (int n = 0 ; n<self.count ; n++ ) {
		OACallBackElement *theTarget=[_elements objectAtIndex:n];
		[theTarget call];
	}
}

- (void)removeElementAt:(int)index
{
	[_elements removeObjectAtIndex:index];
}

- (void)removeLastElement
{
	[_elements removeLastObject];
}

- (int)count
{
    return [_elements count];
}

+ (id)callbackWithBlock:(CallBackBlock)block
{
    OACallBack *callback = [self new];
    [callback addBlock:block];
    return callback;
}

@end
