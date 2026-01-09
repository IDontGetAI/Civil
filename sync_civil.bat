@echo off
chcp 65001 >nul
echo ==========================================
echo    省考复习资料 - GitHub 同步工具
echo ==========================================
echo.

:: 检查是否在 Git 仓库中
git rev-parse --git-dir >nul 2>&1
if errorlevel 1 (
    echo [错误] 当前目录不是 Git 仓库！
    pause
    exit /b 1
)

:: 显示当前分支
for /f "tokens=*" %%i in ('git branch --show-current') do set BRANCH=%%i
echo [信息] 当前分支: %BRANCH%
echo.

:: 步骤 1: 拉取最新代码
echo [1/5] 正在拉取远程最新代码...
git pull origin %BRANCH%
if errorlevel 1 (
    echo [警告] 拉取失败，可能存在冲突或网络问题
    echo.
)

:: 步骤 2: 清理 Git 缓存
echo [2/5] 正在清理 Git 缓存以应用 .gitignore 规则...
git rm -r --cached . >nul 2>&1

:: 步骤 3: 添加文件
echo [3/5] 正在添加文件到暂存区...
git add .
if errorlevel 1 (
    echo [错误] 添加文件失败！
    pause
    exit /b 1
)

:: 显示将要提交的文件统计
echo.
echo [文件统计]
git diff --cached --stat
echo.

:: 步骤 4: 提交更改
echo [4/5] 正在提交更改...
set /p msg="请输入本次更新说明 (直接回车使用默认): "
if "%msg%"=="" set msg=自动同步笔记: %date% %time%
git commit -m "%msg%"
if errorlevel 1 (
    echo [提示] 没有需要提交的更改
    echo.
    goto :end
)

:: 步骤 5: 推送到远程仓库
echo [5/5] 正在推送到远程仓库 origin/%BRANCH%...
git push origin %BRANCH%
if errorlevel 1 (
    echo [错误] 推送失败！请检查网络连接或权限
    pause
    exit /b 1
)

echo.
echo ==========================================
echo ✓ 同步成功完成！
echo ==========================================
echo.

:end
echo 窗口将在 5 秒后关闭...
timeout /t 5