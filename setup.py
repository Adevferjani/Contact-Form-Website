import os
import subprocess
import zipfile
import webbrowser
import json
import sys

def zip_lambda():
    print("[1/5] Zipping Lambda function...")

    backend_dir = os.path.join("src", "backend")
    lambda_path = os.path.join(backend_dir, "lambda_function.py")
    zip_path = os.path.join(backend_dir, "lambda_function.zip")

    if not os.path.exists(lambda_path):
        raise FileNotFoundError(f"❌ Could not find Lambda function at {lambda_path}")

    # Ensure the backend directory exists
    os.makedirs(backend_dir, exist_ok=True)

    # Create the zip in src/backend/
    with zipfile.ZipFile(zip_path, 'w') as zf:
        # Keep lambda_function.py at the root inside the zip
        zf.write(lambda_path, arcname="lambda_function.py")

    print(f"✅ Lambda function zipped at {zip_path}.")


def create_tfvars():
    print("[2/5] Checking terraform.tfvars file...")

    modules_dir = os.path.join(os.getcwd(), "modules")
    os.makedirs(modules_dir, exist_ok=True)  # make sure modules/ exists

    tfvars_path = os.path.join(modules_dir, "terraform.tfvars")

    if os.path.exists(tfvars_path):
        print(f"✅ terraform.tfvars already exists at {tfvars_path}, skipping creation.")
        return  # skip asking for credentials

    # If not exists, prompt user for AWS credentials
    access_key = input("Enter AWS Access Key: ").strip()
    secret_key = input("Enter AWS Secret Key: ").strip()

    with open(tfvars_path, 'w') as f:
        f.write(f'aws_access_key = "{access_key}"\n')
        f.write(f'aws_secret_key = "{secret_key}"\n')

    print(f"✅ terraform.tfvars created at {tfvars_path}. (Remember: don't commit this!)")


def run_terraform():
    print("[3/5] Initializing Terraform...")

    modules_dir = os.path.join(os.getcwd(), "modules")

    subprocess.run(["terraform", "init"], check=True, cwd=modules_dir)

    print("[4/5] Planning Terraform deployment...")
    subprocess.run(
        ["terraform", "plan", "-var-file=terraform.tfvars"],
        check=True,
        cwd=modules_dir
    )

    confirm = input("Apply changes? (yes/no): ").strip().lower()
    if confirm == "yes":
        subprocess.run(
            ["terraform", "apply", "-auto-approve", "-var-file=terraform.tfvars"],
            check=True,
            cwd=modules_dir
        )
        print("✅ Deployment complete.")
        open_website()
    else:
        print("❌ Deployment cancelled.")


def open_website():
    print("[5/5] Fetching website URL...")
    modules_dir = os.path.join(os.getcwd(), "modules")
    try:
        result = subprocess.run(
            ["terraform", "output", "-json"],
            capture_output=True,
            text=True,
            check=True,
            cwd=modules_dir
        )
        outputs = json.loads(result.stdout)
        possible_keys = ["website_url", "cloudfront_url", "site_url"]
        url = None
        for key in possible_keys:
            if key in outputs and "value" in outputs[key]:
                url = outputs[key]["value"]
                break
        if url:
            print(f"🌐 Opening website: {url}")
            webbrowser.open(url)
        else:
            print("⚠️ Could not find website URL in Terraform outputs.")
    except subprocess.CalledProcessError:
        print("⚠️ Failed to get Terraform outputs.")


def destroy_terraform():
    print("🛑 Destroying all Terraform-managed resources...")
    modules_dir = os.path.join(os.getcwd(), "modules")
    subprocess.run(
        ["terraform", "destroy", "-auto-approve"],
        check=True,
        cwd=modules_dir
    )
    print("✅ All resources destroyed.")


if __name__ == "__main__":
    try:
        if len(sys.argv) > 1 and sys.argv[1] == "--destroy":
            destroy_terraform()
        else:
            zip_lambda()
            create_tfvars()
            run_terraform()
    except subprocess.CalledProcessError as e:
        print(f"⚠️ Error running command: {e}")
    except Exception as e:
        print(f"⚠️ Unexpected error: {e}")