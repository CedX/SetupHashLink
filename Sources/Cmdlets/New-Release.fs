namespace Belin.SetupHashLink.Cmdlets

open Belin.SetupHashLink
open System
open System.Management.Automation

/// Creates a new release.
[<Cmdlet(VerbsCommon.New, "Release"); OutputType(typeof<Release>)>]
type NewRelease() =
  inherit Cmdlet()

  /// The version number.
  [<Parameter(Mandatory = true, Position = 1, ValueFromPipeline = true)>]
  member val Version: Version | null = null with get, set

  /// The associated assets.
  [<Parameter(Position = 2); ValidateNotNull>]
  member val Assets: ReleaseAsset array = [||] with get, set

  /// Performs execution of this command.
  override this.ProcessRecord() =
    this.WriteObject { Assets = List.ofArray this.Assets; Version = nonNull this.Version }

/// Creates a new release asset.
[<Cmdlet(VerbsCommon.New, "ReleaseAsset"); OutputType(typeof<ReleaseAsset>)>]
type NewReleaseAsset() =
  inherit Cmdlet()

  /// The target platform.
  [<Parameter(Mandatory = true, Position = 1)>]
  member val Platform = ReleaseAsset.Platform.Windows with get, set

  /// The target file.
  [<Parameter(Mandatory = true, Position = 2)>]
  member val File = "" with get, set

  /// Performs execution of this command.
  override this.ProcessRecord() =
    this.WriteObject { File = this.File; Platform = this.Platform }
