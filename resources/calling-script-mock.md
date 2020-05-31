### Mock For Calling Script

#### Draft MVP: Simple command line interface with mimimal cli options

```powershell
Sort-AndMoveFiles.ps1 -SourceFolder ./test -TargetFolder ./media/test -CustomPostfix "NIKON"
```

#### Draft: Stage 1

- switch parameter to support different types of postfixes
- maybe more difficult to implement (dependency between switch parameter and postfix pattern parameter)

```powershell
Sort-AndMoveFiles.ps1 -SourceFolder ./test -TargetFolder ./media/test -CustomPostfix -CustomPostfixString "NIKON"
Sort-AndMoveFiles.ps1 -SourceFolder ./test -TargetFolder ./media/test -CustomPostfix -CustomPostfixPattern NUMBER
```

#### Draft: Stage 1 Alternative

- support for different types of postfixes
- easier implementation
- no switch parameter

```powershell
Sort-AndMoveFiles.ps1 -SourceFolder ./test -TargetFolder ./media/test -CustomPostfixPattern [ NUMBER | CUSTOM ] [ -CustomPostfix "NIKON" ]
```

