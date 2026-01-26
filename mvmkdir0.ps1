# 파일 이동 스크립트
# 정규식 패턴에 맞는 파일이나 폴더를 찾아서 해당 패턴명의 폴더로 이동시킵니다

Import-Module -Name Microsoft.PowerShell.Management

# 작업할 경로 설정
$rootPath = "D:\YOUR_PATH_ERR_DIR"

# 해당 경로가 존재하는지 확인
if (-not (Test-Path -Path $rootPath)) {
    Write-Host "지정된 경로가 존재하지 않습니다: $rootPath" -ForegroundColor Red
    exit
}

# .S + 두자리 숫자 패턴을 가진 항목들 찾기 (폴더와 파일 모두)
$items = Get-ChildItem -Path $rootPath | Where-Object { $_.Name -match '^(\.?[ES]\d{2})' }

# 찾은 항목들에 대해 처리
foreach ($item in $items) {
    # 정규식 패턴에서 그룹 추출 (.S + 두자리 숫자)
    if ($item.Name -match '^(\.?[ES]\d{2})') {
        $folderName = $Matches[1]
        
        # 대상 폴더 경로 생성
        $targetFolderPath = Join-Path -Path $rootPath -ChildPath $folderName
        
        # 대상 폴더가 없으면 생성
        if (-not (Test-Path -Path $targetFolderPath)) {
            Write-Host "폴더 생성: $folderName" -ForegroundColor Green
            New-Item -Path $targetFolderPath -ItemType Directory | Out-Null
        }
        
        # 항목을 대상 폴더로 이동
        $destinationPath = Join-Path -Path $targetFolderPath -ChildPath $item.Name
        
        # 이미 동일한 이름의 파일이 존재하는지 확인
        if (Test-Path -Path $destinationPath) {
            Write-Host "경고: 대상 폴더에 이미 '$($item.Name)' 파일이 존재합니다. 이동을 건너뜁니다." -ForegroundColor Yellow
        } else {
            Write-Host "이동: $($item.Name) -> $folderName\$($item.Name)" -ForegroundColor Cyan
            Move-Item -Path $item.FullName -Destination $destinationPath -Force
        }
    }
}

# 모르고 폴더만 옮긴 경우 이것만 따로 실행
# 이미 생성된 .S.. 폴더 내로 S로 시작하는 이미지 파일 이동하는 함수
function Move-ImageFilesToCreatedFolders {
    param (
        [Parameter(Mandatory=$true)]
        [string]$RootPath
    )
    
    # 대상 폴더 (패턴 .S숫자 형식) 찾기
    # $patternS= '^(\.S\d{2})$'
    $dotSFolders = Get-ChildItem -Path $RootPath -Directory | Where-Object { $_.Name -match '^([ES]\d{2})$' }
    
    if ($dotSFolders.Count -eq 0) {
        Write-Host "이동할 대상 E,S 형식 폴더를 찾을 수 없습니다." -ForegroundColor Yellow
        return
    }
    
    # 각 폴더에 대해 처리
    foreach ($folder in $dotSFolders) {
        # 이 폴더에 대응하는 S숫자 패턴 추출 (예: .S01 → S01)
        if ($folder.Name -match '^([ES]\d{2})$') {
            $patternToMatch = $Matches[1]
            
            # 원본 경로에서 해당 패턴으로 시작하는 이미지 파일 찾기 (JPG, PNG, GIF, BMP, TIFF 등)
            $imageFiles = Get-ChildItem -Path $RootPath -File | 
                         Where-Object { 
                             $_.Name -match "^$patternToMatch" -and 
                             $_.Extension -match '\.(jpg|jpeg|png|gif|bmp|tiff|tif)$' -and
                             -not ($_.FullName -like "$($folder.FullName)*") # 이미 대상 폴더 내에 있는 파일은 제외
                         }
            
            if ($imageFiles.Count -eq 0) {
                Write-Host "$patternToMatch 패턴에 맞는 이미지 파일이 없습니다." -ForegroundColor Yellow
                continue
            }
            
            # 찾은 이미지 파일들을 폴더로 이동
            foreach ($imageFile in $imageFiles) {
                $destinationPath = Join-Path -Path $folder.FullName -ChildPath $imageFile.Name
                
                # 이미 동일한 이름의 파일이 존재하는지 확인
                if (Test-Path -Path $destinationPath) {
                    Write-Host "경고: 대상 폴더에 이미 '$($imageFile.Name)' 파일이 존재합니다. 이동을 건너뜁니다." -ForegroundColor Yellow
                } else {
                    Write-Host "이미지 이동: $($imageFile.Name) -> $($folder.Name)\$($imageFile.Name)" -ForegroundColor Green
                    Move-Item -Path $imageFile.FullName -Destination $destinationPath -Force
                }
            }
        }
    }
}
Move-ImageFilesToCreatedFolders -RootPath $rootPath

Write-Host "작업 완료!" -ForegroundColor Green

