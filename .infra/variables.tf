variable "module_name" {
	type    = string
	default = "LanguageTool"
	}

variable "repo_name" {
	type    = string
	default = "languagetool-perl"
	}

variable "description" {
	type = string
	default = "Interact with the LanguageTool API from Perl"
	}

variable "metacpan_url" {
	type = string
	default = "https://www.metacpan.org/pod/LanguageTool"
	}

variable tags {
	type = list(string)
	default = [
		"perl",
		"grammar",
		"languagetool",
		"spellchecking"
		]
	}

variable "default_org" {
	type    = string
	default = "briandfoy"
	}

variable "github_org" {
	type    = string
	default = "perlreview"
	}

variable "bitbucket_org" {
	type    = string
	default = "briandfoy"
	}

variable "gitlab_org" {
	type    = string
	default = "briandfoy"
	}
