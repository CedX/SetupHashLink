namespace Belin.SetupHashLink.Cmdlets

open Belin.SetupHashLink
open System
open System.Management.Automation

/// Gets the latest release.
[<Cmdlet(VerbsCommon.Get, "LatestRelease"); OutputType(typeof<Release>)>]
type GetLatestRelease() =
  inherit Cmdlet()

  /// Performs execution of this command.
  override this.ProcessRecord() = this.WriteObject Release.Latest

/// Gets the release corresponding to the specified version.
/// Returns `null` if not found.
[<Cmdlet(VerbsCommon.Get, "Release"); OutputType(typeof<Release>)>]
type GetRelease() =
  inherit Cmdlet()

  /// The version number. Use `*` or `Latest` to get the latest release.
  [<Parameter(Mandatory = true, Position = 1, ValueFromPipeline = true)>]
  member val Version = "" with get, set

  /// Performs execution of this command.
  override this.ProcessRecord() =
    let release =
      match Release.latestReleasePattern.IsMatch this.Version with
      | true -> withNull Release.Latest
      | false -> Version.Parse this.Version |> Release.get |> Option.toObj

    this.WriteObject release
