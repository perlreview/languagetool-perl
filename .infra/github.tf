provider "github" {
  organization = "perlreview"
}

resource "github_repository" "repo" {
	name          = "grammarbot-perl"
	description   = "Interact with the Grammarbot API through Perl"
	homepage_url  = "https://www.metacpan.org/pod/GrammarBot"
	has_downloads = false
	has_issues    = true
	has_projects  = false
	has_wiki      = false

	allow_merge_commit = false
	allow_squash_merge = true
	allow_rebase_merge = false

	auto_init = false

	private = false

	topics = [
		"perl",
		"grammar",
		"grammarbot"
		]
	}
