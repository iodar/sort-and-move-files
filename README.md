# Group and Move Items

### Usage

> **IMPORTANT:** Currently only `Windows` is supported but support for `Linux` is planned.

```powershell
.\Sort-AndMoveItems.ps1 -SourceFolder .\your\media\source -TargetFolder .\storage\media\files
```

| Parameter       | Usage                                                              |
| --------------- | ------------------------------------------------------------------ |
| `-SourceFolder` | Folder in which script will recursively search for files           |
| `-TargetFolder` | Folder where script will create folder structure and move files to |

### Prerequisites For Development

- pwsh >= 7.x
- tests: pester >=5.x

### Run Tests

Using `bash`

```bash
pwsh -c "Invoke-Pester -Output Detailed"
```

Using `pwsh`

```powershell
Invoke-Pester -Output Detailed
```