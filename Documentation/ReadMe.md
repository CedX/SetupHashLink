# Setup HashLink
Set up your [GitHub Actions](https://docs.github.com/en/actions) workflow 
with a specific version of the [HashLink VM](https://hashlink.haxe.org).

## Getting started
If you haven't used GitHub Actions before, be sure to check out the [related documentation](https://docs.github.com/en/actions/quickstart), 
as it explains how to create and configure a workflow.

Set up the HashLink VM in a workflow:

```yaml
steps:
  - uses: cedx/SetupHashLink@v8
  - run: hl --version
```

> [!NOTE]
> A sample workflow can be found in this [workflow.yaml](https://github.com/CedX/SetupHashLink/blob/main/Examples/workflow.yaml) file.

## Usage
- [Inputs](Inputs.md)
- [Basic setup](BasicSetup.md)
- [Matrix setup](MatrixSetup.md)
