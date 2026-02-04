# COLMAP 3D Reconstruction Pipeline - ULTRRA Challenge 2025

**CMU Illumination and Imaging Lab**  
**Author:** Farnaz Alam Ahmed  
**Date:** January-February 2026

Complete end-to-end 3D reconstruction pipeline for camera calibration and pose estimation using Structure-from-Motion (COLMAP) and Multi-View Stereo (OpenMVS).

---

## 🎯 Project Overview

This project implements a production-ready photogrammetry pipeline for the **ULTRRA 2025 Challenge** (Urban Landscape Tracking and Reconstruction for Reality Applications) presented at WACV 2025.

### Objective
Extract precise camera calibration parameters (intrinsic and extrinsic) from multi-view image datasets across 4 benchmark tasks covering different real-world challenges.

---

## 📊 Results Summary

| Task | Challenge | Images | Registered | Rate | Status |
|------|-----------|--------|------------|------|--------|
| **t01** | Image Density | 80 | 79 | **98.75%** | ✅ Complete + Dense |
| **t02** | Camera Models | 64 | 60 | **93.75%** | ✅ Complete |
| **t03** | Large Area | 340 | 288 | **84.7%** | ✅ Complete |
| **t04** | Varying Altitudes | 72 | 71 | **98.6%** | ✅ Complete |
| **Total** | All Tasks | **556** | **498** | **89.6%** | ✅ Ready |

### Key Achievements
- ✅ **89.6% overall registration rate** across 556 images
- ✅ **Dense reconstruction** with 12.9 million points (t01)
- ✅ **Systematic parameter optimization** - improved t03 from 35% → 85%
- ✅ **Production-ready automation** - PowerShell batch processing scripts
- ✅ **Complete documentation** - workflow guides, technical summaries, career materials

---

## 🚀 Quick Start

### Prerequisites
- Windows 10/11
- PowerShell 5.1+
- COLMAP 3.12.6+ (installed via vcpkg)
- OpenMVS 2.1.0+ (optional, for dense reconstruction)

### Installation
```powershell
# Install COLMAP via vcpkg
vcpkg install colmap[cuda]:x64-windows

# Install OpenMVS (optional)
vcpkg install openmvs:x64-windows
```

### Running the Pipeline

**Option 1: Interactive Menu**
```powershell
.\run_colmap.ps1
```
Provides menu-driven interface for:
- Launching COLMAP GUI
- Running automatic reconstruction
- Individual pipeline steps (feature extraction, matching, etc.)

**Option 2: Batch Processing**
```powershell
.\process_all_tasks.ps1
```
Automatically processes all tasks end-to-end.

---

## 📁 Repository Structure

```
COLMAP/
│
├── 📜 Scripts
│   ├── run_colmap.ps1              # Interactive menu system
│   └── process_all_tasks.ps1       # Automated batch processing
│
├── 📖 Documentation
│   ├── README.md                    # This file
│   └── projects/
│       ├── README.md                # Workflow guide & commands
│       └── FINAL_SUBMISSION_SUMMARY.md  # Complete project report
│
└── 📊 Output (Camera Calibration Results)
    └── projects/output/
        ├── t01/  # Image Density Challenge
        ├── t02/  # Camera Models Challenge  
        ├── t03/  # Large Area Challenge
        └── t04/  # Varying Altitudes Challenge

Each task folder contains:
  - cameras.txt     Camera intrinsic parameters
  - images.txt      Camera extrinsic parameters (poses) [not tracked - large]
  - points3D.txt    Sparse 3D point cloud
  - frames.txt      Frame metadata
  - rigs.txt        Camera rig configuration
```

---

## 🔬 Technical Details

### Algorithms Implemented

**Feature Extraction**
- SIFT (Scale-Invariant Feature Transform)
- 128-dimensional descriptors
- Difference of Gaussians (DoG) keypoint detection

**Feature Matching**
- Exhaustive matching across all image pairs
- Lowe's ratio test (0.8-0.9 threshold)
- RANSAC geometric verification with fundamental matrix

**Sparse Reconstruction**
- Incremental Structure-from-Motion (SfM)
- Bundle Adjustment using Levenberg-Marquardt optimization
- Triangulation with DLT + Gauss-Newton refinement
- Mean reprojection error: 0.8-1.0 pixels

