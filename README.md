# ComputerCraft programs and libraries by Zakru

This repository contains some programs and libraries I've made for ComputerCraft, for easy reuse. Everything is in the main branch and can be downloaded as raw files.

## About `tracked` and `asyncTracked`

`tracked` is a library for tracked movement in space. It has the same movement functions as the `turtle` API but keeps track of local direction and facing (initial position is (0, 0, 0), and facing is towards local positive X). Directions are represented by a number from 0-3, where 0 means towards positive X and the rest go up by 90 degree turns to the left. Using this tracking, it provides the additional functions `face` and `moveTo` which take local positions and attempt to move the turtle into the desired location or facing, both returning `success, error` where `error` is `nil` unless `success` is `false`. `moveTo` uses a dumb algorithm and therefore might fail if it encounters an obstacle, so it is best used in a clear space or when you know that the box between the start and end positions is empty.

With `asyncTracked`, movement functions are run in coroutines and are infallible, using a nonstandard coroutine API. `asyncTracked` calls `coroutine.yield(errorType, ...)` where `errorType` is a string event type identifier prefixed by a `$` (just `"$"` can be yielded as a generic yield when its handling should be clear from context), in this case it is always `$tracked_error`, with another parameter describing the type of action which failed and the third being the error string from the underlying `turtle` call.

|Error type|Description|
|-|-|
|`move`|Error caused by `forward`, `backward`, `up` or `down`|
|`turn`|Error caused by `turnLeft` or `turnRight`|

If the first value yielded is not prefixed by `$`, it should be handled as a request to wait for events like normal yields. Note that because of the nonstandard yields, `asyncTracked` requires some sort of custom runtime (see `smartQuarry.lua` for an example)

## `genericPeripherals`

This library provides an interface to request configurable peripherals, so that the same code can run on different devices. The aim is to have standard peripheral names, currently only `speaker_left` and `speaker_right`. These peripherals can be configured with a file called `peripherals.conf` in the root directory with a simple key=value syntax:

```
speaker_left = left
speaker_right = right
monitor_primary = top
printer_log = printer_0
```
