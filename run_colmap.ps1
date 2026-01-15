# COLMAP Helper Script
# Run this from PowerShell

$COLMAP = "C:\Farnaz\vcpkg\packages\colmap_x64-windows\tools\colmap\colmap.exe"
$IMAGES = "C:\Farnaz\projects\images"
$WORKSPACE = "C:\Farnaz\projects\workspace"
$OUTPUT = "C:\Farnaz\projects\output"

function Show-Menu {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "        COLMAP 3D Reconstruction       " -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "1. Launch COLMAP GUI"
    Write-Host "2. Run Automatic Reconstruction"
    Write-Host "3. Feature Extraction Only"
    Write-Host "4. Feature Matching Only"
    Write-Host "5. Sparse Reconstruction Only"
    Write-Host "6. Exit"
    Write-Host ""
}

function Launch-GUI {
    Write-Host "Launching COLMAP GUI..." -ForegroundColor Green
    & $COLMAP gui
}

function Run-AutoReconstruct {
    Write-Host "Running automatic reconstruction..." -ForegroundColor Green
    Write-Host "Images: $IMAGES"
    Write-Host "Workspace: $WORKSPACE"
    & $COLMAP automatic_reconstructor --image_path $IMAGES --workspace_path $WORKSPACE
}

function Run-FeatureExtraction {
    Write-Host "Running feature extraction..." -ForegroundColor Green
    & $COLMAP feature_extractor --image_path $IMAGES --database_path "$WORKSPACE\database.db"
}

function Run-FeatureMatching {
    Write-Host "Running exhaustive feature matching..." -ForegroundColor Green
    & $COLMAP exhaustive_matcher --database_path "$WORKSPACE\database.db"
}

function Run-SparseReconstruction {
    Write-Host "Running sparse reconstruction..." -ForegroundColor Green
    New-Item -ItemType Directory -Force -Path "$WORKSPACE\sparse" | Out-Null
    & $COLMAP mapper --image_path $IMAGES --database_path "$WORKSPACE\database.db" --output_path "$WORKSPACE\sparse"
}

# Main loop
do {
    Show-Menu
    $choice = Read-Host "Enter your choice (1-6)"
    
    switch ($choice) {
        "1" { Launch-GUI }
        "2" { Run-AutoReconstruct }
        "3" { Run-FeatureExtraction }
        "4" { Run-FeatureMatching }
        "5" { Run-SparseReconstruction }
        "6" { Write-Host "Goodbye!" -ForegroundColor Yellow; break }
        default { Write-Host "Invalid choice. Please try again." -ForegroundColor Red }
    }
} while ($choice -ne "6")




