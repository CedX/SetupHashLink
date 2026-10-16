namespace Belin.SetupHashLink.Cmdlets

open Belin.SetupHashLink
open System.Management.Automation

/// Finds a release that matches the specified version constraint.
/// Returns `null` if not found.
[<Cmdlet(VerbsCommon.Find, "Release"); OutputType(typeof<Release>)>]
type FindRelease() =
  inherit Cmdlet()

  /// The version number. Use `*` or `Latest` to get the latest release.
  [<Parameter(Mandatory = true, Position = 1, ValueFromPipeline = true)>]
  member val Constraint = "" with get, set

  /// Performs execution of this command.
  override this.ProcessRecord() =
    this.Constraint |> Release.find |> Option.toObj |> this.WriteObject
