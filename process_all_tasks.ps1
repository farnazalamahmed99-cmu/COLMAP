# ULTRRA Challenge 2025 - Complete Processing Script
# This script processes Tasks 02, 03, and 04 through the full COLMAP + OpenMVS pipeline

$COLMAP = "C:\Farnaz\vcpkg\packages\colmap_x64-windows\tools\colmap\colmap.exe"
$OPENMVS = "C:\Farnaz\vcpkg\packages\openmvs_x64-windows\tools\openmvs"
$BASE_IMAGES = "C:\Users\farna\Desktop\COLMAP Dataset\ultrra25-dev-inputs-v02\inputs\camera_calibration"

# Define tasks
$tasks = @(
    @{
        id = "t02"
        folder = "t02_v06_s00_r01_CameraModels_WACV_dev_A01"
    },
    @{
        id = "t03"
        folder = "t03_v06_s00_r01_ReconstructedArea_WACV_dev_A01"
    },
    @{
        id = "t04"
        folder = "t04_v11_s00_r01_VaryingAltitudes_WACV_dev_A01"
    }
)

function Process-Task {
    param (
        [string]$taskId,
        [string]$taskFolder
    )
    
    $images = "$BASE_IMAGES\$taskFolder"
    $workspace = "C:\Farnaz\projects\workspace\$taskId"
    $output = "C:\Farnaz\projects\output\$taskId"
    $db = "$workspace\database.db"
    
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "Processing $taskId - $taskFolder" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    
    # Create directories
    New-Item -ItemType Directory -Force -Path $workspace | Out-Null
    New-Item -ItemType Directory -Force -Path $output | Out-Null
    New-Item -ItemType Directory -Force -Path "$workspace\sparse" | Out-Null
    
    # Count images
    $imgCount = (Get-ChildItem $images -Filter "*.jpg" -Recurse -ErrorAction SilentlyContinue).Count + 
                (Get-ChildItem $images -Filter "*.png" -Recurse -ErrorAction SilentlyContinue).Count
    Write-Host "Images: $imgCount" -ForegroundColor Yellow
    
    # Step 1: Feature Extraction (if not done)
    if (-not (Test-Path $db) -or (Get-Item $db).Length -lt 1MB) {
        Write-Host "[1/6] Feature Extraction..." -ForegroundColor Green
        & $COLMAP feature_extractor --image_path $images --database_path $db
    } else {
        Write-Host "[1/6] Feature Extraction - Already done (database exists)" -ForegroundColor DarkGreen
    }
    
    # Step 2: Feature Matching
    Write-Host "[2/6] Feature Matching..." -ForegroundColor Green
    & $COLMAP exhaustive_matcher --database_path $db
    
    # Step 3: Sparse Reconstruction (Mapper)
    Write-Host "[3/6] Sparse Reconstruction (Mapper)..." -ForegroundColor Green
    & $COLMAP mapper --database_path $db --image_path $images --output_path "$workspace\sparse"
    
    # Check if reconstruction succeeded
    $sparseModels = Get-ChildItem "$workspace\sparse" -Directory -ErrorAction SilentlyContinue
    if ($sparseModels.Count -eq 0) {
        Write-Host "ERROR: No sparse model created for $taskId" -ForegroundColor Red
        return
    }
    
    $bestModel = $sparseModels | Sort-Object Name | Select-Object -First 1
    Write-Host "Best model: $($bestModel.FullName)" -ForegroundColor Yellow
    
    # Step 4: Export model to text format
    Write-Host "[4/6] Exporting Model..." -ForegroundColor Green
    & $COLMAP model_converter --input_path $bestModel.FullName --output_path $output --output_type TXT
    
    # Step 5: Export PLY point cloud
    Write-Host "[5/6] Exporting PLY..." -ForegroundColor Green
    & $COLMAP model_converter --input_path $bestModel.FullName --output_path "$output\model.ply" --output_type PLY
    
    # Step 6: Image Undistortion (for OpenMVS)
    Write-Host "[6/6] Image Undistortion..." -ForegroundColor Green
    New-Item -ItemType Directory -Force -Path "$workspace\dense" | Out-Null
    & $COLMAP image_undistorter --image_path $images --input_path $bestModel.FullName --output_path "$workspace\dense" --output_type COLMAP
    
    # Summary
    Write-Host ""
    Write-Host "=== $taskId Complete ===" -ForegroundColor Cyan
    Write-Host "Output files:" -ForegroundColor Yellow
    Get-ChildItem $output -ErrorAction SilentlyContinue | ForEach-Object { Write-Host "  - $($_.Name)" }
    Write-Host ""
}

# Main execution
Write-Host "=============================================" -ForegroundColor Magenta
Write-Host "ULTRRA Challenge 2025 - Batch Processing" -ForegroundColor Magenta
Write-Host "=============================================" -ForegroundColor Magenta
Write-Host "Start Time: $(Get-Date)" -ForegroundColor White
Write-Host ""

foreach ($task in $tasks) {
    Process-Task -taskId $task.id -taskFolder $task.folder
}

Write-Host ""
Write-Host "=============================================" -ForegroundColor Magenta
Write-Host "ALL TASKS COMPLETE!" -ForegroundColor Magenta
Write-Host "End Time: $(Get-Date)" -ForegroundColor White
Write-Host "=============================================" -ForegroundColor Magenta




