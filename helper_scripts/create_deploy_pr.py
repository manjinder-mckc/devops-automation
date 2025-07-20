import sys
import subprocess
import os
from datetime import datetime
from contextlib import contextmanager

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))

@contextmanager
def cd(destination):
    '''
    Context manager to change the current working directory.
    '''
    prev_dir = os.getcwd()
    os.chdir(destination)
    try:
        yield
    finally:
        os.chdir(prev_dir)

def run_cmd(cmd, capture_output=False):
    '''
    Run a shell command and return the output.
    '''
    print(f"Running cmd: {cmd}")
    result = subprocess.run(cmd, shell=True, text=True, capture_output=capture_output, check=True)
    return result.stdout.strip() if capture_output else None

def update_tfvars(version, tfvars_path=None):
    '''
    Update the terraform.tfvars file with the given version.
    '''
    #check if tfvars file exists , create if not exists
    if not os.path.exists(tfvars_path):
        print(f"Creating {tfvars_path} with initial content.")
        with open(tfvars_path, "w") as f:
            f.write(f'image = "{version}"\n')
        return

    with open(tfvars_path, "r") as f:
        lines = f.readlines()

    new_lines = []
    found = False
    for line in lines:
        if line.strip().startswith("image"):
            new_lines.append(f'image = "{version}"\n')
            found = True
        else:
            new_lines.append(line)

    if not found:
        new_lines.append(f'image = "{version}"\n')

    with open(tfvars_path, "w") as f:
        f.writelines(new_lines)

    print(f"Updated {tfvars_path} with image = \"{version}\"")

def main():
    if len(sys.argv) != 2:
        print("Usage: python create_deployment_pr.py <image>")
        sys.exit(1)

    image = sys.argv[1]
    version = image.split(":")[1] if ":" in image else image
    branch_name = f"deploy/{version}-{datetime.now().strftime('%Y%m%d%H%M')}"

    with cd(REPO_ROOT):
        tfvars_path = os.path.join("iac", "terraform.tfvars")
        update_tfvars(image, tfvars_path=tfvars_path)

        # Git commit flow
        run_cmd(f"git checkout -b {branch_name}")
        run_cmd(f"git add .")
        run_cmd(f"git commit -m 'chore: deploy version {version}'")
        run_cmd(f"git push -u origin {branch_name}")

        # Create PR using GitHub CLI
        run_cmd(f'gh pr create --title "Deploy version {version}" --body "This PR updates the deployment to version {version}" --base main')

        print("PR created. Merge it to trigger deployment (via terraform apply).")

if __name__ == "__main__":
    main()
