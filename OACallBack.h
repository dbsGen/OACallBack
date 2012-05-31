//
//  OACallBack.h
//  ipadOA
//
//  Created by zrz on 11-1-5.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

typedef void (^CallBackBlock)(id obj);


@interface OACallBack : NSObject{
@private
	NSMutableArray	*_elements;
}

@property (nonatomic,readonly)	int	count;

//ctrl the elements
+ (id)callbackWithBlock:(CallBackBlock)block;

- (void)addTarget:(id)target Function:(SEL)function;
- (void)addBlock:(CallBackBlock)block;
- (void)removeElementAt:(int)index;
- (void)removeLastElement;

//callback
- (void)call;
- (void)call:(id)object;

@end
