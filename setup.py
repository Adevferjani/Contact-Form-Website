import os
import subprocess
import zipfile
import getpass
import webbrowser
import json
import sys

def zip_lambda():
    print("[1/5] Zipping Lambda function...")
    with zipfile.ZipFile('lambda_function.zip', 'w') as zf:
        zf.write('lambda_function.py')
    print("✅ Lambda function zipped.")

def create_tfvars():
    print("[2/5] Creating terraform.tfvars file...")
    access_key = input("Enter AWS Access Key: ").strip()
    secret_key = input("Enter AWS Secret Key: ").strip()

    with open('terraform.tfvars', 'w') as f:
        f.write(f'aws_access_key = "{access_key}"\n')
        f.write(f'aws_secret_key = "{secret_key}"\n')
    print("✅ terraform.tfvars created. (Remember: don't commit this!)")

def run_terraform():
    print("[3/5] Initializing Terraform...")
    subprocess.run(["terraform", "init"], check=True)

    print("[4/5] Planning Terraform deployment...")
    subprocess.run(["terraform", "plan"], check=True)

    confirm = input("Apply changes? (yes/no): ").strip().lower()
    if confirm == "yes":
        subprocess.run(["terraform", "apply", "-auto-approve"], check=True)
        print("✅ Deployment complete.")
        open_website()
    else:
        print("❌ Deployment cancelled.")

def open_website():
    print("[5/5] Fetching website URL...")
    try:
        result = subprocess.run(
            ["terraform", "output", "-json"],
            capture_output=True,
            text=True,
            check=True
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
    subprocess.run(["terraform", "destroy", "-auto-approve"], check=True)
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
