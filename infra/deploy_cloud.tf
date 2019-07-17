
provider "google" {
  credentials = "${file("Devops-App-Cloud-42e3be98bd20.json")}"
  region      = "${var.location_cloud}"

  version = "~> 2.11"
}

# Create random id number
resource "random_id" "id" {
  byte_length = 4
  prefix      = "${var.project_name}-"
}

# Create Project
resource "google_project" "project" {
  name            = "${var.project_name}"
  project_id      = "${random_id.id.hex}"
  billing_account = "${var.billing_account}"
  org_id          = "${var.org_id}"
}


