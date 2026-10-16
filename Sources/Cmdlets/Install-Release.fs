namespace Belin.SetupHashLink.Cmdlets

open Belin.SetupHashLink
open System
open System.Management.Automation

/// Installs the HashLink VM, after downloading it.
[<Cmdlet(VerbsLifecycle.Install, "Release", DefaultParameterSetName = "Constraint"); OutputType(typeof<string>)>]
type InstallRelease() =
  inherit PSCmdlet()

  /// The version constraint of the release to be installed.
  [<Parameter(Mandatory = true, ParameterSetName = "Constraint", Position = 1, ValueFromPipeline = true)>]
  member val Constraint = "" with get, set

  /// The instance of the release to be installed.
  [<Parameter(Mandatory = true, ParameterSetName = "InputObject", ValueFromPipeline = true)>]
  member val InputObject: Release | null = null with get, set

  /// Value indicating whether to fetch the Ant optional tasks.
  [<Parameter>]
  member val OptionalTasks = SwitchParameter false with get, set

  /// Performs execution of this command.
  override this.ProcessRecord() =
    let input =
      match this.ParameterSetName with
      | nameof this.InputObject -> Some (nonNull this.InputObject)
      | _ -> Release.find this.Constraint

    match input with
    | Some release when Release.exists release.Version -> ()
      // TODO let outputPath = Setup(release).Install(this.OptionalTasks)
      // TODO this.WriteObject outputPath
    | _ ->
      let ex = InvalidOperationException "No release matches the specified version constraint."
      this.WriteError (ErrorRecord(ex, "Setup.Install", ErrorCategory.NotInstalled, input))
