# Basic Setup
Set up a specific version of the [HashLink VM](https://hashlink.haxe.org):

```yaml
jobs:
  Test:
    runs-on: windows-latest
    steps:
      - uses: actions/checkout@v5
      - uses: lix-pm/setup-lix@2.0.0
      - uses: CedX/SetupHashLink@v2026
        with:
          version: =1.16.0
      - run: hl --version
      - run: lix download
      - run: haxe Test.hxml
```