**Dense Reconstruction** (Task 01)
- PatchMatch Multi-View Stereo
- Depth map estimation with NCC cost function
- TSDF volumetric fusion
- Result: 12,897,583 dense points

### Parameter Optimization

For challenging datasets (large area, varying altitudes), aggressive parameters were used:

```
SiftMatching.max_ratio: 0.9 (vs default 0.8)
SiftMatching.max_num_matches: 65536 (vs default 32768)
Mapper.min_num_matches: 5 (vs default 15)
Mapper.init_min_tri_angle: 2° (vs default 16°)
Mapper.abs_pose_min_num_inliers: 10 (vs default 30)
```

**Impact:**
- Task 03: Improved from 120/340 (35%) → 288/340 (85%) cameras
- Task 04: Improved from 48/72 (67%) → 71/72 (99%) cameras

---

## 📈 Processing Statistics

**Compute Time:**
- Feature Extraction: ~10 hours
- Feature Matching: ~48 hours
- Sparse Reconstruction: ~2 hours
- Dense Reconstruction: ~6.3 hours (t01)
- **Total:** ~50+ hours

**Output:**
- 498 calibrated cameras
- 61,852 sparse 3D points (combined)
- 12,897,583 dense points (t01)

---

## 📝 Key Files

### For Reviewers/Professors
- [`projects/FINAL_SUBMISSION_SUMMARY.md`](projects/FINAL_SUBMISSION_SUMMARY.md) - Complete technical report
- [`projects/output/`](projects/output/) - All calibration results

### For Understanding the Workflow
- [`projects/README.md`](projects/README.md) - Step-by-step workflow guide
- [`run_colmap.ps1`](run_colmap.ps1) - Interactive processing script
- [`process_all_tasks.ps1`](process_all_tasks.ps1) - Batch automation

---

## 🎓 What I Learned

### Technical Skills
- **Computer Vision:** SfM, MVS, bundle adjustment, triangulation
- **3D Geometry:** Camera models, distortion correction, pose estimation
- **Optimization:** Non-linear least squares, parameter tuning, convergence analysis
- **Software Engineering:** Pipeline automation, error handling, reproducibility

### Problem-Solving
- **Challenge:** Task 03 initially registered only 35% of cameras
- **Solution:** Systematic parameter optimization, relaxed geometric constraints
- **Result:** Achieved 85% registration (+168 cameras)

- **Challenge:** Task 04 registered only 67% of cameras  
- **Solution:** Applied lessons from t03, ultra-aggressive matching parameters
- **Result:** Achieved 99% registration (+23 cameras)

### Real-World Lessons
- Default parameters don't always work for production data
- Large-area reconstruction requires permissive thresholds
- Systematic debugging > random parameter changes
- Documentation is critical for reproducibility

---

## 🔧 Tools & Environment

**Core Software:**
- **COLMAP 3.12.6** - Structure-from-Motion with CUDA 13.0
- **OpenMVS 2.1.0** - Multi-View Stereo dense reconstruction
- **vcpkg** - C++ package management
- **PowerShell** - Automation scripting

**Hardware:**
- CUDA-enabled GPU (feature matching acceleration)
- ~50+ hours total compute time

**Development:**
- Git/GitHub - Version control
- Windows 10/11 - Development platform

---

## 📚 References

- **COLMAP:** https://colmap.github.io/
  - Schönberger, J. L., & Frahm, J. M. (2016). Structure-from-Motion Revisited. CVPR.
  
- **OpenMVS:** https://github.com/cdcseacave/openMVS
  - Open Multi-View Stereo reconstruction library

- **ULTRRA Challenge:** WACV 2025 Workshop
  - Urban Landscape Tracking and Reconstruction for Reality Applications

---

## 🤝 Contributing

This is an academic project for the ULTRRA Challenge 2025. For questions or collaboration:

- **GitHub:** [@farnazalamahmed99-cmu](https://github.com/farnazalamahmed99-cmu)
- **Institution:** Carnegie Mellon University
- **Lab:** Illumination and Imaging Lab

---

## 📄 License

This project uses COLMAP and OpenMVS, which are licensed under BSD-3-Clause. Academic research use only.

---

## 🌟 Acknowledgments

- CMU Illumination and Imaging Lab
- COLMAP development team (ETH Zurich)
- OpenMVS contributors
- ULTRRA Challenge organizers (WACV 2025)

---

**Last Updated:** February 4, 2026
