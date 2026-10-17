# Inputs
By default, this action will install the latest stable release of the [HashLink VM](https://hashlink.haxe.org) corresponding to the current host platform.  
You can customize the downloaded release with the following input:

## **version**: string
The version constraint of the HashLink VM (optional, defaults to `latest`).  
Allowed values are:

- `latest` or `*`: the latest stable release.
- a loose version number: `1`, `1.16`, etc. This is equivalent to using the `>=` operator.
- a strict version number: `=1.0.0`, `=1.16.0`, etc.
- a version specification: `<=1`, `>1.16`, etc.

> [!NOTE]
> The version constraint uses a very basic [syntax and algorithm](https://github.com/CedX/SetupHashLink/blob/main/Sources/Release.fs#L60), but it should suffice in most cases.  
> If this isn't enough, feel free to [open an issue](https://github.com/CedX/SetupHashLink/issues).
