let
    //URL setup
    base_url = "https://vtbgeorgia.atlassian.net",
    api_url = "/rest/api/latest/group/bulk",
    url = base_url & api_url,
    Source = Fetch_Pages(url, 50),
    #"Expanded Column1" = Table.ExpandRecordColumn(Source, "Column1", {"name", "groupId"}, {"Group.name", "Group.id"})
in
    #"Expanded Column1"