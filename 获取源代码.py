
import os
import sys

def should_include_file(file_path, project_dir):
    """判断文件是否应该包含在输出中"""
    rel_path = os.path.relpath(file_path, project_dir)

    # 统一使用正斜杠处理路径，避免Windows和Linux路径分隔符差异
    rel_path = rel_path.replace('\\', '/')

    # 包含根目录下的特定文件
    if os.path.dirname(rel_path) == '' and os.path.basename(file_path) in ['build.gradle', 'gradlew', 'gradlew.bat', 'settings.gradle']:
        return True

    # 包含src和sql目录下的所有文件
    if rel_path.startswith('src/') or rel_path.startswith('sql/'):
        return True

    return False

def is_text_file(file_path):
    """判断文件是否为文本文件"""
    # 尝试读取文件的一小部分来判断是否为文本文件
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            f.read(1024)  # 尝试读取前1024个字符
        return True
    except UnicodeDecodeError:
        try:
            with open(file_path, 'r', encoding='gbk') as f:
                f.read(1024)
            return True
        except:
            return False
    except:
        return False

def extract_code_to_txt(project_dir, output_file):
    """提取项目代码到txt文件"""
    with open(output_file, 'w', encoding='utf-8') as out:
        out.write("=" * 80 + "\n")
        out.write("基于SSM框架的网上村委会业务办理系统 - 源代码\n")
        out.write("=" * 80 + "\n\n")

        # 遍历项目目录
        for root, dirs, files in os.walk(project_dir):
            # 跳过一些不需要的目录
            if '.git' in root or '.idea' in root or 'target' in root or 'build' in root or 'gradle' in root:
                continue

            for file in files:
                file_path = os.path.join(root, file)

                # 只处理应该包含的文件
                if should_include_file(file_path, project_dir):
                    # 获取相对路径
                    rel_path = os.path.relpath(file_path, project_dir)

                    out.write("-" * 80 + "\n")
                    out.write(f"文件路径: {rel_path}\n")
                    out.write("-" * 80 + "\n\n")

                    # 检查是否为文本文件
                    if not is_text_file(file_path):
                        out.write(f"[二进制文件，无法显示内容]\n\n")
                        continue

                    try:
                        with open(file_path, 'r', encoding='utf-8') as f:
                            content = f.read()
                            out.write(content)
                            out.write("\n\n")
                    except UnicodeDecodeError:
                        # 尝试其他编码
                        try:
                            with open(file_path, 'r', encoding='gbk') as f:
                                content = f.read()
                                out.write(content)
                                out.write("\n\n")
                        except Exception as e:
                            out.write(f"无法读取文件: {e}\n\n")
                    except Exception as e:
                        out.write(f"读取文件时出错: {e}\n\n")

if __name__ == "__main__":
    # 获取当前项目目录
    project_dir = os.path.dirname(os.path.abspath(__file__))
    output_file = os.path.join(project_dir, "项目源代码.txt")

    print(f"正在提取项目代码到: {output_file}")
    extract_code_to_txt(project_dir, output_file)
    print("代码提取完成!")
