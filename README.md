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

> **IMPORTANT:** Flags for activating coverage (`--coverage` respectively `-Coverage`) are currently not working due migration to `pester v5`. Waiting for update of pester docs. After that the scripts will be updated.

Using `bash`

```bash
./test.sh [--coverage]
```

Using `pwsh`

```powershell
./test.ps1 [-Coverage]
```