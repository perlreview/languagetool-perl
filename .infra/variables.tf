variable "module_name" {
	type    = string
	default = "GrammarBot"
	}

variable "repo_name" {
	type    = string
	default = "grammarbot-perl"
	}

variable "description" {
	type = string
	default = "Interact with the GrammarBot.io API through Perl"
	}

variable "metacpan_url" {
	type = string
	default = "https://www.metacpan.org/pod/GrammarBot"
	}

variable tags {
	type = list(string)
	default = [
		"perl",
		"grammar",
		"grammarbot"
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
