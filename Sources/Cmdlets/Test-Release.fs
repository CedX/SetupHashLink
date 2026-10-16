namespace Belin.SetupHashLink.Cmdlets

open Belin.SetupHashLink
open System
open System.Management.Automation

/// Gets a value indicating whether a release with the specified version exists.
[<Cmdlet(VerbsDiagnostic.Test, "Release", DefaultParameterSetName = "Version"); OutputType(typeof<bool>)>]
type TestRelease() =
  inherit PSCmdlet()

  /// The release to be tested.
  [<Parameter(Mandatory = true, ParameterSetName = "InputObject", ValueFromPipeline = true)>]
  member val InputObject: Release | null = null with get, set

  /// The version number of the release to be tested.
  [<Parameter(Mandatory = true, ParameterSetName = "Version", Position = 1, ValueFromPipeline = true)>]
  member val Version: Version | null = null with get, set

  /// Performs execution of this command.
  override this.ProcessRecord() =
    let version =
      match this.ParameterSetName with
      | nameof this.InputObject -> (nonNull this.InputObject).Version
      | _ -> nonNull this.Version

    version |> Release.exists |> this.WriteObject
