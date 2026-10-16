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
    match true with
    | true when OperatingSystem.IsLinux() -> Platform.Linux
    | true when OperatingSystem.IsMacOS() -> Platform.MacOS
    | _ -> Platform.Windows

/// Represents an asset of a HashLink release.
type ReleaseAsset =
  {
    /// The target file.
    File: string

    /// The target file.
    Platform: ReleaseAsset.Platform
  }
