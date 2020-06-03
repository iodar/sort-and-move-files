# Group and Move Items

### Usage

> **IMPORTANT:** Currently only `Windows` is supported but support for `Linux` is planned.

```powershell
.\Sort-AndMoveItems.ps1 -Source .\your\media\source -Target .\storage\media\files
```

| Parameter | Usage                                                              |
| --------- | ------------------------------------------------------------------ |
| `-Source` | Folder in which script will recursively search for files           |
| `-Target` | Folder where script will create folder structure and move files to |

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