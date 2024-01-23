//Fetch all pages
let
    FetchPages = (url as text, pageSize as number) => 
    let 
        Source = GenerateByPage(
        (previous) =>
        let
            skipRows = if previous = null then 0 else Value.Metadata(previous)[skipRows],
            totalItems = if previous = null then 0 else Value.Metadata(previous)[total],
            table = if previous = null or Table.RowCount(previous) = pageSize then 
                FetchPage(url, pageSize, skipRows) 
		else null
        in table,
        type table [Column1])
    in
        Source,

//Fetch single page @ position
    FetchPage = (url as text, pageSize as number, skipRows as number) as table=>
    let
        contents = Web.Contents(url,[Query = [maxResults= Text.From(pageSize), startAt = Text.From(skipRows)]]),
        json = Json.Document(contents),
        value = if Value.Is(json, type record) then
            List.Last(Record.ToList(json)) else json,
        table = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error)
    in
        table meta [skipRows = skipRows + pageSize, total = 500],

//Page generation
    GenerateByPage = (getNextPage as function, optional tableType as type) as table=>
    let
        listOfPages = List.Generate(
            () => getNextPage(null),
            (lastPage) => lastPage <> null,
            (lastPage) => getNextPage(lastPage)
            ),
        tableOfPages = Table.FromList(listOfPages, Splitter.SplitByNothing(), {"Column1"}),
        firstRow = tableOfPages{0}?,
        keys = if tableType = null then Table.ColumnNames(firstRow[Column1])
               else Record.FieldNames(Type.RecordFields(Type.TableRow(tableType))),
        appliedType = if tableType = null then Value.Type(firstRow[Column1]) else tableType
    in
        if tableType = null and firstRow = null then
            Table.FromRows({})
        else
        Value.ReplaceType(Table.ExpandTableColumn(tableOfPages, "Column1", keys), appliedType)
in
    FetchPages