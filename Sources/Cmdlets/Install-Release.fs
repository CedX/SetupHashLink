namespace Belin.SetupHashLink.Cmdlets

open Belin.SetupHashLink
open System
open System.Management.Automation

/// Installs the HashLink VM, after downloading it.
/// Returns the path to the installation directory.
[<Cmdlet(VerbsLifecycle.Install, "Release", DefaultParameterSetName = "Constraint"); OutputType(typeof<string>)>]
type InstallRelease() =
  inherit PSCmdlet()

  /// The version constraint of the release to be installed.
  /// Use `*` or `Latest` to install the latest release.
  [<Parameter(Mandatory = true, ParameterSetName = "Constraint", Position = 1, ValueFromPipeline = true)>]
  member val Constraint = "Latest" with get, set

  /// The instance of the release to be installed.
  [<Parameter(Mandatory = true, ParameterSetName = "InputObject", ValueFromPipeline = true)>]
  member val InputObject: Release | null = null with get, set

  /// Performs execution of this command.
  override this.ProcessRecord() =
    let input =
      match this.ParameterSetName with
      | nameof this.InputObject -> Some (nonNull this.InputObject)
      | _ -> Release.find this.Constraint

    match input with
    | Some release when Release.exists release.Version ->
      let installTask = Setup(release).Install()
      this.WriteObject (installTask.GetAwaiter().GetResult())
    | _ ->
      let ex = InvalidOperationException "No release matches the specified version constraint."
      this.WriteError (ErrorRecord(ex, "Setup.Install", ErrorCategory.ObjectNotFound, input))
