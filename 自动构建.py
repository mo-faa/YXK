import os
import shutil
import subprocess
import time
import webbrowser
from pathlib import Path

PROJECT_DIR = Path(r"C:\Users\17475\Desktop\YXK")
TOMCAT_DIR = Path(r"C:\Program Files\apache-tomcat-11.0.15")

BUILD_LIBS_DIR = PROJECT_DIR / "build" / "libs"

WEBAPPS_DIR = TOMCAT_DIR / "webapps"
TARGET_WAR = WEBAPPS_DIR / "YXK.war"
TARGET_DIR = WEBAPPS_DIR / "YXK"

TEMP_DIR = TOMCAT_DIR / "temp"
WORK_DIR = TOMCAT_DIR / "work"
LOGS_DIR = TOMCAT_DIR / "logs"

STARTUP_BAT = TOMCAT_DIR / "bin" / "startup.bat"
SHUTDOWN_BAT = TOMCAT_DIR / "bin" / "shutdown.bat"

APP_URL = "http://localhost:8080/YXK/"


def run_cmd(cmd, cwd=None, check=True):
    print(f"\n>>> 执行: {cmd}")
    p = subprocess.run(cmd, cwd=cwd, shell=True, capture_output=True, text=True)
    if check and p.returncode != 0:
        print("STDOUT:\n", p.stdout)
        print("STDERR:\n", p.stderr)
        raise RuntimeError(f"命令执行失败 (退出码={p.returncode}): {cmd}")
    if p.stdout.strip():
        print(p.stdout.strip())
    return p


def try_shutdown_tomcat():
    print(">>> 尝试关闭 Tomcat...")

    # 优雅关闭：如果 CATALINA_HOME 报错，直接忽略
    if SHUTDOWN_BAT.exists():
        p = run_cmd(f'"{SHUTDOWN_BAT}"', cwd=str(TOMCAT_DIR / "bin"), check=False)
        if "CATALINA_HOME environment variable is not defined correctly" in (p.stdout + p.stderr):
            print(">>> shutdown.bat 提示 CATALINA_HOME 未设置，已忽略（后续会强制终止进程）")
        time.sleep(2)

    # 强制终止
    print(">>> 强制终止 Tomcat(java.exe)...")
    subprocess.run('taskkill /F /IM java.exe', shell=True, check=False)
    time.sleep(2)


def safe_remove_path(p: Path):
    if not p.exists():
        return
    print(f">>> 删除: {p}")
    try:
        if p.is_file():
            p.unlink()
        else:
            shutil.rmtree(p)
    except PermissionError:
        # 处理 Program Files 权限/锁
        try:
            os.chmod(p, 0o777)
        except Exception:
            pass
        time.sleep(0.5)
        if p.is_file():
            p.unlink()
        else:
            shutil.rmtree(p)


def clear_tomcat_cache():
    print(">>> 清理 Tomcat 缓存")

    for d in [TEMP_DIR, WORK_DIR]:
        if d.exists():
            safe_remove_path(d)
            d.mkdir(exist_ok=True)

    if LOGS_DIR.exists():
        for f in LOGS_DIR.glob("catalina.*.log"):
            safe_remove_path(f)

    for item in WEBAPPS_DIR.iterdir():
        if item.is_dir() and item.name not in ["ROOT", "manager", "host-manager", "docs", "examples"]:
            safe_remove_path(item)


def build_project() -> Path:
    print("\n=== 构建项目：gradle clean build ===")

    # 关键：不写死路径，直接用 PATH 里的 gradle
    # 你已验证 “gradle clean build” 在 PowerShell 能成功，说明这里也应能成功
    run_cmd("gradle --version", cwd=str(PROJECT_DIR), check=True)
    run_cmd("gradle clean build", cwd=str(PROJECT_DIR), check=True)

    if not BUILD_LIBS_DIR.exists():
        raise FileNotFoundError("build/libs 不存在")

    wars = list(BUILD_LIBS_DIR.glob("*.war"))
    if not wars:
        raise FileNotFoundError("build/libs 下未生成 .war 文件")

    wars.sort(key=lambda p: p.stat().st_mtime)
    war = wars[-1]
    print(f">>> 构建完成，WAR: {war}")
    return war

def copy_war(src: Path):
    print(f">>> 部署 WAR: {src}")
    safe_remove_path(TARGET_DIR)
    safe_remove_path(TARGET_WAR)
    shutil.copy2(src, TARGET_WAR)


def start_tomcat():
    if not STARTUP_BAT.exists():
        raise FileNotFoundError(f"找不到 startup.bat：{STARTUP_BAT}")

    print(">>> 启动 Tomcat")
    subprocess.Popen(
        f'"{STARTUP_BAT}"',
        cwd=str(TOMCAT_DIR / "bin"),
        shell=True,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL
    )


def main():
    print("=== YXK 自动部署开始（严格 clean build）===")

    try:
        try_shutdown_tomcat()
        clear_tomcat_cache()

        war = build_project()
        copy_war(war)

        start_tomcat()

        time.sleep(3)
        webbrowser.open(APP_URL)

        print("\n=== 部署完成 ===")
        print(f"访问地址: {APP_URL}")

    except Exception as e:
        print("\n[失败]", e)
        input("按回车键退出...")


if __name__ == "__main__":
    main()
