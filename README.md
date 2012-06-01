OACallBack
==========

能稍微减少回调的代码量

make the callback easier.

like this:

    OACallBack *callback = [OACallBack callbackWithBlock:^(id obj){
        NSLog(@"%@", obj); 
    }];
    [callback call:@"some thing"];