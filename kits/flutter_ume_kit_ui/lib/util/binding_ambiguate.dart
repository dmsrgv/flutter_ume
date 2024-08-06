/// This allows a value of type T or T?
/// to be treated as a value of type T?.
///
/// We use this so that APIs that have become
/// non-nullable can still be used with `!` and `?`
/// to support older versions of the API as well.
// refer to https://github.com/flutter/website/blob/main/src/development/tools/sdk/release-notes/release-notes-3.0.0.md#your-code
// removed this cause of no longer support after Flutter 3.0.0 and replaced the direct using bindings:
@Deprecated('Removed from project, because on unused. It was null-safety migration feature')
T? bindingAmbiguate<T>(T? value) => value;
