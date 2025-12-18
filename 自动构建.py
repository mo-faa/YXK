import os
import shutil
import subprocess
import time
import webbrowser
from pathlib import Path

PROJECT_DIR = Path(r"C:\Users\17475\Desktop\YXK")
TOMCAT_DIR = Path(r"C:\Program Files\apache-tomcat-11.0.15")

GRADLEW = PROJECT_DIR / "gradlew.bat"
WAR_PATH = PROJECT_DIR / "build" / "libs" / "YXK.war"

WEBAPPS_DIR = TOMCAT_DIR / "webapps"
TARGET_WAR = WEBAPPS_DIR / "YXK.war"
TARGET_DIR = WEBAPPS_DIR / "YXK"

STARTUP_BAT = TOMCAT_DIR / "bin" / "startup.bat"
SHUTDOWN_BAT = TOMCAT_DIR / "bin" / "shutdown.bat"

APP_URL = "http://localhost:8080/YXK/"


def run_cmd(cmd, cwd=None, check=True):
    print(f"\n>>> RUN: {cmd}")
    p = subprocess.run(cmd, cwd=cwd, shell=True)
    if check and p.returncode != 0:
        raise RuntimeError(f"Command failed (exit={p.returncode}): {cmd}")


def try_shutdown_tomcat():
    # 不强制要求关闭成功，但尽量优雅关闭，避免文件占用导致删除失败
    if SHUTDOWN_BAT.exists():
        try:
            run_cmd(f'"{SHUTDOWN_BAT}"', cwd=str(TOMCAT_DIR), check=False)
            time.sleep(2)
        except Exception:
            pass


def safe_remove_path(p: Path):
    if not p.exists():
        return
    print(f">>> REMOVE: {p}")
    try:
        if p.is_dir():
            shutil.rmtree(p)
        else:
            p.unlink()
    except PermissionError as e:
        raise PermissionError(
            f"权限不足，无法删除：{p}\n"
            f"请用“以管理员身份运行”的 PowerShell/终端执行本脚本。\n"
            f"原始错误：{e}"
        )


def copy_war(src: Path, dst: Path):
    print(f">>> COPY: {src} -> {dst}")
    dst.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(src, dst)


def main():
    print("=== YXK Auto Deploy شروع ===")
    print(f"Project: {PROJECT_DIR}")
    print(f"Tomcat : {TOMCAT_DIR}")

    if not PROJECT_DIR.exists():
        raise FileNotFoundError(f"项目目录不存在：{PROJECT_DIR}")
    if not GRADLEW.exists():
        raise FileNotFoundError(f"找不到 gradlew.bat：{GRADLEW}")
    if not TOMCAT_DIR.exists():
        raise FileNotFoundError(f"Tomcat 目录不存在：{TOMCAT_DIR}")
    if not STARTUP_BAT.exists():
        raise FileNotFoundError(f"找不到 startup.bat：{STARTUP_BAT}")

    # 1) 尝试关闭 Tomcat（避免 webapps 文件被占用）
    print("\n=== Step 1: Try shutdown Tomcat (best effort) ===")
    try_shutdown_tomcat()

    # 2) 构建 WAR
    print("\n=== Step 2: Build WAR (clean war) ===")
    run_cmd(f'"{GRADLEW}" clean war', cwd=str(PROJECT_DIR), check=True)

    if not WAR_PATH.exists():
        raise FileNotFoundError(f"WAR 构建后未找到：{WAR_PATH}")

    # 3) 清理旧部署
    print("\n=== Step 3: Remove old deployment in webapps ===")
    safe_remove_path(TARGET_DIR)
    safe_remove_path(TARGET_WAR)

    # 4) 拷贝新 WAR
    print("\n=== Step 4: Copy new WAR to Tomcat webapps ===")
    copy_war(WAR_PATH, TARGET_WAR)

    # 5) 启动 Tomcat
    print("\n=== Step 5: Start Tomcat ===")
    run_cmd(f'"{STARTUP_BAT}"', cwd=str(TOMCAT_DIR), check=False)

    # 6) 等待 Tomcat 启动并打开浏览器
    print("\n=== Step 6: Open browser ===")
    time.sleep(3)
    webbrowser.open(APP_URL)

    print("\n[OK] Done. If the page is not ready yet, wait a few seconds and refresh.")
    print(f"URL: {APP_URL}")


if __name__ == "__main__":
    main()
