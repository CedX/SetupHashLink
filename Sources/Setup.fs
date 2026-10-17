namespace Belin.SetupHashLink

open System
open System.Diagnostics
open System.IO
open System.IO.Compression
open System.Management.Automation
open System.Net.Http
open System.Runtime.Versioning
open System.Threading.Tasks

/// Identifies an operating system or platform.
type private Platform = ReleaseAsset.Platform

/// Manages the download and installation of the HashLink VM.
type Setup(release: Release) =

  /// The assembly version.
  static let version = nonNull (typeof<Setup>.Assembly.GetName().Version)

  /// The release to download and install.
  member val Release = release

  /// Downloads and extracts the ZIP archive of the HashLink VM.
  /// Returns the path to the extracted directory.
  member _.Download(): Task<string> = task {
    use httpClient = new HttpClient(Timeout = TimeSpan.FromMinutes 1L)
    httpClient.DefaultRequestHeaders.Add("User-Agent", $".NET/{Environment.Version} | Belin.SetupHashLink/{version.ToString 3}")

    let! bytes = httpClient.GetByteArrayAsync release.Url
    let file = Path.GetTempFileName()
    do! File.WriteAllBytesAsync(file, bytes)

    let directory = Path.Join(Path.GetTempPath(), string (Guid.CreateVersion7()))
    do! ZipFile.ExtractToDirectoryAsync(file, directory)
    return Directory.EnumerateDirectories directory |> Seq.exactlyOne |> Path.GetFileName |> fun name -> Path.Join(directory, name)
  }

  /// Installs the HashLink VM, after downloading it.
  /// Returns the path to the installation directory.
  member this.Install(): Task<string> = task {
    let! directory = this.Download()
    if release.IsSource then do! this.Compile directory

    let binFolder = if release.IsSource then Path.Join(directory, "bin") else directory
    Environment.SetEnvironmentVariable("PATH", $"""{Environment.GetEnvironmentVariable "PATH"}{Path.PathSeparator}{binFolder}""")
    do! File.AppendAllTextAsync(nonNull (Environment.GetEnvironmentVariable "GITHUB_PATH"), binFolder)
    return directory
  }

  /// Compiles the sources of the HashLink VM located in the specified directory.
  /// Returns the path to the output directory.
  [<UnsupportedOSPlatform("windows")>]
  member private this.Compile(directory: string) = task {
    let workingDirectory = Environment.CurrentDirectory
    try
      Environment.CurrentDirectory <- directory
      do! match ReleaseAsset.CurrentPlatform with Platform.MacOS -> this.CompileMacOS() | _ -> this.CompileLinux()
    finally
      Environment.CurrentDirectory <- workingDirectory
  }

  /// Compiles the HashLink sources on the Linux platform.
  [<SupportedOSPlatform("linux")>]
  member private _.CompileLinux() = task {
    let dependencies = [
      "libglu1-mesa-dev"
      "libmbedtls-dev"
      "libopenal-dev"
      "libpng-dev"
      "libsdl3-dev"
      "libsqlite3-dev"
      "libturbojpeg-dev"
      "libuv1-dev"
      "libvorbis-dev"
    ]

    let commands = [
      "sudo", "apt-get update"
      "sudo", $"""apt-get install --assume-yes --no-install-recommends {dependencies |> String.concat " "}"""
      "make", ""
      "sudo", "make install"
      "sudo", "ldconfig"
    ]

    for fileName, arguments in commands do
      use startedProcess = Process.Start(fileName, arguments)
      do! startedProcess.WaitForExitAsync()
      if startedProcess.ExitCode <> 0 then raise (ApplicationFailedException $"{fileName} {arguments}")

    let ldLibraryPath = $"""{Environment.GetEnvironmentVariable "LD_LIBRARY_PATH"}{Path.PathSeparator}/usr/local/bin"""
    Environment.SetEnvironmentVariable("LD_LIBRARY_PATH", ldLibraryPath)
    do! File.AppendAllTextAsync(nonNull (Environment.GetEnvironmentVariable "GITHUB_ENV"), $"LD_LIBRARY_PATH={ldLibraryPath}")
  }

  /// Compiles the HashLink sources on the macOS platform.
  [<SupportedOSPlatform("macos")>]
  member private _.CompileMacOS() = task {
    let commands = [
      "brew", "bundle"
      "make", ""
      "sudo", "make codesign_osx"
      "sudo", "make install"
      "sudo", "install_name_tool -change libhl.dylib /usr/local/lib/libhl.dylib /usr/local/bin/hl"
    ]

    for fileName, arguments in commands do
      use startedProcess = Process.Start(fileName, arguments)
      do! startedProcess.WaitForExitAsync()
      if startedProcess.ExitCode <> 0 then raise (ApplicationFailedException $"{fileName} {arguments}")
  }
