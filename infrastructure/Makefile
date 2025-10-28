.PHONY: all bootstrap deploy-testing destroy clean

BOOTSTRAP_DIR=bootstrap
TESTING_DIR=dev
TFVARS=shefqet.tfvars

# Full pipeline: bootstrap → deploy testing
all: bootstrap deploy-testing

# Bootstrap backend resources
bootstrap:
	@echo "🔧 Bootstrapping backend..."
	cd $(BOOTSTRAP_DIR) && rm -rf .terraform .terraform.lock.hcl
	cd $(BOOTSTRAP_DIR) && terraform init -reconfigure -upgrade
	cd $(BOOTSTRAP_DIR) && terraform validate
	cd $(BOOTSTRAP_DIR) && terraform apply -auto-approve

# Deploy testing infrastructure
deploy-testing:
	@echo "🚀 Deploying testing..."
	cd $(TESTING_DIR) && rm -rf .terraform .terraform.lock.hcl
	cd $(TESTING_DIR) && terraform init -reconfigure -upgrade
	cd $(TESTING_DIR) && terraform validate
	cd $(TESTING_DIR) && terraform apply -var-file=$(TFVARS) -auto-approve

# Destroy everything (testing first, then bootstrap)
destroy:
	@echo "⚠️ Destroy all? (y/n)" && read ans && [ $${ans:-n} = y ] || exit 0
	cd $(TESTING_DIR) && terraform destroy -var-file=$(TFVARS) -auto-approve -lock=false
	cd $(BOOTSTRAP_DIR) && terraform destroy -auto-approve -lock=false

# Cleanup local cache/state
clean:
	@echo "⚠️ Clean local? (y/n)" && read ans && [ $${ans:-n} = y ] || exit 0
	rm -rf $(BOOTSTRAP_DIR)/.terraform $(BOOTSTRAP_DIR)/.terraform.lock.hcl $(BOOTSTRAP_DIR)/terraform.tfstate*
	rm -rf $(TESTING_DIR)/.terraform $(TESTING_DIR)/.terraform.lock.hcl $(TESTING_DIR)/terraform.tfstate*