namespace Belin.SetupHashLink

open System
open System.IO
open System.Management.Automation
open System.Text.Json
open System.Text.RegularExpressions

/// Represents a HashLink release.
type Release =
  {
    /// The associated assets.
    Assets: ReleaseAsset list

    /// The version number.
    Version: Version
  }

  /// Value indicating whether this release is provided as source code.
  member this.IsSource: bool = this.GetAsset(ReleaseAsset.CurrentPlatform).IsNone

  /// The associated Git tag.
  member this.Tag: string =
    match this.Version.Build with
    | value when value > 0 -> $"{this.Version.Major}.{this.Version.Minor}.{this.Version.Build}"
    | _ -> $"{this.Version.Major}.{this.Version.Minor}"

  /// The download URL.
  member this.Url: Uri =
    let path =
      match this.GetAsset ReleaseAsset.CurrentPlatform with
      | Some asset -> $"releases/download/{this.Tag}/{asset.File}"
      | None -> $"archive/refs/tags/{this.Tag}.zip"

    Uri(Uri "https://github.com/HaxeFoundation/hashlink/", path)

  /// Gets the asset corresponding to the specified platform.
  member this.GetAsset(platform: ReleaseAsset.Platform): ReleaseAsset option =
    this.Assets |> List.tryFind (fun asset -> asset.Platform = platform)

/// Contains operations for working with HashLink releases.
module Release =

  /// The list of all Apache Ant releases.
  let internal data: Release list =
    let location = Path.GetDirectoryName typeof<Release>.Assembly.Location
    Path.Join(location, "../Resources/Releases.json") |> File.ReadAllText |> JsonSerializer.Deserialize<Release list> |> nonNull

  /// The regular expression used to check if a version constraint represents the latest release.
  let internal latestReleasePattern = Regex(@"^(\*|Latest)$", RegexOptions.IgnoreCase)

  /// The latest release.
  let Latest = data.Head

  /// Gets a value indicating whether a release with the specified version exists.
  let exists (version: Version): bool =
    data |> List.exists (fun release -> release.Version = version)

  /// Finds a release that matches the specified version constraint.
  let find (versionConstraint: string): Release option =
    let operatorString, versionString =
      if latestReleasePattern.IsMatch versionConstraint then "=", string Latest.Version
      elif Regex.IsMatch(versionConstraint, @"^\d") then ">=", versionConstraint
      else
        let constraintMatch = Regex.Match(versionConstraint, @"^([^\d]+)\d")
        if constraintMatch.Success then constraintMatch.Groups[1].Value, Regex.Replace(versionConstraint, @"^[^\d]+", "")
        else "", ""

    let parsedOperator =
      match operatorString with
      | ">" -> Some (>)
      | ">=" -> Some (>=)
      | "=" -> Some (=)
      | "<=" -> Some (<=)
      | "<" -> Some (<)
      | _ -> None

    let parsedVersion =
      match SemanticVersion.TryParse versionString with
      | false, _ -> None
      | true, value -> Some (nonNull value)

    match parsedOperator, parsedVersion with
    | Some compare, Some version -> data |> List.tryFind (fun release -> compare (SemanticVersion release.Version) version)
    | _ -> None

  /// Gets the release corresponding to the specified version.
  let get (version: Version): Release option =
    data |> List.tryFind (fun release -> release.Version = version)
