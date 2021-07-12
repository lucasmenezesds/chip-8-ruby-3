# Some Ruby Programming Language Notes

## About Modules

### #include

When we call `#include MODULE` we're invoking the method `Module.append_features(mod)` and what it does is to add the
constants, methods, and module variables of this module to mod (if this module has not already been added to mod or one
of its ancestors.)
