install: ./Cask
	cask install

test: install
	cask exec ert-runner
