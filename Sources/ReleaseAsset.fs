namespace Belin.SetupHashLink

open System
open System.Text.Json.Serialization

/// Contains operations for working with release assets.
module ReleaseAsset =

  /// Identifies an operating system or platform.
  [<JsonConverter(typeof<JsonStringEnumConverter>)>]
  type Platform =
    | Linux = 1
    | MacOS = 2
    | Windows = 3

  /// The current platform.
  let CurrentPlatform =
    if OperatingSystem.IsLinux() then Platform.Linux
    elif OperatingSystem.IsMacOS() then Platform.MacOS
    else Platform.Windows

/// Represents an asset of a HashLink release.
type ReleaseAsset =
  {
    /// The target file.
    File: string

    /// The target file.
    Platform: ReleaseAsset.Platform
  }
