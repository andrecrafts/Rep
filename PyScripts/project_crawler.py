# Made by AndreCrafts
# Create a summary of all text files in a project directory.
import os
import argparse
from fnmatch import fnmatch

# --- Configuration ---
# Directories to completely ignore during the scan (supports wildcards like test_*)
EXCLUDED_DIRS = {
    'node_modules',
    '.git',
    'dist',
    'build',
    '.cache',
    '__pycache__',
    '.vscode',
    'coverage',
    '.turbo',
    '.*',           # All hidden directories (starting with .)
    'test_*',       # All directories starting with test_
    '*_backup',     # All directories ending with _backup
}

# Specific filenames/patterns to always exclude (supports wildcards like *.pem)
EXCLUDED_FILENAMES = {
    'package-lock.json',
    'pnpm-lock.yaml',
    'yarn.lock',
    '*.pem',        # All PEM certificate files
    '*.key',        # All key files
    '*.log',        # All log files
    '.DS_Store',    # macOS system file
}
# --- End of Configuration ---

def is_dir_included(dirname):
    """
    Checks if a directory should be included in the scan.
    Returns False only if the directory matches an exclusion pattern.
    Supports wildcards (e.g., .*, test_*, *_backup)
    """
    # Check if dirname matches any exclusion pattern
    for pattern in EXCLUDED_DIRS:
        if fnmatch(dirname, pattern):
            return False
    
    # Otherwise, include it
    return True


def is_file_included(filename):
    """
    Checks if a file should be included in the summary.
    Returns False only if the file matches an exclusion pattern.
    Supports wildcards (e.g., *.pem, test_*.py)
    """
    # Check if filename matches any exclusion pattern
    for pattern in EXCLUDED_FILENAMES:
        if fnmatch(filename, pattern):
            return False
    
    # Otherwise, include it
    return True


def write_file_to_summary(summary_file, full_path, relative_path):
    """
    Reads a file and writes its content to the summary file.
    
    Args:
        summary_file: The open file object to write to
        full_path: The absolute path to the source file
        relative_path: The relative path for display purposes
    """
    try:
        with open(full_path, 'r', encoding='utf-8', errors='ignore') as source_file:
            content = source_file.read()
            summary_file.write(f"--- File: {relative_path} ---\n")
            summary_file.write(f'"""\n{content}\n"""\n\n')
    except Exception as e:
        print(f"Warning: Could not read file {full_path}. Reason: {e}")


def process_files(summary_file, project_path, root, files):
    """
    Process all files in a directory and write included ones to the summary.
    
    Args:
        summary_file: The open file object to write to
        project_path: The root path of the project
        root: Current directory being processed
        files: List of filenames in the current directory
    """
    for filename in files:
        if not is_file_included(filename):
            continue
            
        full_path = os.path.join(root, filename)
        relative_path = os.path.relpath(full_path, project_path)
        write_file_to_summary(summary_file, full_path, relative_path)


def filter_directories(dirs):
    """
    Filter out excluded directories from the list.
    
    Args:
        dirs: List of directory names to filter
    """
    filtered_dirs = []
    for directory in dirs:
        if is_dir_included(directory):
            filtered_dirs.append(directory)
    dirs[:] = filtered_dirs


def generate_project_summary(project_path, output_file):
    """
    Walks through a project directory, reads the content of specified text files,
    and writes it all into a single summary .txt file.

    Args:
        project_path (str): The absolute or relative path to the project's root directory.
        output_file (str): The name of the text file to save the summary to.
    """
    project_path = os.path.abspath(project_path)
    project_root_name = os.path.basename(project_path)

    print(f"Scanning project at: {project_path}")
    
    # Open the output file
    try:
        summary_file = open(output_file, 'w', encoding='utf-8')
    except IOError as e:
        print(f"Error: Could not write to output file {output_file}. Reason: {e}")
        return
    
    # Process the project files
    try:
        summary_file.write(f"Contents of project: {project_root_name}\n")
        summary_file.write("=" * 40 + "\n\n")

        for root, dirs, files in os.walk(project_path, topdown=True):
            filter_directories(dirs)
            process_files(summary_file, project_path, root, files)
    finally:
        summary_file.close()
    
    print(f"✅ Project summary successfully generated at: {output_file}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Create a summary of all text files in a project directory."
    )
    parser.add_argument(
        "project_path",
        help="The path to the root directory of the project you want to summarize."
    )
    parser.add_argument(
        "-o",
        "--output",
        default="project_summary.txt",
        help="The name of the output file. Defaults to 'project_summary.txt'."
    )
    
    args = parser.parse_args()
    
    if not os.path.isdir(args.project_path):
        print(f"Error: The specified path '{args.project_path}' is not a valid directory.")
    else:

        generate_project_summary(args.project_path, args.output)
