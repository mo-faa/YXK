import os
import fnmatch
from pathlib import Path
from datetime import datetime

PROJECT_DIR = Path(r"C:\Users\17475\Desktop\YXK")
OUTPUT_TXT = PROJECT_DIR / "项目代码.txt"

# 根目录只保留这几个文件（其余根目录文件一律不导出）
ROOT_ALLOWLIST = {
    "build.gradle",
    "gradle.properties",
    "gradlew",
    "gradlew.bat",
    "settings.gradle",
}

# 明确排除这些目录（你关心的 build/bin 都在这里）
EXCLUDE_DIRS = {
    "build", "bin", ".gradle",
    ".git", ".svn", ".hg",
    ".idea", ".vscode", ".settings", ".classpath", ".project",
    "out", "target",
    "logs", "tmp", "temp",
}

# 排除常见二进制/无意义文件
EXCLUDE_GLOBS = [
    "*.class", "*.jar", "*.war", "*.ear",
    "*.zip", "*.7z", "*.rar",
    "*.png", "*.jpg", "*.jpeg", "*.gif", "*.bmp", "*.ico", "*.webp",
    "*.pdf", "*.doc", "*.docx", "*.xls", "*.xlsx", "*.ppt", "*.pptx",
    "*.exe", "*.dll", "*.so", "*.dylib",
]

# 认为是文本/代码的扩展名（只导出这些）
TEXT_EXTS = {
    ".java", ".xml", ".properties", ".yml", ".yaml",
    ".jsp", ".tag", ".tld",
    ".gradle", ".kts", ".groovy",
    ".sql", ".md", ".txt",
    ".bat", ".cmd", ".ps1", ".sh",
    ".json",
}

def is_excluded_file(name: str) -> bool:
    low = name.lower()
    for pat in EXCLUDE_GLOBS:
        if fnmatch.fnmatch(low, pat.lower()):
            return True
    return False

def read_text_file(path: Path) -> str:
    # 尽量用 UTF-8，失败再用 gbk 兜底
    for enc in ("utf-8", "utf-8-sig", "gbk", "cp1252"):
        try:
            return path.read_text(encoding=enc, errors="strict")
        except Exception:
            pass
    return path.read_text(encoding="utf-8", errors="replace")

def should_dump_file(path: Path) -> bool:
    if is_excluded_file(path.name):
        return False
    if path.suffix.lower() in TEXT_EXTS:
        return True
    # 允许无后缀但在 allowlist 里的根目录文件（gradlew）
    if path.name in ROOT_ALLOWLIST:
        return True
    return False

def build_tree_lines() -> list[str]:
    lines = []
    lines.append(f"ROOT: {PROJECT_DIR}")

    def walk(dir_path: Path, prefix: str = ""):
        try:
            entries = sorted(dir_path.iterdir(), key=lambda p: (p.is_file(), p.name.lower()))
        except PermissionError:
            lines.append(prefix + "└── [Permission Denied]")
            return

        filtered = []
        for p in entries:
            if p.is_dir():
                if p.name in EXCLUDE_DIRS:
                    continue
                # 只展示 src（和其下结构），其它目录不展示
                if dir_path == PROJECT_DIR and p.name != "src":
                    continue
                filtered.append(p)
            else:
                if dir_path == PROJECT_DIR:
                    # 根目录只展示 allowlist
                    if p.name not in ROOT_ALLOWLIST:
                        continue
                    filtered.append(p)
                else:
                    if should_dump_file(p):
                        filtered.append(p)

        for i, p in enumerate(filtered):
            is_last = (i == len(filtered) - 1)
            connector = "└── " if is_last else "├── "
            lines.append(prefix + connector + p.name)

            if p.is_dir():
                extension = "    " if is_last else "│   "
                walk(p, prefix + extension)

    walk(PROJECT_DIR, "")
    return lines

def collect_files_to_dump() -> list[Path]:
    files = []

    # 1) 根目录 allowlist
    for name in sorted(ROOT_ALLOWLIST):
        p = PROJECT_DIR / name
        if p.exists() and p.is_file():
            files.append(p)

    # 2) src/main 下所有文本代码
    src_main = PROJECT_DIR / "src" / "main"
    if src_main.exists():
        for dirpath, dirnames, filenames in os.walk(src_main):
            dirnames[:] = [d for d in dirnames if d not in EXCLUDE_DIRS]
            for fn in sorted(filenames, key=lambda x: x.lower()):
                p = Path(dirpath) / fn
                if should_dump_file(p):
                    files.append(p)

    return files

def main():
    if not PROJECT_DIR.exists():
        raise FileNotFoundError(f"项目目录不存在：{PROJECT_DIR}")

    tree = build_tree_lines()
    files = collect_files_to_dump()

    now = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    with OUTPUT_TXT.open("w", encoding="utf-8") as w:
        w.write("=== 项目代码导出（精简版）===\n")
        w.write(f"生成时间: {now}\n")
        w.write(f"项目根目录: {PROJECT_DIR}\n")
        w.write("\n")
        w.write("说明：\n")
        w.write("- 根目录只导出：build.gradle / gradle.properties / gradlew / gradlew.bat / settings.gradle\n")
        w.write("- 仅导出 src/main 下的源码与资源\n")
        w.write("- 明确跳过：build/、bin/、.gradle/ 等目录\n\n")

        w.write("=== 目录结构（仅关键部分）===\n")
        w.write("\n".join(tree))
        w.write("\n\n")

        w.write("=== 文件内容 ===\n")
        for p in files:
            rel = p.relative_to(PROJECT_DIR).as_posix()
            w.write("\n" + "=" * 120 + "\n")
            w.write(f"FILE: {rel}\n")
            w.write("=" * 120 + "\n")
            w.write(read_text_file(p))
            if not read_text_file(p).endswith("\n"):
                w.write("\n")

    print(f"[OK] 已生成：{OUTPUT_TXT}")
    print(f"[OK] 导出文件数：{len(files)}")
    print("[OK] 已跳过 build/、bin/、.gradle/ 等目录（不会被捕捉）")

if __name__ == "__main__":
    main()
