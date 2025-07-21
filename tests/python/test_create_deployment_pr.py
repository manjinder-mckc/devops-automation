import os,sys
import unittest
from pathlib import Path
import importlib

from contextlib import contextmanager

CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))
HELPER_SCRIPTS_PATH = os.path.abspath(os.path.join(CURRENT_DIR, "../../helper_scripts"))
sys.path.insert(0, HELPER_SCRIPTS_PATH)

print("HELPER_SCRIPTS_PATH:", HELPER_SCRIPTS_PATH)
print("sys.path:", sys.path)

sut = importlib.import_module("create_deploy_pr")

class TestCreateDeploymentPR(unittest.TestCase):
    def setUp(self):
        # Setup a temp test file
        self.test_tfvars_path = "test_terraform.tfvars"
        if os.path.exists(self.test_tfvars_path):
            os.remove(self.test_tfvars_path)

    def tearDown(self):
        # Cleanup
        if os.path.exists(self.test_tfvars_path):
            os.remove(self.test_tfvars_path)

    def test_create_new_tfvars(self):
        version = "nginx:latest"
        sut.update_tfvars(version, tfvars_path=self.test_tfvars_path)

        with open(self.test_tfvars_path, "r") as f:
            content = f.read()

        self.assertIn(f'image = "{version}"', content)

    def test_update_existing_tfvars(self):
        # Pre-fill file
        with open(self.test_tfvars_path, "w") as f:
            f.write('image = "nginx:old"\n')

        version = "nginx:new"
        sut.update_tfvars(version, tfvars_path=self.test_tfvars_path)

        with open(self.test_tfvars_path, "r") as f:
            content = f.read()

        self.assertIn(f'image = "{version}"', content)

    def test_append_image_if_not_found(self):
        # File without "image"
        with open(self.test_tfvars_path, "w") as f:
            f.write('replicas = "3"\n')

        version = "nginx:added"
        sut.update_tfvars(version, tfvars_path=self.test_tfvars_path)

        with open(self.test_tfvars_path, "r") as f:
            content = f.read()

        self.assertIn(f'image = "{version}"', content)


if __name__ == '__main__':
    unittest.main()
