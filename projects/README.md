# COLMAP 3D Reconstruction Projects

## Directory Structure

```
projects/
├── images/      # Place your input images here
├── workspace/   # COLMAP working directory (database, sparse models)
└── output/      # Final reconstructed models and exports
```

## Quick Start

### 1. Prepare Images
Place your photos in the `images/` folder. For best results:
- Use 20-100+ overlapping images
- Ensure 60-80% overlap between consecutive images
- Avoid motion blur and consistent lighting

### 2. Run Automatic Reconstruction
```powershell
C:\Farnaz\vcpkg\packages\colmap_x64-windows\tools\colmap\colmap.exe automatic_reconstructor --image_path C:\Farnaz\projects\images --workspace_path C:\Farnaz\projects\workspace
```

### 3. Launch GUI (Alternative)
```powershell
C:\Farnaz\vcpkg\packages\colmap_x64-windows\tools\colmap\colmap.exe gui
```

## COLMAP Workflow

1. **Feature Extraction** - Detect keypoints in images
2. **Feature Matching** - Match keypoints between image pairs
3. **Sparse Reconstruction** - Build 3D point cloud with camera poses
4. **Dense Reconstruction** - Create dense point cloud (requires CUDA)
5. **Meshing** - Generate 3D mesh from point cloud

## Useful Commands

```powershell
# Feature extraction
colmap.exe feature_extractor --image_path images --database_path workspace\database.db

# Exhaustive matching (for small datasets)
colmap.exe exhaustive_matcher --database_path workspace\database.db

# Sequential matching (for video sequences)
colmap.exe sequential_matcher --database_path workspace\database.db

# Sparse reconstruction
colmap.exe mapper --image_path images --database_path workspace\database.db --output_path workspace\sparse

# Dense reconstruction (CUDA)
colmap.exe image_undistorter --image_path images --input_path workspace\sparse\0 --output_path workspace\dense
colmap.exe patch_match_stereo --workspace_path workspace\dense
colmap.exe stereo_fusion --workspace_path workspace\dense --output_path output\fused.ply
```

## Output Formats
- `.ply` - Point cloud (can open in MeshLab, CloudCompare)
- `.obj` - 3D mesh
- `.nvm` - VisualSFM format




