namespace Belin.SetupHashLink

/// Manages the download and installation of the HashLink VM.
type Setup(release: Release) =

  /// The release to download and install.
  member val Release = release

  /// Downloads and extracts the ZIP archive of the HashLink VM.
  /// Returns the path to the extracted directory.
  member this.Download() =
    ()

  /// Installs the HashLink VM, after downloading it.
  /// Returns the path to the installation directory.
  member this.Install() =
    ()
