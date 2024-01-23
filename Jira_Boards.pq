let
    //URL setup
    base_url = "https://vtbgeorgia.atlassian.net",
    api_url = "/rest/agile/1.0/board",
    url = base_url & api_url,
    Source = Fetch_Pages(url, 50),
    #"Expanded Column1" = Table.ExpandRecordColumn(Source, "Column1", {"id", "self", "name", "type", "location"}, {"Board.id", "Board.url", "Board.name", "Board.type", "Column1.location"}),
    #"Expanded Column1.location" = Table.ExpandRecordColumn(#"Expanded Column1", "Column1.location", {"projectId", "displayName", "projectName", "projectKey", "projectTypeKey", "name"}, {"projectId", "displayName", "projectName", "projectKey", "projectTypeKey", "name"})
in
    #"Expanded Column1.location"