run:
	mkdir _tfc
	cd _tfc && \
	terraform init \
		-backend-config="organization=dasmeta-testing" \
		-backend-config="workspaces.name=testing-infrastructure" \
		-from-module="github.com/dasmeta/terraform-tfe-cloud.git?ref=DMVP-2598-simplify-tfe-use"
