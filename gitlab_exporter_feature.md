GitLab Exporter Features and Limitations
GitLab Exporter was designed to export project information and meta data from instances of GitLab in such a format that can be imported by GitHub Enterprise's ghe-migrator. While a majority of models and data can be successfully migrated, it does have some limitations, due to a lack of information provided by GitLab's API.

Model	Can Export?	Notes
Users	Y	
Groups	Y	Imported as "Organizations"
Group Members	Y	Imported as "Teams"
Subgroups & Subgroup Projects	N	Support for subgroups and their projects has not yet been implemented. See limitations section below.
Projects	Y	Imported as "Repositories"
Fork Relationships	N	Migrating fork relationships is not supported by ghe-migrator and is not currently on the roadmap for GitLab Exporter. NOTE: Fork repos can be migrated but all fork relationships will not carry over. See limitations section below.
Protected branches	Y	Protected branch settings and associated data are migrated
Project Team Members	Y	Imported as "Repository Collaborators"; Requires GitHub Enterprise 2.7
Merge Requests	Y	Imported as "Pull Requests"; renumbered sequentially along with Issues
Merge Request Notes	Y	Imported as "Issue Comments"; GitLab does not provide enough data to determine diff notes, so all are imported inline. See limitations section below.
Issues	Y	
Issue Notes	Y	Imported as "Issue Comments"
Events	Y	Events are imported as Issue Comments, since GitLab's API does not provide enough information to build robust Events in GitHub
Webhooks	Y	Requires GitHub Enterprise 2.7
Attachments	Y	
Tags	Y	Imported as "Releases"
Avatars	N	Avatars are not supported by ghe-migrator and are not currently on the roadmap for the GitLab Exporter
Commit Comments	Y	
Wikis	Y	
Milestones	Y	Since GitLab Milestones can be assigned to multiple Projects, we duplicate the Milestone for all associated Repositories
Known Issues / Limitations
This section describes in more detail some limitations of GitLab Exporter. Most models have a 1:1 mapping in GitHub Enterprise but there are a few models that don't translate over well.

Merge Request Notes
GitLab does not provide enough information in their API to properly recreate merge request diff notes as line comments in GitHub. Due to this limitation, diff notes are created in-line as comments in pull requests.

Fork Relationships
GitHub currently does not support migrating forks between GitLab and GitHub Enterprise due to the complexity in managing fork relationships to optimize disk usage. In addition, GitLab uses an entirely different ref structure that is not compatible with GitHub. For these reasons, fork relationships do not carry over when exporting and importing forked repositories from GitLab.

Users can create new forks once parent repositories are imported to GitHub and push their changes from their local forks to the new remotes on GitHub. An example may look like:

cd ~/my-forked-repo
git remote add github https://github.example.com/dpmex4527/my-forked-repo.git
git push --mirror github
Alternatively, a user could replace the origin remote (which would be GitLab)

cd ~/my-forked-repo
git remote set-url origin https://github.example.com/dpmex4527/my-forked-repo.git
git push --mirror origin
Subgroups and Subgroup projects
GitLab currently does not expose Subgroup and Subgroups via their API. Due to this limitation, support for Subgroups and Subgroup projects is not possible.

Events
GitLab Events do not expose enough information in their API to create valid events in GitHub. Events are imported as regular comments.
