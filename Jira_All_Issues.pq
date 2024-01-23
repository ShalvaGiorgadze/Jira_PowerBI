let
    //URL setup
    base_url = "https://vtbgeorgia.atlassian.net",
    api_url = "/rest/api/latest/search",
    url = base_url & api_url,
    Source = Fetch_Pages(url, 50),
    #"Expanded Column1" = Table.ExpandRecordColumn(Source, "Column1", {"id", "self", "key", "fields"}, {"Issue.id", "Issue.url", "Issue.key", "fields"}),
    #"Expanded fields" = Table.ExpandRecordColumn(#"Expanded Column1", "fields", {"assignee", "status", "creator", "reporter", "project", "created", "updated", "summary"}, {"assignee", "status", "creator", "reporter", "project", "Issue.created", "Issue.updated", "Issue.summary"}),
    #"Expanded assignee" = Table.ExpandRecordColumn(#"Expanded fields", "assignee", {"accountId"}, {"Assignee.accountId"}),
    #"Expanded status" = Table.ExpandRecordColumn(#"Expanded assignee", "status", {"name"}, {"Issue.status"}),
    #"Expanded creator" = Table.ExpandRecordColumn(#"Expanded status", "creator", {"accountId"}, {"Creator.accountId"}),
    #"Expanded reporter" = Table.ExpandRecordColumn(#"Expanded creator", "reporter", {"accountId"}, {"Reporter.accountId"}),
    #"Expanded project" = Table.ExpandRecordColumn(#"Expanded reporter", "project", {"id"}, {"Project.id"})
in
    #"Expanded project"