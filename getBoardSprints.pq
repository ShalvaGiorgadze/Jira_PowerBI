let
    Source = (id as text) => let
        url = "https://vtbgeorgia.atlassian.net/rest/agile/1.0/board/" & id & "/sprint",
        Source = Fetch_Pages(url, 50)
    in
        Source
in
    Source