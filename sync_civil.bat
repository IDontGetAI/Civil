@echo off
echo [1/4] 正在清理 Git 缓存以应用最新的 .gitignore 规则...
git rm -r --cached . >nul 2>&1

echo [2/4] 正在添加 01-06 核心文件夹 (包含 PDF)...
git add .

echo [3/4] 正在提交更改...
set /p msg="请输入本次更新说明 (直接回车则使用默认说明): "
if "%msg%"=="" set msg="自动同步笔记: %date% %time%"
git commit -m "%msg%"

echo [4/4] 正在推送到远程仓库...
git push origin main

echo.
echo ==========================================
echo 同步完成！窗口将在 3 秒后关闭。
echo ==========================================
timeout /t 3