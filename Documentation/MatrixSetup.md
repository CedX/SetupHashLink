# Matrix Setup
Setup multiple versions of the [HashLink VM](https://hashlink.haxe.org) on multiple operating systems:

```yaml
jobs:
  Test:
    name: HashLink ${{matrix.version}} on ${{matrix.platform}}
    runs-on: ${{matrix.platform}}
    strategy:
      matrix:
        platform: [macos-latest, ubuntu-latest, windows-latest]
        version: [<=1.10, latest]
    steps:
      - uses: actions/checkout@v5
      - uses: lix-pm/setup-lix@2.0.0
      - uses: CedX/SetupHashLink@v2026
        with:
          version: ${{matrix.version}}
      - run: hl --version
      - run: lix download
      - run: haxe Test.hxml
```
