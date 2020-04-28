namespace :issues do
  task sync: :environment do
    Issue.download_active_repos
    Issue.download_new_repos
    Issue.update_collab_labels
    Issue.sync_merged_pull_requests
    Issue.sync_draft_pull_requests
  end

  task sync_collabs: :environment do
    Issue.download_active_collab_repos
    Issue.download_new_collab_repos
    Issue.update_collab_labels
  end

  task sync_recent: :environment do
    Repository.sync_recently_active_protocol_repos
  end
end
