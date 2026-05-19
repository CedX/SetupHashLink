# Basic Setup
Set up a specific version of the [HashLink VM](https://hashlink.haxe.org):

```yaml
jobs:
  test:
    runs-on: windows-latest
    steps:
      - uses: actions/checkout@v5
      - uses: lix-pm/setup-lix@master
      - uses: cedx/SetupHashLink@v8
        with:
          version: =1.15.0
      - run: hl --version
      - run: lix download
      - run: haxe test.hxml
```
