output "instance_public_ip" {
  description = "Public IP address of the GitHub Actions Runner VM"
  value       = oci_core_instance.github_runner.public_ip
}

output "ssh_command" {
  description = "Command to SSH into the VM (default OCI Ubuntu user is 'ubuntu')"
  value       = "ssh ubuntu@${oci_core_instance.github_runner.public_ip}"
}

output "cloud_init_log_command" {
  description = "Command to tail the runner bootstrap logs after boot"
  value       = "ssh ubuntu@${oci_core_instance.github_runner.public_ip} 'sudo tail -f /var/log/github-runner-setup.log'"
}